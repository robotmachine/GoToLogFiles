#!/bin/bash
#
#
# Close log file
	logcomment "GoToLogFiles log finished $(date)"

# Collect log file
	rsync -a $LOGFILE $TEMPDIR/GoToLogFiles.log

# Create a compressed archive of all collected data.
	tar -czf $ENDFILE -C $TEMPDIR .
