#!/bin/bash
# This takes all of the different scripts and puts them together to be dropped in to Automator.
# Written by Brian Carter

# Using Unix epoch for temp filename.
VOLTRON=Combined_$(date +%s).txt
cat g2ac.sh | sed '1,3d' | sed 's/#cutthis //' >> $VOLTRON
echo "" >> $VOLTRON
cat g2ars.sh | sed '1,3d' | sed 's/#cutthis //' >> $VOLTRON
echo "" >> $VOLTRON
cat g2m.sh | sed '1,3d' | sed 's/#cutthis //' >> $VOLTRON
echo "" >> $VOLTRON
cat g2mrec.sh | sed '1,3d' | sed 's/#cutthis //' >> $VOLTRON
echo "" >> $VOLTRON
cat g2pclient.sh | sed '1,3d' | sed 's/#cutthis //' >> $VOLTRON
echo "" >> $VOLTRON
cat g2phost.sh | sed '1,3d' | sed 's/#cutthis //' >> $VOLTRON
echo "" >> $VOLTRON
echo "else" >> $VOLTRON
echo "	exit" >> $VOLTRON
echo "fi" >> $VOLTRON
