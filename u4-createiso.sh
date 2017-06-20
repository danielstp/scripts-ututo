#!/bin/bash

source 00-config.sh

#sudo apt-get source gfxboot-theme-ubuntu gfxboot 
#cd gfxboot-theme-ubuntu*/ 
#make DEFAULT_LANG=es 
#sudo cp -af boot/* ../extraer/isolinux/



#sudo cp edit/boot/vmlinuz-XXX extraer/casper/vmlinuz 
#sudo cp edit/boot/initrd.img-XXX extraer/casper/initrd.lz

#cd extraer/casper 
#mkdir lztempdir 
#cd lztempdir 
#lzma -dc -S .lz ../initrd.lz | cpio -imvd --no-absolute-filenames
#cp ../initrd.lz ../inird.lz.orig
#find . | cpio --quiet --dereference -o -H newc | lzma -7 > ../initrd.lz

#cp grub.cfg extraer/boot/grub
#cp txt.cfg extraer/isolinux/txt.cfg
#cp isolinux.cfg extraer/isolinux/
##cp stdmenu.cfg extraer/isolinux/
##cp splash.pcx extraer/isolinux/

DIR=`pwd`

cd  $NOMBREDESTINO/iso

echo Xorriso

if test $TIPOIMAGEN==UBUNTU ; then
 sudo xorriso -as mkisofs \
  -D -r -V "$NOMBREDESTINO" -J -l \
  -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
  -cache-inodes \
  -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot \
  -e boot/grub/efi.img \
     -no-emul-boot \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -isohybrid-gpt-basdat \
  -o ../$NOMBREDESTINO.iso . 
else
 sudo xorriso -as mkisofs \
  -D -r -V "$NOMBREDESTINO" -J -l \
  -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
  -cache-inodes \
  -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot \
     -no-emul-boot \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -isohybrid-gpt-basdat \
  -o ../$NOMBREDESTINO.iso . 
fi

#isohybrid  ../ututo-2017.iso
#-cache-inodes
