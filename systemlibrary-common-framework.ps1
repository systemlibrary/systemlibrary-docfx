Set-Location $PSScriptRoot

# REQUIRED OPTIONS
$csprojFileFullPath = "C:\syslib\systemlibrary-common-framework-private\source\SystemLibrary.Common.Framework.sln"

#$outputFolderFullPath = "C:\syslib\systemlibrary-common-framework\docs\" # set to $null if you want outputFolder to be within the project folder
$outputFolderFullPath = "C:\temp\Docs\"

$siteTitle = "System Library Common Framework"
$footerGithubUrl = "https://github.com/systemlibrary/systemlibrary-common-framework/"
$footerNugetUrl = "https://www.nuget.org/packages/SystemLibrary.Common.Framework/"
$footerWebsiteUrl = "https://www.systemlibrary.com/"
$footerSiteTitle = "System Library Common Framework"
$showViewSourceLinks = $true

#$relativeHostingPath = "/systemlibrary-common-framework/"
$relativeHostingPath = "" # If local IIS, most likely $null, "" or "/" is sufficient
# If using 'github pages' it should be the name of the repo with prefix and suffix /
# It is the path of where css/js is loaded from, from the "root" of your IIS site
# Simply checking network tab in chrome while browsing your site will reveal what it should be, as youll get 404/red for css/js requests

# Upgrade docfx.exe? Download latest from nuget package manager in any project, and copy paste the downloaded files
$docfxConsoleExeFullPath = ($PSScriptRoot + "\docfx.console.2.59.4\docfx.exe")

# OPTIONAL OPTIONS
$cleanUp = $false # delete temp files generated during building documentation files

# Skip rules on the full output: Name.Space.Class
# - string contains wildcard? => contains (case-sensitive)
# - else string contains dot? => starts with (case-sensitive)
# - else => ends with (case-sensitive)
$skipDocumentationFor = @('LogWriter', 
'*.Benchmark*',
'*.Tests*',
'*.ApiTests*',
'*.BaseTest*',
'DelegateJsonConverter',
'DelegateJsonConverter'
) # case sensitive

# EXECUTE
. ($PSScriptRoot + "\scripts\docfx.ps1")