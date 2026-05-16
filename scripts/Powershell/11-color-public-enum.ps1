$colorPublicEnum = @(
    @{ Key = 'public enum '; Value = "<span class='class-enum-keyword-enum'>enum </span>" }
)

foreach ($doc in $htmlFiles) {
    if (-not $doc.Content) { 
        continue
    }

    foreach ($kv in $colorPublicEnum) {
        if ($doc.Content.Contains($kv.Key)) {
            $doc.Content = $doc.Content.Replace($kv.Key, $kv.Value)
            $doc.Changed = $true
        }
    }
}

Out "Colored public enums"