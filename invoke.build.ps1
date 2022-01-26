<#
.SYNOPSIS
    Build script which leverages the InvokeBuild module.
.DESCRIPTION
    Build script which leverages the InvokeBuild module.
    This build script is used in the build pipeline and local development for building this project.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]$Author,

    [Parameter()]
    [String]$Version,

    [Parameter()]
    [Bool]$NewRelease = $false,

    [Parameter()]
    [Bool]$UpdateDocs = $false
)

# Synopsis: Initiate the build process
task . ImportBuildModule,
    InitaliseBuildDirectory,
    CopyChangeLog,
    UpdateChangeLog,
    CreateRootModule,
    CreateProcessScript,
    UpdateModuleManifest,
    CreateArchive,
    UpdateDocs,
    UpdateProjectRepo

# Synopsis: Install dependent build modules
task InstallDependencies {
    $Modules = "PlatyPS","ChangelogManagement"
    if ($Script:ModuleName -ne "codaamok.build") {
        $Modules += "codaamok.build"
    }
    Install-Module -Name $Modules -Scope CurrentUser
}

# Synopsis: Set build platform specific environment variables
task SetGitHubActionEnvironmentVariables {
    New-BuildEnvironmentVariable -Platform "GitHubActions" -Variable @{
        "GH_USERNAME"    = $Author
        "GH_PROJECTNAME" = $ModuleName
    }
}

# Synopsis: Publish module to the PowerShell Gallery
task PublishModule {
    Publish-Module -Path $BuildRoot\build\$ModuleName -NuGetApiKey $env:PSGALLERY_API_KEY -ErrorAction "Stop" -Force
}

# Synopsis: Import the codaamok.build module
task ImportBuildModule {
    if ($Script:ModuleName -eq "codaamok.build") {
        # This is to use module for building codaamok.build itself
        Import-Module .\codaamok.build\codaamok.build.psd1
    }
    else {
        Import-Module "codaamok.build"
    }
}

# Synopsis: Create fresh build directories and initalise it with content from the project
task InitaliseBuildDirectory {
    Invoke-BuildClean -Path @(
        "{0}\build\{1}" -f $BuildRoot, $Script:ModuleName
        "{0}\release" -f $BuildRoot
    )

    if (Test-Path -Path $BuildRoot\$Script:ModuleName\* -Include "*format.ps1xml") {
        $Script:FormatFiles = Copy-Item -Path $BuildRoot\$Script:ModuleName\* -Destination $BuildRoot\build\$Script:ModuleName -Filter "*format.ps1xml" -PassThru
    }

    if (Test-Path -Path $BuildRoot\$Script:ModuleName\Files\*) {
        $Script:FileList = Copy-Item -Path $BuildRoot\$Script:ModuleName\Files\* -Destination $BuildRoot\build\$Script:ModuleName -Recurse -PassThru
    }

    Copy-Item -Path $BuildRoot\LICENSE -Destination $BuildRoot\build\$Script:ModuleName\LICENSE
    Copy-Item -Path $BuildRoot\$Script:ModuleName\en-US -Destination $BuildRoot\build\$Script:ModuleName -Recurse
    $Script:ManifestFile = Copy-Item -Path $BuildRoot\$Script:ModuleName\$Script:ModuleName.psd1 -Destination $BuildRoot\build\$Script:ModuleName\$Script:ModuleName.psd1 -PassThru
}

# Synopsis: Get change log data, copy it to the build directory, and create releasenotes.txt
task CopyChangeLog {
    Copy-Item -Path $BuildRoot\CHANGELOG.md -Destination $BuildRoot\build\$Script:ModuleName\CHANGELOG.md
    $Script:ChangeLogData = Get-ChangeLogData -Path $BuildRoot\CHANGELOG.md
    Export-UnreleasedNotes -Path $BuildRoot\release\releasenotes.txt -ChangeLogData $Script:ChangeLogData -NewRelease $Script:NewRelease
}

# Synopsis: Update CHANGELOG.md (if building a new release with -NewRelease)
task UpdateChangeLog -If ($Script:NewRelease) {
    $LinkPattern   = @{
        FirstRelease  = "https://github.com/{0}/{1}/tree/{{CUR}}" -f $Script:Author, $Script:ModuleName
        NormalRelease = "https://github.com/{0}/{1}/compare/{{PREV}}..{{CUR}}" -f $Script:Author, $Script:ModuleName
        Unreleased    = "https://github.com/{0}/{1}/compare/{{CUR}}..HEAD" -f $Script:Author, $Script:ModuleName
    }

    Update-Changelog -Path $BuildRoot\build\$Script:ModuleName\CHANGELOG.md -ReleaseVersion $Script:Version -LinkMode Automatic -LinkPattern $LinkPattern
}

