
PLYMOUTH_THEME="arch-glow" # can grab from config later if we allow selection
mkdir -p /mnt/usr/share/plymouth/themes
echo 'Installing Plymouth theme...'
cp -rf /root/fresh/plymouth/themes/${PLYMOUTH_THEME} /usr/share/plymouth/themes
sed -i 's/HOOKS=(base udev*/& plymouth/' /etc/mkinitcpio.conf # add plymouth after base udev
plymouth-set-default-theme -R arch-glow # sets the theme and runs mkinitcpio
echo 'Plymouth theme installed'
