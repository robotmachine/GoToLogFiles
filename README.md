#GoToLogFiles_Mac
## Version 1.1
Unofficial OSX log file collector for Citrix SaaS Products
* GoToMeeting/GoToWebinar/GoToTraining
* GoToMyPC
* GoToAssist Corporate & Remote Support

Just need to download the tool? [Click Here](https://citrix.sharefile.com/d-s31fb96733bf49538)  

##CHANGELOG
### 20 July, 2015 (v 1.1):
* Drastically cut down scripting-- down to a single file  
* GoToMyPC host and client merged to one entry  
* GoToAssist RS and Corp merged to one entry  
* User prompt now built in to shell script  
* Desktop folder is popped after log file collection  

### 13 July, 2015 (v 0.9):  
* Printing plist files to text files  
  
###26 June, 2015 (v 0.8):  
* Cut down on redundant scripting
* Created a start.sh and finish.sh for all logging that is common to all products
* Rewrote Voltron to use a function to reduce redundancy  

###25 June, 2015 (v 0.6):
* Simplified output of ps for running process log
* Added `diskutil list` and `df -H` logging to Disk_Info.txt

###11 March, 2015 (v 0.5):
* Removed GoToMeeting Recording logs as they are no longer needed  
* File name now has a Unix Epoch date stamp to avoid globbed files  
* After the logs are collected, a prompt notifies that the process is complete  
* Samples are collected of the GoToMeeting EP and RecMgr if they are running  
