## Working with this repo using Gemini

This document outlines the best practices for using Google's Gemini to manage the dotfiles in this repository. The primary goal is to ensure changes are made safely and controllably, without accidentally applying unintended configurations to your system.

### Core Principles

1.  **Git is the Source of Truth**: All changes must be managed through Git. Any modifications made by Gemini must be verifiable through `git diff`. This allows you to review, approve, and commit changes with full control.

2.  **No Direct Application**: Gemini must **NEVER** run `chezmoi apply`. This command directly modifies files in the home directory and bypasses the safety net of Git review.

3.  **Always Diff Before Committing**: The `chezmoi diff` command is the preferred and only way to preview the potential impact of changes. This shows what `chezmoi apply` *would* do without actually doing it.

### Recommended Workflow

Here is the ideal workflow for making a change using Gemini:

1.  **User Request**: You ask Gemini to make a change (e.g., "Add a new alias `l=ls -lha` to my zsh config").
2.  **Gemini Explores**: Gemini uses tools like `glob` and `read_file` to locate the correct file to modify (e.g., `.zshrc.tmpl`).
3.  **Gemini Modifies**: Gemini uses `write_file` or `replace` to alter the file within the repository.
4.  **Gemini Verifies with Git**: After the change, Gemini should run `git diff` to show the exact modifications to the source-of-truth files.
5.  **Gemini Previews with Chezmoi**: Gemini should then run `chezmoi diff` to show how the changes will be rendered and applied to your home directory.
6.  **User Approval**: You review both diffs. If they are correct and desired, you can then instruct Gemini to commit the changes.

### Allowed and Forbidden Commands

To ensure safety, Gemini's interactions should be limited to the following:

#### ✅ Allowed Commands

*   `git status`, `git diff`, `git add <file>`, `git log`
*   `git commit` (only after you have approved the changes)
*   `chezmoi diff`
*   `chezmoi status`
*   `chezmoi verify`
*   File-system tools (`read_file`, `write_file`, `replace`, `glob`, `list_directory`)

#### ❌ Forbidden Commands

*   `chezmoi apply`
*   `chezmoi add`
*   `chezmoi edit`
*   `chezmoi update`
*   `git push` (unless explicitly and directly requested by you)
