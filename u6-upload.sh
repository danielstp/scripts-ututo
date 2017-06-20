source 00-config.sh
#cp *.sh scripts
#cp README scripts
#cp  lightdm.conf hosts grub.cfg isolinux.cfg resolv.conf sources-UBUNTU.list stdmenu.cfg txt.cfg scripts

#scp scripts/*  www-data@ututo.org:/var/www/ututo.org/public_html/cms/downloads/scripts
 rsync -rsh='ssh' -av --progress --partial  $NOMBREDESTINO/$NOMBREDESTINO.iso www-data@ututo.org:/var/www/ututo.org/public_html/cms/downloads


