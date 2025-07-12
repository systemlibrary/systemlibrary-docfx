if (Get-Command docfx -ErrorAction SilentlyContinue) {
    Out ("Docfx is installed")
}
else {
    Err "Docfx is not installed, please install via: dotnet tool install -g docfx"
    . ($PSScriptRoot + "\13-clean-up.ps1")
    EXIT 1
}

