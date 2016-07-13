# Fake bash for build system
autoload -U +X bashcompinit && bashcompinit

alias bb='bitbake'
alias cdy='cd ~/projects/yocto'

function bb-enter-env(){
    cd ~/projects/yocto
    source ./build/envsetup.sh
    lunch sofia_lte-eng
}

function bb-publish(){
    (
        cd ~/projects/yocto
        bitbake publish
    )
}

function bb-bootimage(){
    (
        cd ~/projects/yocto
        bitbake bootimage-fls
    )
}

function flash-bootimage(){
    (
        cd ~/projects/yocto/out/pub/sofia-lte/images/sofia-lte/signed_fls
        /opt/intel/platformflashtool/bin/downloadTool \
            --library=/opt/intel/platformflashtool/lib/libDownloadTool.so \
            --verbose 4 \
            psi_flash_signed.fls \
            boot-sofia-lte_signed.fls
    )
}

function flash-fls-in-cwd(){
    (
        cd ~/projects/yocto/out/pub/sofia-lte/images/sofia-lte/signed_fls
        /opt/intel/platformflashtool/bin/downloadTool \
            --library=/opt/intel/platformflashtool/lib/libDownloadTool.so \
            --verbose 4 \
            *.fls
    )
}

function flash-all(){
    (
        cd ~/projects/yocto/out/pub/sofia-lte/images/sofia-lte/signed_fls
        /opt/intel/platformflashtool/bin/downloadTool \
            --library=/opt/intel/platformflashtool/lib/libDownloadTool.so \
            --verbose 4 \
            psi_flash_signed.fls \
            boot-sofia-lte_signed.fls \
            mobilevisor_signed.fls \
            mvconfig_smp_signed.fls \
            secvm_signed.fls \
            slb_signed.fls \
            splash_img_signed.fls \
            system-sofia-lte_signed.fls \
            ucode_patch_signed.fls
    )
}
