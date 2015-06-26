#!/bin/bash
# This script makes a compressed archive of the current user's desktop of log files, system diagnostics, and other Citrix Online related items.
# Written by Brian Carter & Kyle Halversen
source start.sh
#cutthis elif [ $@ = "GoToMyPC_Host" ]; then

# Collect GoToMyPC Host Log Files
	if [ -d /Library/Logs/com.citrixonline.GoToMyPC ] && [ "$(ls -A /Library/Logs/com.citrixonline.GoToMyPC)" ] ; then logcomment "GoToMyPC: Host Log Files" ; rsync -av /Library/Logs/com.citrixonline.GoToMyPC/* $TEMPDIR/Endpoint_Logs/ >> $LOGFILE 2>&1 ; else logcomment "GoToMyPC: Host .:. No Logs Found" ; fi

source finish.sh
