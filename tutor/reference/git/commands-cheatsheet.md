# Git Commands Cheatsheet

Essential Git commands for version control. These commands help you track changes, collaborate with others, and manage your code history.

---

## Setup & Init

### git init

**What it does:** Creates a new Git repository in the current directory

**Visual:**
```
Before:                  After:
my-project/              my-project/
  ├── file.txt             ├── .git/         (hidden repository)
  └── code.py              ├── file.txt
                           └── code.py
```

**Syntax:**
```bash
git init                    # Initialize in current directory
git init <directory-name>   # Create new directory and initialize
```

**When to use:** Starting a brand new project that you want to track with version control

**Gotcha:** Running `git init` in a directory that's already inside a Git repository creates a nested repo (usually not what you want). Always check if you're already in a repo with `git status` first.

---

### git clone

**What it does:** Downloads a complete copy of a remote repository to your local machine

**Visual:**
```
GitHub (Remote):         Your Computer (Local):
username/repo
  ├── README.md    -->   cloned-repo/
  ├── src/                 ├── .git/
  └── tests/               ├── README.md
                           ├── src/
                           └── tests/
```

**Syntax:**
```bash
git clone <url>                          # Clone into folder named after repo
git clone <url> <directory-name>         # Clone into specific folder
git clone <url> --depth 1                # Shallow clone (recent history only)
git clone <url> --branch <branch-name>   # Clone specific branch
```

**When to use:** Starting work on an existing project, or downloading open-source code

**Gotcha:** `git clone` creates a new directory, so don't create the folder first. Running `git clone` inside an existing Git repository is usually fine (creates separate repo), but watch your paths.

---

## Basic Workflow

### git status

**What it does:** Shows which files have changed, what's staged, and what branch you're on

**Visual:**
```
Working Directory:       Output shows:
  modified: file1.txt    Modified files:    file1.txt (unstaged)
  modified: file2.txt                       file2.txt (staged ✓)
  new: file3.txt         Untracked files:   file3.txt
```

**Syntax:**
```bash
git status              # Full status
git status -s           # Short format (condensed)
git status --branch     # Include branch info
```

**When to use:** Constantly! Before committing, before switching branches, when confused about what's changed

**Gotcha:** Files can be both staged AND modified (if you edited after staging). Run `git status` to see the truth. Green = staged, red = unstaged/untracked.

---

### git add

**What it does:** Stages changes, marking files to be included in the next commit

**Visual:**
```
Working Directory    Staging Area         Repository
   file.txt     -->    file.txt      -->   (waiting for commit)
   (modified)          (staged ✓)
```

**Syntax:**
```bash
git add <file>              # Stage specific file
git add <file1> <file2>     # Stage multiple files
git add .                   # Stage all changes in current directory
git add -A                  # Stage all changes (entire repo)
git add -p                  # Stage interactively (chunk by chunk)
git add *.py                # Stage all Python files
```

**When to use:** After making changes you want to save in your next commit

**Gotcha:** `git add .` only adds files in current directory and below. Use `git add -A` to stage everything from repo root. Also, adding a file doesn't save it permanently - you still need to commit!

---

### git commit

**What it does:** Saves staged changes as a permanent snapshot in the repository history

**Visual:**
```
Staging Area         Repository History
  file.txt    -->    Commit ABC123: "Add feature X"
  (staged)           Commit DEF456: "Fix bug Y"
                     Commit GHI789: "Update docs"  ← NEW
```

**Syntax:**
```bash
git commit -m "message"              # Commit with inline message
git commit                           # Opens editor for message
git commit -am "message"             # Stage all tracked files + commit
git commit --amend                   # Modify the last commit
git commit --amend --no-edit         # Add to last commit, keep message
```

**When to use:** When you've completed a logical unit of work (a feature, bug fix, or refactor)

**Gotcha:** `git commit -am` only stages TRACKED files (ignores new untracked files). Also, committing is LOCAL - your changes aren't on the remote server until you push!

---

### git push

**What it does:** Uploads local commits to a remote repository (like GitHub)

