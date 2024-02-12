# Porting AnalogDevices' ZCU102 [HDL code](https://github.com/analogdevicesinc/hdl) to AMD/Xilinx ZCU104 board

Release baseline version is 2021.2.
Version is applicable to Xilinx Vitis/Vivado distribution, Ananlog Devices library and Xilinx Petalinux.

Repository contains module links to other repo so clone recursively.
```
$ git clone --recursive ...
```

3 parts/folders containing updated code, all licenced by their respective creators:
- ADI hdl library
- meta layer for petalinux (tbc)
- device tree configuration (tbc)

### Build Bitsream, Device Tree and BIN files
Install Vivado/Vitis 2021.2.
```
$ cd ~/git/hdl_2021_r2/projects/fmcomms2/zcu104/
$ make
$ cd ~/git/hdl_2021_r2/projects/fmcomms2/zcu104/devtree/
$ ./make_devtree.sh
```
BIN file will be in devtree/ folder.

### Build with Petalinux
Download Petalinux installer 2021.2 from AMD.<br>
Use [Petalinux Install Manual](https://docs.xilinx.com/r/2021.2-English/ug1144-petalinux-tools-reference-guide/Installing-the-PetaLinux-Tool)

In a nutshell Ubuntu procedure, more or less, is as follows:
```
sudo mkdir /opt/petalinux
sudo apt install net-tools xterm autoconf libtool texinfo zlib1g-dev gcc-multilib zlib1g:i386 gawk build-essential
bash ./petalinux-v2021.2-final-installer.run -p aarch64 -d /opt/petalinux/2021.2/

source /opt/petalinux/2021.2/settings.sh
petalinux-create -t project -s /opt/petalinux/xilinx-zcu104-v2021.2-final.bsp
WORKDIR=.
HDLDIR=~/git/hdl_2021_r2
petalinux-config -p $WORKDIR/xilinx-zcu104-2021.2/ --get-hw-description=$HDLDIR/projects/fmcomms2/zcu104/fmcomms2_zcu104.sdk/system_top.xsa

cd ./build/
petalinux-build
cd ..
petalinux-package --boot --fsbl images/linux/zynqmp_fsbl.elf --u-boot images/linux/u-boot.elf --pmufw images/linux/pmufw.elf --fpga images/linux/system.bit --force
```

### Create an SD card
- create SD card with fat32 and ext4 partitions
- put boot files on fat32
- unarchive rootfs (choices are ADI kuiper, UltraScale Ubuntu or Petalinux build) on ext4

