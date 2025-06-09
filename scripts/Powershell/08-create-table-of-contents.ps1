
[string]$listItemInstall = CreateListItem '/Install.md' 'Installation instructions'
[string]$listItemManual = CreateListItem '/Manual/Manual.md' 'A handbook about implementation specific details'

$htmlFilesCopy = @() + $htmlFiles

if ($listItemManual -ne "") {
    $htmlFilesCopy = @($listItemManual) + $htmlFilesCopy
}

if ($listItemInstall -ne "") {
    $htmlFilesCopy = @($listItemInstall) + $htmlFilesCopy
}

$indexHtmlOrderedList = createOrderedList $htmlFilesCopy