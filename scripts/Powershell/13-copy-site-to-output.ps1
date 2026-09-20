# MOVE TO __DOCFXSITE TO OUTPUT
Move-Item -Path (Join-Path $SitePath '*') -Destination $Output -Force 

Start-Sleep -Milliseconds 500

# docsapi files are generated and linked by docfx toc file, cannot be touched
$skipDocsApiFiles = Join-Path $Output "docsapi"


# RENAME FILES AND FOLDERS INSIDE OUTPUT TO "<name>.LOWERCASE"
Get-ChildItem -Path $Output -Recurse |
    Where-Object {
        $_.FullName -notlike "$skipDocsApiFiles\*"
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

# LOWER CASE PATH, PRESERVE $OUTPUT, AND REMOVE SUFFIX ".lowercase"
Get-ChildItem -Path $Output -Recurse |
    Where-Object {
        $_.FullName -notlike "$skipDocsApiFiles\*"
    } |
    Sort-Object FullName -Descending |
    ForEach-Object {
        if ($_.Name.EndsWith(".lowercase", [System.StringComparison]::Ordinal)) {
            $lowerName = $_.Name.Substring(
                0,
                $_.Name.Length - ".lowercase".Length
            ).ToLowerInvariant()

            Rename-Item -Path $_.FullName -NewName $lowerName
        }
    }

Start-Sleep -Milliseconds 500

$outputFilesRemaining = Get-ChildItem -Path $SitePath -Recurse -File

if ($outputFilesRemaining.Count -gt 0) {
    Warn ("Copied site to output, but some files couldn't be copied: " + $outputFilesRemaining.Count)
    Warn ("Output path: " + $Output)
}
else {
    Out ("Copied site to output")
}