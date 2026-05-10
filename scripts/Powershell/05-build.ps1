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

    foreach ($line in $results) {
        if ($line -match "Unable|Failed|Error|assembly") {
            Err $line
        }
    }

    Warn ("Tried exctracting from " + $docfxJson)
    Warn "Tip: Close the powershell editor and reopen and try again"
    Warn "Tip: Recompile in Visual Studio and try again"
    Warn "Tip: Delete obj/bin/.vs and recompile in Visual Studio and try again"
    Warn "Tip: Got a typo in any of the tmpl.partial files from docfx?"
    Warn "Tip: Getting the 'Last build hasn't loaded model index.md' error? Re-try a few times or delete the obj and bin folders as docfx caches up and bugs eventually... then try again"

    if ($results -match "Could not load file or assembly 'Microsoft.Build.Framework") {
        Err "DocFX requires a different MSBuild version than what is installed. Try install Visual Studio Build Tools or set MSBUILD_EXE_PATH or upgrade/downgrade docfx. For instance: docfx 2.60 requires VS 2017. Docfx 2.76 requires VS 22"
    }

    Err "Error occured, cannot continue"
    # TODO: Add cleanup of built files if erroring, except the log file....
    # TODO: Add a clean obj upon building docs - so it doesnt add up, the cache for docfx inside the obj folder of the project...
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
