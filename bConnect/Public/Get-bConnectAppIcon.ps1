Function Get-bConnectAppIcon() {
    <#
        .Synopsis
            Get the icon for specified app or all apps within a scope.
        .Parameter AppGuid
            Valid GUID of a app.
        .Parameter Scope
            Valid scope (App/Inventory).
        .Outputs
            Array of Icon (see bConnect documentation for more details).
    #>

    Param (
        [string]$AppGuid,
        [bConnectIconScope]$Scope
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($Scope) {
            $_body = @{
                Scope = [string]$Scope
            }
        }

        If($AppGuid) {
            $_body = @{
                AppId = $AppGuid
            }
        }

        return Invoke-bConnectGet -Controller "Icons" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
