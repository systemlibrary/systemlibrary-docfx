Set-Location $PSScriptRoot

# REQUIRED OPTIONS
# Usually the parent folder or same folder as the .sln, or if you document a single csproj, the folder that contains that .csproj
$SourceRootFullPath = "C:\syslib\systemlibrary-common-framework-private\source"

# Relative from the above folder, where do you have the documentation stored, or if it is siblings to the csproj use blank ""
$DocumentationRelativePath = "SystemLibrary.Common.Framework\Docs"

$Output = "C:\Temp\Docs\"

# Main title of the site
$Title = "System Library Common Framework"

# Relative Hosting Path
$RelativeHostingPath = "" # if local IIS or similar it is $null or "" or "/", if using github pages it should be the name of the repo with prefix and suffix /
                          # its the path to the css and js will be loaded from, from root of your site

# OPTIONAL
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
. ($PSScriptRoot + "\scripts\Powershell\00-docfx.ps1")Output