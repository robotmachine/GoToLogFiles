#!/bin/bash
# This script makes a compressed archive of the current user's desktop of log files, system diagnostics, and other Citrix Online related items.
# Written by Brian Carter & Kyle Halversen
#cutthis elif [ $@ = "GoToMyPC_Host" ]; then

# Change the path or name of the files here:
FILEPATH=~/Desktop
DIRNAME=Citrix_Logs_G2PHost_$(date +%s)
#
# Don't change this:
TEMPDIR=$FILEPATH/.$DIRNAME
ENDFILE=$FILEPATH/$DIRNAME.tgz
LOGFILE=~/Library/Logs/com.citrixonline.g2logfiles.log

# Trap to remove the temporary directory when the script exits
cleanup() {
	rm -rf $TEMPDIR
}
trap "cleanup" EXIT

# Begin log file
	echo "GoToLogFiles log started $(date)" > $LOGFILE

# Create a temporary folder if it does not already exist.
	if [ ! -d "$TEMPDIR" ]; then mkdir $TEMPDIR; fi

# Copy CrashReporter files to a temporary folder.
	rsync -aP --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* $TEMPDIR/CrashReporterUser/ >> $LOGFILE
	rsync -aP /Library/Logs/DiagnosticReports/* $TEMPDIR/CrashReporterSystem/ >> $LOGFILE

# Copy the system log to the temporary folder.
	rsync -aP /private/var/log/system.log* $TEMPDIR/SystemLog/ >> $LOGFILE
	rsync -aP /private/var/log/install.log $TEMPDIR/SystemLog/ >> $LOGFILE

# Copy Endpoint Logs to the temporary folder.
	rsync -aP /Library/Logs/com.citrixonline.GoToMyPC/* $TEMPDIR/Endpoint_Logs/ >> $LOGFILE

# Copy launcher logs
	rsync -aP ~/Library/Logs/com.citrixonline.WebDeployment/* $TEMPDIR/Launcher_Logs/ >> $LOGFILE

# Get a list of running applications and installed applications.
	ps aux > $TEMPDIR/Processes.txt
	system_profiler SPApplicationsDataType >> $TEMPDIR/System_Profiler.txt
	system_profiler SPSoftwareDataType >> $TEMPDIR/System_Profiler.txt
	system_profiler SPHardwareDataType >> $TEMPDIR/System_Profiler.txt
	system_profiler SPDisplaysDataType >> $TEMPDIR/System_Profiler.txt
	system_profiler SPPowerDataType >> $TEMPDIR/System_Profiler.txt
	system_profiler SPAudioDataType >> $TEMPDIR/System_Profiler.txt
	system_profiler SPSerialATADataType >> $TEMPDIR/System_Profiler.txt

# Create a compressed archive of everything grabbed.
	tar -czf $ENDFILE -C $TEMPDIR .

# Close log file
	echo "Closed $(date)." >> $LOGFILE
