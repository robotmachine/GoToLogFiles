#!/bin/bash
# This script makes a compressed archive of the current user's desktop of log files, system diagnostics, and other Citrix Online related items.
# Written by Brian Carter & Kyle Halversen
#cutthis elif [ $@ = "GoToMeeting_Recording_Logs" ]; then

# Set a variable for the temporary directory.
TEMPDIR=~/Desktop/GoToMeeting_Recording_Logs
LOGFILE=~/Library/Logs/com.citrixonline.g2logfiles.log

# Create a temporary folder if it does not already exist.
	if [ ! -d "$TEMPDIR" ]; then mkdir $TEMPDIR; fi

# Trap to remove the temporary directory when the script exits
cleanup() {
	rm -rf $TEMPDIR
}
trap "cleanup" EXIT

# Begin log file
	echo "GoToLogFiles log started $(date)" > $LOGFILE

# Copy CrashReporter files to a temporary folder.
	rsync -aP --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* $TEMPDIR/CrashReporterUser/ >> $LOGFILE
	rsync -aP /Library/Logs/DiagnosticReports/* $TEMPDIR/CrashReporterSystem/ >> $LOGFILE

# Copy the system log to the temporary folder.
	rsync -aP /Private/Var/Log/system.log* $TEMPDIR/SystemLog >> $LOGFILE

# Copy Endpoint and Recording Manager Logs to the temporary folder.
	rsync -aP ~/Library/Logs/com.citrixonline.GoToMeeting/* $TEMPDIR/Endpoint_Logs >> $LOGFILE
	if [ -d ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager ]; then rsync -aP ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager/* $TEMPDIR/Recording_Manager >> $LOGFILE; elif [ -d ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager ]; then rsync -aP ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager/* $TEMPDIR/Recording_Manager >> $LOGFILE;  fi

# Copy unconverted video and audio files.
	if [ -d ~/Documents/Recordings ]; then rsync -aP ~/Documents/Recordings/*.temp_{audio,video} $TEMPDIR/Unconverted_Temp_Files >> $LOGFILE; fi

# Looks in the settings plist for any other directories for the temp files to be in and copies those, too.
THE_PATH=$(defaults -currentHost read com.citrixonline.GoToMeeting | grep RecordingPath | sed 's/    RecordingPath = //g' | sed 's/\;//g' | sed 's/\"//g') ; if [ -f "$THE_PATH"/*.temp_audio ]; then rsync -aP $THE_PATH/*.temp_{audio,video} $TEMPDIR/Unconverted_Temp_Files_Alternate >> $LOGFILE; fi

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
	tar -czf $TEMPDIR.tgz -C $TEMPDIR .

# Close log file
	echo "Closed $(date)." >> $LOGFILE
