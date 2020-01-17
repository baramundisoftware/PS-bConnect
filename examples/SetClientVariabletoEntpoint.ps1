# Import Module
Import-Module -Name bConnect
# Get Crediential
$apiCred = Get-Credential -Message "bConnect" -UserName "user@domain.local"
# Initialize bConnect Module
Initialize-bConnect -Server "SRV-BARAMUNDI" -Credentials $apiCred
# Search for an Endpoint
$endpoint = Search-bConnectEndpoint -Term "WindowsClient1"
# Set Variable to Endpoint
Set-bConnectVariable -ObjectGuid $endpoint.id -Scope "Device" -Category "Location" -Name "City" -Value "Munich"