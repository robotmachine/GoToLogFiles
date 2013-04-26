#!/bin/bash
# Create a temporary folder if it does not already exist.
	if [ ! -d "~/Desktop/GoToMeeting_Recording_Logs" ]; then mkdir ~/Desktop/GoToMeeting_Recording_Logs; fi;\
# Copy CrashReporter files to a temporary folder.
	rsync -a --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* ~/Desktop/GoToMeeting_Recording_Logs/CrashReporterUser/; \
	rsync -a /Library/Logs/DiagnosticReports/* ~/Desktop/GoToMeeting_Recording_Logs/CrashReporterSystem/; \
# Copy the system log to the temporary folder.
	rsync -a /Private/Var/Log/system.log* ~/Desktop/GoToMeeting_Recording_Logs/SystemLog; \
# Copy Endpoint and Recording Manager Logs to the temporary folder.
	rsync -a ~/Library/Logs/com.citrixonline.GoToMeeting/* ~/Desktop/GoToMeeting_Recording_Logs/Endpoint_Logs; \
	if [ -d ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager ]; then rsync -a ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager/* ~/Desktop/GoToMeeting_Recording_Logs/Recording_Manager; elif [ -d ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager ]; then rsync -a ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager/* ~/Desktop/GoToMeeting_Recording_Logs/Recording_Manager;  fi \
# Copy unconverted video and audio files.
	if [ -d ~/Documents/Recordings ]; then rsync -a ~/Documents/Recordings/*.temp_{audio,video} ~/Desktop/GoToMeeting_Recording_Logs/Unconverted_Temp_Files; fi \
# Looks in the settings plist for any other directories for the temp files to be in and copies those, too.
THE_PATH=$(defaults -currentHost read com.citrixonline.GoToMeeting | grep RecordingPath | sed 's/    RecordingPath = //g' | sed 's/\;//g' | sed 's/\"//g') ; if [ -f "$THE_PATH"/*.temp_audio ]; then rsync -a $THE_PATH/*.temp_{audio,video} ~/Desktop/GoToMeeting_Recording_Logs/Unconverted_Temp_Files_Alternate; fi
# Get a list of running applications and installed applications.
	ps aux > ~/Desktop/GoToMeeting_Recording_Logs/Processes.txt; \
	system_profiler SPApplicationsDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPSoftwareDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPHardwareDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPDisplaysDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPPowerDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPAudioDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPSerialATADataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \

# Create a Gzipped Tar of all of the folders on the desktop.
	tar -czf ~/Desktop/GoToMeeting_Recording_Logs.tgz -C ~/Desktop/ GoToMeeting_Recording_Logs ; \
# Remove temporary folder.
	rm -rf ~/Desktop/GoToMeeting_Recording_Logs
