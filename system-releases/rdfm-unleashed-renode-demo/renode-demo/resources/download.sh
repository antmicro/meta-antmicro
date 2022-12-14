#!/bin/bash

# Downloads artifacts needed for the demo:
# fw_payload.elf - the opensbi payload
# rdfm-image-minimal-freedom-u540.rdfm - the initial rdfm update needed for the delta update generation
# rdfm-image-upgraded-freedom-u540.rdfm - the rdfm update that will be compared to generate the delta update
# rdfm-image-minimal-freedom-u540.flash.sdimg - whole system image to runned in Renode
wget --progress=dot:giga https://dl.antmicro.com/projects/renode/rdfm_fu540-fw_payload.elf-s_977584-5e5897d089270537faa86233283daea1ba9cfc2e -O fw_payload.elf
wget --progress=dot:giga https://dl.antmicro.com/projects/renode/rdfm_fu540-rdfm-image-minimal-freedom-u540.rdfm-s_45972480-36cf7d11f16487be7cd8c3279f3a1e1423506f41 -O rdfm-image-minimal-freedom-u540.rdfm
wget --progress=dot:giga https://dl.antmicro.com/projects/renode/rdfm_fu540-rdfm-image-upgraded-freedom-u540.rdfm-s_46745600-a03b694c7959aa6b8a66fc5cda6b2a04479267ec -O rdfm-image-upgraded-freedom-u540.rdfm
wget --progress=dot:giga -c https://dl.antmicro.com/projects/renode/rdfm_fu540-rdfm-image-minimal-freedom-u540.flash.sdimg-s_11249140736-7199261f7d9658786c38ad075fa5ca8cc72ee527 -O rdfm-image-minimal-freedom-u540.flash.sdimg
