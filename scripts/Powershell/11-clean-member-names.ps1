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

    if (-not $doc.Content.Contains("???")) {
        continue
    }

    $maxFlagBlockCounter = 0
    
    while ($doc.Content.Contains("???")) {
        $maxFlagBlockCounter = $maxFlagBlockCounter + 1

        if ($maxFlagBlockCounter -gt 10) {
            break
        }

        $start = $doc.Content.IndexOf("???")

        $end = $doc.Content.IndexOf("???", $start + 3)
        
        if ($end -lt 3) { 
            break 
        }

        $end += 3  # include last ???

        # Extract a block of text with ??? and next ???, which is eligible for all Vars in 'keyValues' list
        $length = $end - $start

        $block = $doc.Content.Substring($start, $length)
    
        if ($block -match "(?s)@%@(.*?)@%@") {
            $fullMemberName = $matches[0]

            foreach ($kv in $keyValues) {
                if ($fullMemberName.Contains($kv.Keyword)) {
                    $block = $block.Replace(("@!@" + $kv.Var + "@!@"), $kv.Value)
                }
                else {
                    $block = $block.Replace(("@!@" + $kv.Var + "@!@"), "")
                }
            }
        
            $block = $block.Replace($fullMemberName, "")
        }
        else {
            Out ("Could not find @%@ within the a block of ???, in document: " + $doc.Name + ", block: " + $block)
        }

        $block = $block.Substring(3, $block.Length - 6).Trim()

        $doc.Content = $doc.Content.Remove($start, $length).Insert($start, $block)
    }

    if ($doc.Content.Contains("???")) {
        Out ($doc.Name + " still contains the template markers for member names. Regex did not caught it")
    }

    if ($doc.Content.Contains("@!@")) {
        Out ($doc.Name + " still contains placeholders for flags, string replace did not replace some variables. Are you using old obsoleted variable flags?")
        Out ("Supported variable flags within @!@ are:")
        foreach ($kv in $keyValues) {
            Out ($kv.Var)
        }
    }

    $doc.Changed = $true
}

Out "Cleaned member names"