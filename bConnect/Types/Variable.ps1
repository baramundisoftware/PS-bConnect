# enum for Variable scopes
Add-Type -TypeDefinition @"
public enum bConnectVariableScope
{
    Device,
    MobileDevice,
    OrgUnit,
    Job,
    Software,
    HardwareProfile
}
"@

# enum for Variable types
Add-Type -TypeDefinition @"
public enum bConnectVariableType
{
    Unknown,
    Number,
    String,
    Date,
    Checkbox,
    Dropdownbox,
    DropdownListbox,
    Filelink,
    Folder,
    Password,
    Certificate
}
"@