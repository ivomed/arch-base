#!/usr/bin/env bash

#-----------------------------------PARU----------------------------------

sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/paru-bin
cd paru-bin
makepkg -si --noconfirm

# ---------------------------------APPS-----------------------------------

paru -S --noconfirm aic94xx-firmware wd719x-firmware brave-bin zramd snap-pac-grub snapper-gui

#----------------------------------NVIDIA DRIVERS-------------------------

sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings

# ---------------------------------VIRT MANAGER---------------------------

sudo pacman -S --noconfirm qemu-base libvirt edk2-ovmf virt-manager vde2 dnsmasq bridge-utils ovmf openbsd-netcat

#----------------------------------KDE------------------------------------

sudo pacman -Syu --noconfirm --needed
sudo pacman -S --noconfirm plasma-desktop plasma-nm plasma-pa kdeplasma-addons kde-gtk-config powerdevil sddm sddm-kcm bluedevil kscreen khotkeys kinfocenter ffmpegthumbs

#----------------------------------SERVICES-------------------------------

sudo systemctl enable bluetooth
sudo systemctl enable zramd.service
sudo timedatectl set-local-rtc 1
sudo systemctl enable --now libvirtd.service
sudo systemctl enable --now virtlogd.socket
sudo virsh net-autostart default
sudo virsh net-start default
cd ..

sudo sed -i '$ a\ivo    ALL=(ALL)    NOPASSWD: /usr/bin/virsh' /etc/sudoers
chsh -s /bin/fish

# ---------------------------------THEME SETTINGS-------------------------

tar -C ~/ -xzvf base-home.tar.gz
rm base-home.tar.gz
sudo mv /home/ivo/Abstract.jpeg /usr/share/wallpapers/
sudo mv /home/ivo/Arch.png /usr/share/wallpapers/
sudo rm -rf /usr/share/sddm/themes/maldives
sudo rm -rf /usr/share/sddm/themes/maya
sudo rm -rf /usr/share/sddm/themes/elarun
sudo rm -rf /usr/share/sddm/themes/breeze
