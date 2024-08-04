# SystemLibrary DocFX for Libraries

## Requirements
- .NET >= 4.8
	* download from Google
- PowerShell >= 2
	* download from Google
- DocFX.console >= 2.58
	* download from nuget.org or through Nuget Package Manager in Visual studio

## Description
- Export your C# comments on all public classes, properties and methods into HTML files
- Customize data/docfx_custom_template if you want to change parts of it or replace it with the regular docfx template that comes with DocFx.console nuget package
- Customize css through data/docfx_custom_template/custom.css as that file is loaded last

## Additional Info
- The normal DocFx template is too messy, displaying tons of unuseful information, hard to find and read example code for a simple function
	- "Improve this doc" is removed
	- Unuseful information such as the inheritance tree is removed
    	- Seeing that all objects "end up" inheriting Object is not useful
  	- All params to each function is hidden
    	- We care about the name of the function and its return type, if it matches our need, we click on it to view the sample code, how to invoke the method, or simply using our Visual Studio to invoke the method
  	- Code is highlighted by hljs 
  	- A lot of custom styling has been made to reflect somewhat the "github code style"
    	- We are used to read code that looks like github or like our Visual Studio styling, then DocFx has its own style? Thats just awful
  	- A new Index.html is created based on all generated html files
  	- A Install.html will be created if a "install.md" exists in the root of your project
    	- Install.html will have a link at the top in the "Index.html"
  	- A Download link will be created at Install.html if a "demo.zip" exists in the root of your project


- If you want a new clean template?
	- Google 'docfx template export default'
	- Run the command
	- Delete all files in "docfx_custom_template" folder
	- Add all files that was output from the command to the "docfx_custom_template" folder
	

## Install
- There's no installation apart from just downloading the whole repo, clone, zip...

## Usage
- Copy "systemlibrary-common-net.ps1" to new file name of your own choice
- Open the new file in Powershell Editor
- Change the variables
- Run the script
- The output of the script can then be hosted in IIS for instance or push to /docs folder in your github repo and activate 'github pages'
  - There are tons of javascrpits, so it must be hosted in a Web Hosting Software, not just open the html files in a browser


## Example
- An example of the documentation created:
- https://systemlibrary.github.io//systemlibrary-common-net/index.html

## Lisence
- It's free forever, copy paste as you'd like...