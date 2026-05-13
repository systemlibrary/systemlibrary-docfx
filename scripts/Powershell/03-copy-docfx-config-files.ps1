try {
    # Copy templated docfx config files
    Copy-Item -Path $docfxJson -Destination $docfxJsonDest -Force
    Copy-Item -Path $filterYml -Destination $filterYmlDest -Force

    # Replace consumer variables into the docfx config files
    ReplaceTextInFile $docfxJsonDest "@DocumentationRelativePath" $DocumentationRelativePath
    ReplaceTextInFile $docfxJsonDest "@Title" $Title

    ReplaceTextInFile $docfxJsonDest "@EnableSearch" $EnableSearch.ToString().ToLower()
    ReplaceTextInFile $docfxJsonDest "@DisableGitFeatures" $DisableGitFeatures.ToString().ToLower()

    Out ("Docfx config files copied and overwritten variables at: " + $rootPath)
}
catch {
    Warn ("Copying docfx config files and replacing variables failed: " + $rootPath)

    Err "Error occured: typo in SourceRootFullPath or DocumentationRelativePath?"
    EXIT 1
}