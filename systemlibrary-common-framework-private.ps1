Set-Location $PSScriptRoot

# REQUIRED OPTIONS

# Root folder of the repository/solution.
# Base directory where DocFX scans for .csproj files and where docfx.json is executed from.
$SourceRootFullPath = "C:\syslib\systemlibrary-common-framework-private\source"

# Relative path (from $SourceRootFullPath) to the documentation source folder.
# Contains Markdown (.md) files and any documentation structure (TOC, assets, etc.).
# If docs are located directly in the root, set to "" (empty string).
$DocumentationRelativePath = "SystemLibrary.Common.Framework\Docs"

# Final output folder where the generated static website will be copied, deployable to GitHub Pages, IIS wwwroot, etc.
$Output = "C:\Temp\Docs\"

# Display name of the documentation site shown in UI header and in Footer.
$SiteTitle = "System Library Common Framework"

# Relative Hosting Path
$RelativeHostingPath = "" # if local IIS or similar it is $null or "" or "/", if using github pages it should be the name of the repo with prefix and suffix /
                          # its the path to the css and js will be loaded from, from root of your site

# OPTIONAL
$LogoExtension = "png"
$EnableSearch = $true
$DisableGitFeatures = $false

$FooterGithubUrl = "https://github.com/systemlibrary/systemlibrary-common-framework/" # leave blank to opt out
$FooterNugetUrl = "https://www.nuget.org/packages/SystemLibrary.Common.Framework/"    # leave blank to opt out
$FooterWebsiteUrl = "https://www.systemlibrary.com/" # leave blank to opt out
$FooterSiteTitle = "System Library Common Framework" # leave blank to opt out

$Debug = $false # Prints additional information during build
$CleanUp = $true # Removes all files and folders used during build, set to false to debug

# Skip api documentation for classes/namespaces, an array of strings:
# - string contains wildcard => uses contains case sensitive matching
# - string contains a dot => starts with case sensitive matching
# - else uses ends with case sensitive matching
$SkipDocumentationFor = @(
'*.Benchmark*',
'*.Tests*',
'*.ApiTests*',
'DelegateJsonConverter',
'CalleeCancelledRequestException',
'ClientResponse',
'ContentType',
'OutputCachePolicy'
)

# EXECUTE
. ($PSScriptRoot + "\scripts\Powershell\00-docfx.ps1")