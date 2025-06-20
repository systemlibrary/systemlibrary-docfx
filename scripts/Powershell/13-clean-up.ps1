if ($cleanUp -eq $true) {
    Start-Sleep -Milliseconds 50
    Remove-Item -Recurse -Force $projectSiteDirectory -ErrorAction SilentlyContinue
    #Remove-Item -Recurse -Force $projectDocDirectory -ErrorAction SilentlyContinue
    Remove-Item -Force "$projectDocDirectory\*.yml" -ErrorAction SilentlyContinue
    Remove-Item -Force "$projectDocDirectory\.manifest" -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force $projectDirectory\"docfx_custom_template" -ErrorAction SilentlyContinue
    Remove-Item $docFxJson -Force -ErrorAction SilentlyContinue
    Remove-Item $projectDirectory$projectName"_toc.yml" -Force -ErrorAction SilentlyContinue
    Remove-Item $projectDirectory$projectName"_index.md" -Force -ErrorAction SilentlyContinue
    Remove-Item $projectDirectory$projectName"_filter.yml" -Force -ErrorAction SilentlyContinue
    
    Out "Cleaned temporary files"
}
else {
    Warn "Clean: skipped"
}