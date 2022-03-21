$docfxDataDir = $PSScriptRoot + "\..\data\"

$projectName = GetFileName $csprojFileFullPath
$projectDirectory = (GetFolderPath $csprojFileFullPath) + "\"
$projectDocDirectory = $projectDirectory + $projectName + "\"
$projectSiteDirectory = $projectDirectory + $projectName + "_site\"
$projectDisplayName = GetFileDisplayName $csprojFileFullPath

$logFileFullPath = ($projectDirectory + $projectName + "-log.txt")

$docfxJson = ($projectDirectory + $projectName + "_docfx.json")

$ignoreClass = New-Object System.Collections.ArrayList

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
    Warn ("Copy to " + $projectDirectory + $projectName + " failed")
    Err "Error occured during copying temp files to your project folder. Do you have a typo in project directory? Some path or file is invalid/does not exist"
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

# CLEAN OUTPUT FOLDER
try {
    if ($outputFolderFullPath -ne $null -and $outputFolderFullPath -ne "") {
        Remove-Item -Recurse -Force $outputFolderFullPath -ErrorAction SilentlyContinue
    }
    Out "Cleaned up output dir..."
}
catch {
    Out "Error cleaning old files in the outfolder, continue..."
}

# ADJUST OUTPUT FILES
Move-Item -Path $projectSiteDirectory$projectName"_index.html" -Destination $projectSiteDirectory$projectName\index.html -Force
Out "Copied index.html to the docs folder"
# CREATE INDEX NAVIGATION LIST
$documentationFiles = GetFiles $projectSiteDirectory\$projectName

$documentationFiles = $documentationFiles | Where-Object { $_.Name -ne "toc.html" -and $_.Name -ne "index.html" }

$documentationFiles = $documentationFiles | Sort-Object Basename

$namespaces = New-Object Collections.Generic.List[String]

for ($i = 0; $i -le $documentationFiles.Length - 1; $i++) {
    $baseName = $documentationFiles[$i].BaseName

    if ($null -ne $baseName -and $baseName.EndsWith("-1") -eq $false) {
        $next = $documentationFiles[$i + 1].BaseName
        if ($null -ne $next -and $next.StartsWith($baseName) -and $next.Contains("-1") -eq $false) {
            $namespaces.Add($baseName);
            $i = $i + 1
        }
    }
}

$names = New-Object Collections.Generic.List[String]

for ($i = 0; $i -le $namespaces.Count - 1; $i++) {
    $ns = $namespaces[$i]
    $names.Add($ns)
    for ($j = 0; $j -le $documentationFiles.Length - 1; $j++) {
        $file = $documentationFiles[$j].BaseName;
        if ($null -ne $file -and $file.StartsWith($ns)) {
            $class = $file.Substring($ns.Length)
            if ($class -eq "") {
                # Skipping the current namespace - its already added
            }
            else {
                # Must contain 1 .
                if ($class.Contains(".")) {
                    $subns = $class.Substring(1)
                    # It still contains a ., then class lives in a sub-namespace
                    if ($subns.Contains(".") -eq $false) {
                        # not already added, just to be safe
                        if ($names.Contains($file) -eq $false) {
                            # it's not a sub-namespace...
                            if ($namespaces.Contains($file) -eq $false) {
                                $names.Add($file)
                            }
                        }
                    }
                }
            }
        }
    }
}

function getCssClass($ns, $baseName) {
    $cssClass = "";
    foreach ($n in $ns) {
        if ($n -eq $baseName) {
            $cssClass = " index-navigation-item--namespace"
            break
        }
    }

    return $cssClass
}

