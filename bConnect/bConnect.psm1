#╔═════════════════════════╦══════════════════════════════════╗
#║  baramundi software AG  ║  bConnect Module for Powershell  ║
#╠═════════════════════════╩══════════════════════════════════╣
#║ Author  : Alexander Haugk <alexander.haugk@baramundi.de>   ║
#║ Target  : bMS 2020 R1                                      ║
#╚════════════════════════════════════════════════════════════╝
# This script is provided "as is" just for educational purpose and without
# warranty of any kind.
#
# Please place your comments, questions, improvements, etc
# on Github: https://github.com/baramundisoftware/PS-bConnect

# fallback bConnect version
$script:_bConnectFallbackVersion = "v1.0"

# overwrite Invoke-RestMethod timeout
$script:_ConnectionTimeout = 0

# Only to ignore certificates errors (self-signed)
Add-Type @"
        using System;
        using System.Net;
        using System.Net.Security;
        using System.Security.Cryptography.X509Certificates;
        public class ServerCertificateValidationCallback
        {
            public static void Ignore()
            {
                ServicePointManager.ServerCertificateValidationCallback += 
                    delegate
                    (
                        Object obj, 
                        X509Certificate certificate, 
                        X509Chain chain, 
                        SslPolicyErrors errors
                    )
                    {
                        return true;
                    };
            }
        }
"@

# init the connection (uri and credentials)
$script:_connectInitialized = $false

# Load all scripts of the module
foreach($modfile in (Get-ChildItem *.ps1 -Path "$PSScriptRoot\Private")){
    . $modfile.FullName
}

foreach($modfile in (Get-ChildItem *.ps1 -Path "$PSScriptRoot\Public","$PSScriptRoot\Types")){
    . $modfile.FullName
    Export-ModuleMember $modfile.BaseName
}
