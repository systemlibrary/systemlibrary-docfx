# SystemLibrary DocFX for Libraries

## Requirements
- .NET >= 4.8
	* download from Google
- PowerShell >= 2
	* download from Google
- DocFX.console >= 2.58
	* download from nuget.org or through Nuget Package Manager in Visual studio

## Description
- Sick tired of DocFx just not playing right, when all you want is all public classes, interfaces, properties and methods if they contain a XML comment in C# code, then export those into a decent documentation for developers by developers?
- With the slight ability to adjust the title, nuget url, github url and banner and footer background, that's it, else it just works?
- With the option to add a "Install.md" file which is also exported to HTML as part of the DOCFX content list?
- With the option to add multiple markdown files as a Manual/Handbook, which are also exported to their respective HTML files, explaning implementation details and thresholds in your system or package?

## Customize
- Customize data/docfx_custom_template if you want to change parts of it or replace it with the regular docfx template that comes with DocFx.console nuget package
- Customize css through data/docfx_custom_template/custom.css as that file is loaded last

## Why
The standard docfx tool is too messy, it is rigid, it is bloated, it displays a ton of unuseful documentation.
It is hard to read and find example code for a simple function, as there's just too much noise in the documentation.
We document for real developers with more than 5 years experience, no need for a wall of text on saying how to create an object and how to invoke a method.

## Adjustments to DocFx
- 'Improve this doc' has been removed
- Inheritance tree is removed
	- Seeing eventually that everything is inheriting an Object is not very useful
- Parameter to functions are hidden
	- Interested in how to invoke the function, simply click it to show a sample if the C# Comment contains a example, else intellisense in VS shows params
	- We care about the name of the function and its return type, if it matches our need, we click on it to view the sample code, how to invoke the method, or simply using our Visual Studio to invoke the method
- Code is highlighted by hljs 
  	- A lot of custom styling has been made to reflect somewhat the "github code style"
    	- We are used to read code that looks like github or like our Visual Studio styling, then DocFx has its own style? Thats just awful
		- YOu want to code in non-github style, then you want to read PR, or review your own self, in github, the moment you see your code in different colors, you get a new view of the code, easily detecting anything
- A new Index.html is created based on all generated html files
- A Install.html will be created if a "install.md" exists in the root of your project
	- Install.html will have a link at the top in the "Index.html"
- All .md files locations in ~/Manual will be added to the Manual overview
	- Folder hierarchy will be preserved in the linkage
		- Ex: Manual/security/obfuscation.md will generate a html file at ~/manual/security/obfuscation.html and a link to this html will be shown in the ~/manual/index.html
- A download link will be created at top of Install.html if a "demo.zip" exists at the root of your project or solution that you targetted
	- CAREFUL: The demo.zip is also copied to the output docs

## Reset to docfx default
If you want a new clean template, but with just the install, markdown and demo.zip functionality??
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