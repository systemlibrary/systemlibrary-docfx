# $res = Test-Path -Path $docfxConsoleExeFullPath -PathType Leaf
# if ($res -eq $False) {
#     Warn "Cannot find docfx console exe file, try rebuilding your solution in Visual Studio/Restore nuget packages"
#     Err ("Cannot find the docfx console exe at path: " + $docfxConsoleExeFullPath)
#     exit 1;
# }

if (Get-Command docfx -ErrorAction SilentlyContinue) {
    Out ("Docfx is installed")
}
else {
    Err "Docfx is not installed, please install via: dotnet tool install -g docfx"
}

