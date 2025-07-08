function Out([string] $msg) {
    Write-Host $msg -ForegroundColor DarkCyan
}
function Warn([string] $msg) {
    Write-Host $msg -ForegroundColor DarkYellow
}
function Err([string] $msg) {
    Write-Host $msg -ForegroundColor Red
}

function GetFiles([string] $folder, [string]$extension = $null) {
    $files = Get-ChildItem $folder -Recurse

    if ($null -eq $extension) {
        return $files | Where-Object { $_.extension -eq $extension }
    }
    return $files
}

# Returns the full path of the folder from a full file path
function GetFolderPath([string] $fullFilePath) {
    return Split-Path -Path $fullFilePath
}

# Returns a file object from a string path
function GetFileName([string] $fileFullPath) {
    if ($fileFullPath -eq $null -or $fileFullPath.Length -le 1) {
        Err "GetFileName was invoked with empty"
        return $null;
    }
    if (-not (Test-Path -LiteralPath $fileFullPath)) { 
        Err ($fileFullPath + " do not exist")
        return $null 
    }
    return (Get-ChildItem $fileFullPath).BaseName
}

# Returns the file without extension, -, . and _
function GetFileDisplayName([string] $fileFullPath) {
    return (Get-ChildItem $fileFullPath).BaseName.replace('.', ' ').replace('-', ' ').replace('_', ' ')
}

function ReplaceTextInFile([string] $fileFullPath, [string] $old, [string] $new) {
    $content = Get-Content  $fileFullPath -Raw -ErrorAction SilentlyContinue

    if ($null -eq $content -or $content -eq "") {
        Start-Sleep -Milliseconds 8
        $content = Get-Content $fileFullPath -ErrorAction SilentlyContinue
        if ($null -eq $content -or $content -eq "") {
            Start-Sleep -Milliseconds 24
            $content = Get-Content $fileFullPath -ErrorAction SilentlyContinue
        }
        if ($null -eq $content -or $content -eq "") {
            Start-Sleep -Milliseconds 48
            $content = Get-Content $fileFullPath -ErrorAction SilentlyContinue
        }
        if ($null -eq $content -or $content -eq "") {
            Write-Host "Checked file Length: $($content.Length)"
            Warn ("Content is null or blank when replacing: " + $old + " with new: " + $new + " in file " + [System.IO.Path]::GetFileName($fileFullPath))
            # No content in file, nothing to replace, continue...
            return
        }
    }
    Start-Sleep -Milliseconds 3
    try {
        $content.Replace($old, $new) | Set-Content $fileFullPath -Force -ErrorAction Stop
    }
    catch {
        Warn ("Trying replacing again in 10ms - as file could not be set, yet...");
        Start-Sleep -Milliseconds 10
        try {
            $content.Replace($old, $new) | Set-Content $fileFullPath -Force  -ErrorAction Stop
        }
        catch {
            Warn ("Trying replacing again in 50ms - last retry...");
            Start-Sleep -Milliseconds 50
            try {
                $content.Replace($old, $new) | Set-Content $fileFullPath -Force
            }
            catch {
                Err ("Error replacing " + $old + " with " + $new + " in file " + $fileFullPath)
            }
        }
    }
    Start-Sleep -Milliseconds 2
}

function HasError($results) {
    if ($null -eq $results) {
        return $false
    }

    if ($results -is [array]) {
        foreach ($result in $results) {
            if ($result.ToString().Contains("Build failed") -or 
                $result.ToString().Contains("[Failure]") -eq $true -or 
                $result.ToString().Contains("Msbuild failed") -eq $true -or 
                $result.ToString().Contains("Method not found") -eq $true -or
                $result.ToString().Contains("Error:")
            ) {
                Err $result
                return $true
            }
        }
    }
    else {
        $res = $results.ToString().Contains("Build failed") 
        -or $results.ToString().Contains("[Failure]") -eq $true 
        -or $results.ToString().Contains("Msbuild failed") -eq $true 
        -or $results.ToString().Contains("Method not found") -eq $true 
        -or $results.ToString().Contains("Error:") -eq $true

        if ($res -eq $true) {
            Err $res
            return $true
        }
    }
    return $false
}

function createListItemHeading($heading) {
    $heading = $heading.Replace("-1", "&lt;T&gt;");
    $heading = $heading.Replace("-2", "&lt;T&gt;");
    return "<h4 class='class heading index-navigation-item'>" + $heading + "</h4>"
}

