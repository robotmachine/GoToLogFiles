#!/bin/bash
# Create a temporary folder if it does not already exist.
	if [ ! -d "~/Desktop/GoToAssist_Remote_Support_Logs" ]; then mkdir ~/Desktop/GoToAssist_Remote_Support_Logs; fi;\
# Copy CrashReporter files to a temporary folder.
	rsync -a --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* ~/Desktop/GoToAssist_Remote_Support_Logs/CrashReporterUser/; \
	rsync -a /Library/Logs/DiagnosticReports/* ~/Desktop/GoToAssist_Remote_Support_Logs/CrashReporterSystem/; \
# Copy the system log to the temporary folder.
	rsync -a /Private/Var/Log/system.log* ~/Desktop/GoToAssist_Remote_Support_Logs/SystemLog; \
# Copy Endpoint Logs to the temporary folder.
	if [ -d ~/Library/Logs/com.citrixonline.g2a.rs/customer ]; then rsync -a ~/Library/Logs/com.citrixonline.g2a.rs/customer ~/Desktop/GoToAssist_Remote_Support_Logs/Customer_Endpoint_Logs; fi
	if [ -d ~/Library/Logs/com.citrixonline.g2a.rs/Expert ]; then rsync -a ~/Library/Logs/com.citrixonline.g2a.rs/Expert ~/Desktop/GoToAssist_Remote_Support_Logs/Expert_Endpoint_Logs; fi
	if [ -d /Library/Logs/com.citrixonline.g2a.rs ]; then rsync -a /Library/Logs/com.citrixonline.g2a.rs ~/Desktop/GoToAssist_Remote_Support_Logs/Unattended_Endpoint_Logs; fi
	if [ -d ~/Library/Logs/com.citrixonline.g2ax ]; then rsync -a ~/Library/Logs/com.citrixonline.g2ax ~/Desktop/GoToAssist_Remote_Support_Logs/Pre_Build_403_Logs; fi
	if [ -d ~/Library/Logs/com.citrixonline.g2ax.customer ]; then rsync -a ~/Library/Logs/com.citrixonline.g2ax.customer ~/Desktop/GoToAssist_Remote_Support_Logs/Pre_Build_403_Logs; fi
	if [ -d ~/Library/Logs/com.citrixonline.g2ax.expert ]; then rsync -a ~/Library/Logs/com.citrixonline.g2ax.expert ~/Desktop/GoToAssist_Remote_Support_Logs/Pre_Build_403_Logs; fi
# Get a list of running applications and installed applications.
	ps aux > ~/Desktop/GoToAssist_Remote_Support_Logs/Processes.txt; \
	system_profiler > ~/Desktop/GoToAssist_Remote_Support_Logs/System_Profiler.txt; \
# Create a Gzipped Tar of all of the folders on the desktop.
	tar -czf ~/Desktop/GoToAssist_Remote_Support_Logs.tgz -C ~/Desktop/ GoToAssist_Remote_Support_Logs ; \
# Remove temporary folder.
	rm -rf ~/Desktop/GoToAssist_Remote_Support_Logs
