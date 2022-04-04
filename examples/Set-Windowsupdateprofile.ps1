[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $UniversalDynamicGroupGuid,
    [Parameter(Mandatory = $true)] [string] $WindowsUpdateProfile,
    [Parameter(Mandatory = $true)] [string] $GuidMicrosoftUpdateProfile
)
<#
-----------------------------------------------
Original Post / Howto: https://forum.baramundi.com/index.php?threads/updateprofile-und-dynamische-gruppen.12945/#post-65427
Script Created by Kallisto:  https://forum.baramundi.com/index.php?members/kallisto.14086/
Script Modified/Posted on Github Scharmer: https://forum.baramundi.com/index.php?members/scharmer.14585/
Script Language: german / feel free do adjust 
-----------------------------------------------

-----------------------------------------------
This Script, look at at an Universal Dynamic Group, if the Endpoint is assigned to an Windows Update Profile.
Create an Universal Dynamic Group an make these filters:
Deactivated = No
Update profile is empty

Additional Filter i used:
Operating system, Variables and Logical Groups (OU) 

After that:
Usage: Set-Windowsupdateprofile.ps1 -WindowsUpdateProfile "Clients 1. Welle IT" -GuidMicrosoftUpdateProfile "779FCAD3-D552-4E89-9BF8-76544FE4BCEC" -UniversalDynamicGroupGuid "50CDB7B4-3CFE-4A7E-A926-47061CB9EA4C"

For Automatic running, create an Windows Task Scheduler
Command: powershell.exe -File "C:\PathtoScript\Set-Windowsupdateprofile.ps1" -WindowsUpdateProfile "Clients 1. Welle IT" -GuidMicrosoftUpdateProfile "779FCAD3-D552-4E89-9BF8-76544FE4BCEC" -UniversalDynamicGroupGuid "50CDB7B4-3CFE-4A7E-A926-47061CB9EA4C
-----------------------------------------------
#>

Import-Module -Name bConnect

[String] $date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$mydocuments = [environment]::getfolderpath("mydocuments")
[String] $pwdir = ($mydocuments + '\Zugänge\')
$username = "XXXXXXX@domain.local"
[String] $pwfile = ('Baramundi-API-PW-' + $username + '.txt')
[String] $pw = ($pwdir + $pwfile)
[String] $reportdir = ('C:\XXXXXXXXX\Logs\Baramundi\UpdateProfile\')
[String] $reportfile = "$date-Baramundi-UpdateProfile-$GuidMicrosoftUpdateProfile.txt"
[String] $report = $reportdir + "$reportfile"

$bConnectServer = "LOCALHOST" # if you have the Script and Baramundi Management on different Server, then use the FQDN address

<#
######### Example how do find the GUIDs #########
Get-bConnectEndpoint | ?{$_.Hostname -eq "XXXXXX"} | fl *Microsoftupdate*
# Example: $WindowsUpdateProfile = "Clients - 2 Wave"
# Example: $GuidMicrosoftUpdateProfile = "779FCAD3-D552-4E89-9BF8-76544FE4BCEC"

Get-bConnectUniversalDynamicGroup | Select-Object Name,ID | sort Name
# Example: $UniversalDynamicGroupGuid = "50CDB7B4-3CFE-4A7E-A926-47061CB9EA4C"
#>

#-----------------------------------------------
#        Passwortdatei
#-----------------------------------------------
write-host 'Prüfe ob das Verzeichnis für die Passwortdatei existiert'
if (!(Test-Path -Path $pwdir )) {
    New-Item -ItemType directory -Path $pwdir
    write-host  "Verzeichnis erstellt:" $pwdir
}
else {
    write-host  "Verzeichnis existiert bereits"
}

write-host 'Prüfe ob das Textfile mit dem Securesctring existiert, sonst frage das Passwort ab und speicheres im Text File ab'
if (!(Test-Path -Path $pw )) {
    write-host ('Passwort von ' + $username + ' eingeben') -ForegroundColor Yellow
    $SecurePassword = Read-Host -AsSecureString ('Bitte Kennwort von ' + $username + ' eingeben')
    $EncryptedPassword = ConvertFrom-SecureString -SecureString $SecurePassword
    Set-Content -Path $pw -Value $EncryptedPassword | out-null
}
else {
    write-host 'PW File existiert bereits'
    $EncryptedPassword = Get-Content -Path $pw
    $SecurePassword = ConvertTo-SecureString -String $EncryptedPassword
}
#-----------------------------------------------
#        Report Verzeichnis vorbereiten
#-----------------------------------------------
write-host 'Prüfe ob das Verzeichnis und die Datei bereits für die Reportdatei existiert'
if (!(Test-Path -Path $reportdir )) {
    write-host ('Report Verzeichnis erstellt: ' + $reportdir)
    New-Item -ItemType directory -Path $reportdir
}
else {
    write-host 'Report Verzeichnis existiert bereits'
}


#-----------------------------------------------
#         Benutzer festlegen
#-----------------------------------------------

$credential = New-Object System.Management.Automation.PSCredential($username, $SecurePassword)

#-----------------------------------------------
#         Script startet
#-----------------------------------------------
Try {
    $LogValue = ($date + ' ' + $username + ' verbinde mit Benutzer')
    $LogValue | out-file -FilePath $report -Encoding UTF8 -Append
    write-host $LogValue -ForegroundColor Green
    Initialize-bConnect -Server $bConnectServer -Credentials $credential -AcceptSelfSignedCertifcate
    $baraEndpoints = Get-bConnectEndpoint -UniversalDynamicGroupGuid $UniversalDynamicGroupGuid
    if ($baraEndpoints -ne "True") {
        ForEach ($baraEndpoint in $baraEndpoints) {
            $LogValue = ($date + ' ' + $baraEndpoint.Hostname + ' wird zur Updategruppe ' + $WindowsUpdateProfile + ' hinzugefuegt')
            $LogValue | out-file -FilePath $report -Encoding UTF8 -Append
            write-host $LogValue  -ForegroundColor Yellow
            $Endpoint = Get-bConnectEndpoint -EndpointGuid $baraEndpoint.Id
            $Endpoint | Add-Member -NotePropertyName "GuidMicrosoftUpdateProfile" -NotePropertyValue $GuidMicrosoftUpdateProfile
            $Endpoint | Add-Member -NotePropertyName "MicrosoftUpdateProfile" -NotePropertyValue $WindowsUpdateProfile
            Edit-bConnectEndpoint -Endpoint $Endpoint
            Clear-Variable baraEndpoint
        }
    }
    else {
        $LogValue = ($date + ' Abfrage für ' + $WindowsUpdateProfile + ' führte zu keinem Ergebnis')
        $LogValue | out-file -FilePath $report -Encoding UTF8 -Append
        write-host $LogValue  -ForegroundColor Green
    }
    Clear-Variable baraEndpoints
}
catch {
    $LogValue = ($date + ' Fehler in der Zuordnung')
    $LogValue | out-file -FilePath $report -Encoding UTF8 -Append
    write-host $LogValue  -ForegroundColor Yellow
}
