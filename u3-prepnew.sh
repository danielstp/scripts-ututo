#!/bin/bash

#http://www.in-ulm.de/~mascheck/various/shebang/

source 00-config.sh


svn propset svn:executable ON *.sh

#https://major.io/2014/07/29/adventures-in-live-booting-linux-distributions/

echo ------------------------------------------------------
echo "NOMBREDESTINO (Directorio donde se crea la nueva imagen, subdirs iso, root, initrd; nombre de la nueva iso):"
echo "     $NOMBREDESTINO"

echo "TMP (lugar donde hace cosas temporarias, mejor SSD): "
echo "     $TMP"
echo "PARTITION (el NOMBREDESTINO suele crearse en una particion independiente (mejor en ssd), para poder bootearla en serio): "
echo "           si es vacia no se usa particion"
echo "     $PARTITION"
echo ------------------------------------------------------
# USAR PARTICION

if test  "x$NOMBREDESTINO" == "x" ; then
    echo NOMBREDESTINO vacio
    exit
fi



mkdir -p  $NOMBREDESTINO/root

sudo umount  $NOMBREDESTINO/root
if test x$PARTITION != "x" ; then
    sudo mount /dev/$PARTITION  $NOMBREDESTINO/root
    echo Si el comando anterior funciono ROOT creado_  $NOMBREDESTINO/root  montado en /dev/$PARTITION    
else
    echo ROOT creado:  $NOMBREDESTINO/root no montado
fi


DIR=`pwd`

CANT2=`ls $NOMBREDESTINO/root| wc -l`
echo entradas en  $NOMBREDESTINO/root: $CANT2

echo COPIA ROOT

if test "x$CANT2" == "x0" ; then       #si no hay nada en el punto de montaje, monta
    echo Copia $NOMBREORIGEN/root en $NOMBREDESTINO/root
    mkdir -p $NOMBREORIGEN/root #pq mkdir de nuevo? tambvien en 001
    cd $NOMBREORIGEN/root
    sudo cp  -ar * $DIR/$NOMBREDESTINO/root 2>/dev/null
    cd $DIR
else
   echo Vacie $NOMBREDESTINO/root si quiere releer la iso mediante: sudo rm -rf $NOMBREDESTINO/iso
fi
#sudo chown -R root:root $DIR/$NOMBREDESTINO/root

############# prepara raiz, lo hace una sola vez, no cada vez que entra al chroot


#cp /etc/resolv.conf  .   # esto garantizaria que internet funcione como en el host
# mejor uno generico con 8.8.8.8

# estos fueron armados de diuversas fuentes y conocimientos

sudo cp fuentes/lightdm.conf  $NOMBREDESTINO/root/etc/lightdm
sudo cp fuentes/resolv.conf $NOMBREDESTINO/root/etc/
sudo cp fuentes/hosts $NOMBREDESTINO/root/etc/
sudo cp   /etc/hosts   $NOMBREDESTINO/root/root/hostscrea
sudo cp fuentes/hostname $NOMBREDESTINO/root/etc/
#sudo cp fuentes/config $NOMBREDESTINO/root/boot
# queda el nombre de la maquina dsa-casa y necesita estar en hosts!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! CAMBIAR
sudo cp fuentes/sources-$NOMBREORIGEN.list $NOMBREDESTINO/root/etc/apt/sources.list 
#hacer el -DEBIAN
# revisar hosts


################## ojo con 1610

# se hace en dos etapas porque todavia no hay usuario ututo en el destino
if test ! -e fuentes/simusol-instalar-todo-last.tar.gz ; then
    cd fuentes
    wget simusol.org/downloads/simusol-instalar-todo-last.tar.gz
    cd ..
fi

sudo cp fuentes/simusol-instalar-todo-last.tar.gz $NOMBREDESTINO/root/root

echo "mkdir -p $NOMBREDESTINO/iso/isolinux"
mkdir -p $NOMBREDESTINO/iso/isolinux
mkdir -p $NOMBREDESTINO/iso/boot
mkdir -p $NOMBREDESTINO/iso/casper


#sudo apt-get source gfxboot-theme-ubuntu gfxboot 
#cd gfxboot-theme-ubuntu*/ 
#make DEFAULT_LANG=es 
#sudo cp -af boot/* ../extraer/isolinux/



