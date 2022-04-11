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

    [CmdletBinding()]
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
