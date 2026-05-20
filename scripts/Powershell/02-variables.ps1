$configFullPath = $PSScriptRoot + "\..\Config\"

$SourceRootFullPath = $SourceRootFullPath.Replace("\", "/")
$DocumentationRelativePath = $DocumentationRelativePath.Replace("\", "/")

$rootPath = $SourceRootFullPath
$docPath = $DocumentationRelativePath

$docfxJson = Join-Path $configFullPath 'docfx.json'
$filterYml = Join-Path $configFullPath 'filter.yml'

$docfxJsonDest = Join-Path $rootPath 'docfx.json'
$filterYmlDest = Join-Path $rootPath 'docfxfilter.yml'

$SitePath = Join-Path $rootPath "__docfxsite"
$logPath = Join-Path $rootPath "__docfxsite.log"
$docsApiPath = Join-Path $rootPath "docsapi"

$templatePath = $PSScriptRoot + "\..\Template\"
$templatePathDest = Join-Path $rootPath "docfxtemplate"

