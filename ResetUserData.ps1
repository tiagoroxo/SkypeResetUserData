## ------------------------------------------
##
##Script: ResetUserData Script 
##Version: V2
##Author: Tiago Roxo
##
## ------------------------------------------

Clear-Host

##-- FUNCTION START
Function ResetUserData () {
 [CmdletBinding()]
    param(
         [Parameter(Mandatory)]
         [string]$identity
         )

    ##--VAR
    $user = Get-CsUser -identity $identity
    $sip=$user.SipAddress.Substring(4)

    $hour = (get-date).hour
    $minute = (get-date).minute
    $second = (get-date).Second
    
    ##--Create folder
    $folder = "C:\UserDataBackup\"
    if( -Not (Test-Path -Path $folder ) )
    {
        New-Item -ItemType directory -Path $folder
        Write-Host "Creating folder" $folder -ForegroundColor Yellow -BackgroundColor DarkGreen
    }else{

    }
    $file = $folder+"ExportedUserData"+$user.SamAccountName.ToString() +$hour +$minute +$second +".zip"
 
    ##--START
    ##--Check if users it's Hosted On-Premises or Online
    if ($user.Enabled.ToString() -eq "True"){
        if ($user.HostingProvider.ToString() -ne "sipfed.online.lync.com")
        {
            Write-Host "Starting the procces for the account->"  $user.SipAddress.ToString() -ForegroundColor White -BackgroundColor Green
            Write-Host "Start Export-CsUserData for the user->" $user.SipAddress.ToString() "Hosted on Pool->" $user.RegistrarPool.ToString() -ForegroundColor Yellow -BackgroundColor DarkGreen
            ##--Uncomment the line below if you want to check user by user by pressing enter.
            #[void](Read-Host 'Press Enter to continue…')
                Export-CsUserData -PoolFqdn $user.RegistrarPool.ToString() -FileName $file -UserFilter $sip -Verbose

            Write-Host "Finished Export-CsUserData"
            Write-Host "loading..."
            Start-Sleep -s 5
            Write-Host "Start Disable-csuser for the user->" $user.SipAddress.ToString() -ForegroundColor Yellow -BackgroundColor DarkGreen
                Disable-CsUser -Identity $sip -Verbose
                invoke-csmanagementstorereplication
            Write-Host "Finished Disable-CsUser"
            Write-Host "loading..."
            Start-Sleep -s 30
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
            Write-Host "Start Restoring Policies" -ForegroundColor Yellow -BackgroundColor DarkGreen
                try
                {
                    if ($user.Clientpolicy){
                    Grant-CsClientPolicy -Identity $sip -PolicyName $user.Clientpolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsClientPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.Clientpolicy.toString()
                }
                try
                {
                    if ($user.VoicePolicy){
                    Grant-CsVoicePolicy -Identity $sip -PolicyName $user.VoicePolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsVoicePolicy -Identity $user.SipAddress.ToString() -PolicyName $user.VoicePolicy.toString()
                }
                try
                {
                    if ($user.VoiceRoutingPolicy){
                    Grant-CsVoiceRoutingPolicy -Identity $sip -PolicyName $user.VoiceRoutingPolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsVoiceRoutingPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.VoiceRoutingPolicy.toString()
                }
                try
                {
                    if ($user.ConferencingPolicy){
                    Grant-CsConferencingPolicy -Identity $sip -PolicyName $user.ConferencingPolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsConferencingPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.ConferencingPolicy.toString()
                }
                try
                {
                    if ($user.PresencePolicy){
                    Grant-CsPresencePolicy -Identity $sip -PolicyName $user.PresencePolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsPresencePolicy -Identity $user.SipAddress.ToString() -PolicyName $user.PresencePolicy.toString()
                }
                try
                {
                    if ($user.DialPlan){
                    Grant-CsDialPlan -Identity $sip -PolicyName $user.DialPlan.toString()
                    }
                }
                catch
                {
                    Grant-CsDialPlan -Identity $user.SipAddress.ToString() -PolicyName $user.DialPlan.toString()
                }
                try
                {
                    if ($user.LocationPolicy){
                    Grant-CsLocationPolicy -Identity $sip -PolicyName $user.LocationPolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsLocationPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.LocationPolicy.toString()
                }
                 try
                {
                    if ($user.ClientVersionPolicy){
                    Grant-CsClientVersionPolicy -Identity $sip -PolicyName $user.ClientVersionPolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsClientVersionPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.ClientVersionPolicy.toString()
                }
                 try
                {
                    if ($user.ArchivingPolicy){
                    Grant-CsArchivingPolicy -Identity $sip -PolicyName $user.ArchivingPolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsArchivingPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.ArchivingPolicy.toString()
                }
                 try
                {
                    if ($user.UserServicesPolicy){
                    Grant-CsUserServicesPolicy -Identity $sip -PolicyName $user.UserServicesPolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsUserServicesPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.UserServicesPolicy.toString()
                }
                 try
                {
                    if ($user.CallViaWorkPolicy){
                    Grant-CsCallViaWorkPolicy -Identity $sip -PolicyName $user.CallViaWorkPolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsCallViaWorkPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.CallViaWorkPolicy.toString()
                }
                  try
                {
                    if ($user.ThirdPartyVideoSystemPolicy){
                    Grant-CsThirdPartyVideoSystemPolicy -Identity $sip -PolicyName $user.ThirdPartyVideoSystemPolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsThirdPartyVideoSystemPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.ThirdPartyVideoSystemPolicy.toString()
                }
                try
                {
                    if ($user.MobilityPolicy){
                    Grant-CsMobilityPolicy -Identity $sip -PolicyName $user.MobilityPolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsMobilityPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.MobilityPolicy.toString()
                }
                try
                {
                    if ($user.HostedVoicemailPolicy){
                    Grant-CsHostedVoicemailPolicy -Identity $sip -PolicyName $user.HostedVoicemailPolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsHostedVoicemailPolicy -Identity $user.SipAddress.ToString() -PolicyName $user.HostedVoicemailPolicy.toString()
                }
                try
                {
                    if ($user.TeamsUpgradePolicy){
                    Grant-CsTeamsUpgradePolicy -Identity $sip -PolicyName $user.TeamsUpgradePolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsTeamsUpgradePolicy -Identity $user.SipAddress.ToString() -PolicyName $user.TeamsUpgradePolicy.toString()
                }
                 try
                {
                    if ($user.IPPhonePolicy){
                        Grant-CsIPPhonePolicy  -Identity $sip -PolicyName $user.IPPhonePolicy.toString()
                    }
                }
                catch
                {
                    Grant-CsIPPhonePolicy  -Identity $user.SipAddress.ToString() -PolicyName $user.IPPhonePolicy.toString()
                }
                 try
                {
                        
                        Set-CsUser –Identity $sip –LineUri $user.LineUri.toString() -EnterpriseVoiceEnabled $user.EnterpriseVoiceEnabled     
                }
                catch
                {
                    Set-CsUser –Identity $user.SipAddress.ToString() –LineUri $user.LineUri.toString() -EnterpriseVoiceEnabled $user.EnterpriseVoiceEnabled
                }
            Write-Host "Finish Restoring Policies" -ForegroundColor White -BackgroundColor Green
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


##--!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!
##--SPECIFY the group of users Where the script will be executed
##--!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!
$allusers = Get-CsUser -Identity tiroxo@uc-pm.net
Write-Host $allusers.count " Users found to be processed on this list"  -ForegroundColor Red -BackgroundColor Yellow
[void](Read-Host 'Press Enter to Start…')
Foreach ($id in $allusers){
     ResetUserData -identity $id
}
##--Opens the Folder where the backups were saved.
explorer.exe $($folder)
Write-Host $allusers.count " Users analysed and proccessed."  -ForegroundColor White -BackgroundColor Green
