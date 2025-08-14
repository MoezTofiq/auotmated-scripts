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