if  test ! -e  $NOMBREDESTINO/iso/isolinux/isolinux.bin ; then
 
  ./01-isolinux.sh

  cd $ISOLINUXDIR
  cp bios/core/isolinux.bin ../$NOMBREDESTINO/iso/isolinux
  cp bios/com32/elflink/ldlinux/ldlinux.c32 ../$NOMBREDESTINO/iso/isolinux
  cd ..

  mkdir -p $NOMBREDESTINO/iso/boot/grub
  mkdir -p $NOMBREDESTINO/iso/EFI/BOOT
  mkdir -p $NOMBREDESTINO/iso/.disk
  
  sudo cp fuentes/grub.cfg  $NOMBREDESTINO/iso/boot/grub
  sudo cp fuentes/isolinux.cfg  $NOMBREDESTINO/iso/isolinux

  cd fuentes/EFI
  sudo cp -ar * ../../$NOMBREDESTINO/iso/EFI
  cd ../disk
  sudo cp -ar * ../../$NOMBREDESTINO/iso/.disk
  cd ../boot
  sudo cp -ar * ../../$NOMBREDESTINO/iso/boot
  cd ../..
fi



# usa nucleo instalado en la HOST, cambiar instalar linux en otro lado, quizas en TARGET

# se recomienda hacere eso antes y que cuando llegue aca este hecho y probado
# esto compila e instala un nucleo nuevo en la maquina !!!!!!!!!!!!!!!!!!!!


echo Copia INITRD
if test ! -e $NOMBREDESTINO/initrd/init  ; then 
  cd $NOMBREORIGEN/initrd
  sudo cp -ar *  $DIR/$NOMBREDESTINO/initrd
  cd ../..
fi

###poner en otro lugar
sudo cp fuentes/uuid.conf  $NOMBREDESTINO/initrd/conf


echo KERNEL

if test ! -e linux-$KERNELVER ; then
     tar -xf $KERNELNAME 

fi    
 
if test ! -e fuentes/config.kernel ; then
   cp $NOMBREORIGEN/root/boot/config-$SOURCEKERNELDIR fuentes/config.kernel
fi

cp fuentes/config.kernel linux-$KERNELVER/.config

echo KERNEL 002

ls $LINUX_INSTALL

if test ! -e $LINUX_INSTALL/vmlinuz ; then 
    ./02-linuxlibre.sh
    # dar exit al menuconfig
  else
      echo si se quiere recrear borrar  $LINUX_INSTALL/vmlinuz
      echo tambien todo el directorio de linux-$KERNELVER para recompilar de cero
    #echo "sudo cp /boot/vmlinuz-4.9.1-gnu /boot/vmlinuz-4.9.1-gnu.back"
    #echo "sudo rm /boot/vmlinuz-4.9.1-gnu"
    # como la maquina puede bootear ese sistema mejor dejar un back, por si sale mal
fi    


#copia a root, no esta todavia home/ututo

