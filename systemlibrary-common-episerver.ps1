Set-Location $PSScriptRoot

# REQUIRED OPTIONS
$csprojFileFullPath = "C:\syslib\systemlibrary-common-episerver\source\SystemLibrary.Common.Episerver\SystemLibrary.Common.Episerver.csproj"

#$outputFolderFullPath = "C:\syslib\systemlibrary-common-episerver\docs\" # set to $null if you want outputFolder to be within the project folder
$outputFolderFullPath = "C:\temp\Docs\"

$siteTitle = "System Library Common Episerver"
$footerGithubUrl = "https://github.com/systemlibrary/systemlibrary-common-episerver/"
$footerNugetUrl = "https://www.nuget.org/packages/SystemLibrary.Common.Episerver/"
$footerWebsiteUrl = "https://www.systemlibrary.com/"
$footerSiteTitle = "System Library Common Episerver"

$ignoreClassesContaining = @('DocFxHide', 'RemoveSuggestedContentTypes', 'HideCategoryListDescriptor', 'CmsEditorController', 'FontAwesomeSolid', 'FontAwesomeBrands', 'FontAwesomeRegular')

#$relativeHostingPath = "/systemlibrary-common-episerver/"
$relativeHostingPath = "" # If local IIS, most likely $null, "" or "/" is sufficient
# If using 'github pages' it should be the name of the repo with prefix and suffix /
# It is the path of where css/js is loaded from, from the "root" of your IIS site
# Simply checking network tab in chrome while browsing your site will reveal what it should be or should not be

# OPTIONAL OPTIONS
# Upgrade docfx.exe? Download latest from nuget package manager in any project, and copy paste the downloaded files
$docfxConsoleExeFullPath = ($PSScriptRoot + "\docfx.console.2.59.3\docfx.exe")

# Delete temp files generated during building documentation files
$cleanUp = $true 

# EXECUTE
. ($PSScriptRoot + "\scripts\functions.ps1")
. ($PSScriptRoot + "\scripts\docfx.ps1")