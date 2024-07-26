Set-Location $PSScriptRoot

# REQUIRED OPTIONS
$csprojFileFullPath = "C:\syslib\systemlibrary-common-net\source\SystemLibrary.Common.Net\SystemLibrary.Common.Net.csproj"

$outputFolderFullPath = "C:\syslib\systemlibrary-common-net\docs\" # set to $null if you want outputFolder to be within the project folder
#$outputFolderFullPath = "C:\temp\Docs\"

$siteTitle = "System Library Common .Net"
$footerGithubUrl = "https://github.com/systemlibrary/systemlibrary-common-net"
$footerNugetUrl = "https://www.nuget.org/packages/SystemLibrary.Common.Net/"
$footerWebsiteUrl = "https://www.systemlibrary.com/"
$footerSiteTitle = "System Library"

$relativeHostingPath = "/systemlibrary-common-net/"
#$relativeHostingPath = "" # If destination is in a IIS website, most likely $null, "" or "/" is sufficient
# If using 'github pages' it should be the /name-of-the-repo/ note the slashes
# It is the path of where css/js is loaded from, from the "root" of your website
# Simply checking network tab in chrome while browsing your site will reveal what it should be, as you'll get 404 for css/js requests

# Upgrade docfx.exe? Download latest from nuget package manager in any project, and copy paste the downloaded files
$docfxConsoleExeFullPath = ($PSScriptRoot + "\docfx.console.2.59.4\docfx.exe")


# OPTIONAL OPTIONS
$cleanUp = $true # delete temp files generated during building documentation files

$skipDocumentationFor = @('DocFxHide') # matching exact class name unless a dot is included in string, then searches with "StartsWith" ex: "System.IO" would skip all under this namespace, "File" would only skip a class File in any namespace

# EXECUTE
. ($PSScriptRoot + "\scripts\docfx.ps1")