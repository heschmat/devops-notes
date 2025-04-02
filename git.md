# Git Basics: Commonly Used Commands

## Installing Git on Ubuntu

To install Git, use the following command:

```sh
sudo apt-get update && sudo apt-get install -y git
```

### Verify Installation

```sh
git --version
```

---

## Setting Up SSH Key for GitHub

To generate an SSH key pair and add it to your GitHub account, run:

```sh
ssh-keygen -t ed25519 -C "me@example.com"
```

### Add SSH Key to SSH Agent

```sh
ls ~/.ssh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/your_file
```

Output:

```
Identity added: path-above (me@example.com)
```

Now, add the content of the `.pub` file to the **SSH Key** section in your GitHub settings.

---

## Initializing a GitHub Repository

### After Creating Your GitHub Repo

Clone the repository:

```sh
git clone git@github.com:<gh-username>/<your-gh-repo>.git
```

Create and initialize the repository:

```sh
echo "# github-101" >> README.md
git init
git add README.md
git commit -m "first commit"
```

### If the Repository Already Exists

```sh
git remote add origin git@github.com:<gh-username>/<your-gh-repo>.git
git branch -M main
git push -u origin main
```

---

## Checking Repository Status

```sh
git status
```

### Understanding Git Status Messages

- **Untracked files** → Before running `git add`
- **Changes not staged for commit** → When modifying an already tracked file
- **Changes to be committed** → After running `git add` (staging area)

### Unstage a File

```sh
git rm --cached <file>
```

---

## Reverting Changes

### Unstage Changes (Move Out of Staging Area)

```sh
git restore --staged <file>
```

### Discard Local Changes

```sh
git restore <file>
```

---

## Viewing Commit History

```sh
git log
```

A more concise log:

```sh
git log --all --graph --decorate --oneline
```

### Creating a Git Alias for Simplified Log View

```sh
git config --global alias.hist "log --all --graph --decorate --oneline"
```

Now, you can simply run:

```sh
git hist
```

---

## Reverting to a Previous Commit

### 1. Temporarily Go Back to a Previous State

```sh
git log
git checkout <commit-id>
git checkout -b <new_branch>
git branch  # Show available branches
# push the local branch to GH
git push --set-upstream origin <new_branch>
# later on, when you modify again sth in this branch, you simply run: git push

# to checkout another branch
git checkout main
```

You can delete your local branch after the changes have been merged successfully.

```sh
git branch -d <new_branch>
```

### 2. Reset to an Older Commit (Discarding All Changes After It)

```sh
git reset --hard <commit-id>
git log
```

### 3. Revert a Specific Commit (Without Losing Later Changes)

```sh
git revert <commit-id>
```

Repeat as needed, then push changes:

```sh
git push
```

---

## Viewing Differences Between Commits

```sh
git diff <file>
```

Compare local changes to the remote `main` branch:

```sh
git diff HEAD..origin/main
```
