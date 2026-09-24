# MOVE TO __DOCFXSITE TO OUTPUT
Move-Item -Path (Join-Path $SitePath '*') -Destination $Output -Force 

Start-Sleep -Milliseconds 1000

# LINUX REQUIRES CASE-SENSITIVE PATHS
$skipDocsApiFiles = Join-Path $Output "/apidocs"
$skipPublicFiles = Join-Path $Output "/public"

# RENAME FILES AND FOLDERS THAT ARE OUTSIDE THE DEFAULT DOCFX OUTPUT, TO "<name>.LOWERCASE"
if ($IsLinux) {
    $upperCaseItems = Get-ChildItem -Path $Output -Recurse |
    Where-Object {
        !$_.FullName.StartsWith($skipDocsApiFiles, [System.StringComparison]::OrdinalIgnoreCase) -and
        !$_.FullName.StartsWith($skipPublicFiles, [System.StringComparison]::OrdinalIgnoreCase) -and
        $_.Name -cne $_.Name.ToLowerInvariant()
    }

    if ($upperCaseItems.Count -gt 0) {

        Warn "Linux requires all documentation paths to be lowercase:"
        
        $upperCaseItems |
        ForEach-Object {
            Warn $_.FullName
        }

        throw "Upper-case file or directory names detected in documentation output."
    }
}

$outputFilesRemaining = Get-ChildItem -Path $SitePath -Recurse -File

if ($outputFilesRemaining.Count -gt 0) {
    Warn ("Copied site to output, but some files couldn't be copied: " + $outputFilesRemaining.Count)
    Warn ("Output path: " + $Output)
}
else {
    Out ("Copied site to output")
}

New-Item -ItemType File -Path (Join-Path $Output ".nojekyll") -Force
Out (".nojekyll file generated")