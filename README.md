# SkypeResetUserData
- In Skype for Business, we can only backup the userdata of an account with the cmdlet:
Export-CsUserData -PoolFqdn "atl-cs-001.litwareinc.com" -FileName "C:\Logs\ExportedUserData.zip" -UserFilter kenmyer@litwareinc.com
- This script will allow you to backup the UserData, Policies, EV Config, and after, deletes the account, and restore it again with all propreties - YOu can run this script for a single or multiple accounts.
- Before using the script, please review it carefully.
##  Intructions: 
####  1. Run this script from a Skype for Business Front-End Server where all Skype for business Modules are Loaded.
####  2. Define the group of userd where you need this script to be executed.
####  3. Run the following cmdlet: Set-ExecutionPolicy -ExecutionPolicy Unrestricted