function createListItemForClass($baseName, $liHref, $cssClass) {
    $cleanName = $baseName.Replace("-1", "&lt;T&gt;");
    $cleanName = $cleanName.Replace("-2", "&lt;T&gt;");

    $title = "class"
    if ($cssClass -ne "") {
        $title = "namespace"
    }
    return "<li class='" + $cssClass + "' title='" + $title + "'><a class='index-navigation-item' href='" + $liHref + "'>" + $cleanName + "</a></li>"
}

function createOrderedList($items) {
    if ($items -eq $null) {
        return "";
    }
    
    $previousDirName = "";
    $tmpOrderedList = "<ol class='navigation-list-item'>" + (
        $items | ForEach-Object {
            # Already a list item string
            if ($_ -is [string] -and $_.StartsWith("<li")) {
                $($_)
            }
            # Is a full relative or absolute path to a file
            else {
                if ($_ -is [string]) {
                    $parent = Split-Path $_ -Parent
                    $dirName = Split-Path $parent -Leaf

                    if ($dirName -ne $previousDirName) {
                        $dirHeading = createListItemHeading $dirName
                        $($dirHeading)
                        $previousDirName = $dirName
                    }

                    $name = [System.IO.Path]::GetFileName($_).Replace(".html", "");

                    $upperCount = ([regex]::Matches($name, '[A-Z]')).Count

                    if ($upperCount -le 4) {
                        $name = ([regex]::Replace($name, '([A-Z])(?=[a-z])', ' $1')).Trim()
                    }
                    
                    $createdLi1 = createListItemForClass $name $_ ""

                    $($createdLi1)
                }   
                else {
                    # A file object
                    $lihref = $relativeHostingPath + $_.Name
                    $cssClass = ""
    
                    if ($namespaceHtmlFiles -contains $_) {
                        $cssClass = "index-navigation-item--namespace"
                    }
    
                    $createdLi = createListItemForClass $_.BaseName $lihref $cssClass
                    $($createdLi)
                }
            }
        }
    ) + "</ol>"

    return $tmpOrderedList
}

# Returns full path of markdown or null
function GetMarkdownFile ([string] $relativeFullFileName) {
    if (-not ($relativeFullFileName -match '^[\\/]')) {
        Err ($relativeFullFileName + " should start with a slash")
        return $null
    }
    
    $fileName = [System.IO.Path]::GetFileName($relativeFullFileName)

    $path = Get-ChildItem -Path $projectDirectory -Recurse -File -Filter $fileName |
    Where-Object {
        $_.FullName -match "$([regex]::Escape($relativeFullFileName))$" -and
        ($_.FullName -replace [regex]::Escape($projectDirectory), '') -split '[\\/]' | Measure-Object | Select-Object -ExpandProperty Count | ForEach-Object { $_ -le 3 }
    } |
    Select-Object -First 1 -ExpandProperty FullName

    if ($path -ne $null -and (Test-Path -Path $path) -eq $true) {
        return $path
    }
    return $null
}

$convertedMdFiles = @()

