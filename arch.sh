apt-get install ruby -y

gem install lolcat

clear

echo Love By LwinGyi ❤ Yuri | lolcat -a -d 500

apt install figlet -y

clear

figlet WELCOME TO LWINGYI YURI Script | lolcat -a -d 13  -F 0.1 -t -p 3.0 -S 1  -f

clear

echo -e "\e[96m╔═════════════════════════════════════════════════════════════════════════════════════════╗  "

echo -e "\e[96m║ ██╗     ██╗    ██╗██╗███╗   ██╗ ██████╗ ██╗   ██╗██╗   ♡   ██╗   ██╗██╗   ██╗██████╗ ██╗♡ "

echo -e "\e[96m║ ██║     ██║    ██║██║████╗  ██║██╔════╝ ╚██╗ ██╔╝██║   ♡   ╚██╗ ██╔╝██║   ██║██╔══██╗██║♡  "

echo -e "\e[96m║ ██║     ██║ █╗ ██║██║██╔██╗ ██║██║  ███╗ ╚████╔╝ ██║   ♡    ╚████╔╝ ██║   ██║██████╔╝██║♡ "

echo -e "\e[96m║ ██║     ██║███╗██║██║██║╚██╗██║██║   ██║  ╚██╔╝  ██║   ♡     ╚██╔╝  ██║   ██║██╔══██╗██║♡  "

echo -e "\e[96m║ ███████╗╚███╔███╔╝██║██║ ╚████║╚██████╔╝   ██║   ██║   ♡      ██║   ╚██████╔╝██║  ██║██║♡ "

echo -e "\e[96m║ ╚══════╝ ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝   ♡      ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝♡  "

echo -e "\e[96m╚═══════════One day I will marry Yuri and realize my dreams just like Yuri═══════════════╝  "

sleep 15

figlet Welcome To BlackArchLinux | lolcat -a -d 13  -F 0.1 -t -p 3.0 -S 1  -f

#!/data/data/com.termux/files/usr/bin/bash

folder=arch-fs

if [ -d "$folder" ]; then

	first=1	echo "skipping downloading"

fi

tarball="arch-rootfs.tar.gz"

if [ "$first" != 1 ];then

	if [ ! -f $tarball ]; then

		echo "Download Rootfs, this may take a while base on your internet speed."

		case `dpkg --print-architecture` in

		aarch64)

			archurl="aarch64" ;;

		arm)

			archurl="armv7" ;;

		*)

			echo "unknown architecture"; exit 1 ;;

		esac

		wget "http://os.archlinuxarm.org/os/ArchLinuxARM-${archurl}-latest.tar.gz" -O $tarball

	fi

	cur=`pwd`

	mkdir -p "$folder"

	cd "$folder"

	echo "Decompressing Rootfs, please be patient."

	proot --link2symlink tar -xf ${cur}/${tarball}||:

	cd "$cur"

fi

mkdir -p arch-binds

bin=start-arch.sh

echo "writing launch script"

cat > $bin <<- EOM

#!/bin/bash

echo " "

echo " "

echo " "

echo "If you are first time starting Arch Linux, you should run this command: chmod 755 && ./additional.sh , this will fix the pacman-key and network problem."

echo " "

echo " "

echo " "

cd \$(dirname \$0)

if [ `id -u` = 0 ];then

    pulseaudio --start --system

else

    pulseaudio --start

fi

## unset LD_PRELOAD in case termux-exec is installed

unset LD_PRELOAD

command="proot"

command+=" --link2symlink"

command+=" -0"

command+=" -r $folder"

if [ -n "\$(ls -A arch-binds)" ]; then

    for f in arch-binds/* ;do

      . \$f

    done

fi

command+=" -b /dev"

command+=" -b /proc"

command+=" -b arch-fs/root:/dev/shm"

## uncomment the following line to have access to the home directory of termux

#command+=" -b /data/data/com.termux/files/home:/root"

## uncomment the following line to mount /sdcard directly to / 

#command+=" -b /sdcard"

command+=" -w /root"

command+=" /usr/bin/env -i"

command+=" HOME=/root"

command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"

command+=" TERM=\$TERM"

command+=" LANG=C.UTF-8"

command+=" /bin/bash --login"

com="\$@"

if [ -z "\$1" ];then

    exec \$command

else

    \$command -c "\$com"

fi

EOM

echo "Setting up pulseaudio so you can have music in distro."

pkg install pulseaudio -y

if grep -q "anonymous" ~/../usr/etc/pulse/default.pa;then

    echo "module already present"

else

    echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> ~/../usr/etc/pulse/default.pa

fi

echo "exit-idle-time = -1" >> ~/../usr/etc/pulse/daemon.conf

echo "Modified pulseaudio timeout to infinite"

echo "autospawn = no" >> ~/../usr/etc/pulse/client.conf

echo "Disabled pulseaudio autospawn"

echo "export PULSE_SERVER=127.0.0.1" >> arch-fs/etc/profile

echo "Setting Pulseaudio server to 127.0.0.1"

echo "fixing shebang of $bin"

termux-fix-shebang $bin

echo "making $bin executable"

chmod +x $bin

echo "removing image for some space"

rm $tarball

echo "You can now launch Arch Linux with the ./${bin} script"

echo "Preparing additional component for the first time, please wait..."

wget "https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Arch/armhf/resolv.conf" -P arch-fs/root

wget "https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Arch/armhf/additional.sh" -P arch-fs/root

echo "Done Thanks For Using The Script By LwinGyi♥️Yuri"
