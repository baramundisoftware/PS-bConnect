# enum for Variable scopes
Add-Type -TypeDefinition @"
public enum bConnectVariableScope
{
    Device,
    MobileDevice,
    OrgUnit,
    Job,
    Software,
    HardwareProfile,
    NetworkDevice,
    OTDevice
}
"@
