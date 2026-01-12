# Git Mental Model

Understanding Git's core concepts will transform it from "magical commands I memorize" to "a tool I actually understand."

## The Three Trees

Git manages your project using three main "trees" (collections of files):

```
┌─────────────────────┐
│  Working Directory  │  ← Your actual files (what you see in your editor)
│   (Modified files)  │
└──────────┬──────────┘
           │
           │  git add
           ↓
┌─────────────────────┐
│   Staging Area      │  ← Files prepared for next commit (the "index")
│  (Staged changes)   │
└──────────┬──────────┘
           │
           │  git commit
           ↓
┌─────────────────────┐
│    Repository       │  ← Permanent history stored in .git folder
│  (Commit history)   │
└─────────────────────┘
```

### Working Directory
- The files you can see and edit
- Your project folder as it exists on disk right now
- Can contain modified, untracked, or clean files

### Staging Area (Index)
- A preview of your next commit
- Files you've marked with `git add`
- Think of it as a shopping cart: you add items before "checking out"

### Repository (.git folder)
- Complete history of all commits
- Contains all snapshots of your project over time
- Hidden `.git` folder in your project root

### Flow Between Trees

```
Working Directory          Staging Area           Repository
    (WD)                      (Index)               (.git)

  app.py ─────git add────→  app.py ─────commit────→ Commit #abc123
  [modified]                [staged]                [permanent]

           ←────checkout─────────────────────────── Commit #def456
           [file restored to previous state]
```

## What is a Commit?

A commit is a **snapshot**, not a diff.

### Anatomy of a Commit

```
┌────────────────────────────────────────┐
│ Commit: abc123def456...                │
├────────────────────────────────────────┤
│ Tree: 789xyz...                        │  ← Snapshot of all files
│   ├─ src/                              │
│   │   └─ app.py (v3)                   │
│   ├─ README.md (v2)                    │
│   └─ config.json (v1)                  │
├────────────────────────────────────────┤
│ Parent: 111aaa222bbb...                │  ← Previous commit(s)
├────────────────────────────────────────┤
│ Author: Your Name <email>              │
│ Date: 2026-01-11 10:30:00              │
├────────────────────────────────────────┤
│ Message: "Add user authentication"     │
└────────────────────────────────────────┘
```

### Key Properties

- **Identified by SHA-1 hash**: 40-character hexadecimal string (e.g., `abc123def456...`)
- **Immutable**: Once created, a commit never changes
- **Complete snapshot**: Contains the full state of all files, not just changes
- **Parent pointer(s)**: Links to previous commit(s), forming a chain
- **Metadata**: Author, timestamp, commit message

### Commits Form a Chain

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│ Commit  │ ←── │ Commit  │ ←── │ Commit  │ ←── │ Commit  │
│  #111   │     │  #222   │     │  #333   │     │  #444   │
└─────────┘     └─────────┘     └─────────┘     └─────────┘
 "Initial"      "Add login"    "Fix bug"      "Add tests"
```

Each commit points backward to its parent, creating a linked history.

## What is a Branch?

A branch is **just a pointer to a commit**. That's it. Nothing more.

### Branch as a Pointer

```
                         ┌─────────┐
                         │  main   │  ← Branch (just a label/pointer)
                         └────┬────┘
                              │
                              ↓
┌─────────┐     ┌─────────┐     ┌─────────┐
│ Commit  │ ←── │ Commit  │ ←── │ Commit  │
│  #111   │     │  #222   │     │  #333   │
└─────────┘     └─────────┘     └─────────┘
```

### Creating a New Branch

When you create a branch, Git just creates a new pointer:

```
Before: git branch feature

                         ┌─────────┐
                         │  main   │
                         └────┬────┘
                              │
                              ↓
┌─────────┐     ┌─────────┐     ┌─────────┐
│ Commit  │ ←── │ Commit  │ ←── │ Commit  │
│  #111   │     │  #222   │     │  #333   │
└─────────┘     └─────────┘     └─────────┘


After: git branch feature

                         ┌─────────┐
                         │  main   │
                         └────┬────┘
                              │
                         ┌────┴────┐
                         │ feature │  ← New pointer to same commit
                         └────┬────┘
                              │
                              ↓
