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

# Load all scripts of the module
foreach($modfile in (Get-ChildItem *.ps1 -Path "$PSScriptRoot\Private")){
    . $modfile.FullName
}

foreach($modfile in (Get-ChildItem *.ps1 -Path "$PSScriptRoot\Public","$PSScriptRoot\Types")){
    . $modfile.FullName
    Export-ModuleMember $modfile.BaseName
}
