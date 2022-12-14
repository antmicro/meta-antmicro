*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Test Teardown                 Test Teardown
Resource                      ${RENODEKEYWORDS}

*** Variables ***
${SCRIPT}                     ${CURDIR}/rdfm-demo.resc
${UART}                       sysbus.uart0

*** Keywords ***
Prepare Machine
    Execute Script            ${SCRIPT}

*** Test Cases ***
Should OTA Update
    [Documentation]           Updates firmware using RDFM on Linux SiFive Freedom-U540 platform.
    Prepare Machine

    Create Terminal Tester    ${UART}
    Start Emulation

    Wait For Prompt On Uart   freedom-u540 login:                       timeout=360
    Write Line To Uart        root
    Wait For Prompt On Uart   root@freedom-u540:~#
    Write Line To Uart        ip addr add 100.64.0.2/10 dev eth0
    Write Line To Uart        rdfm install http://100.64.0.1:12345/rdfm-image-upgraded-freedom-u540.rdfm
    Wait For Prompt On Uart   Use 'commit' to update, or 'rollback'     timeout=180
    Wait For Prompt On Uart   root@freedom-u540:~#
    Write Line To Uart        reboot
    Wait For Prompt On Uart   freedom-u540 login:                       timeout=360
    Write Line To Uart        root                                      waitForEcho=false
    Wait For Prompt On Uart   root@freedom-u540:~#
    Write Line To Uart        rdfm show-provides
    Wait For Prompt On Uart   rootfs-image.checksum=
