#!/bin/bash
# This script makes a compressed archive of the current user's desktop of log files, system diagnostics, and other Citrix Online related items.
# Written by Brian Carter & Kyle Halversen

# Create a temporary folder if it does not already exist.
	if [ ! -d "$TEMPDIR" ]; then mkdir $TEMPDIR; fi

# Trap to remove the temporary directory when the script exits
cleanup() {
	rm -rf $TEMPDIR
}
trap "cleanup" EXIT

# Copy CrashReporter files to a temporary folder.
	rsync -a --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* $TEMPDIR/CrashReporterUser/
	rsync -a /Library/Logs/DiagnosticReports/* $TEMPDIR/CrashReporterSystem/

# Copy the system log to the temporary folder.
	rsync -a /Private/Var/Log/system.log* $TEMPDIR/SystemLog

# Copy Endpoint and Recording Manager Logs to the temporary folder.
	rsync -a ~/Library/Logs/com.citrixonline.GoToMeeting/* $TEMPDIR/Endpoint_Logs
	if [ -d ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager ]; then rsync -a ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager/* $TEMPDIR/Recording_Manager; elif [ -d ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager ]; then rsync -a ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager/* $TEMPDIR/Recording_Manager;  fi

# Copy unconverted video and audio files.
	if [ -d ~/Documents/Recordings ]; then rsync -a ~/Documents/Recordings/*.temp_{audio,video} $TEMPDIR/Unconverted_Temp_Files; fi

# Looks in the settings plist for any other directories for the temp files to be in and copies those, too.
THE_PATH=$(defaults -currentHost read com.citrixonline.GoToMeeting | grep RecordingPath | sed 's/    RecordingPath = //g' | sed 's/\;//g' | sed 's/\"//g') ; if [ -f "$THE_PATH"/*.temp_audio ]; then rsync -a $THE_PATH/*.temp_{audio,video} $TEMPDIR/Unconverted_Temp_Files_Alternate; fi

# Copy launcher logs
	rsync -a ~/Library/Logs/com.citrixonline.WebDeployment/* $TEMPDIR/Launcher_Logs/

# Get a list of running applications and installed applications.
	ps aux > $TEMPDIR/Processes.txt
	system_profiler SPApplicationsDataType >> $TEMPDIR/System_Profiler.txt; \
	system_profiler SPSoftwareDataType >> $TEMPDIR/System_Profiler.txt; \
	system_profiler SPHardwareDataType >> $TEMPDIR/System_Profiler.txt; \
	system_profiler SPDisplaysDataType >> $TEMPDIR/System_Profiler.txt; \
	system_profiler SPPowerDataType >> $TEMPDIR/System_Profiler.txt; \
	system_profiler SPAudioDataType >> $TEMPDIR/System_Profiler.txt; \
	system_profiler SPSerialATADataType >> $TEMPDIR/System_Profiler.txt; \

# Create a compressed archive of everything grabbed.
	tar -czf $TEMPDIR.tgz -C $TEMPDIR .
