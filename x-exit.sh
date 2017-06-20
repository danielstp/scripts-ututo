#llamar como source


cp /etc/hosts.real /etc/hosts 

# poner esto afuera como algo que se hace una vez
rm -rf /tmp/* ~/.bash_history

#rm /etc/resolv.conf

/etc/init.d/dbus stop

rm /var/lib/dbus/machine-id 

rm /sbin/initctl 

dpkg-divert --rename --remove /sbin/initctl

umount /proc || umount -lf /proc 

umount /sys 

umount /dev/pts 




#no funciona como salir para afuera exit si no es source
#'kill -9 $PPID'


