#!/bin/bash
# Create a temporary folder if it does not already exist.
	if [ ! -d "~/Desktop/GoToAssist_Corporate_Logs" ]; then mkdir ~/Desktop/GoToAssist_Corporate_Logs; fi;\
# Copy CrashReporter files to a temporary folder.
	rsync -a --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* ~/Desktop/GoToAssist_Corporate_Logs/CrashReporterUser/; \
	rsync -a /Library/Logs/DiagnosticReports/* ~/Desktop/GoToAssist_Corporate_Logs/CrashReporterSystem/; \
# Copy the system log to the temporary folder.
	rsync -a /Private/Var/Log/system.log* ~/Desktop/GoToAssist_Corporate_Logs/SystemLog; \
# Copy Endpoint Logs to the temporary folder.
	rsync -a ~/Library/Logs/com.citrixonline.g2ac*/* ~/Desktop/GoToAssist_Corporate_Logs/Endpoint_Logs; \
	rsync -a ~/Library/Logs/com.citrixonline.g2a.customer/* ~/Desktop/GoToAssist_Corporate_Logs/Endpoint_Logs_Customer; \
# Get a list of running applications and installed applications.
	ps aux > ~/Desktop/GoToAssist_Corporate_Logs/Processes.txt; \
	system_profiler > ~/Desktop/GoToAssist_Corporate_Logs/System_Profiler.txt; \
# Create a Gzipped Tar of all of the folders on the desktop.
	tar -czf ~/Desktop/GoToAssist_Corporate_Logs.tgz -C ~/Desktop/ GoToAssist_Corporate_Logs ; \
# Remove temporary folder.
	rm -rf ~/Desktop/GoToAssist_Corporate_Logs
