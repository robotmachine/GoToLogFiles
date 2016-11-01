#!/bin/bash
#
#    @@@@@@@@           @@@@@@@@@@          @@                        @@@@@@@@ @@  @@                
#   @@//////@@         /////@@///          /@@                 @@@@@ /@@///// //  /@@                
#  @@      //   @@@@@@     /@@      @@@@@@ /@@        @@@@@@  @@///@@/@@       @@ /@@  @@@@@   @@@@@@
# /@@          @@////@@    /@@     @@////@@/@@       @@////@@/@@  /@@/@@@@@@@ /@@ /@@ @@///@@ @@//// 
# /@@    @@@@@/@@   /@@    /@@    /@@   /@@/@@      /@@   /@@//@@@@@@/@@////  /@@ /@@/@@@@@@@//@@@@@ 
# //@@  ////@@/@@   /@@    /@@    /@@   /@@/@@      /@@   /@@ /////@@/@@      /@@ /@@/@@////  /////@@
#  //@@@@@@@@ //@@@@@@     /@@    //@@@@@@ /@@@@@@@@//@@@@@@   @@@@@ /@@      /@@ @@@//@@@@@@ @@@@@@ 
#   ////////   //////      //      //////  ////////  //////   /////  //       // ///  ////// //////  
#
# GoToLogFiles v.1.2.2
#
# Description:
# Collects log files and diagnostic information for Citrix SaaS products:
# * GoToMeeting/GoToWebinar/GoToTraining
# * GoToMyPC
# * GoToAssist Corporate/Remote Support
# * ShareConnect
#
# Homepage:
# https://github.com/robotmachine/GoToLogFiles_Automator
#
# Maintained by:
# Brian A Carter (robotmachine@gmail.com)
#
# Originally Created by:
# Brian A Carter
# Kyle Halversen
#
#  @@@@@@                   @@         
# /@////@@           @@@@@ //          
# /@   /@@   @@@@@  @@///@@ @@ @@@@@@@ 
# /@@@@@@   @@///@@/@@  /@@/@@//@@///@@
# /@//// @@/@@@@@@@//@@@@@@/@@ /@@  /@@
# /@    /@@/@@////  /////@@/@@ /@@  /@@
# /@@@@@@@ //@@@@@@  @@@@@ /@@ @@@  /@@
# ///////   //////  /////  // ///   // 
#
# This variable can be changed to set where the archive is stored
# Do not change any other variables in this script
FilePath=~/Desktop
##
# Sets variables for the script.
TempName=GoToLogFiles_$(date +%s)
TempDir=$FilePath/.$TempName
ArchiveName=$FilePath/$TempName.tgz
LogFile=~/Library/Logs/com.citrixonline.g2logfiles.log
# Remove the temp directory when the script exits even if due to error
cleanup() {
	rm -rf $TempDir
}
trap "cleanup" EXIT
# Commenting in the log
logcomment() {
	echo "" >> $LogFile
	echo "### $@ ###" >> $LogFile
}
# Prompt user to select a product.
UserSelect=$(osascript <<'END'
on run {}
	set ProductList to {"GoToMeeting", "GoToMyPC", "GoToAssist", "ShareConnect"}
	set UserSelect to {choose from list ProductList with title "GoToLogFiles" with prompt "Please select a product." default items "GoToMeeting"}
	return UserSelect
end run
END)
# Catch if the user hits cancel.
if [[ "$UserSelect" == false ]] ; then
	exit
