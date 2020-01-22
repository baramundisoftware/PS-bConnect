Function Remove-bConnectJobInstance() {
    <#
        .Synopsis
            Remove specified jobinstance.
        .Parameter JobInstanceGuid
            Valid GUID of a jobinstance.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$JobInstanceGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $JobInstanceGuid
        }

        return Invoke-bConnectDelete -Controller "JobInstances" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
