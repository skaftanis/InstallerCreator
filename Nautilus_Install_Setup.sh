#!/bin/bash


cp src/"Install It" ~/.local/share/nautilus/scripts/
chmod +x ~/.local/share/nautilus/scripts/"Install It"

cp src/"Uninstall" ~/.local/share/nautilus/scripts/
chmod +x ~/.local/share/nautilus/scripts/"Uninstall"

zenity --question --title="InstallerCretor" --text="Done! Restart Nautilus Now?"
if [ $? = 0 ]; then
	killall nautilus
	nautilus &
fi

