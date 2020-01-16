#╔═════════════════════════╦══════════════════════════════════╗
#║  baramundi software AG  ║  bConnect Module for Powershell  ║
#╠═════════════════════════╩══════════════════════════════════╣
#║ Author  : Alexander Haugk <alexander.haugk@baramundi.de>   ║
#║ Target  : bMS 2019 R2                                      ║
#╚════════════════════════════════════════════════════════════╝
# This script is provided "as is" just for educational purpose and without
# warranty of any kind.
#
# Please place your comments, questions, improvements, etc 
# on Github: https://github.com/baramundisoftware/PS-bConnect

Get-ChildItem *.ps1 -Path "$PSScriptRoot\Private","$PSScriptRoot\Public","$PSScriptRoot\Types" | ForEach-Object -Process { . $PSItem.FullName }
