# Git Workflows Cheatsheet

A practical guide to common Git workflows and scenarios.

---

## Feature Branch Workflow

The feature branch workflow keeps `main` stable while you develop new features in isolated branches.

### ASCII Diagram

```
main:     A---B---C---F---G
               \       /
feature:        D-----E
```

### Step-by-Step Commands

```bash
# 1. Start from main and get latest changes
git checkout main
git pull origin main

# 2. Create and switch to new feature branch
git checkout -b feature/user-authentication

# 3. Make changes and commit regularly
git add .
git commit -m "Add login form component"
git commit -m "Implement authentication logic"
git commit -m "Add tests for auth flow"

# 4. Push feature branch to remote
git push -u origin feature/user-authentication

# 5. Create Pull Request (via GitHub/GitLab UI)
# After PR is approved and merged:

# 6. Switch back to main and update
git checkout main
git pull origin main

# 7. Delete the feature branch (cleanup)
git branch -d feature/user-authentication
git push origin --delete feature/user-authentication
```

### Key Points

- **Always** start from an updated `main` branch
- **One feature** per branch (keep scope focused)
- **Descriptive names**: `feature/name`, `bugfix/name`, `hotfix/name`
- **Regular commits**: Commit working increments, not half-done work
- **Clean up**: Delete merged branches to avoid clutter

---

## Daily Workflow

Your daily routine for productive, safe Git usage.

### Morning Routine

```bash
# Start your day: sync with team's latest work
git checkout main
git pull origin main

# Switch to your working branch (or create new one)
git checkout feature/your-feature
git merge main  # or: git rebase main (if branch not shared)
```

### During the Day

```bash
# After completing a logical unit of work:
git status                    # Review what changed
git add path/to/file         # Stage specific files
# OR
git add .                    # Stage all changes

git commit -m "Clear, descriptive message"

# Commit frequently with meaningful checkpoints
```

### End of Day

```bash
# Push your work (backup + share progress)
git push origin feature/your-feature

# If branch doesn't exist remotely yet:
git push -u origin feature/your-feature
```

### Commit Granularity Best Practices

**Good Commits** (Atomic & Focused):
```
✓ "Add user email validation"
✓ "Fix off-by-one error in pagination"
✓ "Update dependencies to latest versions"
```

**Bad Commits** (Too vague or too large):
```
✗ "Fix stuff"
✗ "WIP"
✗ "Updated everything for new feature and fixed bugs"
```

**The Atomic Commit Rule**: Each commit should represent **one logical change** that could be reverted independently.

---

## Handling Merge Conflicts

### Why They Happen

Conflicts occur when Git can't automatically merge changes because:
- Two people edited the **same lines** in the same file
- One person edited a file while another deleted it
- Changes are too close together for Git to auto-merge

### The Conflict Markers Explained

When a conflict occurs, Git marks the file like this:

```python
def calculate_total(items):
<<<<<<< HEAD (Current Change - Your Branch)
    total = sum(item.price * item.quantity for item in items)
    return total + shipping_cost
=======
    # Apply discount before calculating total
    total = sum(item.discounted_price * item.qty for item in items)
    return total
>>>>>>> feature/discount-system (Incoming Change)
```

**Marker Breakdown**:
- `<<<<<<< HEAD`: Start of your current branch's version
- `=======`: Separator between the two versions
- `>>>>>>> branch-name`: End of the incoming branch's version

### Steps to Resolve

```bash
# 1. Attempt the merge (triggers conflict detection)
git merge feature/other-branch
# Output: CONFLICT (content): Merge conflict in calculate.py

# 2. See which files have conflicts
git status
# Files with conflicts appear as "both modified"

# 3. Open conflicted file in editor
# Remove the markers (<<<<<<<, =======, >>>>>>>)
# Choose or combine the changes manually

# Example resolution:
def calculate_total(items):
    # Apply discount before calculating total (kept from incoming)
    total = sum(item.discounted_price * item.quantity for item in items)
    return total + shipping_cost  # kept shipping cost from current

# 4. Mark as resolved by staging
git add calculate.py

# 5. Complete the merge
git commit -m "Merge feature/discount-system, resolve pricing conflicts"
```

### Testing After Resolution

**CRITICAL**: Always test after resolving conflicts!

