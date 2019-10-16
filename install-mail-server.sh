# from docker-webmail Dockerfile
# FROM centos
# LABEL maintainer="NAKANO Hideo <nakano@web-tips.co.jp>"

sudo yum -y install patch postfix dovecot

#
# setup postfix
#
sudo cp ./assets/postfix/master.cf.patch /tmp/master.cf.patch
sudo cp -n /etc/postfix/master.cf /etc/postfix/master.cf.orig
sudo patch /etc/postfix/master.cf < /tmp/master.cf.patch

sudo cp ./assets/postfix/main.cf.patch /tmp/main.cf.patch
sudo cp -n /etc/postfix/main.cf /etc/postfix/main.cf.orig
sudo patch /etc/postfix/main.cf < /tmp/main.cf.patch

sudo cp ./assets/postfix/header_checks.patch /tmp/header_checks.patch
sudo cp -n /etc/postfix/header_checks /etc/postfix/header_checks.orig
sudo patch /etc/postfix/header_checks < /tmp/header_checks.patch

sudo groupadd -g 10000 mailuser
sudo useradd -u 10000 -g mailuser -s /sbin/nologin mailuser
sudo mkdir /var/spool/virtual
sudo chown -R mailuser:mailuser /var/spool/virtual

sudo cp ./assets/postfix/vmailbox /etc/postfix/vmailbox
sudo postmap /etc/postfix/vmailbox

sudo /usr/libexec/postfix/aliasesdb
sudo /usr/libexec/postfix/chroot-update

#
# setup dovecot
#
sudo cp ./assets/dovecot/10-auth.conf.patch /tmp/10-auth.conf.patch
sudo cp -n /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.orig
sudo patch /etc/dovecot/conf.d/10-auth.conf < /tmp/10-auth.conf.patch

sudo cp ./assets/dovecot/10-mail.conf.patch /tmp/10-mail.conf.patch
sudo cp -n /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.orig
sudo patch /etc/dovecot/conf.d/10-mail.conf < /tmp/10-mail.conf.patch

sudo cp ./assets/dovecot/10-master.conf.patch /tmp/10-master.conf.patch
sudo cp -n /etc/dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf.orig
sudo patch /etc/dovecot/conf.d/10-master.conf < /tmp/10-master.conf.patch

sudo cp ./assets/dovecot/10-ssl.conf.patch /tmp/10-ssl.conf.patch
sudo cp -n /etc/dovecot/conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf.orig
sudo patch /etc/dovecot/conf.d/10-ssl.conf < /tmp/10-ssl.conf.patch

sudo cp ./assets/dovecot/20-imap.conf.patch /tmp/20-imap.conf.patch
sudo cp -n /etc/dovecot/conf.d/20-imap.conf /etc/dovecot/conf.d/20-imap.conf.orig
sudo patch /etc/dovecot/conf.d/20-imap.conf < /tmp/20-imap.conf.patch

sudo cp ./assets/dovecot/90-quota.conf.patch /tmp/90-quota.conf.patch
sudo cp -n /etc/dovecot/conf.d/90-quota.conf /etc/dovecot/conf.d/90-quota.conf.orig
sudo patch /etc/dovecot/conf.d/90-quota.conf < /tmp/90-quota.conf.patch

sudo cp ./assets/dovecot/auth-passwdfile.conf.ext.patch /tmp/auth-passwdfile.conf.ext.patch
sudo cp -n /etc/dovecot/conf.d/auth-passwdfile.conf.ext /etc/dovecot/conf.d/auth-passwdfile.conf.ext.orig
sudo patch /etc/dovecot/conf.d/auth-passwdfile.conf.ext < /tmp/auth-passwdfile.conf.ext.patch

sudo cp ./assets/dovecot/users /etc/dovecot/users

# EXPOSE 25
# EXPOSE 143
# EXPOSE 587

# CMD /usr/sbin/postfix start && /usr/sbin/dovecot -F

sudo systemctl enable dovecot
sudo systemctl start dovecot
sudo systemctl enable postfix
sudo systemctl start postfix

