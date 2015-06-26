#!/bin/bash
# Close log file
	echo "GoToLogFiles log finished $(date)" >> $LOGFILE

# Collect log file
	rsync -aP $LOGFILE $TEMPDIR/GoToLogFiles.log

# Create a compressed archive of all collected data.
	tar -czf $ENDFILE -C $TEMPDIR .
