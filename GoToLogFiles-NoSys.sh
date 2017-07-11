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
# GoToLogFiles v.1.4.2
#
# Description:
# Collects log files and diagnostic information for:
# * GoToMeeting/GoToWebinar/GoToTraining
# * GoToMyPC
# * GoToAssist Corporate/Remote Support
# * ShareConnect
#
# Homepage:
# https://github.com/robotmachine/GoToLogFiles
#
# Maintained by:
# Brian A Carter (robotmachine@protonmail.ch)
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
ArchiveName=$FilePath/$TempName.zip
LogFile=~/Library/Logs/com.logmein.g2logfiles.log
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
## Create a temporary folder if it does not already exist.
	if [ ! -d "$TempDir" ]; then
		mkdir $TempDir
	fi
#
## Initialise a new log file
	echo "GoToLogFiles log started $(date)" > $LogFile
#
## Collect Launcher/Opener Logs
        gtoLogTempDir="$TempDir/Opener_Logs"
        mkdir $gtoLogTempDir
        gtoLogIds=(com.citrixonline.mac.WebDeploymentApp
                  com.citrixonline.WebDeployment
                  com.logmein.WebDeployment)
        for logId in "${gtoLogIds[@]}"; do
            logPath="$HOME/Library/Logs/$logId"
            if [[ -e "$logPath" ]]; then
                logcomment "Opener: Log Files .:. $logId"
                rsync -av $logPath/* $gtoLogTempDir/$logId/ >> $LogFile 2>&1
            else
                logcomment "Opener: Log Files .:. No Logs Found in $logId"
            fi
        done
#
##  Collect Launcher/Opener Plists
        gtoPlistTempDir="$TempDir/Opener_Plists"
        mkdir $gtoPlistTempDir
        gtoPlistIds=(com.citrixonline.mac.WebDeploymentApp.plist
                    com.citrixonline.WebDeployment.plist
                    com.logmein.WebDeployment.plist)
        for plistId in "${gtoPlistIds[@]}"; do
            plistPath="$HOME/Library/Preferences/$plistId"
            if [[ -e "$plistPath" ]]; then
                logcomment "Opener: Plist .:. $plistId"
                defaults read $plistPath > $gtoPlistTempDir/$(echo "$plistId").txt
            else
                logcomment "Opener: Plist .:. $plistId not found."
            fi
        done
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
        gtmLogsTempDir="$TempDir/GoToMeeting_Logs"
        mkdir $gtmLogsTempDir
        gtmLogIds=(com.citrixonline.GoToMeeting
                   com.logmein.GoToMeeting
                   com.citrixonline.GoToMeeting_Recording_Manager
                   com.citrixonline.Mac.GoToMeeting.RecordingManager)
        for logId in "${gtmLogIds[@]}"; do
            echo "$logId"
            logPath="$HOME/Library/Logs/$logId"
            if [[ -e "$logPath" ]]; then
                logcomment "GoToMeeting: Log Files .:. $logId"
                rsync -av $logPath/* $gtmLogsTempDir/$logId >> $LogFile 2>&1
            else
                logcomment "GoToMeeting: Log Files .:. No Logs Found in $logId"
            fi
	done
        # Collect Plist Files
        gtmPlistTempDir="$TempDir/GoToMeeting_Plist"
        mkdir "$gtmPlistTempDir"
        gtmPlistIds=(com.citrixonline.GoToMeeting.plist
                     com.citrixonline.G2MUpdate.plist
                     com.logmein.GoToMeeting.plist
                     com.logmein.G2MUpdate.plist
                     com.logmein.gotomeeting-messenger.plist
                     com.logmein.gotomeeting-messenger.helper.plist)
        for plistId in "${gtmPlistIds[@]}"; do
            plistPath="$HOME/Library/Preferences/$plistId"
            if [[ -e "$plistPath" ]]; then
                logcomment "GoToMeeting Plist .:. $plistId"
                defaults read $plistPath > $gtmPlistTempDir/$(echo "$plistId").txt
            else
                logcomment "GoToMeeting Plist .:. $plistId not found."
            fi
        done
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
    pushd $TempDir
    zip -r $ArchiveName *
    popd
