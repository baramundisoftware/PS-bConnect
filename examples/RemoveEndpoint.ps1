# Import Module
Import-Module -Name bConnect
# Get Crediential
$apiCred = Get-Credential -Message "bConnect" -UserName "user@domain.local"
# Initialize bConnect Module
Initialize-bConnect -Server "SRV-BARAMUNDI" -Credentials $apiCred
# Search for an Endpoint
$endpoint = Search-bConnectEndpoint -Term "WindowsClient1"
# Remove Endpoint with GUID
Remove-bConnectEndpoint -EndpointGuid $endpoint.id
# Alternative with the Endpoint-Object
# Remove-bConnectEndpoint -Endpoint $endpoint
