# Import Module
Import-Module -Name bConnect
# Get Crediential
$apiCred = Get-Credential -Message "bConnect" -UserName "user@domain.local"
# Initialize bConnect Module
Initialize-bConnect -Server "SRV-BARAMUNDI" -Credentials $apiCred
# Search GroupID for the group "Servers". Name of the group (search string "Servers") must be unique in the group structure.
$orgUnit = Search-bConnectorgunit "Servers"
# Create new Endpoint in Group "Servers" ($orgUnit.Id)
New-bConnectEndpoint -Type WindowsEndpoint -DisplayName "bcTest" -HostName "bcTest" -PrimaryMac "AA-BB-CC-DD-EE-FF" -GroupGuid $orgUnit.Id
