# Git Playground

A safe sandbox for practicing Git commands without fear of breaking anything important.

## What This Is

This directory contains scripts that create pre-configured Git repositories for practicing specific concepts. Each scenario sets up a repository with a particular state so you can practice the relevant commands.

## How to Use

1. Run the setup script for the scenario you want to practice
2. Navigate to the created directory
3. Practice the commands
4. Delete the directory when done (or run setup again to reset)

## Available Scenarios

### 1. Basic Practice (`setup-basic.sh`)

Creates a simple repository for practicing:
- `git status`, `git add`, `git commit`
- Viewing history with `git log`
- Making and staging changes

```bash
./setup-basic.sh
cd git-practice-basic
```

### 2. Branching Practice (`setup-branching.sh`)

Creates a repository with multiple branches for practicing:
- Creating and switching branches
- Merging branches
- Resolving merge conflicts (pre-configured!)

```bash
./setup-branching.sh
cd git-practice-branching
```

### 3. Undo Practice (`setup-undo.sh`)

Creates a repository with history for practicing:
- `git reset` (soft, mixed, hard)
- `git revert`
- `git stash`
- Recovering with `git reflog`

```bash
./setup-undo.sh
cd git-practice-undo
```

## Starting Fresh

To reset any scenario, simply:

```bash
rm -rf git-practice-*
./setup-[scenario].sh
```

## Tips

- **Don't be afraid to experiment!** These repos are disposable
- Run `git status` frequently to see what's happening
- Run `git log --oneline --graph --all` to visualize branches
- Use `git reflog` if you think you've lost something

## Why Practice in a Sandbox?

Learning Git by experimenting on real projects is stressful. What if you lose your work? What if you mess up the history?

These practice repositories contain no important data. You can:
- Run `git reset --hard` without fear
- Force push (though there's no remote)
- Delete branches accidentally
- Create merge conflicts on purpose

Break things. That's how you learn!

## Related Resources

- Tutorial notebooks: `tutor/notebooks/git/`
- Command reference: `tutor/reference/git/commands-cheatsheet.md`
- Mental model guide: `tutor/reference/git/mental-model.md`
- Workflow patterns: `tutor/reference/git/workflows-cheatsheet.md`
