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
