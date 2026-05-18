$keyValues = @(
    @{ Key = 'isGeneric'; Value = "<>" }
    @{ Key = 'isStatic'; Value = "static " }
    @{ Key = 'isMethod'; Value = "()" }
    @{ Key = 'isProperty'; Value = "{ get; set; }" }
)

foreach ($doc in $htmlFiles) {
    if (-not $doc.Content) { 
        continue
    }

    if (-not $doc.Content.Contains("@%@")) {
        continue
    }

    $fullMemberName = ""
    if ($doc.Content -match "@%@.*?@%@") {
        $fullMemberName = $matches[0]
    }

    if($fullMemberName -NE $null -and $fullMemberName.Length -gt 0) {
        foreach ($kv in $keyValues) {
            if($fullMemberName.Contains($kv.Key)) {
                $doc.Content = $doc.Content.Replace("@!@" + $kv.Key + "@!@", $kv.Value)
            }else {
                $doc.Content =  $doc.Content.Replace("@!@" + $kv.Key + "@!@", "")
            }
        }

        $doc.Content = $doc.Content.Replace($fullMemberName, "")
    }
    $doc.Changed = $true
}

Out "Cleaned member names"