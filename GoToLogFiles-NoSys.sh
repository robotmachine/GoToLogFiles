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
# GoToLogFiles v.1.4.5
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
	rm -rf "$TempDir"
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
		mkdir "$TempDir"
	fi
#
## Initialise a new log file
	echo "GoToLogFiles log started $(date)" > $LogFile
#
## Collect Launcher/Opener Logs
        gtoLogTempDir="$TempDir/Opener_Logs"
        mkdir "$gtoLogTempDir"
        gtoLogIds=(com.citrixonline.mac.WebDeploymentApp
                  com.citrixonline.WebDeployment
                  com.logmein.WebDeployment)
        for logId in "${gtoLogIds[@]}"; do
            logPath="$HOME/Library/Logs/$logId"
            if [[ -e "$logPath" ]]; then
                logcomment "Opener: Log Files .:. $logId"
                rsync -av "$logPath"/* "$gtoLogTempDir/$logId/" >> $LogFile 2>&1
            else
                logcomment "Opener: Log Files .:. No Logs Found in $logId"
            fi
        done
#
##  Collect Launcher/Opener Plists
        gtoPlistTempDir="$TempDir/Opener_Plists"
        mkdir "$gtoPlistTempDir"
        gtoPlistIds=(com.citrixonline.mac.WebDeploymentApp.plist
                    com.citrixonline.WebDeployment.plist
                    com.logmein.WebDeployment.plist)
        for plistId in "${gtoPlistIds[@]}"; do
            plistPath="$HOME/Library/Preferences/$plistId"
            if [[ -e "$plistPath" ]]; then
                logcomment "Opener: Plist .:. $plistId"
                defaults read "$plistPath" > "$gtoPlistTempDir/$plistId.txt"
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
#
# Collect GoToAssist Corporate logs
    gtacLogsTempDir="$TempDir/GoToAssist_Corp_Logs"
    gtacLogIds=(com.citrixonline.g2ac
                com.citrixonline.g2a.customer
                com.logmein.g2a.customer
                com.logmein.g2ac)
    for logId in "${gtacLogIds[@]}"; do
        logPath="$HOME/Library/Logs/$logId"
        if [[ -e "$logPath" ]]; then
            mkdir $gtacLogsTempDir
            logcomment "GoToAssist Corporate: Log Files .:. $logId"
            rsync -av $logPath* $gtacLogsTempDir/$logId/ >> $LogFile 2>&1
        else
            logcomment "GoToAssist Corporate: Log Files .:. No Logs found in $logId"
        fi
    done
#
## Copy GoToAssist Corporate preferences to a text file
    gtacPlistTempDir="$TempDir/GoToAssist_Corp_Plist"
    gtacPlistIds=(com.citrixonline.g2ac
                  com.citrixonline.g2a.customer
                  com.logmein.g2ac
                  com.logmein.g2a.customer)
    for plistId in "${gtacPlistIds[@]}"; do
        plistPath="$HOME/Library/Preferences/$plistId*.plist"
        if [[ -e "$plistPath" ]]; then
            mkdir "$gtacPlistTempDir"
            logcomment "GoToAssist Corporate Plist .:. $plistId"
            defaults read $plistPath > $gtacPlistTempDir/$(echo "$plistId").txt
        else
            logcomment "GoToAssist Corporate Plist .:. $plistId not found."
        fi
    done
#
## Collect GoToAssist Remote Support Logs
    gtarsLogsTempDir="$TempDir/GoToAssist_RS_Logs"
    gtarsLogIds=("com.citrixonline.g2a.rs"
                 "com.citrixonline.g2ax"
                 "com.citrixonline.g2ax.customer"
                 "com.citrixonline.g2ax.expert"
                 "com.citrixonline.GoToAssist Remote Support"
                 "com.citrixonline.GoToAssist Remote Support.customer"
                 "com.logmein.GoToAssist Remote Support"
                 "com.logmein.GoToAssist Remote Support.customer"
                 "com.logmein.g2a.rs"
                 "com.logmein.g2ars")
    for logId in "${gtarsLogIds[@]}"; do
        logPath="$HOME/Library/Logs/$logId"
        if [[ -e "$logPath" ]]; then
            mkdir $gtarsLogsTempDir
            logcomment "GoToAssist Remote Support: Log Files .:. $logId"
            rsync -av $logPath* $gtarsLogsTempDir/$logId/ >> $LogFile 2>&1
        else
            logcomment "GoToAssist Remote Support: Log Files .:. No Logs found in $logId"
        fi
    done
#
## Copy GoToAssist Remote Support preferences to a text file.
    ## Collect Plist Files
    gtarsPlistTempDir="$TempDir/GoToAssist_RS_Plist"
    gtarsPlistIds=("com.citrixonline.g2ax.customer"
                   "com.citrixonline.g2ax.expert"
                   "com.citrixonline.g2ax"
                   "com.citrixonline.g2a.rs.plist"
                   "com.citrixonline.g2ars.plist"
                   "com.citrixonline.GoToAssist Remote Support"
                   "com.logmein.g2a.rs"
                   "com.logmein.g2ars"
                   "com.logmein.GoToAssist Remote Support"
                   "com.logmein.GoToAssist Remote Support.customer")
    for plistId in "${gtarsPlistIds[@]}"; do
        plistPath="$HOME/Library/Preferences/$plistId*.plist"
        if [[ -e "$plistPath" ]]; then
            mkdir "$gtarsPlistTempDir"
            logcomment "GoToAssist Remote Support Plist .:. $plistId"
            defaults read "$plistPath" > $gtarsPlistTempDir/$(echo "$plistId").txt
        else
            logcomment "GoToAssist Remote Support Plist .:. $plistId not found."
        fi
    done
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
    #
    ## Collect GoToMeeting and GoToMeeting Recording Manager logs
    gtmLogsTempDir="$TempDir/GoToMeeting_Logs"
    mkdir $gtmLogsTempDir
    gtmLogIds=(com.citrixonline.GoToMeeting
               com.logmein.GoToMeeting
               com.citrixonline.GoToMeeting_Recording_Manager
               com.citrixonline.Mac.GoToMeeting.RecordingManager
              )
    for logId in "${gtmLogIds[@]}"; do
        logPath="$HOME/Library/Logs/$logId"
        if [[ -e "$logPath" ]]; then
            logcomment "GoToMeeting: Log Files .:. $logId"
            rsync -av $logPath/* $gtmLogsTempDir/$logId/ >> $LogFile 2>&1
        else
            logcomment "GoToMeeting: Log Files .:. No Logs Found in $logId"
        fi
    done
    #
    ## Collect Plist Files
    gtmPlistTempDir="$TempDir/GoToMeeting_Plist"
    mkdir "$gtmPlistTempDir"
    gtmPlistIds=(com.citrixonline.GoToMeeting.plist
                 com.citrixonline.G2MUpdate.plist
                 com.logmein.GoToMeeting.plist
                 com.logmein.G2MUpdate.plist
                 com.logmein.gotomeeting-messenger.plist
                 com.logmein.gotomeeting-messenger.helper.plist
                )
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
    #
    ## GoToMyPC Logs
    gtpHostLogTemp="$TempDir/GoToMyPC_Host_Logs"
    gtpClientLogTemp="$TempDir/GoToMyPC_Client_Logs"
    gtpLogIds=(com.citrixonline.GoToMyPC
               com.logmein.GoToMyPC
              )
    for logId in "${gtpLogIds[@]}"; do
        hostLogPath="/Library/Logs/$logId"
        clientLogPath="$HOME/Library/Logs/$logId"
        if [[ -e "$hostLogPath" ]]; then
            mkdir $gtpHostLogTemp
            logcomment "GoToMyPC: Host Log Files .:. $logId"
            rsync -av $hostLogPath/* $gtpHostLogTemp/$logId/ >> $LogFile 2>&1
        else
            logcomment "GoToMyPC: Host Log Files .:. No Logs Found in $logId"
        fi
        if [[ -e "$clientLogPath" ]]; then
            mkdir $gtpClientLogTemp
            logcomment "GoToMyPC: Client Log Files .:. $logId"
            rsync -av $clientLogPath/* $gtpClientLogTemp/$logId/ >> $LogFile 2>&1
        else
            logcomment "GoToMyPC: Client Log Files .:. No Logs Found in $logId"
        fi
    done
    #
    ## GoToMyPC Host Plists
    gtpHostPlistTemp="$TempDir/GoToMyPC_Host_Plist"
    gtpHostPlistIds=(com.citrixonline.GoToMyPC
                     com.logmein.GoToMyPC
                    )
    for plistId in "${$gtpHostPlistIds[@]}"; do
        plistPath="/Library/Preferences/$plistId"
        if [[ -e "plistPath" ]]; then
            mkdir $gtpHostPlistTemp
            logcomment "GoToMyPC: Host Plist .:. $plistId"
            defaults read $plistPath > $gtpHostPlistTemp/$(echo "$plistId").txt
        else
            logcomment "GoToMyPC: Host Plist .:. $plistId not found."
        fi
    done
    #
    ## GoToMyPC Client Plists
    gtpClientPlistTemp="$TempDir/GoToMyPC_Client_Plist"
    gtpClientPlistIds=(com.citrixonline.GoToMyPC.SystemStatusUIHost.plist
                       com.citrixonline.g2p.viewer.plist
                       com.logmein.GoToMyPC.SystemStatusUIHost.plist
                      )
    for plistId in "${$gtpClientPlistIds[@]}"; do
        plistPath="$HOME/Library/Preferences/$plistId"
        if [[ -e "plistPath" ]]; then
            mkdir $gtpClientPlistTemp
            logcomment "GoToMyPC: Client Plist .:. $plistId"
            defaults read $plistPath > $gtpClientPlistTemp/$(echo "$plistId").txt
        else
            logcomment "GoToMyPC: Client Plist .:. $plistId not found."
        fi
    done
#
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
