
function createListItem($baseName, $href, $cssClass) {
    $title = "class"

    if ($cssClass -ne "") {
        $title = "namespace"
    }
    $cleanName = $baseName.Replace('-1', "<>");
    return "<li class='" + $cssClass + "' title='" + $title + "'><a class='index-navigation-item' href='" + $href + "'>" + $cleanName + "</a></li>"
}

$indexHtmlOrderedList = "<ol class='navigation-list-item'>" + ($manualListItem + $installListItem) + (
    $htmlFiles | ForEach-Object {
        $href = ($relativeHostingPath + $_.Name)

        $cssClass = "";

        if ($namespaceHtmlFiles -contains $_) {
            $cssClass = "index-navigation-item--namespace"
        }

        $li = createListItem $_.BaseName $href $cssClass

        $($li)
    } 
) + "</ol>"