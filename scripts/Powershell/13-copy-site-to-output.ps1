# MOVE TO __DOCFXSITE TO OUTPUT
Move-Item -Path (Join-Path $SitePath '*') -Destination $Output -Force 

Start-Sleep -Milliseconds 3000

# docsapi files are generated and linked by docfx toc file, cannot be touched
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

Start-Sleep -Milliseconds 3000

# RENAME 'docsapi/index.html' and any case variation to always lower cased for Linux (github pages)
$docsapiIndexFile = Join-Path $Output "/docsapi/Index.html"
if (Test-Path $docsapiIndexFile) {
    $lowerName = "index.html"

    if ((Get-Item $docsapiIndexFile).Name -cne $lowerName) {
        $temporaryName = "Index.html.lowercase"
        Rename-Item -Path $docsapiIndexFile -NewName $temporaryName
    }
}

Start-Sleep -Milliseconds 1000

$docsapiIndexFile = Join-Path $Output "/DocsApi/Index.html"
if (Test-Path $docsapiIndexFile) {
    $lowerName = "index.html"

    if ((Get-Item $docsapiIndexFile).Name -cne $lowerName) {
        $temporaryName = "Index.html.lowercase"
        Rename-Item -Path $docsapiIndexFile -NewName $temporaryName
    }
}

Start-Sleep -Milliseconds 1000

$docsapiDir = Join-Path $Output "/DocsApi"
if (Test-Path $docsapiDir) {
    $lowerName = "docsapi"

    if ((Get-Item $docsapiDir).Name -cne $lowerName) {
        $temporaryName = "docsapi.lowercase"

        Rename-Item -Path $docsapiDir -NewName $temporaryName
    }
}

Start-Sleep -Milliseconds 2000

# LOWER CASE PATH, PRESERVE $OUTPUT, AND REMOVE SUFFIX ".lowercase"
Get-ChildItem -Path $Output -Recurse |
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
            Warn ($_.FullName + " could not be renamed, continue...")
        }
    }
}

New-Item -ItemType File -Path (Join-Path $Output ".nojekyll") -Force

Start-Sleep -Milliseconds 1000

$outputFilesRemaining = Get-ChildItem -Path $SitePath -Recurse -File

if ($outputFilesRemaining.Count -gt 0) {
    Warn ("Copied site to output, but some files couldn't be copied: " + $outputFilesRemaining.Count)
    Warn ("Output path: " + $Output)
}
else {
    Out ("Copied site to output")
}