#!/bin/bash
source 00-config.sh
#https://kernelnewbies.org/KernelBuild
mkdir -p $LINUX_INSTALL
DIR=`pwd`
echo $DIR/$LINUX_INSTALL

cd  linux-$KERNELVER
#make olddefconfig
make menuconfig
make bzImage
cp  arch/x86/boot/bzImage $DIR/$LINUX_INSTALL/vmlinuz
cp  System.map $DIR/$LINUX_INSTALL/  
make modules
INSTALL_MOD_PATH=$DIR/$LINUX_INSTALL make modules_install
INSTALL_FW_PATH=$DIR/$LINUX_INSTALL/lib/firmware make firmware_install
# no se hace nada para el anterior
make headers_install ARCH=x86_64 INSTALL_HDR_PATH=$DIR/$LINUX_INSTALL/usr

cd ..


#sudo cp System.map-* /boot/

#sudo update-grub
## ojo sin PATH_INSTALL  lo instala en la maquina HOST, pero es bueno tenerlo ahi
# sobre todo si se tiene particion par el root

# instalar modulos en otro dir?



#cd /home/dsa/svn/Ututo

#rm -rf $ARMA/dists $ARMA/install $ARMA/pics  $ARMA/pool $ARMA/preseed $ARMA/ubuntu
