#!/bin/bash

#----------------------------------SNAPPER-----------------------------------

umount /.snapshots
rm -r /.snapshots
snapper -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a
btrfs subvolume set-default 256 /
chown -R :wheel /.snapshots/

sed -i '/ALLOW_GROUPS=""/c \ALLOW_GROUPS="wheel"' /etc/snapper/configs/root
sed -i '/TIMELINE_LIMIT_HOURLY="10"/c \TIMELINE_LIMIT_HOURLY="5"' /etc/snapper/configs/root
sed -i '/TIMELINE_LIMIT_DAILY="10"/c \TIMELINE_LIMIT_DAILY="7"' /etc/snapper/configs/root
sed -i '/TIMELINE_LIMIT_MONTHLY="10"/c \TIMELINE_LIMIT_MONTHLY="0"' /etc/snapper/configs/root
sed -i '/TIMELINE_LIMIT_YEARLY="10"/c \TIMELINE_LIMIT_YEARLY="0"' /etc/snapper/configs/root

systemctl enable grub-btrfs.path
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleanup.timer
systemctl enable sddm

# ---------------------------------REBOOT--------------------------------------

echo
/bin/echo -e "\e[1;32mREBOOTING IN 5..\e[0m"
sleep 1
echo
/bin/echo -e "\e[1;32mREBOOTING IN 4..\e[0m"
sleep 1
echo
/bin/echo -e "\e[1;32mREBOOTING IN 3..\e[0m"
sleep 1
echo
/bin/echo -e "\e[1;32mREBOOTING IN 2..\e[0m"
sleep 1
echo
/bin/echo -e "\e[1;32mREBOOTING IN 1..\e[0m"
sleep 1
echo
/bin/echo -e "\e[1;32mR E B O O T I N G\e[0m"
sleep 1
reboot

