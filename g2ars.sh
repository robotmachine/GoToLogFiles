#!/bin/bash
# This script makes a compressed archive of the current user's desktop of log files, system diagnostics, and other Citrix Online related items.
# Written by Brian Carter & Kyle Halversen
source start.sh
#cutthis elif [ $@ = "GoToAssist_Remote_Support" ]; then

# Collect GoToAssist Remote Support Logs
	if [ -d ~/Library/Logs/com.citrixonline.g2a.rs/customer ]; then logcomment "GoToAssist Remote Support: Logs" ; rsync -av ~/Library/Logs/com.citrixonline.g2a.rs/customer $TEMPDIR/Customer_Endpoint_Logs/ >> $LOGFILE 2>&1 ; fi
	if [ -d ~/Library/Logs/com.citrixonline.g2a.rs/Expert ]; then logcomment "GoToAssist Remote Support: Logs" ; rsync -av ~/Library/Logs/com.citrixonline.g2a.rs/Expert $TEMPDIR/Expert_Endpoint_Logs/ >> $LOGFILE 2>&1 ; fi
	if [ -d /Library/Logs/com.citrixonline.g2a.rs ]; then logcomment "GoToAssist Remote Support: Logs" ; rsync -av /Library/Logs/com.citrixonline.g2a.rs $TEMPDIR/Unattended_Endpoint_Logs/ >> $LOGFILE 2>&1 ; fi
	if [ -d ~/Library/Logs/com.citrixonline.g2ax ]; then logcomment "GoToAssist Remote Support: Logs" ; rsync -av ~/Library/Logs/com.citrixonline.g2ax $TEMPDIR/Pre_Build_403_Logs/ >> $LOGFILE 2>&1 ; fi
	if [ -d ~/Library/Logs/com.citrixonline.g2ax.customer ]; then logcomment "GoToAssist Remote Support: Logs" ; rsync -av ~/Library/Logs/com.citrixonline.g2ax.customer $TEMPDIR/Pre_Build_403_Logs/ >> $LOGFILE 2>&1 ; fi
	if [ -d ~/Library/Logs/com.citrixonline.g2ax.expert ]; then logcomment "GoToAssist Remote Support: Logs" ; rsync -av ~/Library/Logs/com.citrixonline.g2ax.expert $TEMPDIR/Pre_Build_403_Logs/ >> $LOGFILE 2>&1 ; fi

# Copy preferences to a text file.
	if ls ~/Library/Preferences/com.citrixonline.g2ax* 1> /dev/null 2>&1 ; then
		mkdir $TEMPDIR/Plist
		for FILE in ~/Library/Preferences/com.citrixonline.g2ax* ; do
			defaults read $FILE > $TEMPDIR/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "GoToAssist Remote Support Plist .:. No plist files found."
	fi

source finish.sh
