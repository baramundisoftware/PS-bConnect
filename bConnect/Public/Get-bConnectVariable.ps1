Function Get-bConnectVariable() {
    <#
        .Synopsis
            Get variables from a object.
        .Parameter Scope
            enum bConnectVariableScope.
        .Parameter Category
            Valid variable category.
        .Parameter Name
            Valid variable name.
        .Parameter ObjectGuid
            Valid GUID of an object.
        .Outputs
            ObjectVariables (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][bConnectVariableScope]$Scope,
        [string]$Category,
        [string]$Name,
        [string]$ObjectGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        $_body = @{ Scope = $Scope.ToString() }

        If($Category) {
            $_body += @{ Category = $Category }
        }

        If($Name) {
            $_body += @{ Name = $Name }
        }

        If($ObjectGuid) {
            $_body += @{ ObjectId = $ObjectGuid }
        }

        return Invoke-bConnectGet -Controller "Variables" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
