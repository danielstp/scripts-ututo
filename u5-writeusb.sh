#!/bin/bash

source 00-config.sh


DISCO=$1
DISCOSUSB=`find /dev/disk/by-id -name "usb*" ! -name "*part*"`
esUSB=0
echo "los discos usb en el sistema, son: ---"
for  DISU in $DISCOSUSB ; do
   DISD=`echo $DISU | sed -e's|/dev/disk/by-id/||' `
   DIS=`readlink -e $DISU`
   echo $DIS - $DISU 
   if test "$DISCO"x != x ; then 
   if test "$DIS"x == /dev/${DISCO}x ; then
         echo EL DISCO /dev/$DISCO es USB
         esUSB=1
   fi
   fi
done
if test "$DISCO"x == x ; then
   echo "Se debe ejecutar sudo bash 15-creausb.sh DISCO"
   echo "debe usarse un argumento DISCO es sdb sda sdc etc"
   echo ejemplo: sudo ./004-creausb.sh sdb
   exit
fi 


echo "----------------------------------"
if test $esUSB == 0 ; then
   echo "El disco especificado: $DISCO no es USB o no es un disco"
   exit
fi 
echo ---------------------
echo "p
q
" | sudo fdisk   /dev/${DISCO}

echo ---------------------

echo "ATENCION DESTRUIRA EL DISCO  /dev/${DISCO}"
echo "CON CTRL-C evite el desastre"

read nada
sudo umount /dev/${DISCO}1
sudo umount /dev/${DISCO}2
sudo umount /dev/${DISCO}3
#echo "d
#1
#d
#2
#d
#3
#d
#4
#n
#p
#1
#
#+8G
#w
#" |  fdisk /dev/${DISCO}

#sudo umount /dev/${DISCO}1
#sudo umount /dev/${DISCO}2
#sudo umount /dev/${DISCO}3

#sudo fdisk /dev/${DISCO}


#echo para seguir enter
#read

echo Copia iso
ls -l $NOMBREDESTINO/$NOMBREDESTINO.iso
sudo dd if=$NOMBREDESTINO/$NOMBREDESTINO.iso of=/dev/${DISCO} bs=4M status=progress
sudo umount /dev/${DISCO}1
sudo umount /dev/${DISCO}2


#if test 1==2 ; then
#echo "n
#p
#3
##
#
#
# " |  fdisk /dev/${DISCO}
#
# sudo mkfs.ext4 /dev/${DISCO}3
# sudo mkdir -p /tmp/3
# sudo mount /dev/${DISCO}3 /tmp/3
# cp -ar $EDIT/home/*  /tmp/3
# umount /tmp/3
#fi

# se monta home, habria que poner /usr/local, /var, /etc  al menos
# lastima que no exista un overlay o algo asi como habia ne la epoca del oprimer ututo
# ver que se hace con fstab
#http://unix.stackexchange.com/questions/27449/mount-a-filesystem-read-only-and-redirect-writes-to-ram
#https://en.wikipedia.org/wiki/OverlayFS
#http://askubuntu.com/questions/699565/example-overlayfs-usage
#https://major.io/2014/07/29/adventures-in-live-booting-linux-distributions/

#http://windsock.io/tag/overlayfs/
#http://askubuntu.com/questions/109413/how-do-i-use-overlayfs
#mkdir over l k g
#sudo mount -t squashfs extraer-UBUNTU/casper/filesystem.squashfs over
#sudo mount -t overlayfs -o lowerdir=over,upperdir=k,workdir=l overlayfs g


echo ---------------------
echo "p
q
" | sudo fdisk   /dev/${DISCO}

echo ---------------------


#ojo no comienza en 0 como usb-creator, pero escribo al disco no a la particion
# la tabla es sobreescrita por el iso, quien contiene una pseudo particion 2 fat con lo uefi
#la particion 1 comienza en 0 lo que no es corecto

#sudo fdisk /dev/${DISCO}


#echo "
#n
#p
#2
#
#+10M
#t
#1
#0
#t
#2
#ef
#a
#1
#w
#" |  fdisk /dev/${DISCO}


#sudo fdisk /dev/${DISCO}


#echo Creo efi
#sudo mkfs.vfat /dev/${DISCO}2
#sudo mkdir -p /tmp/2
#sudo mount /dev/${DISCO}2 /tmp/2
#echo Copio efi
#sudo cp -r efi /tmp/2
#sudo umount /dev/${DISCO}2

#sudo fdisk /dev/${DISCO}


#sudo mkfs.ext4 /dev/${DISCO}3
#sudo mkdir -p /tmp/3
#sudo mount /dev/${DISCO}3 /tmp/3
#sudo dd if=/dev/zero of=/tmp/3/casper-rw  bs=4M count=512



#n
#p
#3
#
#+4100M

#t
#3
#83
