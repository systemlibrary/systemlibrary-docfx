foreach ($doc in $htmlTocDocs) {

    if (-not $doc.Content) { 
        continue
    }

    $path = $doc.RelativePath
    $depth = ($path -split '/').Count

    $tocItems = $htmlDocs | Where-Object {
        # Remove self from TOC
        if ($doc.FullName -eq $_.FullName) {
            return $false
        }
        
        # Remove toc.yml from TOC
        if ($_.Name -eq "toc") {
            return $false
        }

        if ($_.RelativePath.StartsWith($path) -eq $true) {

            # Exact relative path means a sibling, return true
            if ($_.RelativePath -eq $path) {
                return $true;
            }

            if ($_.Name -eq "Index") {
                $d = ($_.RelativePath -split '/').Count
                return ($d - 1) -eq $depth
            }
        }
        
        return $false;
    }

    $toc = "<div><ul>"

    foreach ($li in $tocItems) {
        $href = $li.Name + ".html"

        if ($li.Name -eq "Index") {
            $href = Join-Path $li.RelativePath $href
        }

        $title = $li.Title

        $toc += "<li><a href=""$href"">$title</a></li>"
    }

    $toc += "</ul></div>"

    if ($doc.Content.Contains("!!TOC!!")) {
        $doc.Changed = $true
        $doc.Content = $doc.Content.Replace("<p>!!TOC!!</p>", $toc)

        if ($doc.Content.Contains("!!TOC!!") -eq $true) {
            $doc.Content = $doc.Content.Replace("!!TOC!!", $toc)
        }
    }

    Out "TOC populated: $($doc.FullName)"
}