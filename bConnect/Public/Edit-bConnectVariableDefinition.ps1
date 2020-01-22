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
