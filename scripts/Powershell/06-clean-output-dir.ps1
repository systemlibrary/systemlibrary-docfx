try {
    if ($outputFolderFullPath -ne $null -and $outputFolderFullPath -ne "") {

        if ($outputFolderFullPath.Length -gt 4) {
            Remove-Item -Recurse -Force $outputFolderFullPath -ErrorAction SilentlyContinue
            Out ("Cleaned output directory: " + $outputFolderFullPath)
        }
        else {
            Err "Cannot clear output dir, it is too short, minimum 4 chars"
        }
    }
}
catch {
    Out "Error cleaning old files in the outfolder, continue"
}
