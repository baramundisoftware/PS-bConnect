# enum for Variable scopes
Add-Type -TypeDefinition @"
public enum bConnectVariableDefinitionScope
{
    MobileDevice,
    OrgUnit,
    Job, 
    Software, 
    HardwareProfile,
    AdObject, 
    Bulletin, 
    Component,
    NetworkDevice, 
    ICDevice,
    AndroidDevice, 
    IOSDevice,
    WindowsPhoneDevice
}
"@
