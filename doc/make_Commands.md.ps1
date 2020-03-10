Import-Module ../bConnect/bConnect.psd1 -Force


function syntax ($cmd,$header=4) {
    $help=Get-Help($cmd)
    '#'*$header+" "+$cmd
    "> {0}" -F $help.Synopsis.trim()
    '```'
    $help.Syntax
    '```'
    $help.Description
    '#'+('#'*$header)+" Parameters"
    ""
    params $help
    ""
}
function params ($help) {
    #$replace=[regex]'^-'
    $help.Parameters.parameter|Sort-Object Position,Required,Name |% {
        $param=$_
        '* {0} `<{1}>`' -F $param.Name,$param.Type.Name
        "  > {0}" -F $param.Description.Text
        '  ```'
        'Position Required PipelineInput Aliases' -split ' '|% {
            "  {0} : {1}" -F $_,$param.$_
        }
        '  ```'
        ""
    }
}
function toc () {
    $tocs=0
    [string[]]$cmds=@()

    $cmds+=(Get-Command -Module bConnect -Noun bConnect).Name|Sort-Object -Descending
    $cmds+=(Get-Command -Module bConnect|? {$_ -notmatch '^(Search|Initialize|Reset)-'}|Sort-Object Noun,Verb).Name
    $cmds+=(Get-Command -Module bConnect -Verb Search).Name
    #$cmds+=(Get-Command -Module bConnect |? {$_ -match '^(Merge|Expand)-'} | Sort-Object Verb,Noun).Name
    
    foreach($cmd in $cmds) {
        $paramAnchor=if($tocs){$tocs}else{""}
        "* [$cmd](#{0}) ( *[Parameters](#parameters{1})* )" -F $cmd.tolower(),$paramAnchor
        $tocs--
    }
}
& {
    "# Cmdlets exported by this module"
    ""
    toc
    ""
    "## Initialize"
    syntax Initialize-bConnect 3
    syntax Reset-bConnect 3
    ""
    "## Commands by Controller"
    ( Get-Command -Module bConnect |? {$_ -notmatch '^(Search|Initialize|Reset)-'}|
    Sort-Object Noun,Verb|Group-Object Noun
    ) | % {
        ""
        "### Controller "+($_.Name -replace '^b(Connect)?')
        $_.Group.Name |% {
            syntax $_
        }
    }
    "### Controller Search"
    (Get-Command -Module bConnect -Verb Search).Name |% {
        syntax $_
    }
    #""
    #"## Helper Commands"
    #""
    #(Get-Command -Module bConnect |? {$_ -match '^(New|Merge|Expand)-'} | Sort-Object Verb,Noun).Name|% {
    #    syntax $_ 3
    #}
} > ./_Commands.md
(Get-Content ./_Commands.md -raw) -replace '\r\n',"`n" -replace '\r',"`n" -replace '[\n]+',"`n" > ./Commands.md
Remove-Item ./_Commands.md
