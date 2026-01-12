#!/bin/bash
# Setup script for basic Git practice
# Creates a simple repository for practicing add, commit, status, log

set -e

REPO_DIR="git-practice-basic"

# Clean up if exists
rm -rf "$REPO_DIR"

echo "Creating basic Git practice repository..."

# Create and initialize
mkdir "$REPO_DIR"
cd "$REPO_DIR"
git init

# Configure local user (so commits work without global config)
git config user.email "practice@example.com"
git config user.name "Git Learner"

# Create initial files
echo "# My Practice Project

This is a sample project for learning Git.
" > README.md

echo "def hello():
    print('Hello, World!')

if __name__ == '__main__':
    hello()
" > hello.py

echo "def add(a, b):
    return a + b

def subtract(a, b):
    return a - b
" > math_utils.py

# Make initial commit
git add README.md
git commit -m "Initial commit: Add README"

git add hello.py
git commit -m "Add hello world script"

git add math_utils.py
git commit -m "Add math utilities module"

# Create some untracked and modified files for practice
echo "
def multiply(a, b):
    return a * b
" >> math_utils.py

echo "# Notes

Things to remember about this project.
" > notes.txt

echo ""
echo "=========================================="
echo "  Basic Git Practice Repository Ready!"
echo "=========================================="
echo ""
echo "Current state:"
echo "- 3 commits in history"
echo "- 1 modified file (math_utils.py)"
echo "- 1 untracked file (notes.txt)"
echo ""
echo "Try these commands:"
echo "  cd $REPO_DIR"
echo "  git status        # See the current state"
echo "  git log --oneline # See commit history"
echo "  git diff          # See what's modified"
echo "  git add .         # Stage all changes"
echo "  git commit -m 'Your message'"
echo ""
