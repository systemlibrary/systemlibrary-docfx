$configFullPath = $PSScriptRoot + "\..\Config\"

$rootPath = $SourceRootFullPath
$docPath = $DocumentationRelativePath

$docfxJsonFullPath = Join-Path $configFullPath 'docfx.json'
$filterYml = Join-Path $configFullPath 'filter.yml'

$docfxJsonDest = Join-Path $rootPath 'docfx.json'
$filterYmlDest = Join-Path $rootPath 'docfxfilter.yml'