**Visual:**
```
Local Repository         Remote Repository (GitHub)
  Commit A                 Commit A
  Commit B                 Commit B
  Commit C (new)    -->    Commit C (uploaded!)
```

**Syntax:**
```bash
git push                              # Push current branch to remote
git push origin <branch-name>         # Push specific branch
git push -u origin <branch-name>      # Set upstream and push
git push --all                        # Push all branches
git push --force                      # Overwrite remote (DANGEROUS!)
```

**When to use:** After committing changes that you want to share or back up to the remote server

**Gotcha:** If someone else pushed to the same branch first, your push will be rejected. You'll need to pull their changes first. NEVER use `--force` unless you know exactly what you're doing (it can erase others' work).

---

### git pull

**What it does:** Downloads commits from remote repository and merges them into your current branch

**Visual:**
```
Remote Repository        Local Repository
  Commit A                 Commit A
  Commit B                 Commit B (you're here)
  Commit C (new)    -->    Commit C (downloaded + merged)
```

**Syntax:**
```bash
git pull                          # Pull current branch from remote
git pull origin <branch-name>     # Pull specific branch
git pull --rebase                 # Pull and rebase instead of merge
git pull --ff-only                # Only pull if fast-forward possible
```

**When to use:** Before starting work (to get latest changes) or when your push is rejected

**Gotcha:** `git pull` = `git fetch` + `git merge`. If there are conflicts between your local changes and remote changes, you'll need to resolve them manually. Always commit or stash your work before pulling!

---

## Branching

### git branch

**What it does:** Lists, creates, or deletes branches (parallel versions of your code)

**Visual:**
```
main      ●───●───●
               \
feature        ●───●  (new branch)
```

**Syntax:**
```bash
git branch                    # List all local branches
git branch -a                 # List all branches (including remote)
git branch <name>             # Create new branch
git branch -d <name>          # Delete merged branch
git branch -D <name>          # Force delete branch (even if unmerged)
git branch -m <old> <new>     # Rename branch
```

**When to use:** To organize work into features, experiments, or bug fixes without affecting the main codebase

**Gotcha:** Creating a branch doesn't switch to it! Use `git checkout <name>` or `git switch <name>` after creating. Also, deleting a branch doesn't delete its commits if they're merged into another branch.

---

### git checkout

**What it does:** Switches between branches or restores files (multi-purpose command)

**Visual:**
```
* main      ●───●───●  (you are here)
  feature   ●───●

After: git checkout feature

  main      ●───●───●
* feature   ●───●  (now you are here)
```

**Syntax:**
```bash
git checkout <branch-name>           # Switch to existing branch
git checkout -b <branch-name>        # Create and switch to new branch
git checkout <commit-hash>           # Go to specific commit (detached HEAD)
git checkout -- <file>               # Discard changes to file (OLD syntax)
git checkout <branch> -- <file>      # Get file from another branch
```

**When to use:** Switching between branches or (historically) discarding file changes

**Gotcha:** `git checkout` does too many things! Modern Git recommends `git switch` (for branches) and `git restore` (for files) instead. Also, uncommitted changes can prevent checkout - commit or stash first.

---

### git switch

**What it does:** Switches between branches (newer, clearer alternative to `git checkout`)

**Visual:**
```
* main      ●───●───●  (current)
  feature   ●───●

After: git switch feature

  main      ●───●───●
* feature   ●───●  (current)
```

**Syntax:**
```bash
git switch <branch-name>        # Switch to existing branch
git switch -c <branch-name>     # Create and switch to new branch
git switch -                    # Switch to previous branch
git switch main                 # Return to main branch
```

**When to use:** Anytime you need to switch branches (clearer than `git checkout`)

**Gotcha:** Can't switch with uncommitted changes that conflict with target branch. Commit, stash, or discard changes first. Also, this is a newer command (Git 2.23+), so older tutorials use `checkout`.

---

### git merge

**What it does:** Combines changes from one branch into your current branch

**Visual:**
```
Before:                    After:
main    ●───●───●          main    ●───●───●───●  (merged!)
             \                              \   /
feature       ●───●        feature           ●───●
```

**Syntax:**
```bash
git merge <branch-name>           # Merge branch into current branch
git merge <branch> --no-ff        # Force merge commit (no fast-forward)
git merge <branch> --squash       # Combine all commits into one
git merge --abort                 # Cancel merge during conflicts
```

**When to use:** Integrating a feature branch back into main, or pulling in changes from main into your feature branch

**Gotcha:** Merge conflicts happen when the same lines are changed in both branches. Git will mark conflicts in files - you must manually resolve them, then `git add` and `git commit`. Always merge INTO the branch you want to keep (checkout main, then merge feature).

---

## Inspection

### git log

**What it does:** Shows the commit history for the repository

**Visual:**
```
Commit Log (newest first):

commit abc123 ← HEAD (most recent)
Author: You
Date: Today
  Add new feature

commit def456
Author: Teammate
Date: Yesterday
  Fix bug in module
```

**Syntax:**
```bash
git log                              # Full log
git log --oneline                    # Condensed (one line per commit)
git log --graph                      # Visual branch diagram
git log --oneline --graph --all      # Beautiful visual of all branches
git log -n 5                         # Show last 5 commits
git log --author="name"              # Filter by author
git log --since="2 weeks ago"        # Filter by date
git log <file>                       # Show commits affecting a file
```

**When to use:** Understanding project history, finding when a bug was introduced, seeing what changed

**Gotcha:** `git log` shows commits reachable from current branch only (unless you use `--all`). Press `q` to exit log viewer. Use `--oneline` for quick overview, full log for details.

---

### git diff

**What it does:** Shows differences between files, commits, or branches

**Visual:**
```
file.txt (before)     file.txt (after)      git diff output:
1 | Hello             1 | Hello             @@ -2,1 +2,1 @@
2 | World             2 | Earth             - World
                                            + Earth
```

**Syntax:**
```bash
git diff                           # Unstaged changes vs last commit
git diff --staged                  # Staged changes vs last commit
git diff <branch1> <branch2>       # Compare two branches
git diff <commit1> <commit2>       # Compare two commits
git diff HEAD~1 HEAD               # Compare last commit to previous
git diff <file>                    # Diff for specific file
```

**When to use:** Before committing (to review changes), comparing branches, or investigating what changed

**Gotcha:** `git diff` with no args shows UNSTAGED changes only. Use `git diff --staged` to see what you're about to commit. Lines starting with `-` are removed, `+` are added. Press `q` to exit.

---

### git show

**What it does:** Shows detailed information about a specific commit (message + diff)

**Visual:**
```
git show abc123 outputs:

commit abc123
Author: You <you@email.com>
Date: Fri Jan 10 2026

  Add login feature

diff --git a/login.py b/login.py
+ def login(user, password):
+   return authenticate(user, password)
```

**Syntax:**
```bash
git show                       # Show last commit
git show <commit-hash>         # Show specific commit
git show <branch-name>         # Show latest commit on branch
git show HEAD~2                # Show 2 commits ago
git show <commit>:<file>       # Show file content at commit
git show --stat                # Show files changed (no diff)
```

**When to use:** Inspecting a specific commit's changes, checking what a teammate did, or reviewing your last commit

**Gotcha:** `git show` defaults to HEAD (last commit). Commit hashes can be abbreviated (first 7 chars usually enough). Press `q` to exit viewer.

---

## Undoing

### git reset

**What it does:** Moves the current branch pointer to a different commit (undoing commits)

**Visual:**
```
Before:                        After: git reset HEAD~1
main  ●───●───●  ← HEAD        main  ●───●  ← HEAD
                                     (last commit undone)
```

**Syntax:**
```bash
git reset <file>                # Unstage file (keep changes)
git reset --soft HEAD~1         # Undo last commit, keep changes staged
git reset --mixed HEAD~1        # Undo last commit, unstage (DEFAULT)
git reset --hard HEAD~1         # Undo last commit, DELETE changes (DANGER!)
git reset --hard origin/main    # Match remote branch exactly (DANGER!)
```

**When to use:** Unstaging files, undoing local commits before pushing, or starting over

**Gotcha:** `--hard` DELETES your work permanently! Only use if you're sure. `git reset` rewrites history - NEVER reset commits that have been pushed (others may have them). Use `git revert` instead for public commits.

---

### git revert

**What it does:** Creates a new commit that undoes changes from a previous commit (safe undo)

**Visual:**
```
Before:                           After: git revert abc123
●───●───●  (bad commit)           ●───●───●───●  (revert commit)
        ↑ abc123                          ↑ new commit undoes abc123
```

**Syntax:**
```bash
git revert <commit-hash>        # Revert specific commit
git revert HEAD                 # Revert last commit
git revert --no-commit <hash>   # Revert without auto-commit
git revert -m 1 <merge-hash>    # Revert merge commit
git revert <hash1>..<hash2>     # Revert range of commits
```

**When to use:** Undoing a commit that's already been pushed, or undoing changes while preserving history

**Gotcha:** `git revert` doesn't delete commits - it creates a NEW commit with opposite changes. This is safer for shared branches but adds to history. If reverting a merge, use `-m 1` to specify parent.

---

### git restore

**What it does:** Restores files to a previous state (newer alternative to `git checkout` for files)

**Visual:**
```
Working Directory:          After: git restore file.txt
  file.txt (modified)  -->    file.txt (restored from last commit)
```

**Syntax:**
```bash
git restore <file>                  # Discard unstaged changes
git restore --staged <file>         # Unstage file (keep changes)
git restore --source=<commit> <file> # Restore from specific commit
git restore .                       # Restore all files in directory
git restore --worktree --staged <file> # Unstage AND discard changes
```

**When to use:** Discarding unwanted changes, unstaging files, or retrieving old file versions

**Gotcha:** `git restore` without `--staged` DELETES unstaged changes permanently! Always double-check before restoring. This is a newer command (Git 2.23+) - older tutorials use `git checkout --`.

---

### git stash

**What it does:** Temporarily saves uncommitted changes so you can work on something else

**Visual:**
```
Working Directory         Stash (temporary storage)        Clean Working Directory
  modified: file.txt  -->   Stash@{0}: WIP on main    -->   (no changes)
```

**Syntax:**
```bash
git stash                      # Save changes and clean working dir
git stash push -m "message"    # Stash with description
git stash list                 # Show all stashes
git stash pop                  # Apply latest stash and delete it
git stash apply                # Apply latest stash and keep it
git stash apply stash@{2}      # Apply specific stash
git stash drop stash@{0}       # Delete specific stash
git stash clear                # Delete all stashes
```

**When to use:** When you need to switch branches but aren't ready to commit, or to save experimental changes

**Gotcha:** Stashes are local only (not pushed to remote). `git stash pop` can cause conflicts if files changed since stashing. Stashes are numbered `stash@{0}` (newest) to `stash@{n}` (oldest).

---

## Remote

### git fetch

**What it does:** Downloads commits from remote repository WITHOUT merging (safe update)

**Visual:**
```
Remote:               Local (after fetch):
origin/main           origin/main (updated reference)
  ●───●───●             ●───●───●
                      main
                        ●───●  (your branch unchanged)
```

**Syntax:**
```bash
git fetch                       # Fetch from default remote (origin)
git fetch origin                # Fetch from specific remote
git fetch --all                 # Fetch from all remotes
git fetch --prune               # Remove deleted remote branches
git fetch origin <branch>       # Fetch specific branch
```

**When to use:** Checking for remote changes before merging, or updating remote branch references

**Gotcha:** `git fetch` downloads but doesn't merge! Your working files don't change. Use `git merge origin/main` after fetching to integrate changes. `git pull` = `git fetch` + `git merge`.

---

### git remote

**What it does:** Manages connections to remote repositories (like GitHub)

**Visual:**
```
Local Repo                Remote Connections:
  .git/      <--------    origin → https://github.com/user/repo.git
             <--------    upstream → https://github.com/original/repo.git
```

**Syntax:**
```bash
git remote                          # List remotes
git remote -v                       # List remotes with URLs
git remote add <name> <url>         # Add new remote
git remote remove <name>            # Remove remote
git remote rename <old> <new>       # Rename remote
git remote get-url origin           # Show remote URL
git remote set-url origin <new-url> # Change remote URL
```

**When to use:** Setting up connections to GitHub, adding upstream repos for forks, or switching remote URLs

**Gotcha:** `origin` is just a convention (default name when cloning) - you can name remotes anything. Deleting a remote locally doesn't delete the remote repository. Use `git remote -v` to verify your remotes point to the right URLs.

---

## Quick Reference Card

**Setup:**
- `git init` - Create new repository
- `git clone <url>` - Copy remote repository

**Daily Workflow:**
- `git status` - Check what's changed
- `git add <file>` - Stage changes
- `git commit -m "msg"` - Save snapshot
- `git push` - Upload to remote
- `git pull` - Download from remote

**Branching:**
- `git branch <name>` - Create branch
- `git switch <name>` - Switch branches
- `git merge <name>` - Combine branches

**Inspection:**
- `git log --oneline` - View history
- `git diff` - See unstaged changes
- `git show <commit>` - Inspect commit

**Undoing:**
- `git restore <file>` - Discard changes
- `git restore --staged <file>` - Unstage
- `git reset --soft HEAD~1` - Undo commit
- `git revert <commit>` - Undo (safely)
- `git stash` - Save work temporarily

**Remote:**
- `git fetch` - Download (no merge)
- `git remote -v` - List connections

---

## Common Workflows

### Starting a New Project
```bash
mkdir my-project
cd my-project
git init
# ... create files ...
git add .
git commit -m "Initial commit"
git remote add origin <url>
git push -u origin main
```

---

### Working on a Feature
```bash
git switch -c feature-name     # Create feature branch
# ... make changes ...
git add .
git commit -m "Add feature"
git switch main                # Return to main
git merge feature-name         # Integrate feature
git branch -d feature-name     # Clean up
```

---

### Fixing a Mistake in Last Commit
```bash
# If you haven't pushed yet:
git reset --soft HEAD~1        # Undo commit, keep changes
# ... fix issues ...
git add .
git commit -m "Fixed version"

# If you already pushed:
git revert HEAD                # Create undo commit
git push
```

---

### Syncing with Remote
```bash
git fetch origin              # Download updates
git status                    # Check if behind
git merge origin/main         # Integrate updates
# Or in one step:
git pull                      # Fetch + merge
```

---

## Common Mistakes to Avoid

### Committing Without Checking Status
```
Don't: git add . && git commit -m "updates"
```
### Always Review What You're Committing
```
Do: git status
    git diff
    git add specific-files
    git commit -m "descriptive message"
```

---

### Using --force Without Understanding
```
Don't: git push --force  (can erase teammates' work!)
```
### Only Force When Necessary
```
Do: Communicate with team first
    Use --force-with-lease (safer)
    Only force on personal branches
```

---

### Forgetting to Pull Before Starting Work
```
Don't: Start work → make changes → try to push → CONFLICT!
```
### Pull First, Then Work
```
Do: git pull
    # ... make changes ...
    git add .
    git commit -m "message"
    git push
```

---

### Confusing reset --hard
```
Don't: git reset --hard HEAD~5  (loses 5 commits of work!)
```
### Use Safer Alternatives
```
Do: git revert <commit>  (for pushed commits)
    git reset --soft HEAD~1  (keep changes)
    git stash  (save work temporarily)
```

---

## Related Resources

- Git basics tutorial: `tutor/notebooks/git-basics.ipynb`
- GitHub workflow guide: `tutor/reference/git/github-workflow.md`
- Resolving merge conflicts: `tutor/reference/git/merge-conflicts.md`
- Interactive Git learning: https://learngitbranching.js.org/
