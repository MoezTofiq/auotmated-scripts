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
sudo apt install i3lock
```

- go to :

```
cd ~/.config/i3
```

- open :

```
nano config
```

- remove bar block

paste PERSONAL CODE BLOCK and restart i3

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
