# auotmated-scripts

Scripts that I use with my ubuntu distro, check the readme file for instructions to link them

## DEBIAN 13 packages to install :

go line by line :

```
sudo apt update
sudo apt install wget gpg apt-transport-https
```

```
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
```

```
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
```

```
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)
```

apt installs :

```

sudo apt install code snapd git

```

```
sudo systemctl enable --now snapd
```

snap installs :

```
sudo snap install todoist
```

install nvidea package :https://wiki.debian.org/NvidiaGraphicsDrivers

install docker :
https://docs.docker.com/engine/install/debian/

install nvm and node :
https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04#option-3-installing-node-using-the-node-version-manager

install steam :
https://wiki.debian.org/Steam#NVIDIA

need to enable non-free repos with nvidia driver install

### i3.config

if you are on ubuntu then

- install :

```

sudo apt install i3 i3lock xdotool brightnessctl playerctl i3status fonts-dejavu rofi network-manager-gnome blueman xfce4-power-manager -y

```

- do :

```

sudo usermod -aG video $USER

```

```

sudo nano ~/.config/i3/powermenu.sh

```

copy and paste :

```

#!/bin/bash

options="Shutdown\nReboot\nLogout\nSuspend"

chosen=$(echo -e $options | rofi -dmenu -i -p "Power")

case "$chosen" in
Shutdown) systemctl poweroff ;;
Reboot) systemctl reboot ;;
Logout) i3-msg exit ;;
Suspend) systemctl suspend ;;
esac

```

- do :

```

sudo chmod +x ~/.config/i3/powermenu.sh

```

- got to :

```

cd ~/.config/i3

```

- open :

```

nano config

```

- remove bar block
- remove or comment out dmenu binding

paste PERSONAL CODE BLOCK and restart i3

- add external display options :

```

mkdir -p ~/.config/i3/scripts

```

copy the files in the new scripts folder:
internal_mirror.sh
external_only.sh

run the commands :

```

chmod +x ~/.config/i3/scripts/internal_mirror.sh
chmod +x ~/.config/i3/scripts/external_only.sh

```

if volume does not work :

install :

```

sudo apt install pulseaudio-utils pipewire-pulse volumeicon-alsa pavucontrol -y

```

### 90-touch.conf

```

cd /etc/X11/xorg.conf.d

```

create the file :

```

nano 90-touchpad.conf

```

and paste the content of the file

### i3 status config

```

nano ~/.i3status.conf

```

copy i3status.conf

### if only ubuntu is installed on the system:

```

sudo nano /etc/default/grub

```

change the lines to the below :

```

GRUB_TIMEOUT_STYLE=menu
GRUB_TIMEOUT=5

```

do :

```

sudo update-grub
sudo reboot

```

### Bash config

`sudo nano ~/.bashrc `

copy code from `barshrc` at the bottom of it

### neovim config :

- install nvim :

```

sudo apt install neovim

```

- create config dir :

```

mkdir -p ~/.config/nvim

```

- copy init.vim file there

### overall package install for ubuntu :

```

sudo apt install joystick jstest-gtk

```

```

sudo cp 30-logitech-F710-gamepad.rules /etc/udev/rules.d/

```

```

```
