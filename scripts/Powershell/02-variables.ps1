$docfxDataDir = $PSScriptRoot + "\..\..\data\"

$projectName = GetFileName $csprojFileFullPath
$projectDirectory = (GetFolderPath $csprojFileFullPath) + "\"
$projectDocDirectory = $projectDirectory + $projectName + "\"
$projectSiteDirectory = $projectDirectory + $projectName + "_site\"
$projectDisplayName = GetFileDisplayName $csprojFileFullPath

$logFileFullPath = ($projectDirectory + $projectName + "-log.txt")

$docfxJson = ($projectDirectory + $projectName + "_docfx.json")
