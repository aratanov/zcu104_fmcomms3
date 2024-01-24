proc build_dts {args} {
    set board zcu104-revc
    set version 2021.2
    set xsa ../fmcomms2_zcu104.sdk/system_top.xsa
    set repo ../../../../../device-tree-xlnx_v2021.2
    set my_dts .
    ## next two files are similar to those in   meta-adi/meta-adi-xilinx/recipes-bsp/device-tree/files/
    set pl_delete ./include_zcu104/pl-delete-nodes-zynqmp-zcu104-revc-ad9361-fmcomms2-3.dtsi
    set pl_overlay ./include_zcu104/pl-zynqmp-zcu104-revc-ad9361-fmcomms2-3.dtsi
    set st_bootargs ./include_zcu104/bootargs-zcu104.dtsi
    ###
    hsi::open_hw_design $xsa
    hsi::set_repo_path $repo
    hsi::create_sw_design device-tree -os device_tree -proc psu_cortexa53_0
    hsi::generate_target -dir $my_dts
    hsi::close_hw_design [hsi::current_hw_design]
    if {$board != 0} {
        foreach lib [glob -nocomplain -directory $repo/device_tree/data/kernel_dtsi/${version}/include/dt-bindings -type d *] {
            if {![file exists $my_dts/include/dt-bindings/[file tail $lib]]} {
                file copy -force $lib $my_dts/include/dt-bindings
            }
        }
        set dtsi_files [glob -nocomplain -directory $repo/device_tree/data/kernel_dtsi/${version}/BOARD -type f *${board}*]
        if {[llength $dtsi_files] != 0} {
            file copy -force [lindex $dtsi_files end] $my_dts
            set fileId [open $my_dts/system-user.dtsi "w"]
            puts $fileId "/include/ \"[file tail [lindex $dtsi_files end]]\""
            puts $fileId "/ {"
            puts $fileId "};"
            close $fileId
            set fileId [open $my_dts/system-top.dts "a"]
            puts $fileId "#include \"[file tail [lindex $dtsi_files end]]\""
            puts $fileId "#include \"$st_bootargs\""
            close $fileId
            set fileId [open $my_dts/pl.dtsi "a"]
            puts $fileId "#include \"$pl_delete\""
            puts $fileId "#include \"$pl_overlay\""
            close $fileId
        } else {
            puts "Info: Board file: $board is not found and will not be added to the system-top.dts"
        }
    }
}
