#!/bin/bash



#basic funtion for cancel button
function quitCheck {
  if [ $? = 1 ]; then
	exit
  fi
}


#start up message
zenity --info --title="Installer Creator" --text="Select the executive file. Make sure that you will not move it to another location after that"
quitCheck

#file selection with zenity
zenity --info --title="Install It" --text="Select an executable"
quitCheck
ANS=`zenity --file-selection --title="Select executive"`
quitCheck

#take the real name of application
REALNAME=`zenity --entry --text="Please enter the name of the application (no need to be the same with executive). Please DON'T use spaces" --title="Choose Name"`
quitCheck

echo ANS=$ANS

#take the executive name (last part of ANS)
IFS="/"
temp=($ANS)
COUNT=`grep -o "/" <<<"$ANS" | wc -l`
NAME=${temp[$COUNT]} 

name_count=${#NAME}
#remove executive name from ANS
IFS=""
#ANS=`echo ${ANS//$NAME}` OLD WAY (bugy) (when folder and executive have the same name) 
for ((i=0;i<$name_count;i++))
do
	ANS=`echo "${ANS%?}"`
done

#create executive file (temp for now)
echo "cd $ANS" > $REALNAME
echo " " >> $REALNAME
echo "chmod +x $NAME" >> $REALNAME
echo "./$NAME" >> $REALNAME
echo "java -jar $NAME" >> $REALNAME


#take icon location
zenity --info --title="Install It" --text="Select an icon"
quitCheck
ICON=`zenity --file-selection --title="Select Icon"`
quitCheck

#take password
PASS=$(zenity --password --title="Give your sudo password")
quitCheck

#Copy icon to /usr/share/pixmaps
echo "echo $PASS | sudo -S cp $ICON /usr/share/pixmaps" > temp
xterm -e bash temp


#Move generated executive to /usr/bin
echo "echo $PASS | sudo -S mv $REALNAME /usr/bin" > temp
xterm -e bash temp

#Make it executalbe
echo "echo  $PASS | sudo -S chmod +x /usr/bin/$REALNAME" > temp
xterm -e bash temp

#take icon name (last part of ICON)
IFS="/"
temp=($ICON)
COUNT=`grep -o "/" <<<"$ICON" | wc -l`
ICON_NAME=${temp[$COUNT]} 


#Create .desktop file
 echo "[Desktop Entry]" > $REALNAME.desktop
	    echo >> $REALNAME.desktop
	    echo Name="$REALNAME" >> $REALNAME.desktop
	    echo >> $REALNAME.desktop 
	    echo Exec="\"$REALNAME\"" >> $REALNAME.desktop
	    echo >> $REALNAME.desktop
	    echo Type="Application" >> $REALNAME.desktop
	    echo Icon=/usr/share/pixmaps/$ICON_NAME >> $REALNAME.desktop
	    echo >> $REALNAME.desktop 

#move .desktop file to /usr/share/applications
echo "echo $PASS | sudo -S mv $REALNAME.desktop /usr/share/applications" > temp
xterm -e bash temp

rm temp

echo $REALNAME >> ~/.InstallerCreator


notify-send "$REALNAME installed succesfuly!"
