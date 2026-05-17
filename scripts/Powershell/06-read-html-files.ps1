$skipRules = @()

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
    if (-not $isSkipped -and -not $isGeneric) {
        $content = [System.IO.File]::ReadAllText($fullName, [System.Text.Encoding]::UTF8)
    }

    $title = $_.BaseName

    if ($content -match '(?s)<h1[^>]*>(.*?)</h1>') {
        $title = $matches[1]
    }
    else {
        if ($content -match "<title>(.*?)</title>") {
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

Out "HTML docs are read and sorted"