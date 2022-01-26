# Contributing

Kindly adhere to the principles detailed in this document while contributing.

This project leverages [GitVersion](https://gitversion.net) and tries to adhere to [SemVer](https://semver.org/). 

## Issues

### Bug reports

Raise issues and bug reports with regards to this product in the Issues tab of this project.

### Fixing an issue

If you're interested in fixing an issue in this project, firstly, thank you! 

1. Fork the repository and create a branch off of `main`/`master`
   1. If you're creating a new feature, name your branch `feature/<InsertAppropriateDescriptionHere>`. If you're fixing a bug, name your branch `fix/<InsertAppropriateDescriptionHere>`.
2. Write your code
3. Update CHANGELOG.md with your changes (preferably using the [ChangeLogManagement](https://www.powershellgallery.com/packages/ChangelogManagement) PowerShell module for formatting consistency) 
```powershell 
Add-ChangelogData -Type Added -Data "Added CONTRIBUTING.md"` )
```
4. For good measure, check for any changes to the upstream repo
5. Make sure you have pushed your commits to your new branch and then create a pull request