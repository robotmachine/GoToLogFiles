#!/bin/bash
#
#
# GoToLogFiles.sh
# Unofficial OSX log file collection and system diagnostic information for Citrix SaaS Products
# Written by Brian Carter & Kyle Halversen
#
# Change the path or name of the files here:
FILEPATH=~/Desktop
DIRNAME=Citrix_Logs_G2M_$(date +%s)
# Don't change this:
TEMPDIR=$FILEPATH/.$DIRNAME
ENDFILE=$FILEPATH/$DIRNAME.tgz
LOGFILE=~/Library/Logs/com.citrixonline.g2logfiles.log

# Remove the temp directory when the script exits even if due to error
cleanup() {
	rm -rf $TEMPDIR
}
trap "cleanup" EXIT
# Commenting in the log
logcomment() {
	echo "" >> $LOGFILE
	echo "### $@ ###" >> $LOGFILE
}

# Create a temporary folder if it does not already exist.
	if [ ! -d "$TEMPDIR" ]; then mkdir $TEMPDIR ; fi

# Initialise a new log file
	echo "GoToLogFiles log started $(date)" > $LOGFILE

# Collect CrashReporter and DiagnosticReports data for both the system and user
	if [ -d ~/Library/Logs/DiagnosticReports ] && [ "$(ls -A ~/Library/Logs/DiagnosticReports)" ]; then logcomment "DiagnosticReports: User" ; rsync -av --exclude="MobileDevice" ~/Library/Logs/DiagnosticReports/* $TEMPDIR/DiagnosticReportsUser/ >> $LOGFILE 2>>$LOGFILE ; else logcomment "DiagnosticReports: User .:. Directory Empty" ; fi
	if [ -d ~/Library/Logs/CrashReporter ] && [ "$(ls -A ~/Library/Logs/CrashReporter)" ]; then logcomment "CrashReporter: User" ; rsync -av --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* $TEMPDIR/CrashReporterUser/ >> $LOGFILE 2>>$LOGFILE ; else logcomment "CrashReporter: User .:. Directory Empty" ; fi
	if [ -d /Library/Logs/DiagnosticReports ] && [ "$(ls -A /Library/Logs/DiagnosticReports)" ]; then logcomment "DiagnosticReports: System" ; rsync -av /Library/Logs/DiagnosticReports/* $TEMPDIR/DiagnosticReportsSystem/ >> $LOGFILE 2>>$LOGFILE ; else logcomment "DiagnosticReports: System .:. Directory Empty" ; fi
	if [ -d /Library/Logs/CrashReporter ] && [ "$(ls -A /Library/Logs/CrashReporter)" ]; then logcomment "CrashReporter: System" ; rsync -av /Library/Logs/CrashReporter/* $TEMPDIR/CrashReporterSystem/ >> $LOGFILE 2>>$LOGFILE ; else logcomment "CrashReporter: System .:. Directory Empty" ; fi

# Collect system log
	logcomment "System Log"
	rsync -av /Private/Var/Log/system.log* $TEMPDIR/SystemLog >> $LOGFILE 2>&1

# Collect Citrix Launcher log and Plist file
	logcomment "Citrix Launcher log"
	rsync -av ~/Library/Logs/com.citrixonline.WebDeployment/* $TEMPDIR/Launcher_Logs/ >> $LOGFILE 2>&1
	logcomment "Citrix Launcher plist"
	if ls ~/Library/Preferences/com.citrixonline.mac.WebDeploymentApp* 1> /dev/null 2>&1 ; then
		if [[ ! -e $TEMPDIR/Plist ]] ; then mkdir $TEMPDIR/Plist ; fi
		for FILE in ~/Library/Preferences/com.citrixonline.mac.WebDeploymentApp* ; do
			defaults read $FILE > $TEMPDIR/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "Citrix Launcher Plist .:. No plist files found."
	fi
	

# Collect system diagnostic information
	logcomment "Diagnostic Information (Only errors are logged)"
	DIAGNOSTIC=$TEMPDIR/Diagnostic
	mkdir $DIAGNOSTIC
	ps > $DIAGNOSTIC/Running_Processes.txt 2>> $LOGFILE
	echo "Disk Utility list:\n" >> $DIAGNOSTIC/Disk_Info.txt 2>> $LOGFILE
	diskutil list >> $DIAGNOSTIC/Disk_Info.txt 2>> $LOGFILE
	echo "\ndf Output:\n" >> $DIAGNOSTIC/Disk_Info.txt 2>> $LOGFILE
	df -H >> $DIAGNOSTIC/Disk_Info.txt 2>> $LOGFILE
	system_profiler SPApplicationsDataType >> $DIAGNOSTIC/System_Profiler.txt 2>> $LOGFILE
	system_profiler SPSoftwareDataType >> $DIAGNOSTIC/System_Profiler.txt 2>> $LOGFILE
	system_profiler SPHardwareDataType >> $DIAGNOSTIC/System_Profiler.txt 2>> $LOGFILE
	system_profiler SPDisplaysDataType >> $DIAGNOSTIC/System_Profiler.txt 2>> $LOGFILE
	system_profiler SPPowerDataType >> $DIAGNOSTIC/System_Profiler.txt 2>> $LOGFILE
	system_profiler SPAudioDataType >> $DIAGNOSTIC/System_Profiler.txt 2>> $LOGFILE
	system_profiler SPSerialATADataType >> $DIAGNOSTIC/System_Profiler.txt 2>> $LOGFILE
