#!/bin/bash

echo "Début de la mise à jour de la configuration vsftpd..."

# Mise à jour de la configuration vsftpd
sed -i -r "s/#write_enable=YES/write_enable=YES/1" /etc/vsftpd.conf
sed -i -r "s/#chroot_local_user=YES/chroot_local_user=YES/1" /etc/vsftpd.conf

echo "Ajout de configurations supplémentaires à vsftpd.conf..."
cat <<EOL >> /etc/vsftpd.conf
local_enable=YES
allow_writeable_chroot=YES
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40005
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO
EOL

# Si $FTP_USER et $FTP_PASSWORD sont définis
if [ -n "$FTP_USER" ] && [ -n "$FTP_PASSWORD" ]; then
    # Création de l'utilisateur FTP
    echo -e "$FTP_PASSWORD\n$FTP_PASSWORD\n" | adduser --gecos "" --home /home/$FTP_USER --shell /bin/bash $FTP_USER
    echo "Utilisateur $FTP_USER ajouté."
    
    # Ajout de l'utilisateur à vsftpd.userlist
    echo "$FTP_USER" | tee -a /etc/vsftpd.userlist

    # Configuration des répertoires
    mkdir -p /home/$FTP_USER/ftp/files
    chown nobody:nogroup /home/$FTP_USER/ftp
    chmod a-w /home/$FTP_USER/ftp
    chown $FTP_USER:$FTP_USER /home/$FTP_USER/ftp/files
else
    echo "Les variables FTP_USER ou FTP_PASSWORD ne sont pas définies."
    exit 1
fi

# Correction des permissions avant démarrage
echo "Correction des permissions du répertoire FTP..."
chmod -R 755 /home/$FTP_USER/ftp
chown -R $FTP_USER:$FTP_USER /home/$FTP_USER/ftp

# Création du répertoire chroot sécurisé
mkdir -p /var/run/vsftpd/empty
chown root:root /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

echo "Démarrage de vsftpd en avant-plan..."
# Démarrage de vsftpd en avant-plan
exec /usr/sbin/vsftpd /etc/vsftpd.conf

