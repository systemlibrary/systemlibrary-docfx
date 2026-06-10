# MOVE TO __DOCFXSITE TO OUTPUT
Move-Item -Path (Join-Path $SitePath '*') -Destination $Output -Force 

Start-Sleep -Milliseconds 333

$outputFilesRemaining = Get-ChildItem -Path $SitePath -Recurse -File

if ($outputFilesRemaining.Count -gt 0) {
    Warn ("Copied site to output, but some files couldn't be copied: " + $outputFilesRemaining.Count)
    Warn ("Output path: " + $Output)
}
else {
    Out ("Copied site to output")
}