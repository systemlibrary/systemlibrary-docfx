function Out($msg) {
    if ($msg -is [string]) {
        Write-Host $msg -ForegroundColor DarkCyan
        return
    }

    if ($msg -is [int]) {
        Write-Host $msg -ForegroundColor DarkCyan
        return
    }

    if ($msg -is [bool]) {
        Write-Host $msg -ForegroundColor DarkCyan
        return
    }
    
    $trimmed = $msg | ForEach-Object {

        $obj = $_
        $clone = [ordered]@{}

        $obj.PSObject.Properties | ForEach-Object {
            $val = $_.Value

            if ($val -is [string] -and $val.Length -gt 22) {
                $clone[$_.Name] = $val.Substring(0, 22) + ""
            }
            else {
                $clone[$_.Name] = $val
            }
        }

        [PSCustomObject]$clone
    }

    $trimmed | Format-Table -AutoSize | Out-Host
}

function Warn([string] $msg) {
    Write-Host $msg -ForegroundColor DarkYellow
}
function Err([string] $msg) {
    Write-Host $msg -ForegroundColor Red
}

function ReplaceTextInFile([string] $fileFullPath, [string] $old, [string] $new) {
    $content = Get-Content  $fileFullPath -Raw -ErrorAction SilentlyContinue

    if ($null -eq $content -or $content -eq "") {
        Start-Sleep -Milliseconds 5
        $content = Get-Content $fileFullPath -Raw -ErrorAction SilentlyContinue
        if ($null -eq $content -or $content -eq "") {
            Start-Sleep -Milliseconds 25
            $content = Get-Content $fileFullPath -Raw -ErrorAction SilentlyContinue
        }
        if ($null -eq $content -or $content -eq "") {
            Start-Sleep -Milliseconds 75
            $content = Get-Content $fileFullPath -Raw -ErrorAction SilentlyContinue
        }

        if ($null -eq $content -or $content -eq "") {
            Start-Sleep -Milliseconds 200
            $content = Get-Content $fileFullPath -Raw -ErrorAction SilentlyContinue

            if ($null -eq $content -or $content -eq "") {
                Start-Sleep -Milliseconds 500
                $content = Get-Content $fileFullPath -Raw -ErrorAction SilentlyContinue
            }
        }
        
        if ($null -eq $content -or $content -eq "") {
            Warn ("Content is null or blank when replacing: " + $old + " with new: " + $new + " in file " + [System.IO.Path]::GetFileName($fileFullPath))
            # No content in file, nothing to replace, continue...
            return
        }
    }
    Start-Sleep -Milliseconds 3
    try {
        $content.Replace($old, $new) | Set-Content $fileFullPath -Force -ErrorAction Stop
    }
    catch {
        Warn ("Retrying replacing text in file in 20ms...");
        Start-Sleep -Milliseconds 20
        try {
            $content.Replace($old, $new) | Set-Content $fileFullPath -Force -ErrorAction Stop
        }
        catch {
            Warn ("Retrying replacing text in file in 60ms...");
            Start-Sleep -Milliseconds 60
            try {
                $content.Replace($old, $new) | Set-Content $fileFullPath -Force -ErrorAction Stop
            }
            catch {
                Warn ("Retrying replacing text in file in 200ms...");
                Start-Sleep -Milliseconds 200
                try {
                    $content.Replace($old, $new) | Set-Content $fileFullPath -Force -ErrorAction Stop
                }
                catch {
                    Warn ("Retrying replacing text in file in 600ms...");
                    Start-Sleep -Milliseconds 600
                    try {
                        [System.IO.File]::WriteAllText($fileFullPath, $content.Replace($old, $new))
                    }
                    catch {
                        Err $_
                        Err ("Error replacing " + $old + " with " + $new + " in file " + $fileFullPath)
                    }
                }
            }
        }
    }
    Start-Sleep -Milliseconds 3
}

function HasError($results) {
    if ($null -eq $results) {
        return $false
    }

    if ($results -is [array]) {
        $tmpFlag = $false
        foreach ($result in $results) {
            if ($result.ToString().Contains("Build failed") -or 
                $result.ToString().Contains("[Failure]") -eq $true -or 
                $result.ToString().Contains("Msbuild failed") -eq $true -or 
                $result.ToString().Contains("Method not found") -eq $true -or
                $result.ToString().Contains("Error: ") -eq $true
            ) {
                $tmpFlag = $true
                Err $result
            }
        }
        if ($tmpFlag -eq $true) {
            return $true
        }
    }
    else {
        $res = $results.ToString().Contains("Build failed") 
        -or $results.ToString().Contains("[Failure]") -eq $true 
        -or $results.ToString().Contains("Msbuild failed") -eq $true 
        -or $results.ToString().Contains("Method not found") -eq $true 
        -or $results.ToString().Contains("Error:") -eq $true

        if ($res -eq $true) {
            Err $res
            return $true
        }
    }
    return $false
}
