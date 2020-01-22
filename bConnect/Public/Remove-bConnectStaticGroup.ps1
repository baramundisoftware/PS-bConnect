Function Remove-bConnectStaticGroup() {
    <#
        .Synopsis
            Remove specified StaticGroup.
        .Parameter StaticGroupGuid
            Valid GUID of a StaticGroup.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$StaticGroupGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $StaticGroupGuid
        }

        return Invoke-bConnectDelete -Controller "StaticGroups" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
