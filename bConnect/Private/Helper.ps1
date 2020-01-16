Function Test-Guid() {
    <#
        .Synopsis
            Test for valid GUID.
        .Parameter Guid
            String to test.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$Guid
    )

    If($Guid -match "\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b") {
        return $true
    } else {
        return $false
    }
}

Function ConvertTo-Hashtable {
    Param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [PSObject[]] $Object
    )
    Process {
        foreach ($obj in $Object) {
            $ht = [ordered]@{}
            $obj | Get-Member -MemberType *Property | ForEach-Object {
                $ht.($_.Name) = $obj.($_.Name)
            }
            $ht
        }
    }
}
