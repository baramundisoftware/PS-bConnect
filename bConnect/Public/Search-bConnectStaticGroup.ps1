Function Search-bConnectStaticGroup() {
    <#
        .Synopsis
            Search for specified static group.
        .Parameter Term
            Searchterm for the search. Wildcards allowed.
        .Outputs
            Array of SearchResult (see bConnect documentation for more details)
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$Term
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Type = "group";
            Term = $Term
        }

        $_groups = Invoke-bConnectGet -Controller "Search" -Version $_connectVersion -Data $_body
        $_result = @()
        Foreach($_group in $_groups) {
            If($_group.Type -eq [bConnectSearchResultType]::StaticGroup) {
                $_result += $_group
            }
        }
        return $_result
    } else {
        return $false
    }
}
