$configFullPath = $PSScriptRoot + "/../Config/"

$SourceRootFullPath = $SourceRootFullPath.Replace("\", "/")

if (![System.IO.Path]::IsPathRooted($SourceRootFullPath)) {
    throw "SourceRootFullPath must be an absolute path: $SourceRootFullPath"
}

if (![System.IO.Path]::IsPathRooted($Output)) {
    throw "Output must be an absolute path: $Output"
}

$DocumentationRelativePath = $DocumentationRelativePath.Replace("\", "/")

$rootPath = $SourceRootFullPath

$docfxJson = Join-Path $configFullPath 'docfx.json'
$filterYml = Join-Path $configFullPath 'filter.yml'

$docfxJsonDest = Join-Path $rootPath 'docfx.json'
$filterYmlDest = Join-Path $rootPath 'docfxfilter.yml'

$SitePath = Join-Path $rootPath "__docfxsite"
$logPath = Join-Path $rootPath "__docfxsite.log"
$docsApiPath = Join-Path $rootPath "docsapi"

$templatePath = $PSScriptRoot + "/../Template/"
$templatePathDest = Join-Path $rootPath "docfxtemplate"

if ($Debug -eq $true) {
    Write-Host ("SourceRootFullPath " + $SourceRootFullPath) -ForegroundColor Gray
    Write-Host ("DocFxJson " + $docfxJson) -ForegroundColor Gray
    Write-Host ("DocFxJsonDestination " + $docfxJsonDest) -ForegroundColor Gray
    Write-Host ("Output " + $Output) -ForegroundColor Gray
}
