# SkypeResetUserData
- In Skype for Business, we can only backup the userdata of an account with the cmdlet:
**Export-CsUserData -PoolFqdn "atl-cs-001.litwareinc.com" -FileName "C:\Logs\ExportedUserData.zip" -UserFilter kenmyer@litwareinc.com**
- This script will allow you to backup, not only the UserData, but as well, Policies and EV Configuration, and after, deletes the account, and restore it again with all propreties - You can run this script for a single or multiple accounts.
- Before using the script, please review it carefully.
##  Intructions: 
####  1. Run the following cmdlet: Set-ExecutionPolicy -ExecutionPolicy Unrestricted
####  2. Run this script from a Skype for Business Front-End Server where all Skype for business Modules are Loaded.
####  3. Define the group of userd where you need this script to be executed.
####  
