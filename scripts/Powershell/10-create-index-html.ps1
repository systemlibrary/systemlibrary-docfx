$projectIndexHtml = ($projectSiteDirectory + "\" + $projectName + "\index.html")

ReplaceTextInFile $projectIndexHtml "[%navigation%]" $indexHtmlOrderedList
ReplaceTextInFile $projectIndexHtml "[%projectDisplayName%]" $projectDisplayName
ReplaceTextInFile $projectIndexHtml "[%relativeHostingPath%]" $relativeHostingPath
ReplaceTextInFile $projectIndexHtml "[%siteTitle%]" $siteTitle
ReplaceTextInFile $projectIndexHtml "[%footerGithubUrl%]" $footerGithubUrl
ReplaceTextInFile $projectIndexHtml "[%footerNugetUrl%]" $footerNugetUrl
ReplaceTextInFile $projectIndexHtml "[%footerWebsiteUrl%]" $footerWebsiteUrl
ReplaceTextInFile $projectIndexHtml "[%footerSiteTitle%]" $footerSiteTitle
ReplaceTextInFile $projectIndexHtml "article-row-container" "article-row-container article-row-container--index"
ReplaceTextInFile $projectIndexHtml "sidenav hide-when-search" "sidenav hide-when-search sidenav--index"

Out "Replaced navigation list in index.html"