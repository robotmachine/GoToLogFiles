#!/bin/bash
# This script makes a compressed archive of the current user's desktop of log files, system diagnostics, and other Citrix Online related items.
# Written by Brian Carter & Kyle Halversen
source start.sh
#cutthis if [ $@ = "GoToAssist_Corporate" ]; then

# Collect GoToAssist Corporate logs
	logcomment "GoToAssist Corporate: Logs"
	rsync -av ~/Library/Logs/com.citrixonline.g2ac* $TEMPDIR/Endpoint_Logs/ >> $LOGFILE 2>&1
	rsync -av ~/Library/Logs/com.citrixonline.g2a.customer $TEMPDIR/Endpoint_Logs_Customer/ >> $LOGFILE 2>&1

source finish.sh
