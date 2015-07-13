#!/bin/bash
# This script makes a compressed archive of the current user's desktop of log files, system diagnostics, and other Citrix Online related items.
# Written by Brian Carter & Kyle Halversen
source start.sh
#cutthis elif [ $@ = "GoToMyPC_Host" ]; then

# Collect GoToMyPC Host Log Files
	if [ -d /Library/Logs/com.citrixonline.GoToMyPC ] && [ "$(ls -A /Library/Logs/com.citrixonline.GoToMyPC)" ] ; then logcomment "GoToMyPC: Host Log Files" ; rsync -av /Library/Logs/com.citrixonline.GoToMyPC/* $TEMPDIR/Endpoint_Logs/ >> $LOGFILE 2>&1 ; else logcomment "GoToMyPC: Host .:. No Logs Found" ; fi

# Copy GoToMyPC Plist to text
	if ls /Library/Preferences/com.citrixonline.GoToMyPC* 1> /dev/null 2>&1 ; then
		if [[ ! -e $TEMPDIR/Plist ]] ; then mkdir $TEMPDIR/Plist ; fi
		for FILE in /Library/Preferences/com.citrixonline.GoToMyPC* ; do
			defaults read $FILE > $TEMPDIR/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "GoToMyPC Plist .:. No plist files found."
	fi
source finish.sh
