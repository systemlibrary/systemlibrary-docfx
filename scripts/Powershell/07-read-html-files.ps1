# Read all HTML files generated, except Index and TOC...
$allHtmlFiles = GetFiles $projectSiteDirectory\$projectName | Where-Object { 
    $fileName = $_.Name
    return $fileName -ne "toc.html" -and $fileName -ne "index.html" -and $fileName.contains("_") -eq $false
}

if ($allHtmlFiles -eq $null -or $allHtmlFiles.Count -eq 0 ) {
    Err "No html files were found. Do you have minimum one public class in your project?"
    exit
}

# List all HTML files that will be skipped based on PS configuration
$htmlFilesSkipped = @()
if ($skipDocumentationFor -ne $null -and $skipDocumentationFor.Count -gt 0) {
    $htmlFilesSkipped = @($allHtmlFiles | Where-Object {
            $fileName = $_.BaseName

            for ($i = 0; $i -lt $skipDocumentationFor.Count; $i++) {
                if ($skipDocumentationFor[$i].Contains(".")) {
                    if ($fileName.StartsWith($skipDocumentationFor[$i])) {
                        return $true;
                    }
                }
                else {
                    if ($fileName.EndsWith($skipDocumentationFor[$i])) {
                        return $true;
                    }
                }
            }
            return $false
        })
}

# All HTML files that will be part of the documentation, without the skipped files
$htmlFiles = $allHtmlFiles | Where-Object {
    return $htmlFilesSkipped.Contains($_) -eq $false;
} | Sort-Object BaseName


# All HTML files that are only namespaces
$namespaceHtmlFiles = $htmlFiles | Where-Object {
    $htmlFile = $_.BaseName

    if ($htmlFile.EndsWith("-1")) { return $false }

    $htmlFileContent = (Get-Content $_.FullName | Select-Object -First 12).Split('<')

    for ($j = 0; $j -lt $htmlFileContent.Length; $j++) {
        # All HTML files have title equal to either Namespace or the Enum/Class/Struct name
        if ($htmlFileContent[$j].StartsWith("title>")) {
            if ($htmlFileContent[$j].Contains(".") -eq $true) {
                return $true
            }
            return $false
        }
    }

    return $false
} | Sort-Object BaseName


$htmlFilesSorted = New-Object Collections.Generic.List[Object]

for ($i = 0; $i -le $namespaceHtmlFiles.Length - 1; $i++) {
    $htmlFilesSorted.Add($namespaceHtmlFiles[$i])

    for ($j = 0; $j -le $htmlFiles.Length - 1; $j++) {
        $htmlFile = $htmlFiles[$j]
        $htmlFileName = $htmlFile.BaseName

        if ($htmlFileName.StartsWith($namespaceHtmlFiles[$i].BaseName)) {

            $className = $htmlFileName.Substring($namespaceHtmlFiles[$i].BaseName.Length)

            if ($null -eq $className -or $className -eq "") {
                # Skipping the current namespace - its already added, above this inner loop
            }
            else {
                # Must start with . and only contain 1 . to be class of current namespace
                if ($className.StartsWith(".")) {
                    $remainingClassName = $className.Substring(1)
                    # It still contains a ., then class lives in a sub-namespace
                    if ($remainingClassName.Contains(".") -eq $false) {
                        # not already added, just to be safe
                        if ($htmlFilesSorted.Contains($htmlFile) -eq $false) {
                            # it's not a namespace (sub-namespace of current namespace)
                            if ($namespaceHtmlFiles.Contains($htmlFile) -eq $false) {
                                $htmlFilesSorted.Add($htmlFile)
                            }
                        }
                    }
                }
            }
        }
    }
}

$htmlFiles = $htmlFilesSorted | Select-Object

Out ("SOOOOORTED")
foreach ($a in $htmlFiles) {
    Out $a.BaseName
}
Out ("SOOOOORTED END")

$removedNamespaceHtmlFiles = @()

for ($i = 0; $i -lt $htmlFiles.Length; $i++) {
    $file = $htmlFiles[$i]

    # Current file is a namespace file, lets check if next file is also a namespace OR if it has a different namespace
    # then we know that "current file namespace" is empty
    if ($namespaceHtmlFiles -contains $file) {

        if ($i -lt $htmlFiles.Length - 1) {
            $nextHtmlFile = $htmlFiles[$i + 1]
            if ($namespaceHtmlFiles -contains $nextHtmlFile) {
                $removedNamespaceHtmlFiles += $file
            }

            if ($nextHtmlFile.BaseName.StartsWith($file.BaseName)) {
            }
            else {
                $removedNamespaceHtmlFiles += $file
            }
        }
    }
}

if ($removedNamespaceHtmlFiles.Length -gt 0) {
    $htmlFiles = $htmlFiles | Where-Object {
        return $removedNamespaceHtmlFiles -contains $_ -eq $false
    }

    $namespaceHtmlFiles = $namespaceHtmlFiles | Where-Object {
        return $removedNamespaceHtmlFiles -contains $_ -eq $false
    } 
}

Out "All html files have been read and sorted"