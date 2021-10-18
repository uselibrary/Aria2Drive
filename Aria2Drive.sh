#!/bin/bash

clear
echo "    ################################################"
echo "    #                                              #"
echo "    #                   Aria2Drive                 #"
echo "    #                  https://pa.ci               #"
echo "    #                  Version 0.1.2               #"
echo "    ################################################"

#check system pure debian
echo -e ""
if cat /etc/*-release | grep -Eqi "debian|ubuntu"; then
  echo "Debian/ubuntu"
else
  echo "Only Debain and ubuntu are supported"
  echo "***EXIT***"
  sleep 1
  exit
fi
if dpkg -l | grep -Eqi "nginx|apache|caddy"; then
  echo "System has been modified"
  echo "Pure Debain or ubuntu is needed!"
  echo "***EXIT***"
  sleep 1
  exit
fi

#set up bbr
if lsmod | grep -Eqi bbr; then
  echo "bbr is running"
else
  echo "set up bbr"
  echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
  sysctl -p
  if lsmod | grep -Eqi bbr; then
    echo "bbr is installed"
  else
    echo "There is something wrong with bbr"
    echo "please check your system"
    echo "***EXIT***"
    sleep 1
    exit
  fi
fi

#update system and install needed software
apt update -y && apt upgrade -y
apt install vim git curl wget unzip -y
apt install nginx -y
apt install php-fpm php-curl -y

#set up nginx
rm /var/www/html/index.nginx-debian.html
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
cd /etc/nginx/sites-available
wget --no-check-certificate -O domain https://raw.githubusercontent.com/uselibrary/Aria2Drive/master/domain
read -p "please input yourdomain: " yourdomain
sed "s/server_name _;/server_name ${yourdomain};/g" domain -i
mv domain ${yourdomain}
ln -s /etc/nginx/sites-available/${yourdomain} /etc/nginx/sites-enabled/
systemctl restart nginx

#install oneindex
cd /home
git clone https://github.com/ikym/Oneindex.git
mv Oneindex/* /var/www/html/
cd /var/www/html
wget --no-check-certificate -O robots.txt https://raw.githubusercontent.com/uselibrary/Aria2Drive/master/robots.txt
rm README.md
chmod -R +777 cache config
echo -ne '\n*/10 * * * * php /var/www/html/one.php cache:refresh' >>/etc/crontab

#install aria2 and AriaNG
apt install aria2 -y
mkdir /etc/aria2
mkdir /home/download
cd /etc/aria2
touch /etc/aria2/aria2.session
wget --no-check-certificate -O aria2.conf https://raw.githubusercontent.com/uselibrary/Aria2Drive/master/aria2.conf
sed "s/dl.pa.ci/${yourdomain}/g" aria2.conf -i
read -p "please input aria2 password: " aria2password
sed "s/hostlocmjj/${aria2password}/g" aria2.conf -i
mkdir /var/www/html/AriaNG
cd /home
NGver=$(wget --no-check-certificate -qO- https://api.github.com/repos/mayswind/AriaNg/releases/latest | grep 'tag_name' | cut -d\" -f4)
wget --no-check-certificate -O AriaNg.zip https://github.com/mayswind/AriaNg/releases/download/${NGver}/AriaNg-${NGver}.zip
unzip -d /var/www/html/AriaNG/ AriaNg.zip
rm /var/www/html/AriaNG/LICENSE
wget --no-check-certificate -O autoupload.sh https://raw.githubusercontent.com/uselibrary/Aria2Drive/master/autoupload.sh
chmod +777 /home/autoupload.sh
cd /lib/systemd/system
wget --no-check-certificate -O aria2.service https://raw.githubusercontent.com/uselibrary/Aria2Drive/master/aria2.service
systemctl enable aria2
systemctl start aria2

#install ssl
cd /home
apt install snapd
snap install core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
certbot --nginx

#install rclone
#apt install rclone is coming to have better performance
cd /home
curl https://rclone.org/install.sh | bash
rclone config
read -p "please input remote drive name again: " drivename
sed "s/OD/${drivename}/g" autoupload.sh -i

echo "FINISHED"
echo "it is recommended to reboot!"
