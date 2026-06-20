$skipRules = @()
function ReplaceNewlinesInContentPart {
    param(
        [string]$content,
        [string]$pattern
    )

    if (-not [regex]::IsMatch($content, $pattern)) {
        return $content
    }

    $replacer = {
        param($match)

        $outer = $match.Groups[1].Value

        # Find the one <p> tag in the part and replace new lines with br if not already formatted by br or ul/ol by the Consumer
        $newOuter = [regex]::Replace($outer, '(?s)<p>(.*?)</p>', {
                param($pMatch)

                $pInner = $pMatch.Groups[1].Value

                if ($pInner -match '<br') { return $pMatch.Value }
                if ($pInner -match '<ul|<ol') { return $pMatch.Value }

                $pReplaced = $pInner -replace "`r`n", '<br/>' -replace "`n", '<br/>'

                return $pMatch.Value.Replace($pInner, $pReplaced)
            })

        return $match.Value.Replace($outer, $newOuter)
    }

    return [regex]::Replace($content, $pattern, $replacer)
}

if ($SkipDocumentationFor -and $SkipDocumentationFor.Count -gt 0) {
    foreach ($s in $SkipDocumentationFor) {
        $skipRules += $s.Replace("<T>", "-1").Replace("<T1, T2>", "-2").Replace("<T1, T2, T3>", "-3")
    }
}

$htmlFiles = Get-ChildItem $sitePath -Recurse -Filter *.html | ForEach-Object {
    $fullName = $_.FullName.Replace("\", "/")

    $isGeneric = $false
    if ($_.BaseName -match '-\d+$') {
        $isGeneric = $true
    }

    $isSkipped = $false
    foreach ($rule in $skipRules) {
        if ($rule.Contains("*") -and $_.BaseName -like $rule.Replace("*", "*")) {
            $isSkipped = $true
        }
        elseif ($rule.Contains(".") -and $_.BaseName.StartsWith($rule)) {
            $isSkipped = $true
        }
        elseif ($_.BaseName.EndsWith($rule)) {
            $isSkipped = $true
        }
    }

    $content = ""
    if (-not $isSkipped) {
        $content = [System.IO.File]::ReadAllText($fullName, [System.Text.Encoding]::UTF8)

        $summaryPattern = '(?s)<div[^>]*markdown summary[^>]*>(.*?)\r?\n?</div>'
        $summaryMemberPattern = '(?s)<div[^>]*summary-content[^>]*>(.*?)\r?\n?</div>'
        
        $remarksPattern = '(?s)<div[^>]*remarks-content[^>]*>(.*?)\r?\n?</div>'

        $content = ReplaceNewlinesInContentPart $content $summaryPattern
        $content = ReplaceNewlinesInContentPart $content $remarksPattern
        $content = ReplaceNewlinesInContentPart $content $summaryMemberPattern
    }

    $title = $_.BaseName

    if ($content -match '(?s)<h1[^>]*>(.*?)</h1>') {
        $title = $matches[1]
    }
    else {
        if ($content -match "(?s)<title>(.*?)</title>") {
            $title = $matches[1]
        }
    }

    # strip nested HTML tags
    $title = $title -replace '<[^>]+>', ''

    # normalize whitespace
    $title = $title -replace '\s+', ' '
    $title = $title.Trim()

    # remove API prefix
    $title = $title -replace '^(Class|Interface|Enum|Struct|Record)\s+', ''

    if ($title.Contains(' | ')) {
        $title = $title.Split(' | ')[0].Trim()
    }

    $hasToc = $content.Contains("!!TOC!!")

    $relativePath = ($fullName -split '__docfxsite/')[1]

    $relativePath = $relativePath.Replace($_.Name, "");

    if ($_.BaseName.Contains("DelegateJsonConverter")) {
        Out "YES FOUND WHEN CREATING HTMLFILES list!"
    }

    [PSCustomObject]@{
        Name         = $_.BaseName
        FullName     = $fullName
        Title        = $title
        IsGeneric    = $isGeneric
        IsSkipped    = $isSkipped
        Content      = $content
        HasToc       = $hasToc
        IsNamespace  = $title -and $title.Contains(".")
        RelativePath = $relativePath
        Changed      = $false
    }
}

if (-not $htmlFiles -or $htmlFiles.Count -eq 0) {
    Err "No HTML files were found in the site generated."
    exit 1
}

$htmlDocs = $htmlFiles | Where-Object { -not $_.IsSkipped }

$htmlDocsSorted = $htmlDocs | Sort-Object FullName

$htmlTocDocs = $htmlDocs | Where-Object { $_.HasToc }

$htmlNamespaceDocs = $htmlDocs | Where-Object { $_.IsNamespace }

$htmlApiDocs = $htmlFiles | Where-Object { -not $_.IsNamespace }

function TraceDocName($name, $listName, $list) {
    foreach ($doc in $list) {
        if ($doc.Name.Contains($name)) {
            Write-Host "$name found in $listName"
        }
    }
}

$traceDocName = "Config<"

TraceDocName $traceDocName "htmlFiles" $htmlFiles
TraceDocName $traceDocName "htmlDocs" $htmlDocs
TraceDocName $traceDocName "htmlDocsSorted" $htmlDocsSorted
TraceDocName $traceDocName "htmlTocDocs" $htmlTocDocs
TraceDocName $traceDocName "htmlNamespaceDocs" $htmlNamespaceDocs
TraceDocName $traceDocName "htmlApiDocs" $htmlApiDocs

Out "HTML docs are read and sorted"