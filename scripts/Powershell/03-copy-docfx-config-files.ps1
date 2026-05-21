try {
    # Clear previous build if existing
    if (Test-Path $templatePathDest) {
        Remove-Item $templatePathDest -Recurse -Force -ErrorAction SilentlyContinue
    }

    if (Test-Path $docsApiPath) {
        Remove-Item $docsApiPath -Recurse -Force -ErrorAction SilentlyContinue
    }

    if (Test-Path $logPath) {
        Remove-Item $logPath -Recurse -Force -ErrorAction SilentlyContinue
    }

    if (Test-Path $SitePath) {
        Remove-Item $SitePath -Recurse -Force -ErrorAction SilentlyContinue
    }

    if (Test-Path $docfxJsonDest) {
        Remove-Item $docfxJsonDest -Recurse -Force -ErrorAction SilentlyContinue
    }

    # Copy templated docfx config files
    Copy-Item -Path $docfxJson -Destination $docfxJsonDest -Force
    Copy-Item -Path $filterYml -Destination $filterYmlDest -Force
    Copy-Item -Path $templatePath -Destination $templatePathDest -Force -Recurse

    # Replace consumer variables into the docfx config files
    ReplaceTextInFile $docfxJsonDest "@DocumentationRelativePath" $DocumentationRelativePath
    ReplaceTextInFile $docfxJsonDest "@SiteTitle" $SiteTitle

    ReplaceTextInFile $docfxJsonDest "@LogoExtension" $LogoExtension.ToString().ToLower()
    ReplaceTextInFile $docfxJsonDest "@EnableSearch" $EnableSearch.ToString().ToLower()
    ReplaceTextInFile $docfxJsonDest "@DisableGitFeatures" $DisableGitFeatures.ToString().ToLower()
    ReplaceTextInFile $docfxJsonDest "@SummaryAsToggle" $SummaryAsToggle.ToString().ToLower()

    Out ("Docfx config files copied and overwritten variables at: " + $rootPath)
}
catch {
    Err ("Copy-docfx-config-files errored: typo in SourceRootFullPath or DocumentationRelativePath? " + $_)
    EXIT 1
}