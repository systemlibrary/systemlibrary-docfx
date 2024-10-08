Set-Location $PSScriptRoot

# REQUIRED OPTIONS
$csprojFileFullPath = "C:\syslib\systemlibrary-common-episerver\source\SystemLibrary.Common.Episerver\SystemLibrary.Common.Episerver.csproj"

$outputFolderFullPath = "C:\syslib\systemlibrary-common-episerver\docs\" # set to $null if you want outputFolder to be within the project folder
#$outputFolderFullPath = "C:\temp\Docs\"

$siteTitle = "System Library Common Episerver"
$footerGithubUrl = "https://github.com/systemlibrary/systemlibrary-common-episerver/"
$footerNugetUrl = "https://www.nuget.org/packages/SystemLibrary.Common.Episerver/"
$footerWebsiteUrl = "https://www.systemlibrary.com/"
$footerSiteTitle = "System Library Common Episerver"

$relativeHostingPath = "/systemlibrary-common-episerver/"
#$relativeHostingPath = "" # If local IIS, most likely $null, "" or "/" is sufficient
# If using 'github pages' it should be the name of the repo with prefix and suffix /
# It is the path of where css/js is loaded from, from the "root" of your IIS site
# Simply checking network tab in chrome while browsing your site will reveal what it should be, as youll get 404/red for css/js requests

# Upgrade docfx.exe? Download latest from nuget package manager in any project, and copy paste the downloaded files
$docfxConsoleExeFullPath = ($PSScriptRoot + "\docfx.console.2.59.4\docfx.exe")


# OPTIONAL OPTIONS
$cleanUp = $true # delete temp files generated during building documentation files

$skipDocumentationFor = @('DocFx',
'SystemLibrary.Common.Episerver.Properties.MessageConfig',
'SystemLibrary.Common.Episerver.Properties.MessageEditorDescriptor',
'SystemLibrary.Common.Episerver.Properties.MessageProperty',
'SystemLibrary.Common.Episerver.Properties.MessageController',
'SystemLibrary.Common.Episerver.Attributes.BoxSelectionController',
'SystemLibrary.Common.Episerver.Attributes.BoxSelectionFactory',
'SystemLibrary.Common.Episerver.Attributes.JsonEditController',
'SystemLibrary.Common.Episerver.Attributes.JsonEditFactory',
'SystemLibrary.Common.Episerver.Descriptors.HideCategoryListDescriptor',
'SystemLibrary.Common.Episerver.Properties.ParentLinkReferenceController',
'SystemLibrary.Common.Episerver.Properties.ParentLinkReferenceEditorDescriptor',
'SystemLibrary.Common.Episerver.Properties.ParentLinkReferenceProperty',
'SystemLibrary.Common.Episerver.Attributes.MultiDropdownSelectionController',
'SystemLibrary.Common.Episerver.Attributes.MultiDropdownSelectionFactory',
'SystemLibrary.Common.Episerver.Initialize.RemoveSuggestedContentTypes',
'SystemLibrary.Common.Episerver.Extensions.CommonEpiserverApplicationServicesOptions',
'SystemLibrary.Common.Episerver.Extensions.CommonEpiserverApplicationBuilderOptions',
'SystemLibrary.Common.Episerver.EditController',
'SystemLibrary.Common.Episerver.Abstract.BaseController',
'SystemLibrary.Common.Episerver.Abstract.BaseMultiSelectionFactory',
'SystemLibrary.Common.Episerver.ConnectionStringsConfig',
'SystemLibrary.Common.Episerver.PropertiesConfig',
'SystemLibrary.Common.Episerver.EditConfig',
'SystemLibrary.Common.Episerver.Properties.MessageConfig',
'SystemLibrary.Common.Episerver.FontAwesome',
'SystemLibrary.Common.Episerver.AppSettings.Configuration',
'SystemLibrary.Common.Episerver.Attributes.ParentLinkReferenceFactory',
'SystemLibrary.Common.Episerver.Abstract.InternalBaseController',
'WebApplicationInitializer'

) # case sensitive

# EXECUTE
. ($PSScriptRoot + "\scripts\docfx.ps1")