┌─────────┐     ┌─────────┐     ┌─────────┐
│ Commit  │ ←── │ Commit  │ ←── │ Commit  │
│  #111   │     │  #222   │     │  #333   │
└─────────┘     └─────────┘     └─────────┘
```

No files are copied. No commits are duplicated. Just a new 41-byte pointer file.

### Why Branches are "Cheap"

- Creating a branch = writing 41 bytes (the SHA-1 hash) to a file
- No files copied, no commits duplicated
- Instant operation, regardless of project size
- Deleting a branch = deleting that small file

### Branches Diverging

When you make commits on different branches:

```
                         ┌─────────┐
                         │  main   │
                         └────┬────┘
                              │
                              ↓
                         ┌─────────┐
                         │ Commit  │
                         │  #444   │
                         └─────────┘
                              ↑
                              │
┌─────────┐     ┌─────────┐  │
│ Commit  │ ←── │ Commit  │ ←┘
│  #111   │     │  #222   │
└─────────┘     └─────────┘
                      ↑
                      │
                 ┌─────────┐
                 │ Commit  │
                 │  #333   │
                 └─────────┘
                      ↑
                      │
                 ┌────┴────┐
                 │ feature │
                 └─────────┘
```

The commits diverge, but they share a common ancestor (#222).

## What is HEAD?

HEAD is a **pointer to a pointer** - it points to the current branch (usually).

### Normal State: HEAD → Branch → Commit

```
┌────────┐
│  HEAD  │  ← Special pointer (you are here)
└───┬────┘
    │
    ↓
┌────────┐
│  main  │  ← Current branch
└───┬────┘
    │
    ↓
┌─────────┐     ┌─────────┐     ┌─────────┐
│ Commit  │ ←── │ Commit  │ ←── │ Commit  │
│  #111   │     │  #222   │     │  #333   │
└─────────┘     └─────────┘     └─────────┘
```

When you make a commit, the current branch pointer moves forward:

```
Before commit:                    After commit:

┌────────┐                        ┌────────┐
│  HEAD  │                        │  HEAD  │
└───┬────┘                        └───┬────┘
    ↓                                 ↓
┌────────┐                        ┌────────┐
│  main  │                        │  main  │
└───┬────┘                        └───┬────┘
    │                                 │
    ↓                                 ↓
┌─────────┐                        ┌─────────┐
│ Commit  │                        │ Commit  │  ← New commit!
│  #333   │                        │  #444   │
└─────────┘                        └────┬────┘
                                        │
                                        ↓
                                   ┌─────────┐
                                   │ Commit  │
                                   │  #333   │
                                   └─────────┘
```

### Switching Branches

When you `git checkout feature` or `git switch feature`:

```
Before:                           After:

┌────────┐                        ┌────────┐
│  HEAD  │                        │  HEAD  │
└───┬────┘                        └───┬────┘
    ↓                                 │
┌────────┐                            │
│  main  │                            ↓
└───┬────┘                        ┌────────┐
    │                             │feature │
    ↓                             └───┬────┘
┌─────────┐                           │
│ Commit  │                           ↓
│  #333   │                       ┌─────────┐
└─────────┘                       │ Commit  │
                                  │  #555   │
┌────────┐                        └─────────┘
│feature │
└───┬────┘
    │
    ↓
┌─────────┐
│ Commit  │
│  #555   │
└─────────┘
```

HEAD now points to `feature` instead of `main`. Your working directory updates to match commit #555.

### Detached HEAD State

When HEAD points directly to a commit instead of a branch:

```
Normal:                           Detached:

┌────────┐                        ┌────────┐
│  HEAD  │                        │  HEAD  │
└───┬────┘                        └───┬────┘
    ↓                                 │
┌────────┐                            │  (no branch!)
│  main  │                            │
└───┬────┘                            ↓
    │                             ┌─────────┐
    ↓                             │ Commit  │
