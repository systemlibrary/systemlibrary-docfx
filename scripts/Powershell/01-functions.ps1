function Out([string] $msg) {
    Write-Host $msg -ForegroundColor DarkCyan
}
function Warn([string] $msg) {
    Write-Host $msg -ForegroundColor DarkYellow
}
function Err([string] $msg) {
    Write-Host $msg -ForegroundColor Red
}

function GetFiles([string] $folder, [string]$extension = $null) {
    $files = Get-ChildItem $folder -Recurse

    if ($null -eq $extension) {
        return $files | Where-Object { $_.extension -eq $extension }
    }
    return $files
}

# Returns the full path of the folder from a full file path
function GetFolderPath([string] $fullFilePath) {
    return Split-Path -Path $fullFilePath
}

# Returns a file object from a string path
function GetFileName([string] $fileFullPath) {
    return (Get-ChildItem $fileFullPath).BaseName
}

# Returns the file without extension, -, . and _
function GetFileDisplayName([string] $fileFullPath) {
    return (Get-ChildItem $fileFullPath).BaseName.replace('.', ' ').replace('-', ' ').replace('_', ' ')
}

function ReplaceTextInFile([string] $fileFullPath, [string] $old, [string] $new) {
    $content = Get-Content $fileFullPath -ErrorAction SilentlyContinue
    if ($null -eq $content) {
        Start-Sleep -Milliseconds 25
        $content = Get-Content $fileFullPath -ErrorAction SilentlyContinue
        if($null -eq $content) {
            Start-Sleep -Milliseconds 75
            $content = Get-Content $fileFullPath -ErrorAction SilentlyContinue
        }
        if ($null -eq $content) {
            Err ("Could not find content when replacing " + $old  + " with new: " + $new + " in file " + $fileFullPath.ToString())
        }
        exit
    }
    Start-Sleep -Milliseconds 7
    try {
        $content.Replace($old, $new) | Set-Content $fileFullPath -Force
    }
    catch {
        Warn ("Trying replacing again in 50ms - as file could not be set, yet...");
        Start-Sleep -Milliseconds 50
        try {
            $content.Replace($old, $new) | Set-Content $fileFullPath -Force
        }
        catch {
            Warn ("Trying replacing again in 200ms - last retry...");
            Start-Sleep -Milliseconds 200
            $content.Replace($old, $new) | Set-Content $fileFullPath -Force
        }
    }
    Start-Sleep -Milliseconds 7
}

function HasError($results) {
    if ($null -eq $results) {
        return $false
    }

    if ($results -is [array]) {
        foreach ($result in $results) {
            if ($result.ToString().Contains("Build failed.") -or $result.ToString().Contains("Error:")) {
                Err $result
                return $true
            }
        }
    }
    else {
        $res = $results.ToString().Contains("Build failed") -or $results.ToString().Contains("Error:") -eq $true

        if ($res -eq $true) {
            Err $res
            return $true
        }
    }
    return $false
}