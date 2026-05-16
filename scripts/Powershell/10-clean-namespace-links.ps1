$removeNamespaceTags = @(
    @{ Key = '<a class="xref" href="SystemLibrary.Common.html">Common</a>'; Value = "<span>Common</span>" },
    @{ Key = '<a class="xref" href="SystemLibrary.html">SystemLibrary</a>'; Value = "<span>SystemLibrary</span>" }
)

foreach ($doc in $htmlFiles) {
    if (-not $doc.Content) { 
        continue
    }

    foreach ($ns in $removeNamespaceTags) {
        if ($doc.Content.Contains($ns.Key)) {
            $doc.Content = $doc.Content.Replace($ns.Key, $ns.Value)
            $doc.Changed = $true
        }
    }
}

Out "Cleaned namespace links"