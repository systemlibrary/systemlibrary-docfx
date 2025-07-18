try {
    if ($null -ne $outputFolderFullPath -and $outputFolderFullPath -ne "") {
        Start-Sleep -Milliseconds 50

        Copy-Item -Path "$projectSiteDirectory\*" -Destination $outputFolderFullPath -Force -Recurse
        
        Start-Sleep -Milliseconds 50
    }
}
catch {
    Err "Error occured reading and moving all site files to outputfolder - Try again? Delete the folder " + $outputFolderFullPath + ", then try again?"
    EXIT 1
}

if ($ignoreClass -ne $null -and $ignoreClass.Count -gt 0) {
    $tocFullPath = ($outputFolderFullPath + "toc.html")

    foreach ($c in $ignoreClass) {
        if ($c -ne $null -and $c -ne "") {
            $fullRemovalPath = ($outputFolderFullPath + "*" + $c + "*")
            Remove-Item $fullRemovalPath -Force -ErrorAction SilentlyContinue

            $old = ("title=""" + $c + """")
            $new = ($old + " class=""docfxhide-attribute""")
            
            ReplaceTextInFile $tocFullPath $old $new
        }
    }
}

Out "Html files copied to output directory"

$parentProjectDirectory = (Get-Item $projectDirectory).Parent.FullName

$demoFullPath = $parentProjectDirectory + "/demo.zip";

if (Test-Path $demoFullPath) {
    # We want to really say we found a demo.zip in case it is not the meaning
    Copy-Item -Path $demoFullPath -Destination ($outputFolderFullPath + "demo.zip") -Force
    Warn ("-------demo.zip--------")
    Warn ("/demo.zip copied to docs")
    Warn ("-------demo.zip--------")
}
else {
    Out ("/demo.zip is not found, skipped...")
}
