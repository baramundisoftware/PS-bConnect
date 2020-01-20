# Import Module
Import-Module -Name bConnect
# Get Crediential
$apiCred = Get-Credential -Message "bConnect" -UserName "user@domain.local"
# Initialize bConnect Module
Initialize-bConnect -Server "SRV-BARAMUNDI" -Credentials $apiCred
# Search for an Endpoint
$endpoint = Search-bConnectEndpoint -Term "WindowsClient1"
# Search for a job
$job = Search-bConnectJob -Term "Inst: Office 2019"
# Assign the job to the endpoint by creating a new job instance
New-bConnectJobInstance -EndpointGuid $endpoint.Id -JobGuid $job.Id -Initiator "PS-bConnect" -StartIfExists