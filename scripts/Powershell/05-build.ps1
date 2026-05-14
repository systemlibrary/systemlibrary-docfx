Out ("Docfx running...")

Set-Location $SourceRootFullPath

& docfx 'docfx.json' `
    -l $logPath `
    --logLevel warning `
    --warningsAsErrors false 2>&1 |
    Tee-Object -Variable results |
    ForEach-Object {
        Write-Host $_ -ForegroundColor DarkYellow
    }

if (HasError $results) {
    foreach ($line in $results) {
        if ($line -match "Unable|Failed|Error|assembly") {
            Err $line
        }
    }

    Warn ("Tried building from: " + $docfxJsonFullPath)
    Warn "Tip: Close the powershell editor and try again"
    Warn "Tip: Delete obj/bin/.vs and recompile in Visual Studio and try again"
    Warn "Tip: Got a typo in any of the tmpl.partial files from docfx?"
    Warn "Tip: Getting the 'Last build hasn't loaded model index.md' error? Re-try a few times or delete the obj and bin folders as docfx caches"

    if ($results -match "Could not load file or assembly 'Microsoft.Build.Framework") {
        Err "DocFX requires a different MSBuild version than what is installed. Try install Visual Studio Build Tools or set MSBUILD_EXE_PATH or upgrade/downgrade docfx. For instance: docfx 2.60 requires VS 2017. Docfx 2.76 requires VS 22"
    }
    Err "Error occured, cannot continue"
    EXIT 1
}
else {
    Out ("Build completed")
}
