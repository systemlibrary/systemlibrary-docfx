# SystemLibrary DocFX

## Requirements
- **.NET ≥ 4.8**  
  Tested with .NET 8.0; originally built for 4.8.
- **PowerShell ≥ 5.1**  
  Included in Windows 11.
- **DocFX.Console ≥ 2.60.1**  
  Install:  
  `dotnet tool update -g docfx --version 2.60.1`

## Why?
- Want clean, readable C# docs generated from XML comments?
- Want to avoid the clutter of default DocFX inheritance trees showing everything inherits from `object`?
- Want code highlighted like GitHub does, distinctly different from your IDE, so you instantly spot what’s good or bad?
- Want a simple way to change banner and footer color, its title, logo and favicon, and that is it?
- Want to target either a single `.csproj` or a full `.sln`?
- Want to include extra docs like `install.md` or a handbook (multiple md files)?
- Want docs focused on what a class does, not drowning in parameter details?
- Want developer-focused docs that help experienced devs find info fast, without unnecessary noise?
- Document for developers by developers - no need for walls of text explaining how to instantiate objects or call methods.
- DocFX's default output template is too noisy and bloated, making it hard to quickly find example code, or technical details with ease.

## Adjustments Made to Docfx Default Template
- Removed "Improve this doc" link.
- Removed inheritance tree — seeing everything inherit `Object` isn’t helpful.
- Remarks from XML comments are hidden by default, click the Remarks link to view
- Examples from XML comments are hidden by default, click the function name to view
- Hiding all function parameters by default:
  - Click a method to see usage examples if present; otherwise rely on VS IntelliSense.
  - Focus on the class and method names and return types, if you want to explore further, you try the class and function out in Visual Studio.
- Code highlighting via hljs with custom styles inspired by GitHub’s code style:
  - Easier to read than default DocFX styles, giving a fresh perspective on your code.
- Generates a `Index.html` with a Table of Content list, based on all HTML files from DocFx, where each HTML file corresponds to each class
  - Can be extended to contain a "Install" link at the top, if an `install.md` exists.
    - Can be extended to contain a Download Link at the top of the `Install` if a `demo.zip` exists at root of the project or solution
    - Note: the `demo.zip` is copied to the output docs folder too
  - Can be extended to contain a "Manual" and/or a "Guide" link, a handbook if you will, if a `~/Manual` or `~/Guide` folder exists in a project, which then exports all containing `.md` files under `~/Manual` or `~/Guide`.
    - Preserving folder hierarchy into the documentation
      - Example: `Manual/security/obfuscation.md` → `manual/security/obfuscation.html` with proper links.
        - Note: Manual/Guide is case sensitive

## Adjust The Template
### Reset
- Delete all files in `data/docfx_custom_template`
- Search "docfx template export default"
- Run export command, then move files into `data/docfx_custom_template`
- Verify `docfx.css` is at `data/docfx_custom_template/styles/docfx.css`

### Modify
- Edit files in `data/docfx_custom_template` to customize or replace with default template
- Add custom CSS colors in `data/docfx_custom_template/custom.css` (loaded last)

## Usage
### Create docs
- Clone the repo
- Copy or rename `systemlibrary-common-framework.ps1` to your project
- Edit variables inside the script
- Run the script
- Host output on IIS, GitHub Pages, or any web server  
  (Must be served via web server due to JavaScript, not just opened as local files)

## Example
- An example of the documentation created:
- https://systemlibrary.github.io/systemlibrary-common-framework/index.html

## License
Free forever, copy paste as you'd like, use at your own risk...

### Third parties
- DocFx (MIT): https://dotnet.github.io/docfx/
- showdown (BSD): https://www.npmjs.com/package/showdown
- highlight.js (BSD): https://www.npmjs.com/package/highlight.js
- remarkable (MIT): https://github.com/jonschlinkert/remarkable