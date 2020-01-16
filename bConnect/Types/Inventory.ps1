# enum for InventoryScan types
Add-Type -TypeDefinition @"
public enum bConnectInventoryScanType
{
    Unknown,
    Custom,
    WMI,
    Hardware
}
"@