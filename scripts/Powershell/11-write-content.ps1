foreach ($doc in $htmlFiles) {
    if (-not $doc.Content) { 
        continue
    }

    if ($doc.Changed) {
        [System.IO.File]::WriteAllText($doc.FullName, $doc.Content, [System.Text.Encoding]::UTF8)
    }
}

Out "Written content to disc"