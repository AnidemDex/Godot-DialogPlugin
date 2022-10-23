> **Author's note:**
> 
> _First off, many, many, many thanks for consider contributing to this plugin! I like to make things, but getting a hand on it is much better. 
> I really appreciate that you are reading this file_ 🤗

# How to contribute
The issue tracker is the preferred channel for bug reports, features requests and submitting pull requests, but please respect the following restrictions:
Please take a moment to review this document in order to make the contribution process easy and effective for everyone involved.

## Table of contents
- [How to contribute](#how-to-contribute)
  - [Table of contents](#table-of-contents)
  - [Bug reports](#bug-reports)
  - [Feature requests or improvements](#feature-requests-or-improvements)
  - [Pull requests](#pull-requests)
    - [Document your changes](#document-your-changes)
    - [Be nice to the Git history](#be-nice-to-the-git-history)

## Bug reports
A bug is a demonstrable problem that is caused by the code in the repository. Good bug reports are extremely helpful.
Try to keep in mind these suggestions when you want to report a bug:

1. **Use the GitHub issue search.** Check if the issue has already been reported, and if it's already solved.
2. **Always open only one issue for one bug.** This help us to keep clean solutions to specific problems.
3. **Don't forget to add information about your system, software and plugin version.** The issue template can help you here.
4. **Describe your issue.** What doesn't work, and how do you expect it to work instead? 
5. If suitable, include the steps required to reproduce the bug.

## Feature requests or improvements
Feature requests are welcome! But this only applies if it's inside the scope of this plugin.

We can integrate _a thing_ that will help you and other users to do _something with the plugin_, but we will not integrate something that:
- **Only will works for you and no other user will be able to use it.**
- **Is out of the scope of this plugin idea.**

As an example, improvements or requests related to documentation are always welcome.

## Pull requests
Good pull requests - patches, improvements, new features - are a fantastic help.

Make sure that your pull request:
- Solves a common use case that several users will need in their real-life projects

Try to ask first before embarking on any significant pull request. Making those are hard and you risk spending a lot of time working on something that the project's developers might not want to merge into the project.

As an example, you don't need to ask to make a pull request that solves an issue, if your pull request fixes it, then you've already asked if it's going to be useful in the plugin.

### Document your changes
Follow [GDScript documentation comments](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_documentation_comments.html) guide to document what you did (if suitable).

If your pull request adds methods, properties, signals or new classes that can be used by any user, you must update the documentation reference to document those.

If your pull request modifies parts of the code in a non-obvious way, make sure to add comments in the code as well.

### Be nice to the Git history
Try to make simple PRs that handle one specific topic. Just like for reporting issues, it's better to open 3 different PRs that each address a different issue than one big PR with three commits.

When updating your fork with upstream changes, please use `git pull --rebase` to avoid creating _"merge commits"_.

Take a look at this [GIT Style guide](https://github.com/agis-/git-style-guide) and try to keep that in mind.