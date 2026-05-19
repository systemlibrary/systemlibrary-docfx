if($UnlinkNamespaces -and $UnlinkNamespaces.Count -gt 0)
{
    $unlinkNamespaceKeyValue = @()

    foreach ($link in $UnlinkNamespaces) {

        $linkTitleParts = $link.Split('.')
        $linkTitle = $linkTitleParts[-1]

        $unlinkNamespaceKeyValue += @{
            Key = '<a class="xref" href="' + $link + '.html">' + $linkTitle + '</a>';
            Value = '<span>' + $linkTitle + '</span>'
        }
    }

    foreach ($doc in $htmlFiles) {
        if (-not $doc.Content) { 
            continue
        }

        foreach ($ns in $unlinkNamespaceKeyValue) {
            if ($doc.Content.Contains($ns.Key)) {
                $doc.Content = $doc.Content.Replace($ns.Key, $ns.Value)
                $doc.Changed = $true
            }
        }
    }
    Out "Cleaned namespace links"
}
