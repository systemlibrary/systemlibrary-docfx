if ($cleanUp -eq $true) {
    Start-Sleep -Milliseconds 50
    Remove-Item -Recurse -Force $projectSiteDirectory -ErrorAction SilentlyContinue
    
    if ($csprojFileFullPath.Contains(".sln")) {
        Remove-Item -Force "$projectDocDirectory\*.yml" -ErrorAction SilentlyContinue
        Remove-Item -Force "$projectDocDirectory\.manifest" -ErrorAction SilentlyContinue
    }
    else {
        Remove-Item -Recurse -Force $projectDocDirectory -ErrorAction SilentlyContinue
    }
    
    Remove-Item -Recurse -Force $projectDirectory\"docfx_custom_template" -ErrorAction SilentlyContinue
    Remove-Item $docFxJson -Force -ErrorAction SilentlyContinue
    Remove-Item $projectDirectory$projectName"_toc.yml" -Force -ErrorAction SilentlyContinue
    Remove-Item $projectDirectory$projectName"_index.md" -Force -ErrorAction SilentlyContinue
    Remove-Item $projectDirectory$projectName"_filter.yml" -Force -ErrorAction SilentlyContinue

    Remove-Item $projectDirectory$projectName"-log.txt" -Force -ErrorAction SilentlyContinue
    
    #Start-Sleep -Milliseconds 50

    # if ((Get-ChildItem -Path "$projectDocDirectory" -Recurse -Force | Where-Object { -not $_.PSIContainer }).Count -eq 0) {
    #     Remove-Item -Path "$projectDocDirectory" -Force
    # }

    Out "Cleaned temporary files"
}
else {
    Warn "Clean: skipped"
}