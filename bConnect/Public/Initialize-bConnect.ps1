Function Initialize-bConnect() {
    <#
        .Synopsis
            Initialize the connection to bConnect.
        .Parameter Server
            Hostname/FQDN/IP of the baramundi Management Server.
        .Parameter Port
            Port of bConnect (default: 443).
        .Parameter Credentials
            PSCredential-object with permissions in the bMS.
        .Parameter AcceptSelfSignedCertificate
            Switch to ignore untrusted certificates.
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)][string]$Server,
        [string]$Port = "443",
        [Parameter(Mandatory=$true)][System.Management.Automation.PSCredential]$Credentials,
        [Alias("AcceptSelfSignedCertifcate")]
        [switch]$AcceptSelfSignedCertificate
    )

    If($AcceptSelfSignedCertificate) {
        [ServerCertificateValidationCallback]::Ignore(); 
    }

    $_uri = "https://$($Server):$($Port)/bConnect"

    $script:_connectUri = $_uri
    $script:_connectCredentials = $Credentials
    $script:_connectInitialized = $true
}

