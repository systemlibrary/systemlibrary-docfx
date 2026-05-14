try {

    if ([string]::IsNullOrWhiteSpace($Output)) {
        throw "Output path is empty"
    }

    if ($Output.Length -lt 6) {
        throw "Output path is too short, must be 6 chars or more"
    }

    $resolved = [System.IO.Path]::GetFullPath($Output)

    # Block dangerous system locations
    $blocked = @(
        "C:\Windows",
        "C:\Program Files",
        "D:\Windows",
        "/usr",
        "/etc"
    )

    foreach ($b in $blocked) {
        if ($resolved.StartsWith($b, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to delete system directory: $resolved"
        }
    }

    if (Test-Path $resolved) {
        Remove-Item -Recurse -Force $resolved -ErrorAction Stop
        Out "Cleaned $resolved"
    }
    else {
        Out "Output folder does not exist, continue..."
    }

}
catch {
    Err "Error cleaning output folder: $($_.Exception.Message)"
    Out "Skipping cleanup, continuing build..."
}