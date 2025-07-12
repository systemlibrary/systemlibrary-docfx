Out ("Building...")

Set-Location $projectDirectory

dotnet restore $csprojFileFullPath
#dotnet build $csprojFileFullPath -c Release

Out "Docfx extracting..."

$results = & docfx $docfxJson `
    -o $outputFolderFullPath `
    -l $logFileFullPath `
    --logLevel warning `
    --warningsAsErrors false `
    --template "C:\syslib\systemlibrary-docfx\data\docfx_custom_template" # $docfxTemplateDir # 

if (HasError $results -eq $true) {
    Remove-Item $logFileFullPath -Force -ErrorAction SilentlyContinue
    Warn "Tip: Close the powershell editor and reopen and try again"
    Warn "Tip: Recompile in Visual Studio and try again"
    Warn "Tip: Delete obj/bin/.vs and recompile in Visual Studio and try again"
    Warn "Tip: Got a typo in any of the tmpl.partial files from docfx?"
    Warn "Tip: Getting the 'Last build hasn't loaded model index.md' error? Re-try a few times or delete the obj and bin folders as docfx caches up and bugs eventually... then try again"
    Err "Error occured, cannot continue"
    # TODO: Add cleanup of built files if erroring, except the log file....
    # TODO: Add a clean obj upon building docs - so it doesnt add up, the cache for docfx inside the obj folder of the project...
    . ($PSScriptRoot + "\13-clean-up.ps1")
    EXIT 1
}
else {
    if ($results -is [System.Collections.IEnumerable]) {
        foreach ($res in $results) {
            Write-Host $res -ForegroundColor DarkYellow
        }
    }
    else {
        Write-Host $results -ForegroundColor DarkYellow
    }
    Out ("Built")

    # CREATE THE INDEX.HTML FRONTPAGE FOR ALL DOCS
    Move-Item -Path $projectSiteDirectory$projectName"_index.html" -Destination $projectSiteDirectory$projectName\index.html -Force -ErrorAction SilentlyContinue
}
