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

source finish.sh