sudo rm $NOMBREDESTINO/root/boot/*

# ver de usar siempre el misno nombre y tipo de nucleo e imagen para todos los proyectos, el estilo ututense de hacer isos live

# es necesario que el linux cree al menos el include aparte, para ver que hizo y borrar lo que estaba

DIR=`pwd`

# usar esto 
if test ! -e $NOMBREDESTINO/root/lib/modules/$KERNELDIR/kernel ; then
 SACARINCLUDE=`ls  $LINUX_INSTALL/usr/include`
 echo $LINUX_INSTALL/usr/include - $SACARINCLUDE

 echo BORRA MODULES FIRMWARE INCLUDE

 for INC in $SACARINCLUDE ; do
     sudo rm -rf $NOMBREDESTINO/root/usr/include/$INC
 done;

 sudo rm -rf   $NOMBREDESTINO/root/lib/modules/*
 sudo mkdir -p $NOMBREDESTINO/root/lib/modules
 sudo rm -rf   $NOMBREDESTINO/root/lib/firmware/*
 sudo mkdir -p $NOMBREDESTINO/root/lib/firmware

 # SACAR /root/lib/modules/KERNEL/build y source
 sudo rm  $NOMBREDESTINO/root/lib/modules/$KERNELDIR/kernel/build
 sudo rm  $NOMBREDESTINO/root/lib/modules/$KERNELDIR/kernel/source


 sudo mkdir -p $NOMBREDESTINO/root/lib/modules/$KERNELDIR/kernel
 sudo mkdir -p $NOMBREDESTINO/root/lib/firmware
 echo "MODULES DEL KERNEL"
 cd $LINUX_INSTALL/lib/modules/$KERNELDIR/
 sudo cp -ar *  $DIR/$NOMBREDESTINO/root/lib/modules/$KERNELDIR/

 cd $DIR
 echo "FIRMWARE DEL KERNEL" # mal copia de otros nucleos
 cd $LINUX_INSTALL/lib/firmware
 sudo cp -ar *  $DIR/$NOMBREDESTINO/root/lib/firmware

 cd $DIR



######### aqui poner todos los nombres que se puedan encontrar, si no estan no hay problema
sudo rm -f $NOMBREDESTINO/root/vmlinuz
sudo rm -f $NOMBREDESTINO/iso/casper/vmlinuz.efi  #o no copiarlos, ver


# lso arranques de isolinux y efi apuntan a casper solo con vmlinuz e initrd.lz
sudo cp  $LINUX_INSTALL/vmlinuz $NOMBREDESTINO/iso/casper
sudo cp  $LINUX_INSTALL/System.map $NOMBREDESTINO/iso/casper
sudo cp  $LINUX_INSTALL/System.map $NOMBREDESTINO/root/boot


######### aqui poner todos los nombres que se puedan encontrar, si no estan no hay problema
sudo rm -f $NOMBREDESTINO/root/vmlinuz
sudo rm -f $NOMBREDESTINO/iso/casper/vmlinuz.efi  #o no copiarlos, ver



#sudo ln -s $NOMBREDESTINO/root/boot/$IMAGEN  $NOMBREDESTINO/root
#rm $ARMA/casper/vmlinuz*
#cp linux-$KERNLEVER/arch/x86/boot/bzImage extraerP/casper/vmlinuz
#echo "linux-$KERNLEVER/arch/x86/boot/bzImage extraerP/casper"

#http://oss.sgi.com/LDP/HOWTO/Kernel-HOWTO/kernel_files_info.html
 
# touch "DESTINOrootlibinstalado"  # o poner con la compilacion del nucleo overificar algun archivo sea el mismo
fi


if test ! -e fuentes/moduleskernelubuntu ; then
  cd $NOMBREORIGEN/initrd/lib/modules/$SOURCEKERNELDIR/kernel
  sudo bash -c "find . > ../../../../../../fuentes/moduleskernelubuntu"
  cd ../../../../../..
else
  echo borre fuentes/moduleskernelubuntu si quiere recrear lista  
fi

cd $DIR

if test ! -e fuentes/firmwareubuntu ; then
  cd  $NOMBREORIGEN/initrd/lib/firmware
  sudo bash -c "find . > ../../../../fuentes/firmwareubuntu"
  cd ../../../..
 else
  echo borre fuentes/firmwareubuntu si quiere recrear lista  
fi


cd $DIR

echo INITRD
# trucho usar mkinitrd u otro mejor suse y devian-live

# ver si existe el kerneldir en lib/modules o esta otro
if test ! -e $NOMBREDESTINO/cambiadoinitrdlib ; then

  # sudo rm -rf   $NOMBREDESTINO/initrd/lib/modules/*
  # sudo mkdir -p $NOMBREDESTINO/initrd/lib/modules
  # sudo rm -rf   $NOMBREDESTINO/initrd/lib/firmware/*
  # sudo mkdir -p $NOMBREDESTINO/initrd/lib/firmware

  echo MODULES
  sudo rm -rf $NOMBREDESTINO/initrd/lib/modules/
  sudo mkdir -p $NOMBREDESTINO/initrd/lib/modules/$KERNELDIR/kernel
  sudo rm -rf $NOMBREDESTINO/initrd/lib/firmware
  sudo mkdir -p $NOMBREDESTINO/initrd/lib/firmware



  
  # esto no esta si no se ejecuto el kernel, usar
  # borrar destino si no esta
  cd $NOMBREDESTINO/root/lib/modules/$KERNELDIR/kernel

  while IFS='' read -r line || [[ -n "$line" ]]; do
   if test -f $line ; then
       sudo cp --parents $line  ../../../../../../$NOMBREDESTINO/initrd/lib/modules/$KERNELDIR/kernel
     else
      if test -d $line ; then
          echo Directory $line
          # podria crearse y no usar parents
      fi
   fi
  done < "../../../../../../fuentes/moduleskernelubuntu"
  cd ../../../../../..

  echo FIRMWARE

  cd $NOMBREDESTINO/root/lib/firmware

  while IFS='' read -r line || [[ -n "$line" ]]; do
   if test -f $line ; then
       sudo cp --parents $line  ../../../../$NOMBREDESTINO/initrd/lib/firmware
     else
      if test -d $line ; then
          echo Directory $line
          # podria crearse y no usar parents
      fi
   fi
  done < "../../../../fuentes/firmwareubuntu"
  cd ../../../..
  
  touch $NOMBREDESTINO/cambiadoinitrdlib

else

    echo si quiere recrear el cambio borre    $NOMBREORIGEN/initrd/lib/modules/$SOURCEKERNELDIR/kernel/cambiado 

fi


echo CREA INITRD

sudo cp $NOMBREORIGEN/initrd/lib/modules/$SOURCEKERNELDIR/modules* $NOMBREDESTINO/initrd/lib/modules/$KERNELDIR/

if test ! -e  $NOMBREDESTINO/iso/casper/initrd.lz ; then
    ./03-initrd.sh
    # lo pone $NOMBREDESTINO/iso/casper/initrd.lz
    # que lo cree en otro lugar asi si se corta, no lo da por hecho, solo si completa lo pone ahi
else
    echo si se quiere recrear borrar $NOMBREDESTINO/iso/casper/initrd.lz
fi




sudo rm -f $NOMBREDESTINO/root/initrd.lz
sudo rm -f $NOMBREDESTINO/root/initrd.img

# el script lo pone en casper con nombre initrd.lz
sudo cp $NOMBREDESTINO/iso/casper/initrd.lz  $NOMBREDESTINO/root/boot/initrd.lz

sudo rm -f $NOMBREDESTINO/root/initrd.lz
sudo ln -s /boot/initrd.lz  $NOMBREDESTINO/root

# debe estar aca antes de squashroot
sudo cp $LINUX_INSTALL/vmlinuz $NOMBREDESTINO/root/boot  
sudo ln -s /boot/vmlinuz  $NOMBREDESTINO/root/vmlinuz

echo MODIFICA ROOT

if test ! -e $NOMBREDESTINO/root/usr/local/bin/simusol ; then
    ./04-gochroot.sh auto
fi    

echo crea SQUASH ROOT

if test ! -e   $NOMBREDESTINO/iso/casper/filesystem.squashfs ; then
   ./05-makeroot.sh
fi


#You use a separate tool to create an initrd image.
#Most distros use a command called mkinitrd, but Fedora has a tool called dracut that is supposed to# replace mkinitrd


echo PERSISTENCIA
#dd if=/dev/zero of=casper-rw  bs=1M count=4096
#mkfs.ext4 -m 0 casper-rw




sudo cp fuentes/uuid.conf  $NOMBREDESTINO/iso/.disk/casper-uuid-generic
cd  $NOMBREDESTINO/iso

#poner fecha automatica

 #establecer el nombre de la imagen
# no lo cambio porque al igual que .disk los usa para identificar la particion root a montar (squashfs)

#HACER



sudo bash -c "echo \"$NOMBREDESTINO (20170101)\" > .disk/info"

sudo bash -c "echo \"#define DISKNAME $NOMBREDESTINO\" > README.diskdefines"
sudo bash -c "echo \"#define TYPE binary\"     >> README.diskdefines"
sudo bash -c "echo \"#define TYPEbinary 1\"    >> README.diskdefines"
sudo bash -c "echo \"#define TYPE ARCH i386\"  >> README.diskdefines"
sudo bash -c "echo \"#define TYPE ARCHi386 1\" >> README.diskdefines"
sudo bash -c "echo \"#define TYPE DISKNUM 1\"  >> README.diskdefines"
sudo bash -c "echo \"#define TYPE DISKNUM1 1\" >> README.diskdefines"


 sudo rm md5sum.txt 
# find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt

sudo bash -c "   find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat > md5sum.txt "


if test -e  casper-rw ; then
 echo ya existe casper-rw
else
 echo Crea casper-rw
 #sudo dd if=/dev/zero of=casper-rw  bs=4M count=990  status=progress
 #sudo dd if=/dev/zero of=casper-rw  bs=4M count=50  status=progress
fi
