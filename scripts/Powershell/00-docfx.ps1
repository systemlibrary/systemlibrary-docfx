if ($LASTEXITCODE -eq 1) { 
    $LASTEXITCODE = 0
}

$Error.Clear()

. ($PSScriptRoot + "\01-functions.ps1")

. ($PSScriptRoot + "\02-variables.ps1")

. ($PSScriptRoot + "\03-copy-docfx-config-files.ps1")

if ($LASTEXITCODE -eq 1) { 
    . ($PSScriptRoot + "\13-clean-up.ps1")
    EXIT
}

. ($PSScriptRoot + "\04-validate-settings.ps1")

if ($LASTEXITCODE -eq 1) { 
    . ($PSScriptRoot + "\13-clean-up.ps1")
    EXIT
}

. ($PSScriptRoot + "\05-build.ps1")

if ($LASTEXITCODE -eq 1) { 
    . ($PSScriptRoot + "\Powershell\13-clean-up.ps1")
    EXIT
}

. ($PSScriptRoot + "\06-read-html-files.ps1")

. ($PSScriptRoot + "\07-clean-output-dir.ps1")

if ($LASTEXITCODE -eq 1) { 
    . ($PSScriptRoot + "\Powershell\13-clean-up.ps1")
    EXIT
}

. ($PSScriptRoot + "\08-populate-toc.ps1")

. ($PSScriptRoot + "\09-populate-footer.ps1")
# . ($PSScriptRoot + "\Powershell\10-swap-variables-in-html.ps1")
# . ($PSScriptRoot + "\Powershell\11-move-to-site-directory.ps1")
# . ($PSScriptRoot + "\Powershell\12-copy-to-output-directory.ps1")

# . ($PSScriptRoot + "\Powershell\13-clean-up.ps1")

Out ("Documentation is ready at: " + $Output)

Write-Host ("Success") -ForegroundColor DarkGreen