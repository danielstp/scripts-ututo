#!/bin/bash
# para usar internet desde el "chroot" 
#https://help.ubuntu.com/community/LiveCDCustomizationFromScratch

source 00-config.sh

DIR=`pwd`
# ejecutar con sudo

# ---------------------  ingreso al "chroot" 


# para disponer de dispositivos
if test ! -e $NOMBREDESTINO/root/dev/input ; then
    sudo mount --bind /dev/ $NOMBREDESTINO/root/dev
    #mount -n -t tmpfs none $NOMBREDESTINO/root/dev
fi

# los copio cada vez que entro porque los estoy editando siempre
sudo cp [a-z]-*.sh $NOMBREDESTINO/root/root

if test x"$1" == xauto ; then
  sudo bash -c "chmod a+w  $NOMBREDESTINO/root/root/t-total.sh"  # si existe permite reescribirlo
  sudo bash -c "cat a-target.sh b-install.sh x-exit.sh >   $NOMBREDESTINO/root/root/t-total.sh"
  sudo bash -c "echo exit >>   $NOMBREDESTINO/root/root/t-total.sh"
  sudo bash -c "chmod a+x  $NOMBREDESTINO/root/root/*.sh"

  echo $NOMBREDESTINO/root/root/t-total.sh
  cd $NOMBREDESTINO/root
 
  sudo chroot . /bin/bash --init-file "/root/t-total.sh" 
 
else
  VARI="echo     kill -9 \\\$PPID >>   $NOMBREDESTINO/root/root/x-exit.sh"
  #echo $VARI
  sudo bash -c "$VARI"
  cd $NOMBREDESTINO/root
  sudo chroot . /bin/bash --init-file /root/a-target.sh    
fi




echo Salí afuera del chroot
#------------------- ya esta afuera del chroot
cd $DIR

sudo umount  $NOMBREDESTINO/root/dev
sudo umount -lf  $NOMBREDESTINO/root/dev
# se asegura que dev este vacio, los kernels modernos lo llenan automaticamente con mount mone devfs /dev

# $ARMA es extraerP tiene varios archivos "fuente" pero tambien se agregan otros con scripts, por ejemplo este y el 15-creaiso, luego de alli se hace la imagen iso

#si bien hay varios edit-* solo hay un arma, dado que es muy automatico el proceso, cada vez que se usa un edit se hace un arma en el mismo lugar y luego se hacen varias isos, pero todas desde el mismo arma

if test -e  $NOMBREDESTINO/root/dev/input ; then
   echo ERROR  Existe algo en dev 
fi


if test -e  $NOMBREDESTINO/root/dev/audio ; then
   echo ERROR  Existe algo en dev 
fi
