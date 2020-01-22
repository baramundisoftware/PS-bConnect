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
