# Import Module
Import-Module -Name bConnect
# Get Crediential
$apiCred = Get-Credential -Message "bConnect" -UserName "user@domain.local"
# Initialize bConnect Module
Initialize-bConnect -Server "SRV-BARAMUNDI" -Credentials $apiCred
# Create Windows Endpoint
New-bConnectEndpoint -Type WindowsEndpoint -DisplayName "WindowsClient1" -HostName "WindowsClient1" -PrimaryMac "AA-BB-CC-DD-EE-FF"