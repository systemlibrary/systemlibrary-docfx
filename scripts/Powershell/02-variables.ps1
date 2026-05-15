$configFullPath = $PSScriptRoot + "\..\Config\"

$SourceRootFullPath = $SourceRootFullPath.Replace("\", "/")
$DocumentationRelativePath = $DocumentationRelativePath.Replace("\", "/")
$SitePath = Join-Path $SourceRootFullPath "__docfxsite"
$logPath = Join-Path $SourceRootFullPath "__docfxsite.log"

$rootPath = $SourceRootFullPath
$docPath = $DocumentationRelativePath

$docfxJson = Join-Path $configFullPath 'docfx.json'
$filterYml = Join-Path $configFullPath 'filter.yml'

$docfxJsonDest = Join-Path $rootPath 'docfx.json'
$filterYmlDest = Join-Path $rootPath 'docfxfilter.yml'

Out $docfxJsonDest