┌─────────┐                       │  #222   │
│ Commit  │                       └─────────┘
│  #333   │
└─────────┘                       (HEAD points directly to commit)
```

This happens when you:
- `git checkout abc123` (check out a specific commit)
- `git checkout origin/main` (check out a remote tracking branch)

Warning: Commits made in detached HEAD state can be lost if you don't create a branch.

## Remotes

A remote is a version of your repository hosted elsewhere (GitHub, GitLab, etc.).

### Local vs Remote Repositories

```
┌─────────────────────────────────────────────────────────────┐
│                    Your Computer (Local)                    │
│                                                             │
│  ┌────────┐                                                │
│  │  HEAD  │                                                │
│  └───┬────┘                                                │
│      ↓                                                      │
│  ┌────────┐        ┌─────────┐     ┌─────────┐           │
│  │  main  │────→   │ Commit  │ ←── │ Commit  │           │
│  └────────┘        │  #222   │     │  #333   │           │
│                    └─────────┘     └─────────┘           │
│                                                             │
│  ┌──────────────┐  ┌─────────┐                            │
│  │ origin/main  │─→│ Commit  │  ← Remote tracking branch  │
│  └──────────────┘  │  #222   │     (your local copy of    │
│                    └─────────┘      where origin/main is) │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ git push / git fetch
                       │
┌──────────────────────┴──────────────────────────────────────┐
│                  GitHub (Remote: origin)                    │
│                                                             │
│  ┌────────┐        ┌─────────┐                            │
│  │  main  │────→   │ Commit  │                            │
│  └────────┘        │  #222   │                            │
│                    └─────────┘                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Understanding origin

- `origin` is just the **default name** for the remote you cloned from
- Not special - you can rename it or have multiple remotes
- Defined in `.git/config`

```bash
# You have a local branch:
main

# And a remote tracking branch:
origin/main  # Your local snapshot of where GitHub's main is

# And the actual remote branch on GitHub:
[on GitHub] main
```

### Remote Tracking Branches

```
Local branches you work on:
┌────────┐
│  main  │  ← Your local main branch
└────────┘

Remote tracking branches (read-only references):
┌──────────────┐
│ origin/main  │  ← Local copy of where GitHub's main was last time you fetched
└──────────────┘

Actual remote branches (on GitHub):
┌──────────────────────┐
│ [GitHub] main        │  ← The real main branch on GitHub
└──────────────────────┘
```

### Git Push/Pull Flow

```
git fetch (download new commits):

  Local                          Remote (GitHub)
┌─────────┐                    ┌─────────┐
│  main   │                    │  main   │
└────┬────┘                    └────┬────┘
     │                              │
     ↓                              ↓
┌─────────┐     Download       ┌─────────┐     ┌─────────┐
│ Commit  │  ←───────────────  │ Commit  │ ←── │ Commit  │
│  #222   │      new commit    │  #222   │     │  #333   │
└─────────┘                    └─────────┘     └─────────┘
                                     ↑
                                     │
┌──────────────┐                     │
│ origin/main  │─────────────────────┘
└──────────────┘  (updates to #333)


git push (upload your commits):

  Local                          Remote (GitHub)
┌─────────┐                    ┌─────────┐
│  main   │                    │  main   │  ← Updates to #444
└────┬────┘                    └────┬────┘
     │                              │
     ↓                              ↓
┌─────────┐     Upload         ┌─────────┐
│ Commit  │  ─────────────→    │ Commit  │
│  #444   │    your commit     │  #444   │  (newly uploaded)
└────┬────┘                    └────┬────┘
     │                              │
     ↓                              ↓
┌─────────┐                    ┌─────────┐
│ Commit  │                    │ Commit  │
│  #333   │                    │  #333   │
└─────────┘                    └─────────┘
```

## Common Misconceptions

| Misconception | Reality |
|---------------|---------|
| "Git stores diffs/changes" | Git stores full snapshots of your entire project at each commit |
| "Branches are heavy/expensive" | Branches are just 41-byte pointers to commits |
| "Each branch has its own copy of files" | All commits share the same object database; branches just point to different commits |
| "git pull downloads files" | `git pull` = `git fetch` (download commits) + `git merge` (integrate them) |
| "Deleting a branch deletes commits" | Deleting a branch only removes the pointer; commits remain (for a while) |
| ".git folder contains files for each version" | .git contains compressed objects; Git reconstructs files when you check them out |
| "origin/main is on GitHub" | origin/main is a LOCAL branch that tracks the remote; it updates when you fetch |
| "Staging area is optional" | You always stage - even `git commit -a` stages for you automatically |
| "Commits are like Word's track changes" | Commits are complete snapshots, not incremental changes |
| "HEAD is the latest commit" | HEAD is a pointer to your current branch (or current commit if detached) |

## Analogies Reference

