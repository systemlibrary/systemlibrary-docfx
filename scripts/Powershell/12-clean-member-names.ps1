$keyValues = @(
    @{ Var = 'isGeneric'; Keyword = '<'; Value = "<span class='method-generic'><></span>" }
    @{ Var = 'isStatic'; Keyword = 'static '; Value = "<span class='member-static'>static </span>" }
    @{ Var = 'isMethod'; Keyword = '('; Value = "<span class='member-method'>()</span>" }
    @{ Var = 'isProperty'; Keyword = '{ '; Value = "<span class='member-property'>{ get; set; }</span>" }
)

foreach ($doc in $htmlApiDocs) {
    if (-not $doc.Content) { 
        continue
    }

    if (-not $doc.Content.Contains("@%@")) {
        continue
    }

    while ($doc.Content -match "@%@(.*?)@%@") {
        $fullMemberName = $matches[0]

        if ($fullMemberName -NE $null -and $fullMemberName.Length -gt 0) {
            foreach ($kv in $keyValues) {
                if ($fullMemberName.Contains($kv.Keyword)) {
                    $doc.Content = $doc.Content.Replace("@!@" + $kv.Var + "@!@", $kv.Value)
                }
                else {
                    $doc.Content = $doc.Content.Replace("@!@" + $kv.Var + "@!@", "")
                }
            }
            $doc.Content = $doc.Content.Replace($fullMemberName, "")
        }
    }
    
    $doc.Changed = $true
}

Out "Cleaned member names"