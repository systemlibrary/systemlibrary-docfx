. ($PSScriptRoot + "\Powershell\01-functions.ps1")

. ($PSScriptRoot + "\Powershell\02-variables.ps1")

. ($PSScriptRoot + "\Powershell\03-copy-docfx-template.ps1")

. ($PSScriptRoot + "\Powershell\04-validate-settings.ps1")

. ($PSScriptRoot + "\Powershell\05-build.ps1")

. ($PSScriptRoot + "\Powershell\06-clean-output-dir.ps1")

. ($PSScriptRoot + "\Powershell\07-read-html-files.ps1")

. ($PSScriptRoot + "\Powershell\08-create-install-list-item.ps1")

. ($PSScriptRoot + "\Powershell\09-create-index-ordered-list.ps1")

. ($PSScriptRoot + "\Powershell\10-create-index-html.ps1")

. ($PSScriptRoot + "\Powershell\11-swap-variables-in-html.ps1")

. ($PSScriptRoot + "\Powershell\12-move-to-site-directory.ps1")

. ($PSScriptRoot + "\Powershell\13-copy-to-output-directory.ps1")

. ($PSScriptRoot + "\Powershell\14-clean-up.ps1")

Start-Sleep -Milliseconds 5

Out ("Built documentation to directory: " + $outputFolderFullPath)


Write-Host ("Success") -ForegroundColor DarkGreen