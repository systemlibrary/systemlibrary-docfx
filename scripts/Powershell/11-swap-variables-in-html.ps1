
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

        $skipDocumentationForSeparatedCommaList = $skipDocumentationForSeparatedCommaList.Replace("<", "__-1_");
        $skipDocumentationForSeparatedCommaList = $skipDocumentationForSeparatedCommaList.Replace(">", "__-2_");

        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%custom-skipDocumentationFor%]" $skipDocumentationForSeparatedCommaList

        foreach ($skip in $skipDocumentationFor) {
            if ($skip.Contains(".") -eq $false) {
                ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile (">" + $skip + "<") "><"
            }
        }

        if ($namespaceHtmlFiles -contains $htmlFile) {
            foreach ($skip in $skipDocumentationFor) {
                if ($skip.Contains(".") -eq $true) {
                    $desc = "id=" + [char]34 + $skip + "--description" + [char]34
                    $descNewValue = $desc + " class='docfxhide-attribute'"

                    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile ($desc) ($descNewValue)

                    $parts = $skip.Split(".")
                    $skipClass = $parts[$parts.Length - 1]
                    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile (">" + $skipClass + "<") "><"

                    $skipClassDesc = $skipClass + "--description"
                    $desc = "id=" + [char]34 + $skipClassDesc + [char]34
                    $descNewValue = $desc + " class='docfxhide-attribute'"

                    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile ($desc) ($descNewValue)

                    # A nested class "one level deep", try remove such skipped parts on the "namespace overview page"
                    if ($parts.Length -gt 1) {
                        $nestedClass = $parts[$parts.Length - 2] + "." + $parts[$parts.Length - 1]
                        $nestedClassDescription = $nestedClass + "--description"

                        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile (">" + $nestedClass + "<") "><"

                        $nestedClassDescriptionOld = "id=" + [char]34 + $nestedClassDescription + [char]34
                        $nestedClassDescriptionNew = $nestedClassDescriptionOld + " class='docfxhide-attribute'"

                        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile ($nestedClassDescriptionOld) ($nestedClassDescriptionNew)
                    }
                }
            }
        }

    }
}

Out "Swapped all variables for all html files"