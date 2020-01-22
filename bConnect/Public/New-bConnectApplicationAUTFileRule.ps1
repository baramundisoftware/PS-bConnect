Function New-bConnectApplicationAUTFileRule() {
    <#
        .Synopsis
            Creates a new AUTFileRule for Applications.
        .Parameter FileName
            Name of the file
        .Parameter FileSize
            Size of the file
        .Parameter Date
            Timestamp as Date of the file
        .Parameter CRC
            Checksum of the file
        .Parameter Version
            Version of the file
        .Parameter Company
            Company of the file
        .Parameter ProductName
            Product name of the file
        .Parameter InternalName
            Internal name of the file
        .Parameter Language
            Language of the file
        .Parameter ProductVersion
            Product version of the file
        .Parameter FileDescription
            File description of the file
        .Parameter FileVersionNumeric
            Numerical file version
        .Parameter CommandLine
            Command line parameters
        .Outputs
            AUTFileRule (see bConnect documentation for more details)
    #>

    Param(
        [string]$FileName,
        [uint64]$FileSize,
        [string]$Date,
        [uint64]$CRC,
        [string]$Version,
        [string]$Company,
        [string]$ProductName,
        [string]$InternalName,
        [string]$Language,
        [string]$ProductVersion,
        [string]$FileDescription,
        [string]$FileVersionNumeric,
        [string]$CommandLine
    )

    $_new_aut = @{
        FileName = $FileName;
        FileSize = $FileSize;
        Date = $Date;
        CRC = $CRC;
        Version = $Version;
        Company = $Company;
        ProductName = $ProductName;
        InternalName = $InternalName;
        Language = $Language;
        ProductVersion = $ProductVersion;
        FileDescription = $FileDescription;
        FileVersionNumeric = $FileVersionNumeric;
        CommandLine = $CommandLine;
    }

    return $_new_aut
}
