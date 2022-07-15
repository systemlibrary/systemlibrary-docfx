function createInstallListItem() {
    $installFileFullPath = $projectDirectory + "Install.md";

    if ((Test-Path -Path $installFileFullPath) -eq $true) {
        $hrefInstall = "/Install.html"
        if ($relativeHostingPath -ne $null -and $relativeHostingPath -ne "") {
            if ($relativeHostingPath.EndsWith("/") -eq $true) {
                $hrefInstall = ($relativeHostingPath + "Install.html");
            }
            else {
                $hrefInstall = ($relativeHostingPath + "/Install.html");
            }
        }

        if ($outputFolderFullPath -ne $null -and $outputFolderFullPath -ne "") { 
            $mdContent = Get-Content -Path $installFileFullPath -Raw

            $mdContent = $mdContent.Replace('`', "!====!");
            $mdContent = $mdContent.Replace("""", "!????!");
            $mdContent = $mdContent.Replace("'", "!@@@@!");

            $mdContentEncoded = [System.Net.WebUtility]::HtmlEncode($mdContent)

            $scriptsDir = $PSScriptRoot + "\..\..\scripts\";
            
            $htmlContent = Get-Content -Path ($scriptsDir + "Install.template.html") -Raw;

            [string]$htmlMdContent = $htmlContent.Replace("@md-content-encoded", $mdContentEncoded);

            $ignoreOutput = New-Item -Path ($outputFolderFullPath + "Install.html") -Value "$htmlMdContent" -Force -ErrorAction SilentlyContinue

            $ignoreOutput = Copy-Item -Path ($scriptsDir + "remarkable.js") -Destination  ($outputFolderFullPath + "remarkable.js") -Force -Recurse -ErrorAction SilentlyContinue

            $ignoreOutput = Copy-Item -Path ($scriptsDir + "highlight.11.4.0.min.js") -Destination  ($outputFolderFullPath + "highlight.11.4.0.min.js") -Force -Recurse -ErrorAction SilentlyContinue
            $ignoreOutput = Copy-Item -Path ($scriptsDir + "highlight.11.4.0.min.css") -Destination  ($outputFolderFullPath + "highlight.11.4.0.min.css") -Force -Recurse -ErrorAction SilentlyContinue
        }

        return "<li class='install' title='Install'><a class='index-navigation-item' href='" + $hrefInstall + "'>Install Documentation</a></li>";
    }
    return "";
}

$installListItem = createInstallListItem
