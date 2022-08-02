try {
    if ($outputFolderFullPath -ne $null -and $outputFolderFullPath -ne "") {
        Remove-Item -Recurse -Force $outputFolderFullPath -ErrorAction SilentlyContinue
        Out ("Cleaned output directory: " + $outputFolderFullPath)
    }
}
catch {
    Out "Error cleaning old files in the outfolder, continue"
}