function getSetupNavigationListItem() {
    $installFileFullPath = $projectDirectory + "Install.md";

    if ((Test-Path -Path $installFileFullPath) -eq $true) {
        $hrefInstall = ($relativeHostingPath + "\Install.html");

        if ($outputFolderFullPath -ne $null -and $outputFolderFullPath -ne "") { 
            $mdContent = Get-Content -Path $installFileFullPath -Raw

            $mdContent = $mdContent.Replace('`', "!====!");
            $mdContent = $mdContent.Replace("""", "!????!");
            $mdContent = $mdContent.Replace("'", "!@@@@!");

            $mdContentEncoded = [System.Net.WebUtility]::HtmlEncode($mdContent)

            $scriptsDir = $PSScriptRoot + "\..\scripts\";
            
            $htmlContent = Get-Content -Path ($scriptsDir + "Install.template.html") -Raw;

            [string]$htmlMdContent = $htmlContent.Replace("@md-content-encoded", $mdContentEncoded);

            $res1 = New-Item -Path ($outputFolderFullPath + "Install.html") -Value "$htmlMdContent" -Force -ErrorAction SilentlyContinue

            # $res2 = Copy-Item -Path ($scriptsDir + "2.0.0.showdown.min.js") -Destination ($outputFolderFullPath + "2.0.0.showdown.min.js") -Force -Recurse -ErrorAction SilentlyContinue
            $res3 = Copy-Item -Path ($scriptsDir + "remarkable.js") -Destination  ($outputFolderFullPath + "remarkable.js") -Force -Recurse -ErrorAction SilentlyContinue

            $res3 = Copy-Item -Path ($scriptsDir + "highlight.11.4.0.min.js") -Destination  ($outputFolderFullPath + "highlight.11.4.0.min.js") -Force -Recurse -ErrorAction SilentlyContinue
            $res3 = Copy-Item -Path ($scriptsDir + "highlight.11.4.0.min.css") -Destination  ($outputFolderFullPath + "highlight.11.4.0.min.css") -Force -Recurse -ErrorAction SilentlyContinue
        }

        return "<li class='install' title='Install'><a class='index-navigation-item' href='" + $hrefInstall + "'>Install Documentation</a></li>";
    }
    return "";
}

function getNavigationListItem($namespaces, $baseName, $href) {
    $cssClass = getCssClass $namespaces $baseName

    $title = "class"

    if ($cssClass -ne "") {
        $title = "namespace"
    }
    return "<li class='" + $cssClass + "' title='" + $title + "'><a class='index-navigation-item' href='" + $href + "'>" + $baseName + "</a></li>"
}

function getName($class, $list) {
    for ($j = 0; $j -le $documentationFiles.Length - 1; $j++) {
        if ($documentationFiles[$j].BaseName -eq $class) {
            return $documentationFiles[$j].Name
        }
    }
    return ""
}

function addClassName($ignoreClassesContaining, $className) {
    if ($ignoreClassesContaining -ne $null -and $ignoreClassesContaining.Count -gt 0) {
        foreach ($c in $ignoreClassesContaining) {
            if ($className.Contains($c)) {
                $ignoreClass.Add($className)
                return $true
            }
        }
    }
    return $false
}

$htmlDocumentationList = "<ol>" + (getSetupNavigationListItem) + (
    $names | ForEach-Object {
        $baseName = ($_)
        $name = getName $baseName $documentationFiles
        $href = ($relativeHostingPath + $name)

        $className = $baseName.split(".")[-1]

        $ignore = addClassName $ignoreClassesContaining $className

        if ($ignore -eq $true) {
            Out ("Ignoring: " + $className)
        }
        else {
            $li = getNavigationListItem $namespaces $baseName $href
            $($li)
        }
    } 
) + "</ol>"

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
Out "Moved all files to site directory"

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

if ($ignoreClass -ne $null -and $ignoreClass.Count -gt 0) {
    $tocFullPath = ($outputFolderFullPath + "toc.html")

    foreach ($c in $ignoreClass) {
        if ($c -ne $null -and $c -ne "") {
            $fullRemovalPath = ($outputFolderFullPath + "*" + $c + "*")
            Remove-Item $fullRemovalPath -Force -ErrorAction SilentlyContinue

            $old =("title=""" + $c + """")
            $new = ($old + " class=""docfxhide-attribute""")
            
            ReplaceTextInFile $tocFullPath $old $new
        }
    }
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