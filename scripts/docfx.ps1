if ($LASTEXITCODE -eq 1) { 
    $LASTEXITCODE = 0
}

. ($PSScriptRoot + "\Powershell\01-functions.ps1")

. ($PSScriptRoot + "\Powershell\02-variables.ps1")

. ($PSScriptRoot + "\Powershell\03-copy-docfx-files.ps1")

if ($LASTEXITCODE -eq 1) { 
    . ($PSScriptRoot + "\Powershell\13-clean-up.ps1")
    EXIT
}

. ($PSScriptRoot + "\Powershell\04-validate-settings.ps1")

if ($LASTEXITCODE -eq 1) { 
    . ($PSScriptRoot + "\Powershell\13-clean-up.ps1")
    EXIT
}

. ($PSScriptRoot + "\Powershell\05-build.ps1")

if ($LASTEXITCODE -eq 1) { 
    . ($PSScriptRoot + "\Powershell\13-clean-up.ps1")
    EXIT
}

. ($PSScriptRoot + "\Powershell\06-clean-output-dir.ps1")

. ($PSScriptRoot + "\Powershell\07-read-html-files.ps1")

if ($LASTEXITCODE -eq 1) { 
    . ($PSScriptRoot + "\Powershell\13-clean-up.ps1")
    EXIT
}

. ($PSScriptRoot + "\Powershell\08-create-table-of-contents.ps1")
. ($PSScriptRoot + "\Powershell\09-create-index-html.ps1")
. ($PSScriptRoot + "\Powershell\10-swap-variables-in-html.ps1")
. ($PSScriptRoot + "\Powershell\11-move-to-site-directory.ps1")
. ($PSScriptRoot + "\Powershell\12-copy-to-output-directory.ps1")

. ($PSScriptRoot + "\Powershell\13-clean-up.ps1")

Out ("Documentation is ready at: " + $outputFolderFullPath)

Write-Host ("Success") -ForegroundColor DarkGreen