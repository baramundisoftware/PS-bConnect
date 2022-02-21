# enum for AndroidEnterpriseProfileType types
Add-Type -TypeDefinition @"
public enum bConnectAndroidEnterpriseProfileType
{
    None_Android_Legacy_Device = 0,
    Fully_managed_device = 1,
    Work_Profile = 2,
    Dedicated_Device = 4
}
"@