## PS-bConnect
Powershell module for **[bConnect](https://www.baramundi.com/en/management-suite/interfaces/)**, the REST-API of the **[baramundi Management Suite](https://www.baramundi.com/en/)**.

## Installation
You can install the module from the Powershell Gallery Repository directly by using the Install-Module CMDlet:

    Install-Module -Name bConnect

## Usage
To use the functions of PS-bConnect you need to import the module into your current session and initialize the connection to the REST-API:

    Import-Module -Name bConnect
    $apiCred = Get-Credential -Message "bConnect" -UserName "user@domain.local"
    Initialize-bConnect -Server "SRV-BARAMUNDI" -Credentials $apiCred
    
You may also add the switch *-AcceptSelfSignedCertifcate* if you use a self-signed certificate at the bConnect port.

## Author
Alexander Haugk
baramundi software AG
https://www.baramundi.com

## Contributing
Contributions, feature requests and issues are welcome.

Please post your request in the [issue tracker](https://github.com/baramundisoftware/PS-bConnect/issues).

## License
Copyright (c)2020 baramundi software AG.

This project ist licensed under the [MIT License](https://github.com/baramundisoftware/PS-bConnect/blob/master/LICENSE).
