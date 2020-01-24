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