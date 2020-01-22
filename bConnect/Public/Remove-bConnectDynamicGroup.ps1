Function Remove-bConnectDynamicGroup() {
    <#
        .Synopsis
            Remove specified DynamicGroup.
        .Parameter DynamicGroupGuid
            Valid GUID of a DynamicGroup.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$DynamicGroupGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $DynamicGroupGuid
        }

        return Invoke-bConnectDelete -Controller "DynamicGroups" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
