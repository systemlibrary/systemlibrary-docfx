# MOVE TO PROJECT SITE ROOT

Move-Item -Path $projectSiteDirectory$projectName\* -Destination $projectSiteDirectory -Force 

Remove-Item -Recurse -Force $projectSiteDirectory$projectName -ErrorAction SilentlyContinue

Start-Sleep -Milliseconds 20

Out ("Moved all html files to site directory")