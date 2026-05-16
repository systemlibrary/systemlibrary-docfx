$githubTemplate = "<span>Source: <a href='$FooterGithubUrl'>github</a></span><br>"
$nugetTemplate = "<span>Package: <a href='$FooterNugetUrl'>nuget</a></span><br>"
$websiteTemplate = "<span>Website: <a href='$FooterWebsiteUrl'>$SiteTitle</a></span><br>"

$footerTemplate = ""

if ($FooterGithubUrl -ne $null -and $FooterGithubUrl -ne "") {
    $footerTemplate = $footerTemplate + $githubTemplate
}

if ($nugetTemplate -ne $null -and $nugetTemplate -ne "") {
    $footerTemplate = $footerTemplate + $nugetTemplate
}

if ($websiteTemplate -ne $null -and $websiteTemplate -ne "") {
    $footerTemplate = $footerTemplate + $websiteTemplate
}
$footerTemplate = $footerTemplate + "<br>"

foreach ($doc in $htmlDocs) {
    if (-not $doc.Content) { 
        continue
    }
    
    if ($doc.Content.Contains("[FOOTER]")) {
        $doc.Content = $doc.Content.Replace("[FOOTER]", $footerTemplate)
        
        $doc.Changed = $true
        
    }
}

Out "Populated footer"