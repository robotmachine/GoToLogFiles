#!/bin/bash
# This takes all of the different scripts and puts them together to be dropped in to Automator.
# Written by Brian Carter

# Using Unix epoch for temp filename.
VOLTRON=Combined_$(date +%s).txt
#
processor () {
	cat "$@" | sed '1,3d' | awk '!/source/' | sed 's/#cutthis //' >> $VOLTRON
	echo "" >> $VOLTRON
}
processor start.sh
processor g2ac.sh
processor g2ars.sh
processor g2m.sh
processor g2phost.sh
processor g2pclient.sh
echo -e "\nelse\n  logcomment 'No product selected'\nfi\n" >> $VOLTRON
processor finish.sh
