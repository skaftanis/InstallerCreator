#!/bin/bash

#basic funtion for cancel button
function quitCheck {
  if [ $? = 1 ]; then
	exit
  fi
}

#create an array with movies/serries names 
	#find lines of name.txt
	LINES=`wc -l < ~/.InstallerCreator`
	#create the array
	k=1 #helping var
	counter=1;
	for i in `seq 1 $LINES`; do
		#if [ `expr $i % 2` -ne 0 ]; then
		temp=`sed -n "${i}p" ~/.InstallerCreator`
		if [ "$temp" != "NULL" ]; then 
			array[k]=$temp
		else
			counter=`expr $counter + 1`
		fi
		k=`expr $k + 1`
		#fi		
	done

if [ $counter -eq $k ]; then 
zenity --info --text="Empty List! Please Enter an Serrie first!"

else 
#choose movies/serrie (20 serries maximum)
CHOICE=`zenity --list --text="Choose the movie/serrie you want to remove. DOUBLE CLICK IT!" --column='' ${array[1]} ${array[2]} ${array[3]} ${array[4]} ${array[5]} ${array[6]} ${array[7]} ${array[8]} ${array[9]} ${array[10]} ${array[11]} ${array[12]} ${array[13]} ${array[14]} ${array[15]} ${array[16]} ${array[17]} ${array[18]} ${array[19]} ${array[20]}`
quitCheck
fi

#fix choice format
IFS="|"
temp=($CHOICE)
CHOICE=${temp[1]}
#IFS=""

#take password
PASS=$(zenity --password --title="Give your sudo password")
quitCheck

#remove executable from /usr/bin
echo "echo -e $PASS | sudo -S rm /usr/bin/$CHOICE" > temp
xterm -e bash temp


#remove .desktop file
echo "echo -e $PASS | sudo -S rm /usr/share/applications/$CHOICE.desktop" > temp
xterm -e bash temp

rm temp

#set old name equal to NULL
OLD=$CHOICE
NEW=NULL
sed -i "s/$OLD/$NEW/g" ~/.InstallerCreator

notify-send "$CHOICE uninstalled succesfuly!"
