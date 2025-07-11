Out ("Building...")

Set-Location $projectDirectory

$results = & docfx $docfxJson `
    -o $outputFolderFullPath `
    -l $logFileFullPath `
    --logLevel warning `
    --template $docfxTemplateDir # "C:\syslib\systemlibrary-docfx\data\docfx_custom_template"

if (HasError $results -eq $true) {
    Remove-Item $logFileFullPath -Force -ErrorAction SilentlyContinue
    Err $logFileFullPath
    Err $results
    Warn "Tip: Close the powershell editor and reopen and try again"
    Warn "Tip: Recompile in Visual Studio and try again"
    Warn "Tip: Delete obj/bin/.vs and recompile in Visual Studio and try again"
    Warn "Tip: Got a typo in any of the tmpl.partial files from docfx?"
    Warn "Tip: Getting the 'Last build hasn't loaded model index.md' error? Re-try a few times or delete the obj and bin folders as docfx caches up and bugs eventually... then try again"
    Err "Error occured, cannot continue"
    # TODO: Add cleanup of built files if erroring, except the log file....
    # TODO: Add a clean obj upon building docs - so it doesnt add up, the cache for docfx inside the obj folder of the project...
    exit
}
else {
    foreach ($res in $results) {
        if ($res.Tostring().Contains("Info:") -eq $false) {
            Write-Host $res -ForegroundColor DarkYellow
        }
    }
}
Out ("Built")

# CREATE THE INDEX.HTML FRONTPAGE FOR ALL DOCS
Move-Item -Path $projectSiteDirectory$projectName"_index.html" -Destination $projectSiteDirectory$projectName\index.html -Force -ErrorAction SilentlyContinue
