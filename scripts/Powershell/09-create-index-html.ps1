$projectIndexHtml = ($projectSiteDirectory + "\" + $projectName + "\index.html")

ReplaceTextInFile $projectIndexHtml "[%navigation%]" $indexHtmlOrderedList
ReplaceTextInFile $projectIndexHtml "[%projectDisplayName%]" $projectDisplayName
ReplaceTextInFile $projectIndexHtml "[%relativeHostingPath%]" $relativeHostingPath
ReplaceTextInFile $projectIndexHtml "[%siteTitle%]" $siteTitle

if ($footerNugetUrl -ne $null -and $footerNugetUrl -ne "") {
    ReplaceTextInFile $projectIndexHtml "[%footerNugetUrl%]" $footerNugetUrl
}
else {
    ReplaceTextInFile $projectIndexHtml "<span>Package: <a href='[%footerNugetUrl%]'>nuget</a></span><br>" ""
}

if ($footerGithubUrl -ne $null -and $footerGithubUrl -ne "") {
    ReplaceTextInFile $projectIndexHtml "[%footerGithubUrl%]" $footerGithubUrl
}
else {
    ReplaceTextInFile $projectIndexHtml "<span>Source: <a href='[%footerGithubUrl%]'>github</a></span><br>" ""
}

if ($footerWebsiteUrl -ne $null -and $footerWebsiteUrl -ne "") {
    ReplaceTextInFile $projectIndexHtml "[%footerWebsiteUrl%]" $footerWebsiteUrl
}
else {
    ReplaceTextInFile $projectIndexHtml "<span>Website: <a href='[%footerWebsiteUrl%]'>[%footerSiteTitle%]</a></span>" ""
}

ReplaceTextInFile $projectIndexHtml "[%footerSiteTitle%]" $footerSiteTitle
ReplaceTextInFile $projectIndexHtml "article-row-container" "article-row-container article-row-container--index"
ReplaceTextInFile $projectIndexHtml "sidenav hide-when-search" "sidenav hide-when-search sidenav--index"

Out "Replaced navigation list in index.html"