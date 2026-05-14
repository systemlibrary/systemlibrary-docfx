$skipRules = @()

if ($SkipDocumentationFor -and $SkipDocumentationFor.Count -gt 0) {
    foreach ($s in $SkipDocumentationFor) {
        $skipRules += $s.Replace("<T>", "-1").Replace("<T1, T2>", "-2").Replace("<T1, T2, T3>", "-3")
    }
}

$htmlFiles = Get-ChildItem $sitePath -Recurse -Filter *.html | ForEach-Object {

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
    if (-not $isSkipped -and -not $isGeneric) {
        $content = Get-Content $_.FullName -Raw
    }

    $title = $null
    if ($content -match "<title>(.*?)</title>") {
        $title = $matches[1]
    }

    $hasToc = $content.Contains("!!TOC!!")
    if (-not $hasToc) {
        $content = ""
    }

    [PSCustomObject]@{
        Name        = $_.BaseName
        FullName    = $_.FullName
        Title       = $title
        IsGeneric   = $isGeneric
        IsSkipped   = $isSkipped
        Content     = $content
        HasToc      = $hasToc
        IsNamespace = $title -and $title.Contains(".")
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

# Out "-------ALL:-------"
# Out $htmlFiles

# Out "-------DOCS:-------"
# Out $htmlDocs

# Out "------TOC:--------"
# Out $htmlTocDocs

# Out "------NAMESPACE:--------"
# Out $htmlNamespaceDocs

Out "HTML docs are read and sorted"