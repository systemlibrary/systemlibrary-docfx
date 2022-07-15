
if ($null -eq $relativeHostingPath) {
    $relativeHostingPath = ""
}

foreach ($htmlFile in $htmlFiles) {
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%relativeHostingPath%]" $relativeHostingPath
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%siteTitle%]" $siteTitle
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerGithubUrl%]" $footerGithubUrl
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerNugetUrl%]" $footerNugetUrl
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerWebsiteUrl%]" $footerWebsiteUrl
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerSiteTitle%]" $footerSiteTitle

    #Does it hold with one list of htmlFilesSkipped... which contains both namespaces and class names...
    # would that be sufficient for the javascript to hide stuff from TOC?
    if ($null -ne $removedNamespaceHtmlFiles -and $removedNamespaceHtmlFiles.Count -gt 0) {
        $removedNamespaceHtmlFilesCommaSeparatedList = $removedNamespaceHtmlFiles -join ","
        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%empty-namespaces%]" $removedNamespaceHtmlFilesCommaSeparatedList
    }
    #[%ignored-classes%]

    if ($null -ne $skipDocumentationFor -and $skipDocumentationFor.Count -gt 0) {
        foreach ($skip in $skipDocumentationFor) {
            ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile (">" + $skip + "<") "><"
        }
    }
}

Out "Swapped all variables for all html files"