fi
#
#    @@@@@@                                                       @@                               
#   @@////@@                                                     /@@                 @@@@@         
#  @@    //   @@@@@@  @@@@@@@@@@  @@@@@@@@@@   @@@@@@  @@@@@@@   /@@        @@@@@@  @@///@@  @@@@@@
# /@@        @@////@@//@@//@@//@@//@@//@@//@@ @@////@@//@@///@@  /@@       @@////@@/@@  /@@ @@//// 
# /@@       /@@   /@@ /@@ /@@ /@@ /@@ /@@ /@@/@@   /@@ /@@  /@@  /@@      /@@   /@@//@@@@@@//@@@@@ 
# //@@    @@/@@   /@@ /@@ /@@ /@@ /@@ /@@ /@@/@@   /@@ /@@  /@@  /@@      /@@   /@@ /////@@ /////@@
#  //@@@@@@ //@@@@@@  @@@ /@@ /@@ @@@ /@@ /@@//@@@@@@  @@@  /@@  /@@@@@@@@//@@@@@@   @@@@@  @@@@@@ 
#   //////   //////  ///  //  // ///  //  //  //////  ///   //   ////////  //////   /////  //////  
#
# Create a temporary folder if it does not already exist.
	if [ ! -d "$TempDir" ]; then
		mkdir $TempDir
	fi
# Initialise a new log file
	echo "GoToLogFiles log started $(date)" > $LogFile
