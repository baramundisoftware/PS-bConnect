Function Edit-bConnectApplication() {
    <#
        .Synopsis
            Create a new application.
        .Parameter Application
            Application object (hashtable).
        .Outputs
            NewEndpoint (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$Application
    )

    If($Application.AUT.Count -gt 0) {
        $Application.EnableAUT = $true
    }


    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_Application = ConvertTo-Hashtable $Application
        return Invoke-bConnectPatch -Controller "Applications" -Version $_connectVersion -objectGuid $_Application.Id -Data $_Application
    } else {
        return $false
    }
}
