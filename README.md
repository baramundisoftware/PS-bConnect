![GitHub](https://img.shields.io/github/license/baramundisoftware/PS-bConnect.svg)
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/bConnect.svg)](https://www.powershellgallery.com/packages/bConnect/) 
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/bConnect.svg)](https://www.powershellgallery.com/packages/bConnect/)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-3.0-blue.svg)](https://github.com/baramundisoftware/PS-bConnect)

# PS-bConnect
Powershell module for **[baramundi Connect](https://www.baramundi.com/en/management-suite/interfaces/) (bConnect)**, the REST-API of the **[baramundi Management Suite](https://www.baramundi.com/en/)**.

## Installation
You can install the module from the [Powershell Gallery](https://www.powershellgallery.com/packages/bConnect/) Repository directly by using the Install-Module Cmdlet:

    Install-Module -Name bConnect

## Update
You can update the module from the [Powershell Gallery](https://www.powershellgallery.com/packages/bConnect/) Repository directly by using the Update-Module Cmdlet:

    Update-Module -Name bConnect

## Usage
To use the functions of PS-bConnect you need to import the module into your current session and initialize the connection to the REST-API:

    Import-Module -Name bConnect
    $apiCred = Get-Credential -Message "bConnect" -UserName "user@domain.local"
    Initialize-bConnect -Server "SRV-BARAMUNDI" -Credentials $apiCred
    
You may also add the switch *-AcceptSelfSignedCertifcate* if you use a self-signed certificate at the bConnect port.

For more details please visit the [Wiki](https://github.com/baramundisoftware/PS-bConnect/wiki).

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