# Collect CrashReporter and DiagnosticReports data for both the system and user
	mkdir "$TempDir/OSX_Logs"
	if [ -d ~/Library/Logs/DiagnosticReports ] && [ "$(ls -A ~/Library/Logs/DiagnosticReports)" ]; then
		logcomment "DiagnosticReports: User"
		rsync -av --exclude="MobileDevice" ~/Library/Logs/DiagnosticReports/* $TempDir/OSX_Logs/DiagnosticReports_User/ >> $LogFile 2>>$LogFile
	else 
		logcomment "DiagnosticReports: User .:. Directory Empty"
	fi
	if [ -d ~/Library/Logs/CrashReporter ] && [ "$(ls -A ~/Library/Logs/CrashReporter)" ]; then
		logcomment "CrashReporter: User"
		rsync -av --exclude="MobileDevice" ~/Library/Logs/CrashReporter/* $TempDir/OSX_Logs/CrashReporter_User/ >> $LogFile 2>>$LogFile
	else
		logcomment "CrashReporter: User .:. Directory Empty"
	fi
	if [ -d /Library/Logs/DiagnosticReports ] && [ "$(ls -A /Library/Logs/DiagnosticReports)" ]; then
		logcomment "DiagnosticReports: System"
		rsync -av /Library/Logs/DiagnosticReports/* $TempDir/OSX_Logs/DiagnosticReports_System/ >> $LogFile 2>>$LogFile
	else 
		logcomment "DiagnosticReports: System .:. Directory Empty"
	fi
	if [ -d /Library/Logs/CrashReporter ] && [ "$(ls -A /Library/Logs/CrashReporter)" ]; then
		logcomment "CrashReporter: System"
		rsync -av /Library/Logs/CrashReporter/* $TempDir/OSX_Logs/CrashReporter_System/ >> $LogFile 2>>$LogFile
	else
		logcomment "CrashReporter: System .:. Directory Empty"
	fi
# Collect system log
	logcomment "System Log"
	rsync -av /Private/Var/Log/system.log* $TempDir/OSX_Logs/SystemLog/ >> $LogFile 2>&1
# Collect Citrix Launcher log and Plist file
	logcomment "Citrix Launcher log"
	rsync -av ~/Library/Logs/com.citrixonline.WebDeployment/* $TempDir/Launcher/ >> $LogFile 2>&1
	logcomment "Citrix Launcher plist"
	if ls ~/Library/Preferences/com.citrixonline.mac.WebDeploymentApp* 1> /dev/null 2>&1 ; then
		if [[ ! -e $TempDir/Plist/ ]] ; then 
			mkdir $TempDir/Plist/
		fi
		for FILE in ~/Library/Preferences/com.citrixonline.mac.WebDeploymentApp* ; do
			defaults read $FILE > $TempDir/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "Citrix Launcher Plist .:. No plist files found."
	fi
# Collect system diagnostic information
	logcomment "Diagnostic Information (Only errors are logged)"
	DiagFolder=$TempDir/Diagnostic
	mkdir $DiagFolder
	ps > $DiagFolder/Running_Processes.txt 2>> $LogFile
	echo "Disk Utility list:\n" >> $DiagFolder/Disk_Info.txt 2>> $LogFile
	diskutil list >> $DiagFolder/Disk_Info.txt 2>> $LogFile
	echo "\ndf Output:\n" >> $DiagFolder/Disk_Info.txt 2>> $LogFile
	df -H >> $DiagFolder/Disk_Info.txt 2>> $LogFile
	system_profiler SPApplicationsDataType >> $DiagFolder/System_Profiler.txt 2>> $LogFile
	system_profiler SPSoftwareDataType >> $DiagFolder/System_Profiler.txt 2>> $LogFile
	system_profiler SPHardwareDataType >> $DiagFolder/System_Profiler.txt 2>> $LogFile
	system_profiler SPDisplaysDataType >> $DiagFolder/System_Profiler.txt 2>> $LogFile
	system_profiler SPPowerDataType >> $DiagFolder/System_Profiler.txt 2>> $LogFile
	system_profiler SPAudioDataType >> $DiagFolder/System_Profiler.txt 2>> $LogFile
	system_profiler SPSerialATADataType >> $DiagFolder/System_Profiler.txt 2>> $LogFile
#
#    @@@@@@@@           @@@@@@@@@@              @@                     @@           @@  
#   @@//////@@         /////@@///              @@@@                   //           /@@  
#  @@      //   @@@@@@     /@@      @@@@@@    @@//@@    @@@@@@  @@@@@@ @@  @@@@@@ @@@@@@
# /@@          @@////@@    /@@     @@////@@  @@  //@@  @@////  @@//// /@@ @@//// ///@@/ 
# /@@    @@@@@/@@   /@@    /@@    /@@   /@@ @@@@@@@@@@//@@@@@ //@@@@@ /@@//@@@@@   /@@  
# //@@  ////@@/@@   /@@    /@@    /@@   /@@/@@//////@@ /////@@ /////@@/@@ /////@@  /@@  
#  //@@@@@@@@ //@@@@@@     /@@    //@@@@@@ /@@     /@@ @@@@@@  @@@@@@ /@@ @@@@@@   //@@ 
#   ////////   //////      //      //////  //      // //////  //////  // //////     //  
#
if [[ "$UserSelect" == "GoToAssist" ]]; then
	# Collect GoToAssist Corporate logs
	logcomment "GoToAssist Corporate: Logs"
	rsync -av ~/Library/Logs/com.citrixonline.g2ac* $TempDir/G2AC_Endpoint_Logs/ >> $LogFile 2>&1
	rsync -av ~/Library/Logs/com.citrixonline.g2a.customer $TempDir/G2AC_Customer_Logs/ >> $LogFile 2>&1
	#
	# Collect GoToAssist Remote Support Logs
	if [ -d ~/Library/Logs/com.citrixonline.g2a.rs/customer ]; then 
		logcomment "GoToAssist Remote Support: Logs"
		rsync -av ~/Library/Logs/com.citrixonline.g2a.rs/customer $TempDir/G2ARS_Customer_Endpoint_Logs/ >> $LogFile 2>&1
	fi
	if [ -d ~/Library/Logs/com.citrixonline.g2a.rs/Expert ]; then 
		logcomment "GoToAssist Remote Support: Logs"
		rsync -av ~/Library/Logs/com.citrixonline.g2a.rs/Expert $TempDir/G2ARS_Expert_Endpoint_Logs/ >> $LogFile 2>&1
	fi
	if [ -d /Library/Logs/com.citrixonline.g2a.rs ]; then 
		logcomment "GoToAssist Remote Support: Logs"
		rsync -av /Library/Logs/com.citrixonline.g2a.rs $TempDir/G2ARS_Unattended_Endpoint_Logs/ >> $LogFile 2>&1
	fi
	if [ -d ~/Library/Logs/com.citrixonline.g2ax ]; then 
		logcomment "GoToAssist Remote Support: Logs"
		rsync -av ~/Library/Logs/com.citrixonline.g2ax $TempDir/G2ARS_Pre_Build_403_Logs/ >> $LogFile 2>&1
	fi
	if [ -d ~/Library/Logs/com.citrixonline.g2ax.customer ]; then 
		logcomment "GoToAssist Remote Support: Logs"
		rsync -av ~/Library/Logs/com.citrixonline.g2ax.customer $TempDir/G2ARS_Customer_Pre_Build_403_Logs/ >> $LogFile 2>&1
	fi
	if [ -d ~/Library/Logs/com.citrixonline.g2ax.expert ]; then 
		logcomment "GoToAssist Remote Support: Logs"
		rsync -av ~/Library/Logs/com.citrixonline.g2ax.expert $TempDir/G2ARS_ExpertPre_Build_403_Logs/ >> $LogFile 2>&1
	fi

	# Copy GoToAssist Remote Support preferences to a text file.
	if ls ~/Library/Preferences/com.citrixonline.g2ax* 1> /dev/null 2>&1 ; then
		if [[ ! -e $TempDir/Plist ]]; then
			mkdir $TempDir/Plist
		fi
		for FILE in ~/Library/Preferences/com.citrixonline.g2ax* ; do
			defaults read $FILE > $TempDir/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "GoToAssist Remote Support Plist .:. No plist files found."
	fi

	# Copy GoToAssist Corporate preferences to a text file
	if ls ~/Library/Preferences/com.citrixonline.g2ac* 1> /dev/null 2>&1 ; then
		if [[ ! -e $TempDir/Plist ]]; then
			mkdir $TempDir/Plist
		fi
		for FILE in ~/Library/Preferences/com.citrixonline.g2ac* ; do
			defaults read $FILE > $TempDir/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "GoToAssist Corporate Plist .:. No plist files found."
	fi
#
#    @@@@@@@@           @@@@@@@@@@          @@@@     @@@@                   @@   @@                 
#   @@//////@@         /////@@///          /@@/@@   @@/@@                  /@@  //            @@@@@ 
#  @@      //   @@@@@@     /@@      @@@@@@ /@@//@@ @@ /@@  @@@@@   @@@@@  @@@@@@ @@ @@@@@@@  @@///@@
# /@@          @@////@@    /@@     @@////@@/@@ //@@@  /@@ @@///@@ @@///@@///@@/ /@@//@@///@@/@@  /@@
# /@@    @@@@@/@@   /@@    /@@    /@@   /@@/@@  //@   /@@/@@@@@@@/@@@@@@@  /@@  /@@ /@@  /@@//@@@@@@
# //@@  ////@@/@@   /@@    /@@    /@@   /@@/@@   /    /@@/@@//// /@@////   /@@  /@@ /@@  /@@ /////@@
#  //@@@@@@@@ //@@@@@@     /@@    //@@@@@@ /@@        /@@//@@@@@@//@@@@@@  //@@ /@@ @@@  /@@  @@@@@ 
#   ////////   //////      //      //////  //         //  //////  //////    //  // ///   //  /////  
#
elif [[ "$UserSelect" == "GoToMeeting" ]]; then
	# Collect GoToMeeting and GoToMeeting Recording Manager logs
	if [ -d ~/Library/Logs/com.citrixonline.GoToMeeting ] && [ "$(ls -A ~/Library/Logs/com.citrixonline.GoToMeeting)" ]; then 
		logcomment "GoToMeeting: Log Files"
		rsync -av ~/Library/Logs/com.citrixonline.GoToMeeting/* $TempDir/GoToMeeting_Logs >> $LogFile 2>&1
	else 
		logcomment "GoToMeeting: Log Files .:. No Logs Found"
	fi
	if [ -d ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager ] && [ "$(ls -A ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager)" ]; then
		logcomment "GoToMeeting: Recording Manager Log Files"
		rsync -av ~/Library/Logs/com.citrixonline.GoToMeeting_Recording_Manager/* $TempDir/Recording_Manager >> $LogFile 2>&1
	elif [ -d ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager ] && [ "$(ls -A ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager)" ] ; then 
		logcomment "GoToMeeting: Recording Manager Log Files"
		rsync -av ~/Library/Logs/com.citrixonline.Mac.GoToMeeting.RecordingManager/* $TempDir/Recording_Manager  >> $LogFile 2>&1
	else 
		logcomment "GoToMeeting: Recording Manager Log Files .:. No Logs Found"
	fi
	#
	# Copy GoToMeeting preferences to a text file.
	if ls ~/Library/Preferences/com.citrixonline.GoToMeeting* 1> /dev/null 2>&1 ; then
		if [[ ! -e $TempDir/Plist ]] ; then mkdir $TempDir/Plist
		fi
		for FILE in ~/Library/Preferences/com.citrixonline.GoToMeeting* ; do
			defaults read $FILE > $TempDir/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "GoToMeeting Plist .:. No plist files found."
	fi
	# Sample GoToMeeting processes if they are running
	mkdir $TempDir/Sample
	logcomment "GoToMeeting: Sample Process .:. Only Errors Logged"
	sample GoToMeeting > $TempDir/Sample/GoToMeeting_Sample.txt 2>>$LogFile
	sample "GoToMeeting Recording Manager" > $TempDir/Sample/GoToMeetingRecMgr_Sample.txt 2>>$LogFile

#
#    @@@@@@@@           @@@@@@@@@@          @@@@     @@@@          @@@@@@@    @@@@@@ 
#   @@//////@@         /////@@///          /@@/@@   @@/@@  @@   @@/@@////@@  @@////@@
#  @@      //   @@@@@@     /@@      @@@@@@ /@@//@@ @@ /@@ //@@ @@ /@@   /@@ @@    // 
# /@@          @@////@@    /@@     @@////@@/@@ //@@@  /@@  //@@@  /@@@@@@@ /@@       
# /@@    @@@@@/@@   /@@    /@@    /@@   /@@/@@  //@   /@@   /@@   /@@////  /@@       
# //@@  ////@@/@@   /@@    /@@    /@@   /@@/@@   /    /@@   @@    /@@      //@@    @@
#  //@@@@@@@@ //@@@@@@     /@@    //@@@@@@ /@@        /@@  @@     /@@       //@@@@@@ 
#   ////////   //////      //      //////  //         //  //      //         //////  
#
elif [ "$UserSelect" = "GoToMyPC" ]; then
	# Collect GoToMyPC Host Log Files
	if [ -d /Library/Logs/com.citrixonline.GoToMyPC ] && [ "$(ls -A /Library/Logs/com.citrixonline.GoToMyPC)" ] ; then
		logcomment "GoToMyPC: Host Log Files"
		rsync -av /Library/Logs/com.citrixonline.GoToMyPC/* $TempDir/G2P_Host_Logs/ >> $LogFile 2>&1
	else 
		logcomment "GoToMyPC: Host .:. No Logs Found"
	fi
	# Copy GoToMyPC Plist to text
	if ls /Library/Preferences/com.citrixonline.GoToMyPC* 1> /dev/null 2>&1 ; then
		if [[ ! -e $TempDir/Plist ]]; then
			mkdir $TempDir/Plist
		fi
		for FILE in /Library/Preferences/com.citrixonline.GoToMyPC* ; do
			defaults read $FILE > $TempDir/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "GoToMyPC Host Plist .:. No plist files found."
	fi
	# Collect GoToMyPC Client logs
	if [ -d ~/Library/Logs/com.citrixonline.GoToMyPC ] && [ "$(ls -A ~/Library/Logs/com.citrixonline.GoToMyPC)" ] ; then
		logcomment "GoToMyPC: Client Logs"
		rsync -av ~/Library/Logs/com.citrixonline.GoToMyPC/* $TempDir/G2P_Client_Logs/ >> $LogFile 2>&1
	else logcomment "GoToMyPC: Client Logs .:. No Logs Found"
	fi
	# Copy GoToMyPC Plist to text
	if ls /Library/Preferences/com.citrixonline.GoToMyPC* 1> /dev/null 2>&1 ; then
		if [[ ! -e $TempDir/Plist ]]; then
			mkdir $TempDir/Plist
		fi
		for FILE in /Library/Preferences/com.citrixonline.GoToMyPC* ; do
			defaults read $FILE > $TempDir/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "GoToMyPC Plist .:. No plist files found."
	fi
	# Copy GoToMyPC viewer Plist to text
	if ls ~/Library/Preferences/com.citrixonline.GoToMyPC* 1> /dev/null 2>&1 ; then
		if [[ ! -e $TempDir/Plist ]] ; then 
			mkdir $TempDir/Plist
		fi
		for FILE in ~/Library/Preferences/com.citrixonline.GoToMyPC* ; do
			defaults read $FILE > $TempDir/Plist/$(echo "$FILE" | awk -F \/ '{ print $NF }').txt
		done
	else
		logcomment "GoToMyPC Plist .:. No plist files found."
	fi
#   @@@@@@@@ @@                                 @@@@@@                                               @@  
#  @@////// /@@                                @@////@@                                             /@@  
# /@@       /@@       @@@@@@   @@@@@@  @@@@@  @@    //   @@@@@@  @@@@@@@  @@@@@@@   @@@@@   @@@@@  @@@@@@
# /@@@@@@@@@/@@@@@@  //////@@ //@@//@ @@///@@/@@        @@////@@//@@///@@//@@///@@ @@///@@ @@///@@///@@/ 
# ////////@@/@@///@@  @@@@@@@  /@@ / /@@@@@@@/@@       /@@   /@@ /@@  /@@ /@@  /@@/@@@@@@@/@@  //   /@@  
#        /@@/@@  /@@ @@////@@  /@@   /@@//// //@@    @@/@@   /@@ /@@  /@@ /@@  /@@/@@//// /@@   @@  /@@  
#  @@@@@@@@ /@@  /@@//@@@@@@@@/@@@   //@@@@@@ //@@@@@@ //@@@@@@  @@@  /@@ @@@  /@@//@@@@@@//@@@@@   //@@ 
# ////////  //   //  //////// ///     //////   //////   //////  ///   // ///   //  //////  /////     //  
elif [ "$UserSelect" = "ShareConnect" ]; then
	# Collect log files for ShareConnect
	if [ -d /Library/Logs/com.citrixonline.ShareConnect ] && [ "$(ls -A /Library/Logs/com.citrixonline.ShareConnect)" ] ; then
		logcomment "ShareConnect: Log Files"
		rsync -av /Library/Logs/com.citrixonline.ShareConnect/* $TempDir/ShareConnect_Logs/ >> $LogFile 2>&1
	else
		logcomment "ShareConnect .:. No Logs Found"
	fi
else
	logcomment "No Product Selected"
fi
#
#    @@@@@@   @@                  @@                 
#   @@////@@ /@@                 //            @@@@@ 
#  @@    //  /@@  @@@@@@   @@@@@@ @@ @@@@@@@  @@///@@
# /@@        /@@ @@////@@ @@//// /@@//@@///@@/@@  /@@
# /@@        /@@/@@   /@@//@@@@@ /@@ /@@  /@@//@@@@@@
# //@@    @@ /@@/@@   /@@ /////@@/@@ /@@  /@@ /////@@
#  //@@@@@@  @@@//@@@@@@  @@@@@@ /@@ @@@  /@@  @@@@@ 
#   //////  ///  //////  //////  // ///   //  /////  
#
# Close log file
	logcomment "GoToLogFiles log finished $(date)"
#
# Collect log file
	rsync -a $LogFile $TempDir/GoToLogFiles.log
#
# Create a compressed archive of all collected data.
	tar -czf $ArchiveName -C $TempDir .
