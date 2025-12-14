# auotmated-scripts

Scripts that I use with my ubuntu distro, check the readme file for instructions to link them

### open_tmux_in_terminal.sh

make sure to give the file permission:
`chmod +x open_tmux_in_terminal.sh`
Add the following code to the .bashrc file :

```
if [ -z "$TMUX" ]; then
	/home/moeez/automation/auotmated-scripts/open_tmux_in_terminal.sh
fi
```

### i3.config

if you are on ubuntu then

- install :

```
sudo apt install i3 i3lock xdotool brightnessctl playerctl i3status fonts-dejavu rofi network-manager-gnome blueman xfce4-power-manager  -y
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
sudo apt install pulseaudio-utils pipewire-pulse  volumeicon-alsa pavucontrol -y
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
