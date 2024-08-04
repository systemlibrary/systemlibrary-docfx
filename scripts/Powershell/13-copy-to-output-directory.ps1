try {
    if ($null -ne $outputFolderFullPath -and $outputFolderFullPath -ne "") {
        Start-Sleep -Milliseconds 20

        Copy-Item -Path $projectSiteDirectory\* -Destination $outputFolderFullPath -Force -Recurse -ErrorAction SilentlyContinue

        Start-Sleep -Milliseconds 20
    }
}
catch {
    Err "Error occured reading and moving all site files to outputfolder - Try again? Delete the folder " + $outputFolderFullPath + ", then try again?"
    exit
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
    Copy-Item -Path $demoFullPath -Destination ($outputFolderFullPath + "demo.zip") -Force
    Out ("demo.zip sample copied to docs, continue")
} else {
    Out ("No demo.zip sample exist, continue")
}
