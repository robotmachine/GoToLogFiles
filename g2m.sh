#/bin/bash
# This script makes a compressed archive of the current user's desktop of log files, system diagnostics, and other Citrix Online related items.
# Written by Brian Carter & Kyle Halversen
source start.sh
#cutthis elif [ $@ = "GoToMeeting" ]; then

# Collect GoToMeeting and GoToMeeting Recording Manager logs
	rsync -aP ~/Library/Logs/com.citrixonline.GoToMeeting/* $TEMPDIR/Endpoint_Logs >> $LOGFILE
	if [ -d ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager ]; then rsync -aP ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager/* $TEMPDIR/Recording_Manager; elif [ -d ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager ]; then rsync -aP ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager/* $TEMPDIR/Recording_Manager; fi >> $LOGFILE

# Sample GoToMeeting processes if they are running
	mkdir $TEMPDIR/Sample
	sample GoToMeeting > $TEMPDIR/Sample/GoToMeeting_Sample.txt 2>&1
	sample "GoToMeeting Recording Manager" > $TEMPDIR/Sample/GoToMeetingRecMgr_Sample.txt 2>&1

source finish.sh
