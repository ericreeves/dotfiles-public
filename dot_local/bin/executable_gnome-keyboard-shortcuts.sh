#!/bin/bash
for i in 1 2 3 4 5 6 7 8 9; do
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-${i} "['<Control><Alt>${i}']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-${i} "['<Alt>${i}']"
done

gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Control><Alt>0']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Alt>0']"
