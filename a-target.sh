#!/bin/bash

# montaje de sistemas dinámicos

if test ! -e /prov/version ; then
  mount -t proc none /proc 
fi

if test ! -e /sys/module ; then
  mount -t sysfs none /sys
fi
if test ! -e /dev/pts/0 ; then    
  mount -t devpts none /dev/pts
fi



#sudo mount -o bind /run /mnt/run
# podria usarse para entre otras cosas tener resolv.conf que es un link a /run/resolvconf/resolv.conf
#https://wiki.ubuntu.com/DebootstrapChroot

#/run
#/run/shm
#/proc/sys/fs/binfmt_mist
#/var/lib/nfs/rpc_pipefs
#/proc/fs/nfsd
#/proc/bus/usb
# establecer variables para resolver problemas con  gpg y otros 
export HOME=/root 
export LC_ALL=C

cp /etc/hosts /etc/hosts.real
cp /root/hostscrea /etc/hosts
# para programas que usan dbus

#apt-get install dbus

mkdir -p /var/lib/dbus
dbus-uuidgen > /var/lib/dbus/machine-id

# para evitar que los paquetes con demonios protesten (caso cups)  
dpkg-divert --local --rename --add /sbin/initctl 
ln -s /bin/true /sbin/initctl
/etc/init.d/dbus start

cd /root
