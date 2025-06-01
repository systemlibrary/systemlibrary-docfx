function createManualListItem() {
    $manualPath = Get-ChildItem -Path $projectDirectory -Recurse -File -Filter "Manual.md" |
    Where-Object {
        $_.FullName -match "[\\/]Manual[\\/]Manual\.md$" -and
        ($_.FullName -replace [regex]::Escape($projectDirectory), '') -split '[\\/]' | Measure-Object | Select-Object -ExpandProperty Count | ForEach-Object { $_ -le 3 }
    } |
    Select-Object -First 1 -ExpandProperty FullName

    if ((Test-Path -Path $manualPath) -eq $true) {
        Out "Manual.md found"
        $hrefInstall = "/Manual/Manual.html"
        if ($relativeHostingPath -ne $null -and $relativeHostingPath -ne "") {
            if ($relativeHostingPath.EndsWith("/") -eq $true) {
                $hrefInstall = ($relativeHostingPath + "Manual/Manual.html");
            }
            else {
                $hrefInstall = ($relativeHostingPath + "/Manual/Manual.html");
            }
        }

        if ($outputFolderFullPath -ne $null -and $outputFolderFullPath -ne "") { 
            $mdContent = Get-Content -Path $manualPath -Raw

            $mdContent = $mdContent.Replace('`', "!====!");
            $mdContent = $mdContent.Replace("""", "!????!");
            $mdContent = $mdContent.Replace("'", "!@@@@!");

            $mdContentEncoded = [System.Net.WebUtility]::HtmlEncode($mdContent)

            $scriptsDir = $PSScriptRoot + "\..\..\scripts\";
            
            $htmlContent = Get-Content -Path ($scriptsDir + "Markdown.template.html") -Raw;

            [string]$htmlMdContent = $htmlContent.Replace("@md-content-encoded", $mdContentEncoded);

            $ignoreOutput = New-Item -Path ($outputFolderFullPath + "Manual/Manual.html") -Value "$htmlMdContent" -Force -ErrorAction SilentlyContinue

            $ignoreOutput = Copy-Item -Path ($scriptsDir + "remarkable.js") -Destination  ($outputFolderFullPath + "remarkable.js") -Force -Recurse -ErrorAction SilentlyContinue

            $ignoreOutput = Copy-Item -Path ($scriptsDir + "highlight.11.4.0.min.js") -Destination  ($outputFolderFullPath + "highlight.11.4.0.min.js") -Force -Recurse -ErrorAction SilentlyContinue
            $ignoreOutput = Copy-Item -Path ($scriptsDir + "highlight.11.4.0.min.css") -Destination  ($outputFolderFullPath + "highlight.11.4.0.min.css") -Force -Recurse -ErrorAction SilentlyContinue
        }

        return "<li class='manual' title='Manual - docs about details for each module and system within the framework'><a class='index-navigation-item' href='" + $hrefInstall + "'>Manual</a></li>";
    }
    return "";
}

$manualListItem = createManualListItem