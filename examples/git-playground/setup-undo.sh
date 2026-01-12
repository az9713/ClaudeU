#!/bin/bash
# Setup script for Git undo practice
# Creates a repository with history for practicing reset, revert, stash

set -e

REPO_DIR="git-practice-undo"

# Clean up if exists
rm -rf "$REPO_DIR"

echo "Creating undo practice repository..."

# Create and initialize
mkdir "$REPO_DIR"
cd "$REPO_DIR"
git init

# Configure local user
git config user.email "practice@example.com"
git config user.name "Git Learner"

# Create a series of commits
echo "# Calculator

A simple calculator module.
" > README.md
git add README.md
git commit -m "Initial commit"

echo "def add(a, b):
    return a + b
" > calculator.py
git add calculator.py
git commit -m "Add addition function"

echo "def add(a, b):
    return a + b

def subtract(a, b):
    return a - b
" > calculator.py
git add calculator.py
git commit -m "Add subtraction function"

echo "def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b
" > calculator.py
git add calculator.py
git commit -m "Add multiplication function"

echo "def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    return a / b  # Bug: no zero check!
" > calculator.py
git add calculator.py
git commit -m "Add division function (has bug)"

echo "def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    if b == 0:
        raise ValueError('Cannot divide by zero')
    return a / b
" > calculator.py
git add calculator.py
git commit -m "Fix division by zero bug"

# Add some uncommitted work for stash practice
echo "
def power(a, b):
    return a ** b
" >> calculator.py

echo "# TODO: Add more operations" > notes.txt

echo ""
echo "=========================================="
echo "  Undo Practice Repository Ready!"
echo "=========================================="
echo ""
echo "Commit history (oldest to newest):"
git log --oneline
echo ""
echo "Current state:"
echo "- 6 commits in history"
echo "- 1 modified file (calculator.py - has new power function)"
echo "- 1 untracked file (notes.txt)"
echo ""
echo "Practice exercises:"
echo ""
echo "1. View history:"
echo "   git log --oneline"
echo ""
echo "2. Stash your current work:"
echo "   git stash push -m 'WIP: power function'"
echo "   git stash list"
echo "   git stash pop"
echo ""
echo "3. Reset to previous commit (soft - keeps changes staged):"
echo "   git reset --soft HEAD~1"
echo ""
echo "4. Reset to previous commit (mixed - unstages changes):"
echo "   git reset HEAD~1"
echo ""
echo "5. Reset to previous commit (hard - discards changes):"
echo "   git reset --hard HEAD~1"
echo "   # Use reflog to recover: git reflog"
echo ""
echo "6. Revert a specific commit (creates new commit):"
echo "   git revert HEAD~2  # Revert the 'multiply' commit"
echo ""
echo "7. Recover 'lost' commits:"
echo "   git reflog"
echo "   git checkout <hash>"
echo ""
