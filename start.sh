#!/bin/bash
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
	if [ -d ~/Library/Logs/DiagnosticReports ]; then logcomment "DiagnosticReports: User" ; rsync -av --exclude="MobileDevice" ~/Library/Logs/DiagnosticReports/* $TEMPDIR/DiagnosticReportsUser/ >> $LOGFILE ; fi
	if [ -d ~/Library/Logs/CrashReporter ]; then logcomment "CrashReporter: User" ; rsync -av --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* $TEMPDIR/CrashReporterUser/ 2>&1 >> $LOGFILE ; fi
	if [ -d /Library/Logs/DiagnosticReports ]; then logcomment "DiagnosticReports: System" ; rsync -av /Library/Logs/DiagnosticReports/* $TEMPDIR/DiagnosticReportsSystem/ >> $LOGFILE ; fi
	if [ -d /Library/Logs/CrashReporter ]; then logcomment "CrashReporter: System" ; rsync -av /Library/Logs/CrashReporter/* $TEMPDIR/CrashReporterSystem/ 2>&1 >> $LOGFILE ; fi

# Collect system log
	logcomment "System Log"
	rsync -av /Private/Var/Log/system.log* $TEMPDIR/SystemLog >> $LOGFILE

# Collect Citrix Launcher log
	logcomment "Citrix Launcher log"
	rsync -av ~/Library/Logs/com.citrixonline.WebDeployment/* $TEMPDIR/Launcher_Logs/ >> $LOGFILE

# Collect system diagnostic information
	DIAGNOSTIC=$TEMPDIR/Diagnostic
	mkdir $DIAGNOSTIC
	ps > $DIAGNOSTIC/Running_Processes.txt
	diskutil list >> $DIAGNOSTIC/Disk_Info.txt
	df -H >> $DIAGNOSTIC/Disk_Info.txt
	system_profiler SPApplicationsDataType >> $DIAGNOSTIC/System_Profiler.txt
	system_profiler SPSoftwareDataType >> $DIAGNOSTIC/System_Profiler.txt
	system_profiler SPHardwareDataType >> $DIAGNOSTIC/System_Profiler.txt
	system_profiler SPDisplaysDataType >> $DIAGNOSTIC/System_Profiler.txt
	system_profiler SPPowerDataType >> $DIAGNOSTIC/System_Profiler.txt
	system_profiler SPAudioDataType >> $DIAGNOSTIC/System_Profiler.txt
	system_profiler SPSerialATADataType >> $DIAGNOSTIC/System_Profiler.txt