# Synopsis: Creates a single .psm1 file of all private and public functions of the to-be-built module
task CreateRootModule {
    $Script:RootModule = "{0}\build\{1}\{1}.psm1" -f $BuildRoot, $Script:ModuleName
    $DevModulePath = "{0}\{1}" -f $BuildRoot, $Script:ModuleName
    Export-RootModule -DevModulePath $DevModulePath -RootModule $Script:RootModule
}

# Synopsis: Create a single Process.ps1 script file for all script files under ScriptsToProcess\* (if any)
task CreateProcessScript -If (Test-Path -Path ("{0}\{1}\ScriptsToProcess" -f $BuildRoot, $Script:ModuleName) -Include "*.ps1") {
    Export-ScriptsToProcess -Path ("{0}\{1}\ScriptsToProcess" -f $BuildRoot, $Script:ModuleName)
    $Script:ProcessScript = $true
}

# Synopsis: Update the module manifest in the build directory
task UpdateModuleManifest {
    $UpdateModuleManifestSplat = @{
        Path              = $Script:ManifestFile
        RootModule        = (Split-Path $Script:RootModule -Leaf)
        FunctionsToExport = Get-PublicFunctions -Path $BuildRoot\$Script:ModuleName\Public
        ReleaseNotes      = (Get-Content $BuildRoot\release\releasenotes.txt) -replace '`'
    }

    # Build with pre-release data from the branch if the -Version parameter is not passed (for local development and testing)
    if ($Script:Version) {
        $UpdateModuleManifestSplat["ModuleVersion"] = $Script:Version
    }
    else {
        $GitVersion = (gitversion.exe | ConvertFrom-Json)
        $UpdateModuleManifestSplat["ModuleVersion"] = $GitVersion.MajorMinorPatch
        $UpdateModuleManifestSplat["Prerelease"] = $GitVersion.NuGetPreReleaseTag
    }

    if ($Script:FormatFiles) {
        $UpdateModuleManifestSplat["FormatsToProcess"] = $Script:FormatFiles.Name
    }

    if ($Script:FileList) {
        # Use this instead of Updatet-ModuleManifest due to https://github.com/PowerShell/PowerShellGet/issues/196
        $Regex = '^# FileList = @\(\)$'
        $ReplaceStr = 'FileList = "{0}"' -f [String]::Join('", "', $Script:FileList.Name)
        (Get-Content -Path $Script:ManifestFile.FullName) -replace $Regex, $ReplaceStr | Set-Content -Path $Script:ManifestFile
    }

    if ($Script:ProcessScript) {
        # Use this instead of Updatet-ModuleManifest due to https://github.com/PowerShell/PowerShellGet/issues/196
        $Regex = '(#? ?ScriptsToProcess.+)'
        $ReplaceStr = 'ScriptsToProcess = "Process.ps1"'
        (Get-Content -Path $Script:ManifestFile.FullName) -replace $Regex, $ReplaceStr | Set-Content -Path $Script:ManifestFile
    }

    Update-ModuleManifest @UpdateModuleManifestSplat

    # Arguably a moot point as Update-MooduleManifest obviously does some testing to ensure a valid manifest is there first before updating it
    # However with the regex replace for ScriptsToProcess, I want to be sure
    $null = Test-ModuleManifest -Path $Script:ManifestFile
}

# Synopsis: Create archive of the module
task CreateArchive {
    $ReleaseAsset = "{0}_{1}.zip" -f $Script:ModuleName, $Script:Version
    Compress-Archive -Path $BuildRoot\build\$Script:ModuleName\* -DestinationPath $BuildRoot\release\$ReleaseAsset -Force
}

# Synopsis: Update documentation (-NewRelease or -UpdateDocs switch parameter)
task UpdateDocs -If ($NewRelease -Or $UpdateDocs) {
    Import-Module -Name $BuildRoot\build\$Script:ModuleName -Force
    New-MarkdownHelp -Module $Script:ModuleName -OutputFolder $BuildRoot\docs -Force
}

# Synopsis: Update the project's repository with files updated by the pipeline e.g. module manifest
task UpdateProjectRepo -If ($NewRelease) {
    Copy-Item -Path $BuildRoot\build\$Script:ModuleName\CHANGELOG.md -Destination $BuildRoot\CHANGELOG.md

    $ManifestData = Import-PowerShellDataFile -Path $Script:ManifestFile

    # Instead of copying the manifest from the .\build directory, update it in place
    # This enables me to keep FunctionsToExport = '*' for development. Therefore instead only update the important bits e.g. version and release notes    
    $UpdateModuleManifestSplat = @{
        Path          = "{0}\{1}\{1}.psd1" -f $BuildRoot, $Script:ModuleName
        ModuleVersion = $ManifestData.ModuleVersion
        ReleaseNotes  = $ManifestData.PrivateData.PSData.ReleaseNotes
    }
    Update-ModuleManifest @UpdateModuleManifestSplat
    
    $null = Test-ModuleManifest -Path ("{0}\{1}\{1}.psd1" -f $BuildRoot, $Script:ModuleName)
}