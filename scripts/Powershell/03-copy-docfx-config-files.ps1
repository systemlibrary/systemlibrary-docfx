try {
    if (Test-Path $templatePathDest) {
        Remove-Item $templatePathDest -Recurse -Force -ErrorAction SilentlyContinue
    }        
    # Copy templated docfx config files
    Copy-Item -Path $docfxJson -Destination $docfxJsonDest -Force
    Copy-Item -Path $filterYml -Destination $filterYmlDest -Force
    Copy-Item -Path $templatePath -Destination $templatePathDest -Force -Recurse

    # Replace consumer variables into the docfx config files
    ReplaceTextInFile $docfxJsonDest "@DocumentationRelativePath" $DocumentationRelativePath
    ReplaceTextInFile $docfxJsonDest "@Title" $Title

    ReplaceTextInFile $docfxJsonDest "@LogoExtension" $LogoExtension.ToString().ToLower()
    ReplaceTextInFile $docfxJsonDest "@EnableSearch" $EnableSearch.ToString().ToLower()
    ReplaceTextInFile $docfxJsonDest "@DisableGitFeatures" $DisableGitFeatures.ToString().ToLower()

    Out ("Docfx config files copied and overwritten variables at: " + $rootPath)
}
catch {
    Err ("Copy-docfx-config-files errored: typo in SourceRootFullPath or DocumentationRelativePath? " + $_)
    EXIT 1
}