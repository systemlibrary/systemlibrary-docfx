# MOVE TO __DOCFXSITE TO OUTPUT
Move-Item -Path (Join-Path $SitePath '*') -Destination $Output -Force 

Start-Sleep -Milliseconds 333

$outputFilesRemaining = Get-ChildItem -Path $Output -Recurse -File

if ($outputFilesRemaining.Count -gt 0) {
    Warn ("Copied site to output, but few files couldnt be copied: " + $outputFilesRemaining.Count)
}
else {
    Out ("Copied site to output")
}