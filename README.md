# SkypeResetUserData
- In Skype for Business, we can only backup the userdata of an account with the cmdlet:
Export-CsUserData -PoolFqdn "atl-cs-001.litwareinc.com" -FileName "C:\Logs\ExportedUserData.zip" -UserFilter kenmyer@litwareinc.com
- This script will allow you to backup the UserData, Policies, EV Config, and after, deletes the account, and restore it again with all propreties - YOu can run this script for a single or multiple accounts.
- Before using the script, please review it carefully.
##  Intructions: 
###  1. Run this script from a Front-End Server where we have all Skype for business Modules Loaded
###  2. On the C:\ Drive create an folder called UserDataBackup
###  3. Define the group of userd where you need this script to be executed.
###  4. Run the following cmdlet: Set-ExecutionPolicy -ExecutionPolicy Unrestricted
