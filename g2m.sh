#/bin/bash
# This script makes a compressed archive of the current user's desktop of log files, system diagnostics, and other Citrix Online related items.
# Written by Brian Carter & Kyle Halversen
source start.sh
#cutthis elif [ $@ = "GoToMeeting" ]; then

# Collect GoToMeeting and GoToMeeting Recording Manager logs
	if [ -d ~/Library/Logs/com.citrixonline.GoToMeeting ] && [ "$(ls -A ~/Library/Logs/com.citrixonline.GoToMeeting)" ] ; then logcomment "GoToMeeting: Log Files" ; rsync -av ~/Library/Logs/com.citrixonline.GoToMeeting/* $TEMPDIR/Endpoint_Logs >> $LOGFILE 2>&1 ; else logcomment "GoToMeeting: Log Files .:. No Logs Found" ; fi
	if [ -d ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager ] && [ "$(ls -A ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager)" ]; then logcomment "GoToMeeting: Recording Manager Log Files"rsync -av ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager/* $TEMPDIR/Recording_Manager >> $LOGFILE 2>&1 ; elif [ -d ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager ] && [ "$(ls -A ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager)" ] ; then logcomment "GoToMeeting: Recording Manager Log Files" ; rsync -av ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager/* $TEMPDIR/Recording_Manager  >> $LOGFILE 2>&1 ; else logcomment "GoToMeeting: Recording Manager Log Files .:. No Logs Found" ;  fi

# Copy preferences to a text file.
	if ls ~/Library/Preferences/com.citrixonline.GoToMeeting* 1> /dev/null 2>&1 ; then
		if [[ ! -e $TEMPDIR/Plist ]] ; then mkdir $TEMPDIR/Plist ; fi
		for FILE in ~/Library/Preferences/com.citrixonline.GoToMeeting* ; do
			defaults read $FILE > $TEMPDIR/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "GoToMeeting Plist .:. No plist files found."
	fi

# Sample GoToMeeting processes if they are running
	mkdir $TEMPDIR/Sample
	logcomment "GoToMeeting: Sample Process .:. Only Errors Logged"
	sample GoToMeeting > $TEMPDIR/Sample/GoToMeeting_Sample.txt 2>>$LOGFILE
	sample "GoToMeeting Recording Manager" > $TEMPDIR/Sample/GoToMeetingRecMgr_Sample.txt 2>>$LOGFILE

source finish.sh
