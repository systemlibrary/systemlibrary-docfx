$configFullPath = $PSScriptRoot + "/../Config/"

$SourceRootFullPath = $SourceRootFullPath.Replace("\", "/")

$DocumentationRelativePath = $DocumentationRelativePath.Replace("\", "/")

if (![System.IO.Path]::IsPathRooted($SourceRootFullPath)) {
    throw "SourceRootFullPath must be an absolute path: $SourceRootFullPath"
}

if (![System.IO.Path]::IsPathRooted($Output)) {
    throw "Output must be an absolute path: $Output"
}

if (!$IsWindows -and
    ![System.IO.Path]::IsPathRooted($DocumentationRelativePath) -and
    !$DocumentationRelativePath.StartsWith('./')) {

    throw "DocumentationRelativePath must be an absolute path or start with './' on Linux: $DocumentationRelativePath"
}

if ($IsWindows -and $DocumentationRelativePath.StartsWith('./')) {
    throw "DocumentationRelativePath must not start with './' on Windows: $DocumentationRelativePath"
}

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
