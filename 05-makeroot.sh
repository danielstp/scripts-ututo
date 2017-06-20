#!/bin/bash
# ojo si no esta esto sudo lo activa mal
# toma los archivos de edit-$TIPOIMAGEN y crea squash y auxiliares

source 00-config.sh # provee $TIPOIMAGEN y $ARMA


# $ARMA es extraerP tiene varios archivos "fuente" pero tambien se agregan otros con scripts, por ejemplo este y el 15-creaiso, luego de alli se hace la imagen iso

#si bien hay varios edit-* solo hay un arma, dado que es muy automatico el proceso, cada vez que se usa un edit se hace un arma en el mismo lugar y luego se hacen varias isos, pero todas desde el mismo arma

if test -e  $NOMBREDESTINO/root/dev/input ; then
    echo Existe algo en dev salir
    echo EXISTE $NOMBREDESTINO/root/iso/dev/input
   exit
fi

mkdir -p $NOMBREDESTINO/iso/casper

#if test ! -e  extraer/casper/filesystem.squashfs ; then
 chmod +w $NOMBREDESTINO/iso/casper/filesystem.manifest 
  sudo chroot $NOMBREDESTINO/root dpkg-query -W --showformat='${Package} ${Version}\n' > $NOMBREDESTINO/iso/casper/filesystem.manifest 
 sudo rm $NOMBREDESTINO/iso/casper/filesystem.squashfs 

 sudo mksquashfs $NOMBREDESTINO/root $NOMBREDESTINO/iso/casper/filesystem.squashfs  

 printf $(sudo du -sx --block-size=1 $NOMBREDESTINO/root | cut -f1) > $NOMBREDESTINO/iso/casper/filesystem.size


#fi



# sudo cp extraer/casper/filesystem.manifest extraer/casper/filesystem.manifest-desktop 
# sudo sed -i '/ubiquity/d' extraer/casper/filesystem.manifest-desktop 
# sudo sed -i '/casper/d' extraer/casper/filesystem.manifest-desktop 

 
#sudo apt-get source gfxboot-theme-ubuntu gfxboot 
#cd gfxboot-theme-ubuntu*/ 
#make DEFAULT_LANG=es 
#sudo cp -af boot/* ../extraer/isolinux/



#sudo cp edit/boot/vmlinuz-XXX extraer/casper/vmlinuz 
#sudo cp edit/boot/initrd.img-XXX extraer/casper/initrd.lz
