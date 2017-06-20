#sudo mount -n -o remount,suid  /dev/sdc1 
# si usted trabaja en un disco extraible se monta nosuid y no puede usar correctamente sudo y otras cosas

NOMBREORIGEN=ubuntu1604
if test x"$NOMBREORIGEN" == x"ubuntu1610" ; then
    DOWN=http://ubnt-releases.xfree.com.ar/ubuntu-releases/16.10/
    ISOORIGEN=ubuntu-16.10-desktop-amd64.iso
    SOURCEKERNELDIR=4.8.0-22-generic   
fi    
if test x"$NOMBREORIGEN" == x"ubuntu1604" ; then
    DOWN=http://ubnt-releases.xfree.com.ar/ubuntu-releases/16.04/
    ISOORIGEN=ubuntu-16.04.1-desktop-amd64.iso
    SOURCEKERNELDIR=4.4.0-31-generic
fi
if test x"$NOMBREORIGEN" == x"debian86" ; then
    ISOORIGEN=debian-live-8.6.0-amd64-gnome-desktop.iso 
fi

TMP=tmp    # poner en un ssd  /tmp seria por defecto

LINUX_INSTALL=linux-install

#echo "ISOORIGEN (imagen que se usara):  $ISOORIGEN"
#echo "DOWN (donde se la baja): $DOWN"
#echo "NOMBREORIGEN (Directorio donde se abre la imagen, subdirs iso, root, initrd): $NOMBREORIGEN"
#echo "TMP (lugar donde hace cosas temporarias, mejor SSD): $TMP"

NOMBREDESTINO=UtutoSimusolLibre-x86_64-2017-04
LONG=${#NOMBREDESTINO}

if test "$LONG" -gt 32 ; then 
   echo Longuitud de NOMBREDESTINO es $LONG mayor a 32 #xorriso 
   exit
fi

NOMBRE=$NOMBREDESTINO
#NOMBRE=Ututo-2017-D
#NOMBRE=Ututo-2017-UL
#NOMBRE=Simusol-2017-U
#NOMBRE=Simusol-2017-U

# eliminar estas tres cuando se pueda
EDIT=ISODESTINO/root
ARMA=ISODESTINO/iso
IMAGELZ=ISODESTINO/initrd
#ARMA=extraerP
#EXTRAER=extraer-$TIPOIMAGEN
#EDIT=edit-$TIPOIMAGEN
#IMAGELZ=lztempdir

PARTITION=sda6                                  # OJO ESTO DEPENDE DE LA MAQUINA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
PARTITION=
# hace que la busque con una etiqueta especial de que fue creada para esto

EXTRAER=ISOORIGEN/iso

KERNELVER=4.9.4
KERNELDIR=$KERNELVER-gnu
KERNELNAME=linux-libre-$KERNELVER-gnu.tar.bz2
KERNELURL=http://linux-libre.fsfla.org/pub/linux-libre/releases/LATEST-4.9.N/


TIPOIMAGEN=UBUNTU
# 
if test $TIPOIMAGEN==UBUNTU ; then 
   NUCLEOORIGEN=$ISOORIGEN/iso/casper/vmlinuz.efi
   IMAGENORIGEN=$ISOORIGEN/iso/casper/initrd.lz
else
  NUCLEOORIGEN=$ISOORIGEN/iso/live/vmlinuz
  IMAGENORIGEN=$ISOORIGEN/iso/live/initrd.img
fi

# OJO PONER ACA el archivo del nucleo libre
NUCLEOORIGEN=LIBRE # LIBRE lo toma del compilado del ultimo kernel libre

# el nombre del nucleo debe ser vmlinuz, y la imagen initrd.lz


ISOLINUXDIR=syslinux-6.04-pre1
ISOLINUXFILE=$ISOLINUXDIR.tar.xz
ISOLINUXURL=https://www.kernel.org/pub/linux/utils/boot/syslinux/Testing/6.04/$ISOLINUXFILE







# quizas no tenga sentido copiar directamente abrir cada imagen en mnt-$TIPOIMAGEN
# no usar $TIPOIMAGEN, usar $PROYECTO, para cada pendrive diferente, savlo en la pregunta arriba
# no usar $EDIT sino $RAIZ
