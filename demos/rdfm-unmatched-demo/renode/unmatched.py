#!/usr/bin/env -S python -m bpython -i

from tuttest import get_snippets, Snippet
from pyrenode3.wrappers import Analyzer, Emulation, Monitor, TerminalTester, Machine
from pathlib import Path
from sys import stderr
from typing import Optional
import time

from Antmicro.Renode.Core import Range
from Antmicro.Renode.Testing import TerminalTesterResult
from Antmicro.Renode.Utilities import WriteFilePath
from Antmicro.Renode.Peripherals.CPU import PrivilegeLevel

this_dir = Path(__file__).parent.absolute()

readme = str(this_dir / "../README.md")
spl = str(this_dir / "u-boot-spl.bin")
itb = str(this_dir / "u-boot.itb")
sd = str(this_dir / "sdcard.sdimg")
repl = str(this_dir / "sifive-fu740.repl")

snippets = get_snippets(
    readme,
    names=[
        "setup-target",
        "silence-logs",
        "check-update",
        "commit-update",
        "update-delta",
        "update-same",
    ],
)

e = Emulation()
m = Monitor()


def errExit(text: str):
    print(text, file=stderr)
    exit(1)


def setup_machine() -> Machine:
    hifive = e.add_mach("unmatched")
    hifive.load_repl(repl)
    hifive.LoadPlatformDescriptionFromString(
        "virtio: Storage.VirtIOBlockDevice @ sysbus 0x100d0000 { IRQ -> plic@54 }"
    )

    # Analyzer(hifive.sysbus.uart0).Show()
    hifive.sysbus.uart0.CreateFileBackend(str(this_dir / "uart0.log"), True)

    hifive.sysbus.Tag(Range(0x1000, 1), "MSEL", 11)

    hifive.sysbus.s7.set_IsHalted(True)
    hifive.sysbus.u74_2.set_IsHalted(True)
    hifive.sysbus.u74_3.set_IsHalted(True)
    hifive.sysbus.u74_4.set_IsHalted(True)

    hifive.sysbus.u74_1.RegisterCustomCSR(
        "FEATURE_DISABLE", 0x7C1, PrivilegeLevel.Machine
    )

    hifive.sysbus.virtio.LoadImage(WriteFilePath(sd), True)

    e.CreateSwitch("switch1")
    tap = e.CreateAndGetTap("tap50", "tap")
    e.Connector.Connect(hifive.sysbus.ethernet.internal, e.externals.switch1)
    e.Connector.Connect(tap, e.externals.switch1)

    return hifive


def reset(hifive: Machine):
    hifive.Pause()
    hifive.Reset()
    hifive.load_binary(spl, 0x08000000)
    hifive.load_binary(itb, 0x84000000)
    hifive.sysbus.SetPCOnAllCores(0x08000000)
    hifive.Start()
    print("Booting")


def login(hifive: Machine):
    tt = TerminalTester(hifive.sysbus.uart0, 300.0)

    if tt.WaitFor("renodeunmatched login: ", includeUnfinishedLine=True) is None:
        errExit("Timeout during machine boot")

    tt.WriteLine("root")
    print("Logging in")

    if tt.WaitFor("root@renodeunmatched:~#", includeUnfinishedLine=True) is None:
        errExit("Failed to login")


def runSnippet(
    hifive: Machine,
    name: str,
    expect: Optional[str] = None,
    timeout: float = 10.0,
):
    tt = TerminalTester(hifive.sysbus.uart0, timeout)

    if (cmd := snippets.get(name)) is None or len(cmd.text) == 0:
        errExit(f"Empty snippet '{name}'")

    tt.WriteLine(cmd.text)
    print(f"Running '{name}' snippet")

    if expect is not None:
        if tt.WaitFor(expect) is None:
            errExit(f"Timeout in {name}: expected '{expect}' not found")

    if tt.WaitFor("root@renodeunmatched:~#", includeUnfinishedLine=True) is None:
        errExit(f"Timeout in {name}: snippet did not finish in time")

    time.sleep(5)


def run_test():
    hifive = setup_machine()
    reset(hifive)

    e.StartAll()

    login(hifive)
    runSnippet(hifive, "silence-logs")
    runSnippet(hifive, "setup-target")

    runSnippet(
        hifive, "update-same", expect="Mender will write in chunks of ", timeout=1500.0
    )

    reset(hifive)
    login(hifive)

    runSnippet(hifive, "silence-logs")
    runSnippet(hifive, "setup-target")
    runSnippet(hifive, "commit-update", expect="Committing update")
    runSnippet(
        hifive, "update-delta", expect="The artifact is a delta update:", timeout=600.0
    )

    reset(hifive)
    login(hifive)

    runSnippet(hifive, "silence-logs")
    runSnippet(hifive, "check-update", expect="OK")
    runSnippet(hifive, "commit-update", expect="Committing update")

    # input("Press Enter to exit")


if __name__ == "__main__":
    run_test()
