#!/bin/bash
# Setup script for Git branching practice
# Creates a repository with branches and a pre-configured merge conflict

set -e

REPO_DIR="git-practice-branching"

# Clean up if exists
rm -rf "$REPO_DIR"

echo "Creating branching practice repository..."

# Create and initialize
mkdir "$REPO_DIR"
cd "$REPO_DIR"
git init

# Configure local user
git config user.email "practice@example.com"
git config user.name "Git Learner"

# Create initial content on main
echo "# Shopping List App

A simple app to manage shopping lists.
" > README.md

echo "items = []

def add_item(item):
    items.append(item)
    print(f'Added: {item}')

def list_items():
    for i, item in enumerate(items, 1):
        print(f'{i}. {item}')

def main():
    add_item('Milk')
    add_item('Bread')
    list_items()

if __name__ == '__main__':
    main()
" > shopping.py

git add README.md shopping.py
git commit -m "Initial commit: Shopping list app"

# Create feature branch with changes
git checkout -b feature/remove-item

echo "items = []

def add_item(item):
    items.append(item)
    print(f'Added: {item}')

def remove_item(item):
    if item in items:
        items.remove(item)
        print(f'Removed: {item}')
    else:
        print(f'Not found: {item}')

def list_items():
    for i, item in enumerate(items, 1):
        print(f'{i}. {item}')

def main():
    add_item('Milk')
    add_item('Bread')
    add_item('Eggs')
    remove_item('Bread')
    list_items()

if __name__ == '__main__':
    main()
" > shopping.py

git add shopping.py
git commit -m "Add remove_item function"

# Go back to main and make conflicting changes
git checkout main

echo "items = []

def add_item(item):
    items.append(item)
    print(f'Added: {item}')

def clear_items():
    items.clear()
    print('Cleared all items')

def list_items():
    if not items:
        print('List is empty')
        return
    for i, item in enumerate(items, 1):
        print(f'{i}. {item}')

def main():
    add_item('Milk')
    add_item('Bread')
    list_items()
    clear_items()
    list_items()

if __name__ == '__main__':
    main()
" > shopping.py

git add shopping.py
git commit -m "Add clear_items function and empty list check"

# Create another feature branch (no conflict)
git checkout -b feature/count-items

echo "def count_items():
    return len(items)
" >> shopping.py

git add shopping.py
git commit -m "Add count_items function"

# Return to main
git checkout main

echo ""
echo "=========================================="
echo "  Branching Practice Repository Ready!"
echo "=========================================="
echo ""
echo "Branches created:"
echo "  * main (current)"
echo "    feature/remove-item (will conflict with main)"
echo "    feature/count-items (clean merge)"
echo ""
echo "Try these exercises:"
echo ""
echo "1. View all branches:"
echo "   git branch -a"
echo ""
echo "2. Visualize the branches:"
echo "   git log --oneline --graph --all"
echo ""
echo "3. Practice a clean merge:"
echo "   git merge feature/count-items"
echo ""
echo "4. Practice resolving a conflict:"
echo "   git merge feature/remove-item"
echo "   # Edit shopping.py to resolve"
echo "   # git add shopping.py"
echo "   # git commit"
echo ""
