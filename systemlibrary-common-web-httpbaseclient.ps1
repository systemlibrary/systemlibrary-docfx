# REQUIRED OPTIONS
$csprojFileFullPath = "C:\syslib\systemlibrary-common-web-httpbaseclient\source\SystemLibrary.Common.Web.HttpBaseClient\SystemLibrary.Common.Web.HttpBaseClient.csproj"

$outputFolderFullPath = "C:\syslib\systemlibrary-common-web-httpbaseclient\docs\" # set to $null if you want outputFolder to be within the project folder

$docfxConsoleExeFullPath = "C:\syslib\Packages\docfx.console.2.58.0\tools\docfx.exe" # download docfx.console as nuget package to some project, any project, and reference the .exe here

$siteTitle = "System Library"
$footerGithubUrl = "https://github.com/systemlibrary/systemlibrary-common-web-httpbaseclient"
$footerNugetUrl = "https://www.nuget.org/packages/SystemLibrary.Common.Web.HttpBaseClient/"
$footerWebsiteUrl = "https://www.systemlibrary.com/"
$footerSiteTitle = "System Library Common Web HttpBaseClient"


$relativeHostingPath = "/systemlibrary-common-web-httpbaseclient/" # If local IIS, most likely $null, "" or "/" is sufficient
                                                    # If using 'github pages' it should be the name of the repo with prefix and suffix /
                                                    # It is the path of where css/js is loaded from, from the "root" of your domain
                                                    # Simply checking network tab in chrome while browsing your site after pushing to repo, files included in ~/docs/ folder, will reveal what it should (not) be

# OPTIONAL OPTIONS
$cleanUp = $true # delete temp files generated during building documentation files

# EXECUTE
Set-Location $PSScriptRoot
. ($PSScriptRoot + "\scripts\functions.ps1")
. ($PSScriptRoot + "\scripts\docfx.ps1")