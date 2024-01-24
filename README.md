Release baseline version is 2021.2
Version is applicable to Xilinx Vitis/Vivado distribution, Ananlog Devices library and Xilinx Petalinux.

3 parts/folders containing updated code
  ADI hdl library
  meta layer for petalinux
  device tree configuration


sudo mkdir /opt/petalinux
sudo apt install net-tools xterm autoconf libtool texinfo zlib1g-dev gcc-multilib zlib1g:i386 gawk build-essential
bash /mnt/ubu/petalinux/petalinux-v2021.2-final-installer.run -p aarch64 -d /opt/petalinux/2021.2/

petalinux-create -t project -s /opt/petalinux/xilinx-zcu104-v2021.2-final.bsp

source /opt/petalinux/2021.2/settings.sh
petalinux-create -t project -s /opt/petalinux/xilinx-zcu104-v2021.2-final.bsp
WORKDIR=.
HDLDIR=~/git/hdl_2021_r2
petalinux-config -p $WORKDIR/xilinx-zcu104-2021.2/ --get-hw-description=$HDLDIR/projects/fmcomms2/zcu104/fmcomms2_zcu104.sdk/system_top.xsa

cd ./build/
petalinux-build
cd ..
petalinux-package --boot --fsbl images/linux/zynqmp_fsbl.elf --u-boot images/linux/u-boot.elf --pmufw images/linux/pmufw.elf --fpga images/linux/system.bit --force


#######################
xsct -eval "source xsct_devtree_wDel.tcl; build_dts"


#######################
### create SD card with fat32 and ext4 partitions
### put boot files on fat32
### unarchive rootfs.. on ext4

#######################
git clone -b xlnx_rel_v2021.2 https://github.com/xilinx/device-tree-xlnx device-tree-xlnx_v2021.2
git clone -b 2021_R2 https://github.com/analogdevicesinc/meta-adi.git meta-adi_2021_r2





