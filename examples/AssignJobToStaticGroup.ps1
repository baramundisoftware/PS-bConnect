# Import Module
Import-Module -Name bConnect
# Get Crediential
$apiCred = Get-Credential -Message "bConnect" -UserName "user@domain.local"
# Initialize bConnect Module
Initialize-bConnect -Server "SRV-BARAMUNDI" -Credentials $apiCred
# Search for a static Group
$staticGroup = Search-bConnectGroup -Term "NO: Office 2019"
# Get Endpoints
$endpoints = Get-bConnectEndpoint -StaticGroupGuid $staticGroup.Id
# Search for a job
$job = Search-bConnectJob -Term "Inst: Office 2019"
foreach($endpoint in $endpoints){
    # Assign the job to the endpoint by creating a new job instance
    New-bConnectJobInstance -EndpointGuid $endpoint.Id -JobGuid $job.Id -Initiator "PS-bConnect"
}


