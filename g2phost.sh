#!/bin/bash
# Create a temporary folder if it does not already exist.
	if [ ! -d "~/Desktop/GoToMyPC_Host_Logs" ]; then mkdir ~/Desktop/GoToMyPC_Host_Logs; fi;\
# Copy CrashReporter files to a temporary folder.
	rsync -a --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* ~/Desktop/GoToMyPC_Host_Logs/CrashReporterUser/; \
	rsync -a /Library/Logs/DiagnosticReports/* ~/Desktop/GoToMyPC_Host_Logs/CrashReporterSystem/; \
# Copy the system log to the temporary folder.
	rsync -a /Private/Var/Log/system.log* ~/Desktop/GoToMyPC_Host_Logs/SystemLog; \
# Copy Endpoint Logs to the temporary folder.
	rsync -a /Library/Logs/com.citrixonline.GoToMyPC/* ~/Desktop/GoToMyPC_Host_Logs/Endpoint_Logs; \
# Get a list of running applications and installed applications.
	ps aux > ~/Desktop/GoToMyPC_Host_Logs/Processes.txt; \
	system_profiler > ~/Desktop/GoToMyPC_Host_Logs/System_Profiler.txt; \
# Create a Gzipped Tar of all of the folders on the desktop.
	tar -czf ~/Desktop/GoToMyPC_Host_Logs.tgz -C ~/Desktop/ GoToMyPC_Host_Logs ; \
# Remove temporary folder.
	rm -rf ~/Desktop/GoToMyPC_Host_Logs
