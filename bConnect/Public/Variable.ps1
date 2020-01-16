# --- Variable ---
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

    Param (
        [Parameter(Mandatory=$true)][bConnectVariableScope]$Scope,
        [string]$Category,
        [string]$Name,
        [string]$ObjectGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
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

Function Set-bConnectVariable() {
    <#
        .Synopsis
            Set variable for a object.
        .Parameter ObjectGuid
            Valid GUID of an object.
        .Parameter Scope
            enum bConnectVariableScope.
        .Parameter Category
            Valid variable category.
        .Parameter Name
            Valid variable name.
        .Parameter Value
            New value.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$ObjectGuid,
        [Parameter(Mandatory=$true)][bConnectVariableScope]$Scope,
        [Parameter(Mandatory=$true)][string]$Category,
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$Value,
        [switch]$UseDefault
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_variable = @{
            Category = $Category;
            Name = $Name;
            UseDefault = $UseDefault.ToString();
            Value = $Value
        }

        $_variables = @($_variable)

        $_body = @{
            ObjectId = $ObjectGuid;
            Scope = $Scope.ToString();
            Variables = $_variables
        }

        return Invoke-bConnectPut -Controller "Variables" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Export-ModuleMember Get-bConnectVariable
Export-ModuleMember Set-bConnectVariable