```bash
# Run your tests
pytest tests/

# Or manually test the affected functionality
python -m myapp.test_calculate

# If something's wrong, you can abort:
git merge --abort  # Before committing
git reset --hard HEAD~1  # After committing (dangerous!)
```

---

## Rebasing vs Merging

Two ways to integrate changes from one branch into another.

### When to Use Each

**Use Merge** when:
- Working on a shared branch
- Want to preserve complete history
- Creating Pull Requests (most teams prefer merge commits)

**Use Rebase** when:
- Updating your local feature branch with main
- Cleaning up commit history before PR
- Branch is **NOT** pushed/shared yet

### ASCII Diagrams Showing the Difference

**Before Integration**:
```
main:     A---B---C
               \
feature:        D---E
```

**After Merge** (creates merge commit):
```
main:     A---B---C-------F (merge commit)
               \         /
feature:        D---E---
```

**After Rebase** (rewrites history):
```
main:     A---B---C
                   \
feature:            D'---E'  (commits D and E rewritten)
```

### Commands

**Merge Approach**:
```bash
git checkout feature/my-feature
git merge main
# Creates a merge commit if there are changes
```

**Rebase Approach**:
```bash
git checkout feature/my-feature
git rebase main
# Replays your commits on top of main

# If conflicts occur during rebase:
# 1. Resolve conflicts in files
# 2. git add <resolved-files>
# 3. git rebase --continue

# To abort rebase:
git rebase --abort
```

### The Golden Rule

**NEVER REBASE SHARED BRANCHES**

```
✗ Don't: git rebase main  (while on main)
✗ Don't: Rebase a branch others are working on
✓ Do:    Rebase your local feature branch before pushing
✓ Do:    Rebase to clean up local commits
```

Why? Rebase rewrites commit history. If others have those commits, their Git history breaks.

---

## Undoing Mistakes (Decision Tree)

```
What do you want to undo?
│
├── Uncommitted changes in working directory
│   └── git restore <file>              (discard changes to file)
│       git restore .                   (discard all changes)
│
├── Staged changes (already did `git add`)
│   └── git restore --staged <file>     (unstage, keep changes)
│       git reset HEAD <file>           (alternative command)
│
├── Last commit (NOT pushed yet)
│   ├── Keep changes, redo commit
│   │   └── git reset --soft HEAD~1     (uncommit, keep staged)
│   │
│   ├── Keep changes, unstage them
│   │   └── git reset HEAD~1            (uncommit, unstage, keep files)
│   │       git reset --mixed HEAD~1    (same as above)
│   │
│   └── Discard everything
│       └── git reset --hard HEAD~1     (⚠ DANGEROUS: deletes changes)
│
├── Commit already pushed
│   └── git revert <commit-hash>        (creates new commit that undoes)
│       git revert HEAD                 (revert last commit)
│
└── Multiple commits back
    ├── Not pushed yet
    │   └── git reset --soft HEAD~3     (undo last 3 commits)
    │
    └── Already pushed
        └── git revert HEAD~2..HEAD     (revert range of commits)
```

### Quick Reference Commands

```bash
# Discard uncommitted changes
git restore filename.py
git restore .

# Unstage file (but keep changes)
git restore --staged filename.py

# Undo last commit, keep changes
git reset HEAD~1

# Undo last commit, discard changes (DANGEROUS)
git reset --hard HEAD~1

# Undo pushed commit (safe, creates new commit)
git revert HEAD
```

---

## Best Practices

### Commit Message Format (Conventional Commits)

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code change that neither fixes bug nor adds feature
- `test`: Adding tests
- `chore`: Maintenance, dependencies

**Examples**:
```bash
git commit -m "feat(auth): add password reset functionality"
git commit -m "fix(api): handle null response in user endpoint"
git commit -m "docs(readme): update installation instructions"
git commit -m "refactor(utils): simplify date formatting logic"
```

### Branch Naming Conventions

```
feature/short-description      # New features
bugfix/issue-description       # Bug fixes
hotfix/critical-fix           # Urgent production fixes
release/v1.2.0                # Release preparation
docs/what-changed             # Documentation updates

# Examples:
feature/user-profile
bugfix/login-error-handling
hotfix/payment-gateway-timeout
```

### When to Commit (Atomic Commits)

**Commit when you've completed**:
- A single logical change
- A bug fix
- A new function or class
- Refactoring one component
- A set of related changes that make sense together

