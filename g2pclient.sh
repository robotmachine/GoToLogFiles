#!/bin/bash
# Create a temporary folder if it does not already exist.
	if [ ! -d "~/Desktop/GoToMyPC_Client_Logs" ]; then mkdir ~/Desktop/GoToMyPC_Client_Logs; fi;\
# Copy CrashReporter files to a temporary folder.
	rsync -a --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* ~/Desktop/GoToMyPC_Client_Logs/CrashReporterUser/; \
	rsync -a /Library/Logs/DiagnosticReports/* ~/Desktop/GoToMyPC_Client_Logs/CrashReporterSystem/; \
# Copy the system log to the temporary folder.
	rsync -a /Private/Var/Log/system.log* ~/Desktop/GoToMyPC_Client_Logs/SystemLog; \
# Copy Endpoint Logs to the temporary folder.
	rsync -a ~/Library/Logs/com.citrixonline.GoToMyPC/* ~/Desktop/GoToMyPC_Client_Logs/Endpoint_Logs; \
# Get a list of running applications and installed applications.
	ps aux > ~/Desktop/GoToMyPC_Client_Logs/Processes.txt; \
	system_profiler SPApplicationsDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPSoftwareDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPHardwareDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPDisplaysDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPPowerDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPAudioDataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
	system_profiler SPSerialATADataType >> ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \

# Create a Gzipped Tar of all of the folders on the desktop.
	tar -czf ~/Desktop/GoToMyPC_Client_Logs.tgz -C ~/Desktop/ GoToMyPC_Client_Logs ; \
# Remove temporary folder.
	rm -rf ~/Desktop/GoToMyPC_Client_Logs
