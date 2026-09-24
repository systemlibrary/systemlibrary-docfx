# MOVE TO __DOCFXSITE TO OUTPUT
Move-Item -Path (Join-Path $SitePath '*') -Destination $Output -Force 

Start-Sleep -Milliseconds 500

# docsapi and public files are generated and linked by docfx toc file, cannot be touched
$skipDocsApiFiles = Join-Path $Output "/docsapi"
$skipPublicFiles = Join-Path $Output "/public"

# RENAME FILES AND FOLDERS THAT ARE OUTSIDE THE DEFAULT DOCFX OUTPUT, TO "<name>.LOWERCASE"
Get-ChildItem -Path $Output -Recurse |
Where-Object {
    !$_.FullName.StartsWith($skipDocsApiFiles, [System.StringComparison]::OrdinalIgnoreCase) -and
    !$_.FullName.StartsWith($skipPublicFiles, [System.StringComparison]::OrdinalIgnoreCase)
} |
Sort-Object FullName -Descending |
ForEach-Object {
    $lowerName = $_.Name.ToLowerInvariant()

    if ($_.Name -cne $lowerName) {
        $temporaryName = $_.Name + ".lowercase"

        Rename-Item -Path $_.FullName -NewName $temporaryName
    }
}

Start-Sleep -Milliseconds 500

# LOWER CASE PATH - FOLDERS FIRST
Get-ChildItem -Path $Output -Recurse -Directory |
Sort-Object FullName -Descending |
ForEach-Object {
    if ($_.Name.EndsWith(".lowercase", [System.StringComparison]::Ordinal)) {

        $lowerName = $_.Name.Substring(
            0,
            $_.Name.Length - ".lowercase".Length
        ).ToLowerInvariant()

        try {
            Rename-Item -Path $_.FullName -NewName $lowerName
        }
        catch {
            Warn ($_.FullName + " to " + $lowerName + " could not rename directory, continue...")
        }
        Start-Sleep -Milliseconds 33
    }
}

Start-Sleep -Milliseconds 1000

# LOWER CASE PATH - FILES SECOND
Get-ChildItem -Path $Output -Recurse -File |
Sort-Object FullName -Descending |
ForEach-Object {
    if ($_.Name.EndsWith(".lowercase", [System.StringComparison]::Ordinal)) {

        $lowerName = $_.Name.Substring(
            0,
            $_.Name.Length - ".lowercase".Length
        ).ToLowerInvariant()

        try {
            Rename-Item -Path $_.FullName -NewName $lowerName
        }
        catch {
            Warn ($_.FullName + " to " + $lowerName + " could not rename file, continue...")
        }
    }
}

Start-Sleep -Milliseconds 500

# RENAME 'DocsApi/Index.html' and any case variation to always lower cased for Linux (github pages)
$docsapiIndexFile = Join-Path $Output "/DocsApi/Index.html"
if (Test-Path $docsapiIndexFile) {
    $lowerName = "index.html"

    if ((Get-Item $docsapiIndexFile).Name -cne $lowerName) {
        Rename-Item -Path $docsapiIndexFile -NewName "Index.html.lowercase"

        Start-Sleep -Milliseconds 50

        $docsapiIndexFile = Join-Path $Output "/DocsApi/Index.html.lowercase"

        # Linux requires us to specify the docsapi as lower, on windows theres no issue as that folder already is lowercased and we just lowercase t he "Index.html" actually
        $docsApiDest = Join-Path $Output "/docsapi"

        Rename-Item -Path $docsApiDest -NewName "index.html"

        Start-Sleep -Milliseconds 50

        $docsapiDir = Join-Path $Output "/DocsApi"

        $docsapiDirFiles = Get-ChildItem -Path $docsapiDir -Recurse -File
 
        if ($docsapiDirFiles.Count -eq 0) {
            # Linux, the 'DocsApi' folder is empty and shall be deleted
            Remove-Item $docsapiDir
        }
    }
}


New-Item -ItemType File -Path (Join-Path $Output ".nojekyll") -Force

Start-Sleep -Milliseconds 500

$outputFilesRemaining = Get-ChildItem -Path $SitePath -Recurse -File

if ($outputFilesRemaining.Count -gt 0) {
    Warn ("Copied site to output, but some files couldn't be copied: " + $outputFilesRemaining.Count)
    Warn ("Output path: " + $Output)
}
else {
    Out ("Copied site to output")
}