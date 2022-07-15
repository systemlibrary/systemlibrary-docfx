Set-Location $PSScriptRoot

# REQUIRED OPTIONS
$csprojFileFullPath = "C:\syslib\systemlibrary-common-web\source\SystemLibrary.Common.Web\SystemLibrary.Common.Web.csproj"

$outputFolderFullPath = "C:\syslib\systemlibrary-common-web\docs\" # set to $null if you want outputFolder to be within the project folder
#$outputFolderFullPath = "C:\temp\Docs\"

$siteTitle = "System Library Common Web"
$footerGithubUrl = "https://github.com/systemlibrary/systemlibrary-common-web/"
$footerNugetUrl = "https://www.nuget.org/packages/SystemLibrary.Common.Web/"
$footerWebsiteUrl = "https://www.systemlibrary.com/"
$footerSiteTitle = "System Library Common Web"

$relativeHostingPath = "/systemlibrary-common-web/"
#$relativeHostingPath = "" # If local IIS, most likely $null, "" or "/" is sufficient
# If using 'github pages' it should be the name of the repo with prefix and suffix /
# It is the path of where css/js is loaded from, from the "root" of your IIS site
# Simply checking network tab in chrome while browsing your site will reveal what it should be, as youll get 404/red for css/js requests

# Upgrade docfx.exe? Download latest from nuget package manager in any project, and copy paste the downloaded files
$docfxConsoleExeFullPath = ($PSScriptRoot + "\docfx.console.2.59.3\docfx.exe")


# OPTIONAL OPTIONS
$cleanUp = $true # delete temp files generated during building documentation files

$skipDocumentationFor = @() # case sensitive

# EXECUTE
. ($PSScriptRoot + "\scripts\docfx.ps1")