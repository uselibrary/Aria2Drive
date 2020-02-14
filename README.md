# Aria2Drive

Script for oneindex, aria2, AriaNG and rclone to built remote cloud storage.

详细说明请访问

Aria2Drive为一键脚本，将会为你打造一个利用aria2和onedrive实现离线下载功能的私有网盘，只支持Debian 9（主要是因为没时间去适配其他系统，我主用Debian系），考虑到稳定性问题，推荐使用纯净系统进行运行和安装。

地址为<https://github.com/uselibrary/Aria2Drive>

一键脚本如下，推荐边运行脚本边看教程，<https://pa.ci/95.html>

wget --no-check-certificate -O Aria2Drive.sh <https://raw.githubusercontent.com/uselibrary/Aria2Drive/master/Aria2Drive.sh> && chmod +x Aria2Drive.sh && bash Aria2Drive.sh

首先，你得有一台具有root权限的运行Debian 9的服务器/VPS，以及一个OneDrive账号。 以下外部软件将会被安装（将会自动安装，不必过多关注），以实现离线下载和网盘列表的功能： 基础性软件：vim git curl wget unzip 维持性软件：nginx php-fpm php-curl 功能性软件：aria2 AriaNG Oneindex rclone