| Git Concept | Analogy | Explanation |
|-------------|---------|-------------|
| **Working Directory** | Your desk | The files you're actively working with right now |
| **Staging Area** | Shopping cart | You add items before "checking out" (committing) |
| **Repository** | Photo album | Permanent record of snapshots (commits) over time |
| **Commit** | Photograph | A snapshot of how everything looked at that moment |
| **Branch** | Bookmark | A lightweight pointer to a specific page (commit) |
| **HEAD** | "You are here" marker | Shows which bookmark you're currently using |
| **Merge** | Combining two photo albums | Integrate changes from two different histories |
| **Remote** | Shared photo album (cloud) | A copy of the repository hosted elsewhere |
| **Clone** | Downloading the album | Getting a complete copy of the repository |
| **Push** | Uploading new photos | Sending your commits to the remote repository |
| **Pull** | Syncing from cloud | Downloading and merging changes from the remote |
| **Tag** | Permanent label on a photo | Named pointer to a specific commit that doesn't move |
| **Stash** | Temporary drawer | Temporarily store changes without committing |
| **Rebase** | Rewriting history | Moving commits to start from a different point |

## The Big Picture

Git is fundamentally:

1. A **content-addressable filesystem** (stores snapshots, retrieves by hash)
2. With a **simple version control system** built on top (commits, branches, merges)
3. That supports **distributed collaboration** (remotes, push/pull)

Once you understand these core concepts:
- Commits are snapshots with parent pointers
- Branches are movable pointers to commits
- HEAD points to your current branch
- The three trees (working/staging/repository)
- Remotes are just other copies of the repository

Everything else in Git starts to make sense.

## Visualization: A Complete Example

```
Local Repository                           Remote (origin)
─────────────────                          ────────────────

Working Directory
┌─────────────────┐
│  app.py [edit]  │
│  README.md      │
└─────────────────┘
        │
        │ git add app.py
        ↓
Staging Area
┌─────────────────┐
│  app.py [ready] │
└─────────────────┘
        │
        │ git commit -m "Update app"
        ↓

┌────────┐                                 ┌────────┐
│  HEAD  │                                 │  main  │
└───┬────┘                                 └───┬────┘
    ↓                                          │
┌────────┐        ┌─────────┐                 ↓
│  main  │────→   │ Commit  │ [new!]      ┌─────────┐
└────────┘        │  #555   │             │ Commit  │
                  └────┬────┘             │  #444   │
                       │                  └────┬────┘
                       ↓                       │
┌──────────────┐  ┌─────────┐                ↓
│ origin/main  │─→│ Commit  │            ┌─────────┐
└──────────────┘  │  #444   │            │ Commit  │
                  └────┬────┘            │  #333   │
                       │                  └─────────┘
                       ↓
                  ┌─────────┐
                  │ Commit  │
                  │  #333   │
                  └─────────┘

After git push origin main:

┌────────┐                                 ┌────────┐
│  HEAD  │                                 │  main  │ ← updated!
└───┬────┘                                 └───┬────┘
    ↓                                          │
┌────────┐        ┌─────────┐                 ↓
│  main  │────→   │ Commit  │             ┌─────────┐
└────────┘        │  #555   │             │ Commit  │
                  └────┬────┘             │  #555   │ ← pushed
                       │                  └────┬────┘
                       ↓                       │
┌──────────────┐  ┌─────────┐                ↓
│ origin/main  │─→│ Commit  │ ← updates   ┌─────────┐
└──────────────┘  │  #555   │             │ Commit  │
                  └────┬────┘             │  #444   │
                       │                  └────┬────┘
                       ↓                       │
                  ┌─────────┐                ↓
                  │ Commit  │            ┌─────────┐
                  │  #444   │            │ Commit  │
                  └────┬────┘            │  #333   │
                       │                  └─────────┘
                       ↓
                  ┌─────────┐
                  │ Commit  │
                  │  #333   │
                  └─────────┘
```

## Key Takeaways

1. Git is simpler than it seems - it's just snapshots and pointers
2. Understanding the mental model makes commands intuitive
3. Most "magic" comes from moving pointers around
4. Branches are cheap - use them liberally
5. Your local repository is complete - you don't need the remote to work
6. Think in terms of commits (snapshots) and references (pointers)

Now when someone says "just rebase your feature branch onto main," you understand:
- `main` is a pointer to a commit
- `feature` is a pointer to another commit
- Rebasing moves the `feature` pointer's commits to start from where `main` points
- No magic - just moving snapshots and pointers around!
