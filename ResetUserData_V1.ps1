## ------------------------------------------
##
##Script: ResetUserData Script 
##Version: V1
##Author: Tiago Roxo
##
##Description: This script Backups all the userdata, Policies, EV Config, and after that, deletes the account and restore it again.
##Intructions: 
##  1. Run this script from a Front-End Server where we have all Skype for business Modules Loaded
##  2. On the C:\ Drive create an folder called UserDataBackup
##  3. Define the group of userd where you need this script to be executed.
##  4. Run the following cmdlet: Set-ExecutionPolicy -ExecutionPolicy Unrestricted
##
## ------------------------------------------

Clear-Host

Function ResetUserData () {
 [CmdletBinding()]
    param(
         [Parameter(Mandatory)]
         [string]$identity
         )

    #VAR
    $user = Get-CsUser -identity $identity
    $sip=$user.SipAddress.Substring(4)

    $hour = (get-date).hour
    $minute = (get-date).minute
    $second = (get-date).Second
    $folder = "C:\UserDataBackup\"
    $file = $folder+"ExportedUserData"+$user.SamAccountName.ToString() +$hour +$minute +$second +".zip"
 
    #START
    #Check if users it's Hosted On-Premises or Online
    if ($user.Enabled.ToString() -eq "True"){
        if ($user.HostingProvider.ToString() -ne "sipfed.online.lync.com")
        {
            Write-Host "Starting the procces for the account->"  $user.SipAddress.ToString() -ForegroundColor White -BackgroundColor Green
            Write-Host "Start Export-CsUserData for the user->" $user.SipAddress.ToString() "Hosted on Pool->" $user.RegistrarPool.ToString() -ForegroundColor Yellow -BackgroundColor DarkGreen
            ##Uncomment the line below if you want to check user by user by pressing enter.
            ##[void](Read-Host 'Press Enter to continue…')
                Export-CsUserData -PoolFqdn $user.RegistrarPool.ToString() -FileName $file -UserFilter $sip -Verbose
            explorer.exe $($folder)
            Write-Host "Finished Export-CsUserData"
            Write-Host "loading..."
            Start-Sleep -s 5
            Write-Host "Start Disable-csuser for the user->" $user.SipAddress.ToString() -ForegroundColor Yellow -BackgroundColor DarkGreen
                Disable-CsUser -Identity $sip -Verbose
            Write-Host "Finished Disable-CsUser"
            Write-Host "loading..."
            Start-Sleep -s 5
            Write-Host "Start Enable-CsUser->" $user.SipAddress.ToString() -ForegroundColor Yellow -BackgroundColor DarkGreen
                Enable-CsUser -Identity $sip -RegistrarPool $user.RegistrarPool.ToString() -SipAddress $user.SipAddress.ToString() -Verbose
            Write-Host "Finished Enable-CsUser"
            Write-Host "loading..."
            Start-Sleep -s 5
            Write-Host "Start Update-CsUserData->" $user.SipAddress.ToString() -ForegroundColor Yellow -BackgroundColor DarkGreen
                Update-CsUserData -Filename $file -UserFilter $user -Verbose
            Write-Host "Finished Update-CsUserData"
            Write-Host "loading..."
            Write-Host "-------------------------- USER DETAILS[BEFORE] --------------------------"
            Get-csuser -Identity $identity
            Write-Host "-------------------------- USER DETAILS[BEFORE] --------------------------"
            Start-Sleep -s 5
            Write-Host "Start Restoring Policies"
                Grant-CsClientPolicy -Identity $sip -PolicyName $user.Clientpolicy.toString()
                Grant-CsVoicePolicy  -Identity $sip -PolicyName $user.VoicePolicy.toString()
                Grant-CsVoiceRoutingPolicy -Identity $sip -PolicyName $user.VoiceRoutingPolicy.toString()
                Grant-CsConferencingPolicy -Identity $sip -PolicyName $user.ConferencingPolicy.toString()
                Grant-CsPresencePolicy -Identity $sip -PolicyName $user.PresencePolicy.toString()
                Grant-CsDialPlan -Identity $sip -PolicyName $user.DialPlan.toString()
                Grant-CsLocationPolicy -Identity $sip -PolicyName $user.LocationPolicy.toString()
                Grant-CsClientVersionPolicy -Identity $sip -PolicyName $user.ClientVersionPolicy.toString()
                Grant-CsArchivingPolicy -Identity $sip -PolicyName $user.ArchivingPolicy.toString()
                Grant-CsUserServicesPolicy -Identity $sip -PolicyName $user.UserServicesPolicy.toString()
                Grant-CsCallViaWorkPolicy -Identity $sip -PolicyName $user.CallViaWorkPolicy.toString()
                Grant-CsThirdPartyVideoSystemPolicy -Identity $sip -PolicyName $user.ThirdPartyVideoSystemPolicy.toString()
                Grant-CsMobilityPolicy -Identity $sip -PolicyName $user.MobilityPolicy.toString()
                Grant-CsHostedVoicemailPolicy -Identity $sip -PolicyName $user.HostedVoicemailPolicy.toString()
                Grant-CsTeamsUpgradePolicy -Identity $sip -PolicyName $user.TeamsUpgradePolicy.toString()
                Grant-CsIPPhonePolicy  -Identity $sip -PolicyName $user.IPPhonePolicy.toString()
                Set-CsUser –Identity $sip –LineUri $user.LineUri.toString() -EnterpriseVoiceEnabled $user.EnterpriseVoiceEnabled
            Write-Host "-------------------------- USER DETAILS[AFTER] --------------------------"
            Get-csuser -Identity $identity
            Write-Host "-------------------------- USER DETAILS[AFTER] --------------------------"
            Start-Sleep -s 5
        }     
        else{
            Write-Host "Cannot process user - > USER" $user.SipAddress.ToString()  "it's hosted Online - >"  $user.HostingProvider.ToString() -ForegroundColor White -BackgroundColor Red
        }
    }else{
        Write-Host "Cannot process user - > USER" $user.SipAddress.ToString()  "user is Disabled"  -ForegroundColor White -BackgroundColor Red
    }
}

##!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!
##SPECIFY the group of users Where the script will be executed
##!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!
$allusers = Get-CsUser
Write-Host $allusers.count " Users found to be processed on this list"  -ForegroundColor Red -BackgroundColor Yellow
[void](Read-Host 'Press Enter to Start…')
Foreach ($id in $allusers){
     ResetUserData -identity $id
}
Write-Host $allusers.count " Users analysed and proccessed."  -ForegroundColor White -BackgroundColor Green
