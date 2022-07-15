
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

    # Send "skip Documentation For"-query option into DOM, so Javascript can use same "logic" to hide elements in SideToc
    if ($null -ne $skipDocumentationFor -and $skipDocumentationFor.Count -gt 0) {

        $skipDocumentationForSeparatedCommaList = $skipDocumentationFor -join ","
        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%custom-skipDocumentationFor%]" $skipDocumentationForSeparatedCommaList

        # NOTE: This doesnt work anymore in latest docfx, a hrefs contains WBR elements in between capital and lower letters
        foreach ($skip in $skipDocumentationFor) {
            ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile (">" + $skip + "<") "><"
        }

        # This must be updated to also support removal of "links to sub-stuff if namespace search is being used..."
        # and support of "full namespace and class name: systemlibrary.common.net.dump" should then be removed link fo "dump" on "link.."
        # split and take last part of name "dump", and replace >dump< with ><....
    }
}

Out "Swapped all variables for all html files"