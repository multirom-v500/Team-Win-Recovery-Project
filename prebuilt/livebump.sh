#!/sbin/sh
#Livebump for LG G3 kernel
#by skin1980@xda

IMAGE_IN=/tmp/bump/original-boot.img
IMAGE_OUT=/tmp/bump/image_bumped.img
OUT=/tmp/bump/out

if [ -z $IMAGE_IN ]; then exit 1; fi
mkdir $OUT
/sbin/unpackbootimg -i $IMAGE_IN -o $OUT

if [ -e $OUT/original-boot.img-ramdisk.gz ]; then
	rdcomp=$OUT/original-boot.img-ramdisk.gz
elif [ -e $OUT/original-boot.img-ramdisk.lz4 ]; then
	rdcomp=$OUT/original-boot.img-ramdisk.lz4
else
	exit 1
fi

/sbin/mkbootimg --kernel $OUT/original-boot.img-zImage --ramdisk $rdcomp --dt $OUT/original-boot.img-dt --cmdline "$(cat $OUT/original-boot.img-cmdline)" --pagesize $(cat $OUT/original-boot.img-pagesize) --base $(cat $OUT/original-boot.img-base) --ramdisk_offset $(cat $OUT/original-boot.img-ramdisk_offset) --tags_offset $(cat $OUT/original-boot.img-tags_offset) --output $IMAGE_OUT

echo "Bumping the boot.img..."
printf '\x41\xA9\xE4\x67\x74\x4D\x1D\x1B\xA4\x29\xF2\xEC\xEA\x65\x52\x79' >> $IMAGE_OUT
