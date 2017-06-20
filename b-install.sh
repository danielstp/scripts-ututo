#!/bin/bash

#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 12345678  #Substitute "12345678" with the PPA's OpenPGP ID.

apt-get update



## falla ubunto  si hago esto, parece
## sudo apt-get -y upgrade
# al sacar este paquete virtual y a no hace upgrade mas del kernel
# esto no funciona porque al remover esos uiere poner los especificos
#apt-get -y remove linux-headers-generic linux-image-generic
#linux-image-4.4.0-59-generic linux-image-extra-4.4.0-59-generic linux-signed-image-4.4.0-59-generic  linux-signed-image-generic
# usar pinning o algo asi

# ptobbar ahora con upgrade

apt-get -y install vlc

apt-get -y install vrms zip unzip  sharutils file-roller   unace  p7zip-full uudeview mpack lhasa arj cabextract 
apt-get -y install mc emacs build-essential  subversion openssh-server
#display

#sudo apt-get -y install texlive-latex-base texlive-lang-spanish latex2html

#apt-get install --yes ubuntu-standard casper lupin-casper
#no porque hace initramfs

#apt-get -y install --yes discover laptop-detect os-prober

### NO
#apt-get install --yes linux-generic

#apt-get -y install --no-install-recommends network-manager
#apt-get install --yes grub2 plymouth-x11
apt-get -y install ubiquity-frontend-gtk


#ls /boot/vmlinuz-2.6.**-**-generic > list.txt
#sum=$(cat list.txt | grep '[^ ]' | wc -l)

#if [ $sum -gt 1 ]; then
#dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge
#fi

#rm list.txt

apt-get clean   # si instalo algo mas hacerlo de nuevo

#aca no tiene sentido lo hace antes del chroot
#sudo umount /dev


#- install the makedev package, and create a default set of static device files using (after chrooting)
# apt-get install makedev
# mount none /proc -t proc
# cd /dev
# MAKEDEV generic
#cd /dev/ 
#sudo MAKEDEV generic

#paquete gdm no disponible

# se debiera iniciar lightdm, pero no se hara
#sudo apt-get install gdm3
#sudo /etc/init.d/gdm3 start

#sudo /etc/init.d/networking restart

export EP=`perl -e 'printf("%s\n", crypt($ARGV[0], "password"))' "enter"`
useradd -m -p $EP -s /bin/bash ututo
usermod -a -G sudo ututo


# comentario viejo
# ojo con esto todavia no esta creado ututo en chroot y ademas nada garantiza que el numero de usuario de ututo sea el mismo que en el chroot, ni que exista en e host, hacer esto adentro del chroot
# LO PASO A TARGET

mv /root/simusol-instalar-todo-last.tar.gz /home/ututo
chown ututo /home/ututo/simusol-instalar-todo-last.tar.gZ
chown ututo /root/*.sh  # agregado root



echo "ututo ALL = NOPASSWD: ALL" >> /etc/sudoers #si no se hace esto no le da tty al make cuando instalo el simusol
su ututo -c "rm -rf  /home/ututo/sit"
su ututo -c "tar -xzvf /home/ututo/simusol-instalar-todo-last.tar.gz -C /home/ututo"

su ututo -c "make -C /home/ututo/sit"

