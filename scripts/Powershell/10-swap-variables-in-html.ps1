if ($null -eq $relativeHostingPath) {
    $relativeHostingPath = ""
}

Start-Sleep -Milliseconds 150

Out "Swapping HTML in the docfx generated HTML files"

foreach ($htmlFile in $htmlFiles) {
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%relativeHostingPath%]" $relativeHostingPath
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%siteTitle%]" $siteTitle
    ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerSiteTitle%]" $footerSiteTitle
    
    # Remove footer options if null/blank
    if ($footerNugetUrl -ne $null -and $footerNugetUrl -ne "") {
        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerNugetUrl%]" $footerNugetUrl
    }
    else {
        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "<span>Package: <a href='[%footerNugetUrl%]'>nuget</a></span><br>" ""
    }

    if ($footerGithubUrl -ne $null -and $footerGithubUrl -ne "") {
        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerGithubUrl%]" $footerGithubUrl
    }
    else {
        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "<span>Source: <a href='[%footerGithubUrl%]'>github</a></span><br>" ""
    }

    if ($footerWebsiteUrl -ne $null -and $footerWebsiteUrl -ne "") {
        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "[%footerWebsiteUrl%]" $footerWebsiteUrl
    }
    else {
        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "<span>Website: <a href='[%footerWebsiteUrl%]'>[%footerSiteTitle%]</a></span>" ""
    }
  
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

    if ($showViewSourceLinks -eq $false) {
        ReplaceTextInFile $projectSiteDirectory\$projectName\$htmlFile "custom-source-code-link-container" "custom-source-code-link-container custom-source-code-link-container--hidden"
    }
}

Out "Swapped all variables for all html files"