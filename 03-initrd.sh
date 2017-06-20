source 00-config.sh


#cp extraer/casper/initrd.lz inird.lz.orig
cd $NOMBREDESTINO/initrd
find . | cpio --quiet --dereference -o -H newc | lzma -7 > ../../$NOMBREDESTINO/iso/casper/initrd.lz


# probar lzma -e
