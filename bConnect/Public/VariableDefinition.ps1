# --- Variable definitions---
Function Get-bConnectVariableDefinition() {
    <#
        .Synopsis
            Get variable definition.
        .Parameter Id
            Valid GUID of a VariableDefinition
        .Parameter Scope
            enum bConnectVariableScope.
        .Parameter Category
            Valid variable category.
        .Parameter Name
            Valid variable name.
        .Outputs
            VariableDefinition (see bConnect documentation for more details).
    #>

    Param (
        [string]$Id,
        [bConnectVariableScope]$Scope,
        [string]$Category,
        [string]$Name
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{}

        If($Id) {
            $_body += @{
                Id = $Id
            }
        }

        If($Scope) {
            $_body += @{
                Scope = $Scope.ToString()
            }
        }

        If($Category) {
            $_body += @{
                Category = $Category
            }
        }

        If($Name) {
            $_body += @{
                Name = $Name
            }
        }

        return Invoke-bConnectGet -Controller "VariableDefinitions" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function New-bConnectVariableDefinition() {
    <#
        .Synopsis
            New VariableDefinition.
        .Parameter Scope
            enum bConnectVariableScope.
        .Parameter Category
            Valid variable category.
        .Parameter Name
            Valid variable name.
        .Parameter Type
            enum bConnectVariableType.
        .Outputs
            New VariableDefinition (see bConnect documentation for more details).
    #>

    Param (
        [Parameter(Mandatory=$true)][bConnectVariableScope]$Scope,
        [Parameter(Mandatory=$true)][string]$Category,
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][bConnectVariableType]$Type
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Scope = $Scope.ToString();
            Category = $Category;
            Name = $Name;
            Type = [string]$Type
        }

        return Invoke-bConnectPost -Controller "VariableDefinitions" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Edit-bConnectVariableDefinition() {
    <#
        .Synopsis
            Updates a VariableDefinition.
        .Parameter VariableDefinition
            A valid VariableDefinition with changed values
            Updating the Category or Name will change the ID of the correspondig VariableDefinition object!
        .Outputs
            VariableDefinition (see bConnect documentation for more details).
    #>

    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$VariableDefinition
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $VariableDefinition.Id) {
            $_body = @{
                Scope = $VariableDefinition.Scope;
                Category = $VariableDefinition.Category;
                Name = $VariableDefinition.Name;
                Type = $VariableDefinition.Type;
                Comments = $VariableDefinition.Comments
            }

            return Invoke-bConnectPatch -Controller "VariableDefinitions" -Version $_connectVersion -objectGuid $VariableDefinition.Id -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}

Export-ModuleMember Get-bConnectVariableDefinition
Export-ModuleMember New-bConnectVariableDefinition
Export-ModuleMember Edit-bConnectVariableDefinition
