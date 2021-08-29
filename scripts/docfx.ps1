$docfxDataDir = $PSScriptRoot + "\..\data\"

$projectName = GetFileName $csprojFileFullPath
$projectDirectory = (GetFolderPath $csprojFileFullPath) + "\"
$projectDocDirectory = $projectDirectory + $projectName + "\"
$projectSiteDirectory = $projectDirectory + $projectName + "_site\"
$projectDisplayName = GetFileDisplayName $csprojFileFullPath

$logFileFullPath = ($projectDirectory + $projectName + "-log.txt")

$docfxJson = ($projectDirectory + $projectName + "_docfx.json")
Out "Initialized"

try {
    Copy-Item -Path $docfxDataDir"docfx.json" -Destination $docfxJson -Force
    Copy-Item -Path $docfxDataDir"toc.yml" -Destination $projectDirectory$projectName"_toc.yml" -Force
    Copy-Item -Path $docfxDataDir"index.md" -Destination $projectDirectory$projectName"_index.md" -Force
    Copy-Item -Path $docfxDataDir"filter.yml" -Destination $projectDirectory$projectName"_filter.yml" -Force

    Copy-Item -Path $docfxDataDir"docfx_custom_template" -Destination $projectDirectory -Recurse -Force

    ReplaceTextInFile $projectDirectory$projectName"_toc.yml" "[%projectName%]" $projectName
    ReplaceTextInFile $projectDirectory$projectName"_toc.yml" "[%projectDisplayName%]" $projectDisplayName

    ReplaceTextInFile $docfxJson "[%projectName%]" $projectName
    ReplaceTextInFile $docfxJson "[%projectDirectory%]" $projectDirectory.replace('\', '/')
}
catch {
    Warn ("Copy to " + $destinationDir + " from " + $currentDir + " failed")
    Err "Error occured during copying temp files to your project. Please make sure they do not exist: docfx.json, toc.yml, _docfx_filter.yml, and index.md"
    exit
}

# EXECUTE
Out "Executing..."
Set-Location $projectDirectory
$results = & $docfxConsoleExeFullPath @($docfxJson, "-o " + $outputFolderFullPath, "-l " + $logFileFullPath + " --loglevel ""Warning""")

if (HasError $results -eq $true) {
    Remove-Item $logFileFullPath -Force -ErrorAction SilentlyContinue
    Warn "Tip: Close the powershell editor and reopen and try again"
    Warn "Tip: Recompile in Visual Studio and try again"
    Warn "Tip: Delete obj/bin/.vs and recompile in Visual Studio and try again"
    Warn "Tip: Getting the 'Last build hasn't loaded  model index.md' error? Re-try a few times or delete the obj and bin folders as docfx caches up and bugs evnetually... then try again"
    Err "Error occured, cannot continue"
    # TODO: Add cleanup of built files if erroring, except the log file....
    exit
    # TODO: Add a clean obj upon building docs - so it doesnt add up, the cache for docfx inside the obj folder of the project...
}
else {
    foreach ($res in $results) {
        if ($res.Tostring().Contains("Info:") -eq $false) {
            Write-Host $res
        }
    }
}

# ADJUST OUTPUT FILES
Move-Item -Path $projectSiteDirectory$projectName"_index.html" -Destination $projectSiteDirectory$projectName\index.html -Force
Out ("ADJUST: " + $projectSiteDirectory + $projectName)
Out "Copied index.html to the docs folder"

# CREATE INDEX NAVIGATION LIST
$documentationFiles = GetFiles $projectSiteDirectory\$projectName

$documentationFiles = $documentationFiles | Where-Object { $_.Name -ne "toc.html" -and $_.Name -ne "index.html" }

$documentationFiles = $documentationFiles | Sort-Object Basename

if ($null -eq $relativeHostingPath) {
    $htmlDocumentationList = "<ol>" + ($documentationFiles | % { $("<li><a class='index-navigation-item' href='/" + $($_.Name) + "'>" + $($_.Basename) + "</a></li>") }) + "</ol>"
}
else {
    $htmlDocumentationList = "<ol>" + ($documentationFiles | % { $("<li><a class='index-navigation-item' href='" + $relativeHostingPath + $($_.Name) + "'>" + $($_.Basename) + "</a></li>") }) + "</ol>"
}

$projectIndexHtml = ($projectSiteDirectory + "\" + $projectName + "\index.html")

ReplaceTextInFile $projectIndexHtml "[%navigation%]" $htmlDocumentationList
ReplaceTextInFile $projectIndexHtml "[%projectDisplayName%]" $projectDisplayName
ReplaceTextInFile $projectIndexHtml "[%relativeHostingPath%]" $relativeHostingPath
ReplaceTextInFile $projectIndexHtml "[%siteTitle%]" $siteTitle
ReplaceTextInFile $projectIndexHtml "[%footerGithubUrl%]" $footerGithubUrl
ReplaceTextInFile $projectIndexHtml "[%footerNugetUrl%]" $footerNugetUrl
ReplaceTextInFile $projectIndexHtml "[%footerWebsiteUrl%]" $footerWebsiteUrl
ReplaceTextInFile $projectIndexHtml "[%footerSiteTitle%]" $footerSiteTitle
Out "Added navigation list to index.html"

if ($null -eq $relativeHostingPath) {
    $relativeHostingPath = ""
}

foreach ($htmlFile in $documentationFiles) {
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%relativeHostingPath%]" $relativeHostingPath
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%siteTitle%]" $siteTitle
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerGithubUrl%]" $footerGithubUrl
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerNugetUrl%]" $footerNugetUrl
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerWebsiteUrl%]" $footerWebsiteUrl
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerSiteTitle%]" $footerSiteTitle
}
Start-Sleep -Milliseconds 25
Out "Replaced all relative hosting paths in all html files"

# MOVE TO PROJECT SITE ROOT
Move-Item -Path $projectSiteDirectory$projectName\* -Destination $projectSiteDirectory -Force
Remove-Item -Recurse -Force $projectSiteDirectory$projectName -ErrorAction SilentlyContinue
Out "Moved all files to root site"

# COPY TO OUTPUT FOLDER
try {
    if ($outputFolderFullPath -ne $null -and $outputFolderFullPath -ne "") {
        Start-Sleep -Milliseconds 25

        $outputFiles = GetFiles $projectSiteDirectory

        Copy-Item -Path $projectSiteDirectory\* -Destination $outputFolderFullPath -Force -Recurse -ErrorAction SilentlyContinue

        Start-Sleep -Milliseconds 25
    }
}
catch {
    Err "Error occured reading and moving all site files to outputfolder - Try again? Delete the folder " + $outputFolderFullPath + ", then try again?"
    exit
}

# CLEANUP
if ($cleanUp -eq $true) {
    Remove-Item -Recurse -Force $projectSiteDirectory -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force $projectDocDirectory -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force $projectDirectory\"docfx_custom_template" -ErrorAction SilentlyContinue
    Remove-Item $docFxJson -Force -ErrorAction SilentlyContinue
    Remove-Item $projectDirectory$projectName"_toc.yml" -Force -ErrorAction SilentlyContinue
    Remove-Item -Force $projectDirectory$projectName"_index.md" -ErrorAction SilentlyContinue
    Remove-Item -Force $projectDirectory$projectName"_filter.yml" -ErrorAction SilentlyContinue
    Write-Host "Cleaned" -ForegroundColor DarkCyan
}
else {
    Write-Host "Clean: skipped" -ForegroundColor DarkCyan
}

Start-Sleep -Milliseconds 25
Write-Host ("Success: " + $outputFolderFullPath) -ForegroundColor DarkGreen