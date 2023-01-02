#!/bin/bash

#----------------------------------VRIJEME--------------------------------

ln -sf /usr/share/zoneinfo/Europe/Zagreb /etc/localtime
hwclock --systohc
timedatectl set-ntp true

#----------------------------------LOCALE---------------------------------

sed -i '/#en_US.UTF-8 UTF-8/c \en_US.UTF-8 UTF-8' /etc/locale.gen
sed -i '/#hr_HR.UTF-8 UTF-8/c \hr_HR.UTF-8 UTF-8' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=croat" >> /etc/vconsole.conf

#----------------------------------NAME-----------------------------------

echo "IME" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 IME.localdomain IME" >> /etc/hosts
echo root:PASSWD | chpasswd

#----------------------------------APPS-----------------------------------

pacman -Sy --noconfirm --needed
pacman -S --noconfirm base-devel linux-zen-headers linux-firmware grub efibootmgr dosfstools os-prober mtools networkmanager dialog wpa_supplicant wireless_tools nano wget reflector snapper btrfs-progs grub-btrfs duf dolphin konsole rsync ark unzip ntfs-3g kate bash-completion sof-firmware flatpak kinit ttf-droid ttf-hack ttf-font-awesome otf-font-awesome ttf-lato ttf-liberation ttf-linux-libertine ttf-opensans ttf-roboto ttf-ubuntu-font-family terminus-font ufw cronie ksysguard htop kfind sshfs samba openssh nfs-utils cups nmap print-manager cups-pdf grub-customizer bleachbit neofetch stress fish partitionmanager filelight packagekit-qt5 kdiskmark 

#----------------------------------BTRFS----------------------------------

sed -i '/MODULES=()/c \MODULES=(btrfs)' /etc/mkinitcpio.conf
mkinitcpio -p linux-zen

#----------------------------------GRUB-----------------------------------

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/c \GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 amd_iommu=on"' /etc/default/grub
sleep 1
sed -i '63s/.//' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

#----------------------------------USER------------------------------------

useradd -mG wheel,users,storage,power,lp,adm,optical,audio,video ivo
echo ivo:PASSWD | chpasswd
echo "ivo ALL=(ALL) ALL" >> /etc/sudoers.d/ivo

#----------------------------------SUDO-----------------------------------

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

#----------------------------------MULTILIB-------------------------------

sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo "[chaotic-aur]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
#----------------------------------SERVICES-------------------------------

systemctl enable NetworkManager
systemctl enable cups.service
systemctl enable cronie
systemctl enable sshd
systemctl enable smb
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl mask hibernate.target hybrid-sleep.target

#----------------------------------RAZNO-----------------------------------

echo "Numlock=On" >> /etc/sddm.conf
sed -i '12s/.//' /etc/profile.d/freetype2.sh
echo "PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"" >> /etc/environment
echo "EDITOR="/usr/bin/vim"" >> /etc/environment
sed -i '/#DefaultTimeoutStopSec=90s/c \DefaultTimeoutStopSec=10s' /etc/systemd/system.conf
mkdir /mnt/nas
chown ivo:ivo /mnt/nas
chsh -s /bin/fish

tar -C /usr/share/sddm/themes/ -xzvf sddm-dragon.tar.gz
rm sddm-dragon.tar.gz

#----------------------------------EXIT----------------------------------

printf "\e[1;32mDONE! Exit, umount -a and REBOOT \e[0m"
