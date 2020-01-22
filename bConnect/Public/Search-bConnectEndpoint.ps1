Function Search-bConnectEndpoint() {
    <#
        .Synopsis
            Search for specified endpoints.
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
            Type = "endpoint";
            Term = $Term
        }

        return Invoke-bConnectGet -Controller "Search" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
