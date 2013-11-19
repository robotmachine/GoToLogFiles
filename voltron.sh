#!/bin/bash
# This takes all of the different scripts and puts them together to be dropped in to Automator.
# Written by Brian Carter

# Using Unix epoch for temp filename.
VOLTRON=Combined_$(date +%s).txt
echo "if [ $@ = "GoToMyPC_Host" ]; then" >> $VOLTRON
echo "" >> $VOLTRON
cat g2phost.sh >> $VOLTRON
echo "" >> $VOLTRON
echo "elif [ $@ = "GoToMyPC_Client" ]; then" >> $VOLTRON
echo "" >> $VOLTRON
cat g2pclient.sh >> $VOLTRON
echo "" >> $VOLTRON
echo "elif [ $@ = "GoToMeeting" ]; then" >> $VOLTRON
echo "" >> $VOLTRON
cat g2m.sh >> $VOLTRON
echo "elif [ $@ = "GoToMeeting_Recording_Logs" ]; then" >> $VOLTRON
echo "" >> $VOLTRON
cat g2mrec.sh >> $VOLTRON
echo "" >> $VOLTRON
echo "elif [ $@ = "GoToAssist_Corporate" ]; then" >> $VOLTRON
echo "" >> $VOLTRON
cat g2ac.sh >> $VOLTRON
echo "" >> $VOLTRON
echo "elif [ $@ = "GoToAssist_Remote_Support" ]; then" >> $VOLTRON
echo "" >> $VOLTRON
cat g2ars.sh >> $VOLTRON
echo "" >> $VOLTRON
echo "else" >> $VOLTRON
echo "	exit" >> $VOLTRON
echo "fi" >> $VOLTRON
