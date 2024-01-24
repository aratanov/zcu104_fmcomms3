#!/bin/sh

VERSTR="ZCU-104 Reference Design v."$(date +\%d\%m\%Y)
VERHEX="$(printf '%.40s' "$VERSTR" | xxd -p -u)"
echo "$VERHEX" > ./version.txt

BINFILE="BOOT.BIN"
if [ ! -f "$BINFILE" ]; then
  xsct -eval "source xsct_devtree.tcl; build_dts"
fi

DTSFILE="devtree_decomp.dts"
if [ -f "$DTSFILE" ]; then
  dtc -I dts -O dtb -o system.dtb $DTSFILE
else
  gcc -I . -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp -o system-top.dts.tmp system-top.dts
  dtc -I dts -O dtb -o system.dtb system-top.dts.tmp
  dtc -I dtb -O dts -o devtree_decomp.dts system.dtb
fi

bootgen -arch zynqmp -image bootgen_mp.bif -o BOOT.BIN -w
