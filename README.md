#GoToLogFiles_Mac
## Version 0.6
Unofficial OSX log file collector for Citrix SaaS Products

##CHANGELOG
###25 June, 2015 (v 0.6):
* Simplified output of ps for running process log
* Added `diskutil list` and `df -H` logging to Disk_Info.txt
###11 March, 2015 (v 0.5):
* Removed GoToMeeting Recording logs as they are no longer needed  
* File name now has a Unix Epoch date stamp to avoid globbed files  
* After the logs are collected, a prompt notifies that the process is complete  
* Samples are collected of the GoToMeeting EP and RecMgr if they are running  
