try {
    # Copy default docfx files
    Copy-Item -Path $docfxDataDir"docfx.json" -Destination $docfxJson -Force
    Copy-Item -Path $docfxDataDir"toc.yml" -Destination $projectDirectory$projectName"_toc.yml" -Force
    Copy-Item -Path $docfxDataDir"index.md" -Destination $projectDirectory$projectName"_index.md" -Force
    Copy-Item -Path $docfxDataDir"filter.yml" -Destination $projectDirectory$projectName"_filter.yml" -Force

    # Copy our custom template (WHY?)
    # Copy-Item -Path $docfxDataDir"docfx_custom_template" -Destination $projectDirectory -Recurse -Force

    # Replace project and display name inside the TOC generated files from DOCFX
    ReplaceTextInFile $projectDirectory$projectName"_toc.yml" "[%projectName%]" $projectName
    ReplaceTextInFile $projectDirectory$projectName"_toc.yml" "[%projectDisplayName%]" $projectDisplayName

    ReplaceTextInFile $docfxJson "[%projectName%]" $projectName
    ReplaceTextInFile $docfxJson "[%projectDirectory%]" $projectDirectory.replace('\', '/')

    Out (("Docfx template copied to " + $projectDirectory))
}
catch {
    Warn ("Copy to " + $projectDirectory + $projectName + " failed")
    Err "Error occured during copying temp files to your project folder. Do you have a typo in project directory? Some path or file is invalid/does not exist"
    exit
}