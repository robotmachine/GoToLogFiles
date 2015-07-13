#GoToLogFiles_Mac
## Version 0.9
Unofficial OSX log file collector for Citrix SaaS Products

Just need to download the tool? [Click Here](https://citrix.sharefile.com/d/s6919f11988943839)  

##CHANGELOG
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
