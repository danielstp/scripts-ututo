#!/bin/bash
source 00-config.sh
# pensada para que sea repetible y si las cosas ya se hicieron las deje como estan. Esten o no esten debe llevar todo al estado querido, creo que se llma isopotente o idempotente a este tipo de programa

# no se olvide habilitar virtualizacion acelerada en el bios

echo ------------------------------------------------------
echo "ISOORIGEN (imagen que se usara):  $ISOORIGEN"
echo "DOWN (donde se la baja): $DOWN"
echo "NOMBREORIGEN (Directorio donde se abre la imagen, subdirs iso, root, initrd): $NOMBREORIGEN"
echo "TMP (lugar donde hace cosas temporarias, mejor SSD): $TMP"
echo ------------------------------------------------------



if test  "x$ISOORIGEN" == "x" ; then
    echo  ISOORIGEN vacio
    if test  "x$DOWN" == "x" ; then
        echo DOWN vacio
	echo Ambos esta na vacios no puedo seguir
	exit
    fi
fi

if test  "x$NOMBREORIGEN" == "x" ; then
    echo NOMBREORIGEN vacio
    exit
fi
if test  "x$TMP" == "x" ; then
    echo TMP vacio
    exit
fi



# posicionados en /svn/Ututo/

#echo Origen Iso tenia: -
#sudo bash -c "ls mntt 2>/dev/nul"  #si existe el directorio, muestra su directorio - 2 standard error
#echo ------------------- fin listado  origen iso: mnt


mkdir -p $TMP/mntt
sudo umount $TMP/mntt

rm -rf $TMP/mntt/*                       # nunca hhacer un rm -rf en cosas que no tengan un pedacito de camino sin variable, y un nombre  como /mnt no es bueno tampoco
# ojo quizas tmp no sea ssd

CANT=`ls $TMP/mntt| wc -l`  # puede no ser borrable
echo entradas en  $TMP/mntt: $CANT
if test "x$CANT" == "x0" ; then       #si no hay nada en el punto de montaje, monta
    echo Monta $ISOORIGEN en $TMP/mntt
    mkdir -p $TMP/mntt                    
    sudo mount -o loop $ISOORIGEN $TMP/mntt
else
    echo ERROR hay info en $TMP/mntt
fi



#echo Extraer tenia: ----
#sudo bash -c "ls $EXTRAER 2>/dev/nul" 
#echo ------------------- fin listado extraer

DIR=`pwd`

mkdir -p $NOMBREORIGEN/iso

CANT2=`ls $NOMBREORIGEN/iso| wc -l`
echo entradas en  $NOMBREORIGEN/iso: $CANT2

if test "x$CANT2" == "x0" ; then       #si no hay nada en el punto de montaje, monta
    echo copia $TMP/mntt en $NOMBREORIGEN/iso
    mkdir -p $NOMBREORIGEN/iso
    cd $TMP/mntt/
    cp  -ar * $DIR/$NOMBREORIGEN/iso 2>/dev/null
    cd $DIR
else
   echo Vacie $NOMBREORIGEN/iso si quiere releer la iso mediante: sudo rm -rf $NOMBREORIGEN/iso
fi


sudo umount $TMP/mntt
echo es correcto que no se monte


#  abre root

# no debe haber root para que funcione unsquash
#ls da cero aunque no exista avisa que no hay y dice 0 OK

CANT3=`ls $NOMBREORIGEN/root| wc -l`
echo es correcto que no se pueda acceder
echo entradas en  $NOMBREORIGEN/root: $CANT3

if test  x"$CANT3" == x"0"  ; then
    sudo rm -rf  $NOMBREORIGEN/root
    # debe ser sudo para crear algunos dispositivos en dev que los eliminamos y otros create_inode write_xattr:
    sudo unsquashfs -d $NOMBREORIGEN/root   $NOMBREORIGEN/iso/casper/filesystem.squashfs
    sudo rm -rf $NOMBREORIGEN/root/dev; 
    sudo mkdir  $NOMBREORIGEN/root/dev
  else
    echo ELIMINE  $NOMBREORIGEN/root si desea reCREAR, es distinto de vaciar
fi
#boprrados
#/dev/full
#/mapper/control
#/devv/null
#/dev/random
#/dev/tty
#/dev/urandom
#/dev/zero
#create_inode: could not create character device ubuntu1610/root/dev/zero, because you're not superuser!
#write_xattr: could not write xattr security.capability for file ubuntu1610/root/usr/bin/gnome-keyring-daemon because you're not superuser!


# abre initrd

mkdir -p  $NOMBREORIGEN/initrd

CANT4=`ls $NOMBREORIGEN/initrd| wc -l`
echo entradas en  $NOMBREORIGEN/initrd: $CANT
if test   x"$CANT4" == x"0"  ; then
 cd  $NOMBREORIGEN/initrd
 lzma -dc -S .lz ../iso/casper/initrd.lz | cpio -imvd --no-absolute-filenames 2>/dev/null
else
  echo Vacie   $NOMBREORIGEN/initrd si quiere recrear
fi



#ojo ver extraer, quizas no valga la pena guardar esa info, simplemente montar y copiar aca, y eliminar el extraer, ya mucha de esa info no la tomamos de cada pendrive, sino la tenemos preparada en forma eterna

# instalar uck


#    sudo umount $NOMBREORIGEN/root/dev  #para el caso de elminar otras cosas en $NOMBREORIGEN/root y que siga montado
# mv  $NOMBREORIGEN/root/dev  /tmp/dev    