function ConvertMdToHtml([string] $markdownFile, [string] $relativeFullFileName) {
    if ($convertedMdFiles -contains $markdownFile) {
        return
    }
    $convertedMdFiles += $markdownFile

    $mdContent = Get-Content -Path $markdownFile -Raw

    $mdContent = $mdContent.Replace('`', "!====!");
    $mdContent = $mdContent.Replace("""", "!????!");
    $mdContent = $mdContent.Replace("'", "!@@@@!");

    $scriptsDir = $PSScriptRoot + "\..\..\scripts\";

    $tocHtmlContent = ""

    if ($mdContent.Contains("!!TOC!!")) {

        $markdownDir = [System.IO.Path]::GetDirectoryName($markdownFile)
        $markdownFiles = Get-ChildItem -Path $markdownDir -Recurse -Filter *.md | Select-Object -ExpandProperty FullName
        $markdownHtmlFiles = @()

        foreach ($md in $markdownFiles) {
            if ($convertedMdFiles -contains $md) {
                continue
            }
            
            $relativeMdPath = $md.Substring($markdownDir.Length).TrimStart('\', '/')

            ConvertMdToHtml $md $relativeMdPath
        
            $htmlHref = $relativeMdPath.Replace(".md", ".html")
        
            if ($relativeHostingPath -ne $null -and $relativeHostingPath -ne "") {
                $htmlHref = ($relativeHostingPath + $htmlHref).Replace("\", "/")
            }
            else {
                $htmlHref = ($outputFolderFullPath + $htmlHref).Replace("/", "\")
            }
        
            $markdownHtmlFiles += $htmlHref
        }

        $tocHtmlContent = createOrderedList $markdownHtmlFiles

        $tocHtmlContent = $tocHtmlContent.Replace("\", "\\");
    }

    $htmlContent = Get-Content -Path ($scriptsDir + "Markdown.template.html") -Raw;

    $mdContentEncoded = [System.Net.WebUtility]::HtmlEncode($mdContent)

    $mdContentEncoded = $mdContentEncoded.Replace("!!TOC!!", $tocHtmlContent);

    [string]$htmlMdContent = $htmlContent.Replace("@md-content-encoded", $mdContentEncoded);

    [string]$htmlFile = $relativeFullFileName.Replace(".md", ".html");
  
    $mdToOutputHtmlFilePath = ($outputFolderFullPath + $htmlFile)

    if ($relativeHostingPath -ne $null -and $relativeHostingPath -ne "") {
        $mdToOutputHtmlFilePath = $mdToOutputHtmlFilePath.Replace("\/", "/");
        $mdToOutputHtmlFilePath = $mdToOutputHtmlFilePath.Replace("\", "/");
    }
    else {
        $mdToOutputHtmlFilePath = $mdToOutputHtmlFilePath.Replace("\/", "\");
        $mdToOutputHtmlFilePath = $mdToOutputHtmlFilePath.Replace("/", "\");
    }

    $scriptsRelativeDir = [System.IO.Path]::GetDirectoryName($mdToOutputHtmlFilePath)

    $ignored = New-Item -Path $mdToOutputHtmlFilePath -Value "$htmlMdContent" -Force -ErrorAction SilentlyContinue
    
    #$ignored = Copy-Item -Path ($scriptsDir + "remarkable.js") -Destination  ($scriptsRelativeDir + "/remarkable.js") -Force -Recurse -ErrorAction SilentlyContinue
    #$ignored = Copy-Item -Path ($scriptsDir + "highlight.11.4.0.min.js") -Destination  ($scriptsRelativeDir + "/highlight.11.4.0.min.js") -Force -Recurse -ErrorAction SilentlyContinue
    #$ignored = Copy-Item -Path ($scriptsDir + "highlight.11.4.0.min.css") -Destination  ($scriptsRelativeDir + "/highlight.11.4.0.min.css") -Force -Recurse -ErrorAction SilentlyContinue
    
    $ignored = Copy-Item -Path ($scriptsDir + "remarkable.1.7.4.min.js") -Destination  ($scriptsRelativeDir + "/remarkable.1.7.4.min.js") -Force -Recurse -ErrorAction SilentlyContinue
    $ignored = Copy-Item -Path ($scriptsDir + "highlight.11.11.1.min.js") -Destination  ($scriptsRelativeDir + "/highlight.11.11.1.min.js") -Force -Recurse -ErrorAction SilentlyContinue
    $ignored = Copy-Item -Path ($scriptsDir + "highlight.11.11.1.min.css") -Destination  ($scriptsRelativeDir + "/highlight.11.11.1.min.css") -Force -Recurse -ErrorAction SilentlyContinue
}

function MdToHref([string] $relativeFullFileName) {
    $markdownFile = GetMarkdownFile $relativeFullFileName

    if ($markdownFile -eq $null) {
        Out ($relativeFullFileName + " is not found, skipped...")
        return $null
    }

    ConvertMdToHtml $markdownFile $relativeFullFileName

    $href = $relativeFullFileName.Replace(".md", ".html");

    if ($relativeHostingPath -ne $null -and $relativeHostingPath -ne "") {
        $href = ($relativeHostingPath + $href).Replace("\/", "/");
    }
    else {
        $href = ($outputFolderFullPath + $href).Replace("\/", "\");
    }

    return $href
}

# Returns a <li><a href></a></li> or "" if markdown file do not exist
# It will also take that markdown and convert to HTML and copy the HTML to the output destination
function CreateListItem([string] $relativeFullFileName, [string]$title = "") {
    $global:convertedMdFiles = @()

    [string]$hrefSrc = MdToHref $relativeFullFileName

    if ($hrefSrc -eq $null -or $hrefSrc -eq "") {
        return ""
    }

    [string]$fileName = [System.IO.Path]::GetFileName($relativeFullFileName);

    [string]$name = [System.IO.Path]::GetFileNameWithoutExtension($fileName);

    [string]$cssclass = $name.ToLower();

    $name = $name.Replace("-1", "&lt;T&gt;");
    $name = $name.Replace("-2", "&lt;T&gt;");

    $li = "<li class='$cssclass' title='$title'><a class='index-navigation-item' href='$hrefSrc'>$name</a></li>";

    return $li;
}
