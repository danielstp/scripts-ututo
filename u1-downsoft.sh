#!/bin/bash
source 00-config.sh

LNUCLEO="libncurses5-dev libssl-dev  gcc make git exuberant-ctags bc libssl-dev xz-utils "

#dracut asciidoc, ojo instalar dracut en debian cambia mucho recompila y hace grubupdate
#lsinitrd
#https://catchchallenger.first-world.info/wiki/Quick_Benchmark:_Gzip_vs_Bzip2_vs_LZMA_vs_XZ_vs_LZ4_vs_LZO

# instalar manual en todo caso de fuentes


#fakeroot

#redhat sudo yum install gcc make git ctags ncurses-devel openssl-devel
#SUSE sudo zypper in git gcc ncurses-devel libopenssl-devel ctags cscope
LISOLINUX="nasm uuid-dev"
LISO="squashfs-tools genisoimage virtualbox dpkg-dev build-essential  isolinux xorriso"
LISTA=" vrms $LNUCLEO $LISOLINUX $LISO " #syslinux
for PROG in  $LISTA ;  do 
             echo $PROG
	     OKP=`dpkg-query -W -f='${Status}' $PROG 2>/dev/null`; # da lo mismo si no esta que si no existe en general, si esta da "install ok installed", si no nada
	     if test x"$OKP" = x ; then
		echo FALTA $PROG 
	        break; 
	     fi;
done;

if test x"$OKP" == x ; then 
		sudo apt-get update  
		#sudo apt-get upgrade
		sudo apt-get  --force-yes --yes install $LISTA ; 
fi;



   if test ! -e $KERNELNAME ; then 
       #comprobar si hay internet, y si ya esta completo
       echo       wget  $KERNELURL$KERNELNAME
      wget  $KERNELURL/$KERNELNAME
   else
       echo Ya tenemos$KERNELNAME
   fi
  
#wget
#tar -jxvf linux-libre-$nucleov-gnu.tar.bz2
# unxz linux-4.9.tar.xz
# gpg --keyserver hkp://keys.gnupg.net --recv-keys 00411886
# gpg --verify linux-4.9.tar.sign

#####
#make-kpkg clean
#fakeroot make-kpkg --initrd --revision=1.0.NAS kernel_image kernel_headers -j 16

# bajar
if test ! -e $ISOORIGEN ; then 
    #comprobar si hay internet, y si ya esta completo 
    wget  $DOWN/$ISOORIGEN
else
    echo Ya tenemos  $ISOORIGEN
fi
# revisar si esta bajada incompleta con wget -c
#https://www.kernel.org/pub/linux/utils/boot/syslinux/
#https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz




if test ! -e $ISOLINUXDIR ; then 
   if test ! -e $ISOLINUXFILE ; then 
      #comprobar si hay internet, y si ya esta completo 
      wget  $ISOLINUXURL
   else
       echo Ya tenemos $ISOLINUXFILE
   fi
   tar -xf  $ISOLINUXFILE
fi
