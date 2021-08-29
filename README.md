# SystemLibrary DocFX for Libraries

## Requirements
- .NET >= 4.8
	* download from Google
- PowerShell >= 2
	* download from Google
- DocFX.console >= 2.58
	* download from nuget.org or through Nuget Package Manager in Visual studio

## Description
- Create a DocFX library documentation for your .csproj file
- Host the documentation flies on a server or locally in IIS for example
- You can customize "data/docfx_custom_template" if you want to, but it is "messy" at current state
- You can also customize "data/docfx_custom_template/custom.css" as that file is added last, but the code has been copy-pasted from Chrome and not polished...

## Additional Info
- The docfx template has been slightly modified
	- "Improve this Doc" is removed
	- code (hljs code html nodes) can only highlight C# or HTML
	- a bunch of custom styling has been made from the default "docfx template"
	- a custom navigation list is used on index.html as entry
	- example, arguments and return information per method is currently added to a "tab menu"
- If you want a new clean template?
	- Google 'docfx template export default'
	- Run the command
	- Delete all files in "docfx_custom_template" folder
	- Add all files that was output from the command to the "docfx_custom_template" folder
	
## Futuristic vision
- All protected members are hidden
- All "this[]" index operator implementations are hidden
- Might adjust the layout to look and feel more like the github source, as all coders are familiar with it
 and the docs are for developers who sit 24/7 looking at code...

## Install
- Download the code from this repo, either as zip, clone, copy paste 1 and 1 file...

## Usage
- Copy "systemlibrary-common-net.ps1" to new file name of your own choice
- Open the new file in Powershell Editor
- Change the top required variables, such as $csprojFileFullPath, etc...
- Run the script
- Either:
	- a) Host the files in IIS on your local computer, as there's tons of javascript that requires it, cannot open directly the html files
	- b) Push to for instance github repo, to the root of the repo in a folder named "docs", then activate 'github pages' 


## Example
- An example of the documentation created:
- https://systemlibrary.github.io/systemlibrary-common-net/SystemLibrary.Common.Net.html

## Lisence
- It's free forever, copy paste as you'd like...