#!/usr/bin/env python3
# Copyright (c) 2024, Antmicro
# SPDX-License-Identifier: Apache-2.0

import os
import sys
import subprocess
import re
import struct


ENV_NAME_BOOT_PART="mender_boot_part"
ENV_NAME_UPGRADE="upgrade_available"
# Resolve path to the disk (for example: '/dev/nvme0n1p15')
SLOT_APP_A = os.path.realpath('/dev/disk/by-partlabel/APP')
SLOT_APP_B = os.path.realpath('/dev/disk/by-partlabel/APP_b')
# Extract the partition number from the disk path
SLOT_A_PART_NUM = re.findall(r'\d+', SLOT_APP_A)[-1]
SLOT_B_PART_NUM = re.findall(r'\d+', SLOT_APP_B)[-1]

EFIVARS_PATH = "/sys/firmware/efi/efivars"
VAR_NEXT_BOOT_SLOT = "BootChainFwNext-781e084c-a330-417c-b678-38e696380cb9"
VAR_SLOT_A_STATE = "RootfsStatusSlotA-781e084c-a330-417c-b678-38e696380cb9"
VAR_SLOT_B_STATE = "RootfsStatusSlotB-781e084c-a330-417c-b678-38e696380cb9"
SLOT_EFI_HEADER = b'\x07\x00\x00\x00'
SLOT_STATE_BOOTABLE = 0x00000000
SLOT_STATE_UNBOOTABLE = 0x000000FF
TEST_BOOT_FLAG_PATH = "/data/rdfm/.upgrade-available"


def get_current_slot() -> int:
    """ Get the currently booted slot as an integer.

    Returns:
        0: slot A is booted
        1: slot B is booted
    """
    return int(subprocess.check_output(["nvbootctrl", "get-current-slot"]))


def get_next_slot() -> int:
    """ Return the slot that will be booted on next device boot

    nvbootctrl does not have any way of getting this, so reach out directly
    to the corresponding EFI variable. This however may not exist (as no slot
    switch was attempted yet), in which case the currently booted slot is used.
    """
    try:
        with open(f"{EFIVARS_PATH}/{VAR_NEXT_BOOT_SLOT}", "rb") as f:
            bytes = f.read()
            _, slot = struct.unpack('<LL', bytes)
            return slot
    except:
        return get_current_slot()


def get_slot_state(slot: int) -> int:
    """ Read the state of the given slot

    This reads the state of the given slot. The following values were observed
    to be used:

        0x00000000: slot is bootable
        0x000000FF: slot failed to boot previously
    """
    if slot not in [0, 1]:
        raise RuntimeError(f"Invalid slot was given: {slot}. Accepted values: 0, 1")

    try:
        varname = VAR_SLOT_A_STATE if slot == 0 else VAR_SLOT_B_STATE
        with open(f"{EFIVARS_PATH}/{varname}", "rb") as f:
            bytes = f.read()
            _, slot = struct.unpack('<LL', bytes)
            return slot
    except:
        raise RuntimeError(f"Could not read EFI variable {varname}")


def set_slot_state(slot: int, state: int):
    """ Set the state of the given slot

    This allows changing the state of the given slot. This can be used to clear
    failure information to allow a given slot to be booted again.

    See: SLOT_STATE_BOOTABLE, SLOT_STATE_UNBOOTABLE
    """
    if slot not in [0, 1]:
        raise RuntimeError(f"Invalid slot was given: {slot}. Accepted values: 0, 1")

    try:
        varname = VAR_SLOT_A_STATE if slot == 0 else VAR_SLOT_B_STATE
        path = f"{EFIVARS_PATH}/{varname}"

        # efivars are immutable by default..
        subprocess.check_call(["chattr", "-i", path])

        with open(path, "wb") as f:
            # Write the header
            f.write(SLOT_EFI_HEADER)
            # Write variable data
            f.write(struct.pack('<L', state))

        # restore immutability
        subprocess.check_call(["chattr", "+i", path])
    except:
        raise RuntimeError(f"Could not write EFI variable {varname}")


def set_next_slot(slot: int):
    """ Set which slot should be booted next

    Allowed values for slot: 0 (slot A), 1 (slot B)
    """
    subprocess.check_call(["nvbootctrl", "set-active-boot-slot", str(slot)])


def partition_number_to_slot(number: str) -> int:
    """ Convert a partition number to a slot number
    """
    if SLOT_A_PART_NUM == number:
        return 0
    elif SLOT_B_PART_NUM == number:
        return 1
    else:
        raise RuntimeError(f"Partition number: {number} matches neither slot A or B!")


def slot_to_partition_number(slot: int) -> int:
    """ Convert a slot number to a partition number
    """
    if slot == 0:
        return SLOT_A_PART_NUM
    elif slot == 1:
        return SLOT_B_PART_NUM
    else:
        raise RuntimeError(f"Invalid slot was given: {slot}. Accepted values: 0, 1")


def printenv():
    """ printenv helper to integrate slot switching with RDFM
    """
    is_upgrade_available = "0"
    try:
        with open(TEST_BOOT_FLAG_PATH, "rt") as f:
            is_upgrade_available = f.read()
    except:
        pass

    # When a slot fails to boot, upgrade_available is supposed to be cleared by the bootloader.
    # Detect this scenario by checking states of both slots: if one of them failed
    # to boot, then we're in this exact scenario.
    slot0_state, slot1_state = get_slot_state(0), get_slot_state(1)
    if SLOT_STATE_UNBOOTABLE in [slot0_state, slot1_state]:
        is_upgrade_available = 0
        try:
            os.unlink(TEST_BOOT_FLAG_PATH)
        except:
            pass

    print(f"{ENV_NAME_UPGRADE}={is_upgrade_available}")
    # This MUST return the next slot that will be booted!
    # Otherwise, rollback will not work properly.
    print(f"{ENV_NAME_BOOT_PART}={slot_to_partition_number(get_next_slot())}")


def setenv():
    """ setenv helper to integrate slot switching with RDFM
    """
    for line in sys.stdin:
        assignment = line.rstrip()

        # Ignore malformed lines
        if "=" not in assignment:
            continue

        name, value = assignment.split("=")
        if name == ENV_NAME_BOOT_PART:
            target_slot = partition_number_to_slot(value)
            set_next_slot(target_slot)
            set_slot_state(target_slot, SLOT_STATE_BOOTABLE)
        elif name == ENV_NAME_UPGRADE:
            # Write the upgrade_available value to a flag file
            try:
                with open(TEST_BOOT_FLAG_PATH, "wt") as f:
                    f.write(value)
            except:
                print("Failed writing upgrade_available value, ignoring", file=sys.stderr)


def main():
    err: int = 0

    if "rdfm-tegra-printenv" in sys.argv[0]:
        printenv()
    elif "rdfm-tegra-setenv" in sys.argv[0]:
        setenv()
    else:
        print(f"Unrecognized tool name in argv[0]: {sys.argv[0]}")
        print("Allowed tool names: rdfm-tegra-printenv/rdfm-tegra-setenv")
        err = 1

    exit(err)


if __name__ == "__main__":
    main()
