Function Get-bConnectVariableDefinition() {
    <#
        .Synopsis
            Get variable definition.
        .Parameter Id
            Valid GUID of a VariableDefinition
        .Parameter Scope
            enum bConnectVariableScope.
        .Parameter Category
            Valid variable category. (Only valid if Scope is present.)
        .Parameter Name
            Valid variable name. (Only valid if Scope and Categore are present.)
        .Outputs
            VariableDefinition (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param (
        [string]$Id,
        [bConnectVariableDefinitionScope]$Scope,
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
        } Elseif($Scope -ne $null) {
            $_body += @{
                Scope = $Scope.ToString()
            }
            
            If($Category) {
                $_body += @{
                    Category = $Category
                }
                
                If($Name) {
                    $_body += @{
                        Name = $Name
                    }
                }
            }
        }

        return Invoke-bConnectGet -Controller "VariableDefinitions" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
