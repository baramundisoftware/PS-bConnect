Function Reset-bConnect() {
    <#
        .Synopsis
            Resets PS-bConnect to not initialized.
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType("System.Boolean")]
    Param()

    if($PSCmdlet.ShouldProcess($_body.Id, "Start job instance.")){
        If($script:_defaultCertPolicy) {
            # Reset certicate validation
            [System.Net.ServicePointManager]::CertificatePolicy = $script:_defaultCertPolicy
        }

        $_uri = $null

        $script:_bConnectInfo = $null
        $script:_connectUri = $_uri
        $script:_connectCredentials = $null
        $script:_connectInitialized = $false
    }
}