**Don't commit**:
- Half-finished work (unless using WIP strategy)
- Multiple unrelated changes together
- Code that breaks tests
- Debugging print statements (clean up first)

### .gitignore Essentials

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
.env

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Project specific
/dist/
/build/
*.log
.coverage
htmlcov/

# Secrets (NEVER commit these)
*.pem
*.key
secrets.json
credentials.json
.env.local
```

---

## Common Scenarios

### "I committed to the wrong branch"

```bash
# Scenario: You're on main but meant to be on feature branch

# 1. Create the correct branch (keeps commit)
git branch feature/correct-branch

# 2. Reset main to before your commit
git reset --hard HEAD~1

# 3. Switch to the correct branch
git checkout feature/correct-branch

# Your commit is now on the correct branch!
```

### "I need to update my branch with main"

**Option 1: Merge** (safe, preserves history):
```bash
git checkout feature/my-feature
git fetch origin
git merge origin/main
# Resolve conflicts if any
```

**Option 2: Rebase** (cleaner history, if branch not shared):
```bash
git checkout feature/my-feature
git fetch origin
git rebase origin/main
# Resolve conflicts if any, then:
git rebase --continue
```

### "I want to undo my last commit"

**If NOT pushed yet**:
```bash
# Keep changes, redo commit
git reset --soft HEAD~1
# Make additional changes
git add .
git commit -m "Better commit message"

# OR discard commit entirely
git reset --hard HEAD~1  # ⚠ DANGEROUS
```

**If already pushed**:
```bash
# Create a new commit that undoes the previous
git revert HEAD
git push origin feature/my-feature
```

### "I'm in the middle of work but need to switch branches"

**Option 1: Stash** (temporary storage):
```bash
# Save current work
git stash save "WIP: working on user profile"

# Switch branches and do other work
git checkout main
# ... do stuff ...

# Come back and restore
git checkout feature/user-profile
git stash pop  # Reapplies changes and removes from stash

# View stashes
git stash list

# Apply without removing
git stash apply stash@{0}
```

**Option 2: WIP Commit** (commit and amend later):
```bash
# Commit work in progress
git add .
git commit -m "WIP: partial implementation"

# Switch branches
git checkout other-branch
# ... do stuff ...

# Come back and continue
git checkout feature/user-profile

# Undo the WIP commit, keep changes
git reset HEAD~1

# Or amend it when done
git add .
git commit --amend -m "Complete implementation"
```

**Option 3: Create temporary branch**:
```bash
# Create branch with current changes
git checkout -b temp/save-work

# Commit there
git add .
git commit -m "Saving work temporarily"

# Switch to needed branch
git checkout main
# ... do stuff ...

# Return and continue (or merge changes back)
git checkout temp/save-work
```

---

## Quick Command Reference

### Daily Commands
```bash
git status                  # Check current state
git pull                    # Get latest changes
git add <files>            # Stage changes
git commit -m "message"    # Commit staged changes
git push                   # Push commits to remote
git log --oneline -10      # View recent commits
```

### Branch Management
```bash
git branch                 # List local branches
git branch -a              # List all branches (including remote)
git checkout -b new-branch # Create and switch to branch
git branch -d branch-name  # Delete merged branch
git branch -D branch-name  # Force delete branch
```

### Viewing Changes
```bash
git diff                   # Unstaged changes
git diff --staged          # Staged changes
git diff main..feature     # Compare branches
git log --graph --oneline  # Visual commit history
git show <commit-hash>     # Show specific commit
```

### Remote Operations
```bash
git fetch                  # Download remote changes (don't merge)
git pull                   # Fetch + merge
git push -u origin branch  # Push and set upstream
git remote -v              # View remote repositories
```

---

## Tips for Success

1. **Commit early, commit often**: Small commits are easier to understand and revert
2. **Write meaningful messages**: Your future self will thank you
3. **Pull before you push**: Avoid conflicts by staying in sync
4. **Review before committing**: Use `git diff` and `git status`
5. **Test before pushing**: Don't break the build for others
6. **Branch for everything**: Even small fixes deserve a branch
7. **Keep main stable**: Never commit directly to main (in team projects)
8. **Communicate**: Coordinate with team on merge/rebase strategy

---

**Remember**: Git is forgiving. Most mistakes can be undone. When in doubt, make a backup branch before trying something risky:

```bash
git branch backup-before-experiment
# Now experiment freely
```
