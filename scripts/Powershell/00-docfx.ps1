if ($LASTEXITCODE -eq 1) { 
    $LASTEXITCODE = 0
}

$Error.Clear()

. ($PSScriptRoot + "\01-functions.ps1")

. ($PSScriptRoot + "\02-variables.ps1")

. ($PSScriptRoot + "\03-copy-docfx-config-files.ps1")

if ($LASTEXITCODE -eq 1) { 
    if ($Debug -eq $false) {
        . ($PSScriptRoot + "\14-clean-temp-files.ps1")
    }
    EXIT
}

. ($PSScriptRoot + "\04-validate-settings.ps1")

if ($LASTEXITCODE -eq 1) { 
    if ($Debug -eq $false) {
        . ($PSScriptRoot + "\14-clean-temp-files.ps1")
    }
    EXIT
}

. ($PSScriptRoot + "\05-build.ps1")

if ($LASTEXITCODE -eq 1) { 
    if ($Debug -eq $false) {
        . ($PSScriptRoot + "\14-clean-temp-files.ps1")
    }
    EXIT
}

. ($PSScriptRoot + "\06-read-html-files.ps1")

. ($PSScriptRoot + "\07-clean-output-dir.ps1")

if ($LASTEXITCODE -eq 1) { 
    if ($Debug -eq $false) {
        . ($PSScriptRoot + "\14-clean-temp-files.ps1")
    }
    EXIT
}

. ($PSScriptRoot + "\08-populate-toc.ps1")

. ($PSScriptRoot + "\09-populate-footer.ps1")

. ($PSScriptRoot + "\10-clean-namespace-links.ps1")

. ($PSScriptRoot + "\11-clean-member-names.ps1")

. ($PSScriptRoot + "\12-write-content.ps1")

. ($PSScriptRoot + "\13-copy-site-to-output.ps1")

. ($PSScriptRoot + "\14-clean-temp-files.ps1")

Write-Host "Success" -ForegroundColor Green
Write-Host "`tWebsite at: $Output" -ForegroundColor DarkGreen
Write-Host "`tRun with 'docfx serve'" -ForegroundColor DarkGreen