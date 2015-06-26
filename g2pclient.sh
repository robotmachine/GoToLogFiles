#!/bin/bash
# This script makes a compressed archive of the current user's desktop of log files, system diagnostics, and other Citrix Online related items.
# Written by Brian Carter & Kyle Halversen
source start.sh
#cutthis elif [ $@ = "GoToMyPC_Client" ]; then

# Collect GoToMyPC Client logs
	if [ -d ~/Library/Logs/com.citrixonline.GoToMyPC ] && [ "$(ls -A ~/Library/Logs/com.citrixonline.GoToMyPC)" ] ; logcomment "GoToMyPC: Client Logs" ; rsync -aP ~/Library/Logs/com.citrixonline.GoToMyPC/* $TEMPDIR/Endpoint_Logs/ >> $LOGFILE 2>&1 ; else logcomment "GoToMyPC: Client Logs .:. No Logs Found" ; fi

source finish.sh
