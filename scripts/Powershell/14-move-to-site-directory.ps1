# MOVE TO PROJECT SITE ROOT

Move-Item -Path $projectSiteDirectory$projectName\* -Destination $projectSiteDirectory -Force

Remove-Item -Recurse -Force $projectSiteDirectory$projectName -ErrorAction SilentlyContinue

Out "Moved all html files to site directory"