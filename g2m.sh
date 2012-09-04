#!/bin/bash
# Create a temporary folder if it does not already exist.
	if [ ! -d "~/Desktop/GoToMeeting_Logs" ]; then mkdir ~/Desktop/GoToMeeting_Logs; fi;\
# Copy CrashReporter files to a temporary folder.
	rsync -a --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* ~/Desktop/GoToMeeting_Logs/CrashReporterUser/; \
	rsync -a /Library/Logs/DiagnosticReports/* ~/Desktop/GoToMeeting_Logs/CrashReporterSystem/; \
# Copy the system log to the temporary folder.
	rsync -a /Private/Var/Log/system.log* ~/Desktop/GoToMeeting_Logs/SystemLog; \
# Copy Endpoint and Recording Manager Logs to the temporary folder.
	rsync -a ~/Library/Logs/com.citrixonline.GoToMeeting/* ~/Desktop/GoToMeeting_Logs/Endpoint_Logs; \
	if [ -d ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager ]; then rsync -a ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager/* ~/Desktop/GoToMeeting_Logs/Recording_Manager; elif [ -d ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager ]; then rsync -a ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager/* ~/Desktop/GoToMeeting_Logs/Recording_Manager;  fi \
# Get a list of running applications and installed applications.
	ps aux > ~/Desktop/GoToMeeting_Logs/Processes.txt; \
	system_profiler > ~/Desktop/GoToMeeting_Logs/System_Profiler.txt; \
# Create a Gzipped Tar of all of the folders on the desktop.
	tar -czf ~/Desktop/GoToMeeting_Logs.tgz -C ~/Desktop/ GoToMeeting_Logs ; \
# Remove temporary folder.
	rm -rf ~/Desktop/GoToMeeting_Logs
