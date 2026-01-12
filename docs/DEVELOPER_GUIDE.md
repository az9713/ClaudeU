# ClaudeU - Developer Guide

A comprehensive guide for developers who want to understand, modify, or extend the ClaudeU project. This guide assumes you have programming experience (C, C++, Java) but may be new to Python, web development, or AI-assisted tools.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Understanding the Big Picture](#2-understanding-the-big-picture)
3. [Development Environment Setup](#3-development-environment-setup)
4. [Project Architecture Deep Dive](#4-project-architecture-deep-dive)
5. [Understanding Each File](#5-understanding-each-file)
6. [How Claude Code Output Styles Work](#6-how-claude-code-output-styles-work)
7. [The Tutor Type System](#7-the-tutor-type-system)
8. [The /tutor Command](#8-the-tutor-command)
9. [Web Scraping Fundamentals](#9-web-scraping-fundamentals)
10. [Working with Jupyter Notebooks](#10-working-with-jupyter-notebooks)
11. [Extending the Project](#11-extending-the-project)
12. [Testing and Quality Assurance](#12-testing-and-quality-assurance)
13. [Deployment and Distribution](#13-deployment-and-distribution)
14. [Glossary](#14-glossary)

---

## 1. Introduction

### What is ClaudeU?

ClaudeU is **not** just a single tutor - it's a **framework for building your own personalized AI university**. At its core, it's a behavioral configuration system for Claude Code that lets you create unlimited tutors for any subject, each teaching in whatever style works best for you.

**Key Concept**: Think of it as a tutor factory. The included Python, Git, and Stock tutors are examples - but you can create tutors for cooking, chess, music theory, languages, or literally anything you want to learn.

### The Vision: Unlimited Customization

This framework enables:
- **Unlimited topic tutors**: Create a tutor for any subject you want to learn
- **Unlimited teaching methods**: Invent new pedagogical approaches
- **Mix and match**: Combine any method with any topic (socratic + cooking-tutor, eli5 + chess-tutor)
- **Personal ownership**: Your tutor library grows over time - your own AI university

### Why Does This Exist?

Many beginners use AI tools to generate code without understanding what the code does. But more broadly, people want **personalized education** that adapts to their learning style and interests. This framework addresses both by:
- Teaching concepts instead of providing ready-to-paste solutions
- Using the learner's own materials as teaching context
- Creating hands-on practice artifacts
- Allowing complete customization of both WHAT is taught and HOW

### Who Is This Guide For?

This guide is for developers who:
- Want to create new tutors for any subject
- Want to invent new teaching methods
- Want to customize how existing tutors teach
- Want to build a personal library of AI tutors
- Are learning modern Python development practices

---

## 2. Understanding the Big Picture

### System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                           USER'S COMPUTER                           │
│                                                                     │
│  ┌─────────────────┐    ┌──────────────────┐    ┌───────────────┐  │
│  │   Claude Code   │───▶│ Output Style     │───▶│  Claude AI    │  │
│  │   (CLI Tool)    │    │ (python-tutor.md)│    │  (API)        │  │
│  └─────────────────┘    └──────────────────┘    └───────────────┘  │
│          │                       │                       │          │
│          │                       │                       │          │
│          ▼                       ▼                       ▼          │
│  ┌─────────────────┐    ┌──────────────────┐    ┌───────────────┐  │
│  │  User's Project │    │ tutor/ directory │    │ Teaching      │  │
│  │  (any code)     │    │ - notebooks/     │    │ Responses     │  │
│  │                 │    │ - reference/     │    │               │  │
│  └─────────────────┘    └──────────────────┘    └───────────────┘  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### How It Works - Step by Step

1. **User starts Claude Code** in their project directory
2. **Output style loads** from `.claude/output-styles/python-tutor.md`
3. **User asks a question** (e.g., "What is a list comprehension?")
4. **Claude reads the output style** instructions
5. **Claude responds pedagogically** instead of just writing code
6. **Claude may create notebooks** in `tutor/notebooks/` for practice
7. **Claude may create cheatsheets** in `tutor/reference/` for quick reference

### For C/C++/Java Developers: What's Different Here?

| Aspect | Traditional Development | This Project |
|--------|------------------------|--------------|
| Compilation | Compile to executable | Interpreted Python (no compilation) |
| Build System | Makefile, CMake, Maven | `pyproject.toml` + `uv` package manager |
| IDE | Visual Studio, Eclipse, IntelliJ | VS Code + Jupyter Lab |
| Libraries | Header files, .dll/.so/.jar | pip packages |
| Entry Point | `main()` function | No single entry point - notebooks run cell by cell |

---

## 3. Development Environment Setup

### Prerequisites

Before starting, ensure you have:
- A computer with Windows 10+, macOS 10.15+, or Linux
- Administrative access to install software
- A terminal/command prompt
- Internet connection

### Step 1: Install Python 3.13+

**Why Python 3.13?** This project uses Python 3.13 features. Older versions won't work.

#### Windows

1. Go to https://www.python.org/downloads/
2. Download "Python 3.13.x" (the latest 3.13 version)
3. Run the installer
4. **IMPORTANT**: Check "Add Python to PATH" at the bottom of the installer
5. Click "Install Now"
6. Verify installation:
   ```cmd
   python --version
   ```
   You should see `Python 3.13.x`

#### macOS

Option 1 - Official installer:
1. Go to https://www.python.org/downloads/
2. Download and install Python 3.13

Option 2 - Using Homebrew (recommended):
```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Python
brew install python@3.13

# Verify
python3 --version
```

#### Linux (Ubuntu/Debian)

```bash
# Add deadsnakes PPA for latest Python
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.13 python3.13-venv python3.13-dev

# Verify
python3.13 --version
```

### Step 2: Install UV Package Manager (Recommended)

UV is a fast, modern Python package manager. It's optional but recommended.

#### Windows (PowerShell)
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

#### macOS/Linux
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Verify installation:
```bash
uv --version
```

### Step 3: Install Claude Code

Claude Code is Anthropic's official CLI for Claude.

```bash
# Install via npm (requires Node.js)
npm install -g @anthropic-ai/claude-code

# OR install via pip
pip install claude-code

# Verify
claude --version
```

**Note**: You'll need an Anthropic API key. Set it as an environment variable:
```bash
# Windows (PowerShell)
$env:ANTHROPIC_API_KEY="your-api-key-here"

# macOS/Linux
export ANTHROPIC_API_KEY="your-api-key-here"
```

### Step 4: Clone and Set Up the Project

```bash
# Clone the repository
git clone https://github.com/ShawhinT/AI-Builders-Bootcamp-8.git

# Navigate to the python-tutor directory
cd AI-Builders-Bootcamp-8/python-tutor

# Install dependencies using UV (recommended)
uv sync

# OR install using pip
pip install jupyterlab ipykernel

# For the example notebook, also install:
pip install requests beautifulsoup4 pandas
```

### Step 5: Verify Your Setup

Run these commands to verify everything works:

```bash
# Check Python version (should be 3.13+)
python --version

# Check that Jupyter is installed
jupyter --version

# Start Jupyter Lab (opens in browser)
jupyter lab

# In a new terminal, start Claude Code
claude
```

In Claude Code, type:
```
/output-style python-tutor
```

You should see a confirmation that the tutor style is active.

---

## 4. Project Architecture Deep Dive

### Directory Structure Explained

```
python-tutor/
│
├── .claude/                          # Claude Code configuration
│   ├── output-styles/                # Custom behavior definitions
│   │   ├── python-tutor.md           # Topic tutor: Python basics
│   │   ├── git-tutor.md              # Topic tutor: Git version control
│   │   ├── stock-indicators-tutor.md # Topic tutor: Financial indicators
│   │   ├── socratic.md               # Method: guiding questions only
│   │   ├── rubber-duck.md            # Method: explain your thinking
│   │   ├── eli5.md                   # Method: simple analogies
│   │   ├── challenge-first.md        # Method: puzzle before explanation
│   │   └── minimalist.md             # Method: ultra-concise responses
│   └── commands/                     # Custom slash commands
│       └── tutor.md                  # /tutor command for managing tutors
│
├── tutor/                            # Generated teaching materials
│   ├── notebooks/                    # Practice Jupyter notebooks
│   │   └── web-scraping/             # Domain-specific notebooks
│   │       └── html-and-beautifulsoup.ipynb
│   └── reference/                    # Quick reference cheatsheets
│       └── web-scraping/             # Domain-specific cheatsheets
│           └── beautifulsoup-cheatsheet.md
│
├── docs/                             # Documentation (you're reading it)
│   ├── DEVELOPER_GUIDE.md            # This file
│   ├── USER_GUIDE.md                 # For learners
│   ├── QUICK_START.md                # 5-minute setup
│   ├── TUTOR_COMMAND.md              # /tutor command reference
│   └── WHY_OUTPUT_STYLES.md          # Rationale for output styles
│
├── example.ipynb                     # Working example for students
├── pyproject.toml                    # Project metadata and dependencies
├── .python-version                   # Specifies Python 3.13
├── .gitignore                        # Files to exclude from git
├── uv.lock                           # Locked dependency versions
├── README.md                         # Project overview
└── CLAUDE.md                         # Quick reference for Claude Code
```

### How Files Relate to Each Other

```
User types question in Claude Code
            │
            ▼
┌───────────────────────────────────┐
│ .claude/output-styles/            │
│     python-tutor.md               │◀── Defines HOW Claude responds
│                                   │
│  - Teaching behaviors             │
│  - Artifact creation rules        │
│  - Target user profile            │
└───────────────────────────────────┘
            │
            │ Claude reads user's files
            ▼
┌───────────────────────────────────┐
│ example.ipynb                     │◀── Sample code for teaching
│                                   │
│  - Real, working code             │
│  - Web scraping example           │
│  - BeautifulSoup usage            │
└───────────────────────────────────┘
            │
            │ Claude creates learning materials
            ▼
┌───────────────────────────────────┐
│ tutor/                            │◀── Generated teaching artifacts
│   ├── notebooks/                  │
│   │   └── concept.ipynb           │    Hands-on practice
│   └── reference/                  │
│       └── cheatsheet.md           │    Quick reference
└───────────────────────────────────┘
```

### Configuration Files Explained

#### `pyproject.toml` - Project Definition

This file (TOML format) defines the project. It's similar to `pom.xml` in Maven or `package.json` in Node.js.

```toml
[project]
name = "python-tutor"           # Project name
version = "0.1.0"               # Semantic version
description = "Add your description here"
readme = "README.md"            # Points to readme file
requires-python = ">=3.13"      # Minimum Python version

dependencies = [                 # Required packages
    "ipykernel>=7.1.0",         # Jupyter kernel
    "jupyterlab>=4.5.1",        # Notebook interface
]
```

**For C/C++ developers**: This replaces Makefiles. Python uses this file to understand what packages to install.

**For Java developers**: This is like `pom.xml` - it declares dependencies that are downloaded automatically.

#### `.python-version` - Version Lock

Contains just one line:
```
3.13
```

This tells tools like `pyenv` and `uv` which Python version to use.

#### `uv.lock` - Dependency Lock

This file locks exact versions of all dependencies (including transitive ones). Similar to `package-lock.json` in Node.js. **Never edit this manually** - it's generated by `uv sync`.

---

## 5. Understanding Each File

### `.claude/output-styles/python-tutor.md`

This is the heart of the project. Let's break it down:

```markdown
---
name: python-tutor
description:
  Pedagogical Python assistant for complete beginners...
---
```

**Frontmatter** (between `---`): Metadata about the style.

```markdown
## Core Constraint

**Teaching only, no implementation.**
```

**The key rule**: Claude will describe changes but not write production code.

```markdown
## Target User

Complete beginner to programming:
- Has never written code before
- Using AI tools to generate functional code
- Accumulating code faster than understanding
```

**User profile**: This shapes all of Claude's responses.

```markdown
## Core Behaviors

### 1. Explain Code
When asked about a file or snippet:
- One-sentence plain English summary
- Summarize key steps in a numbered list
- Highlight 3 key concepts, tricks, or tools used
```

**Behavior definitions**: Six distinct ways Claude responds to different queries.

### `example.ipynb` - The Teaching Example

This Jupyter notebook demonstrates web scraping. Let's understand its structure:

**Cell 1-2: Imports**
```python
import requests         # Makes HTTP requests (like a web browser)
from bs4 import BeautifulSoup  # Parses HTML
import json            # Handles JSON data
import re              # Regular expressions for text patterns
import pandas as pd    # Data analysis and CSV handling
```

**For C/C++ developers**: `import` is like `#include`, but it loads Python modules at runtime, not compile time.

**For Java developers**: `import` works similarly to Java, but Python doesn't have packages in the same way - modules are just `.py` files.

**Cell 3-4: Collecting Job URLs**
```python
job_url_list = []

for i in range(5):
    url = f"https://aijobs.ai/engineer?location=United%20States&page={i+1}"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")
    job_cards = soup.find_all("a", class_="jobcardStyle1")
    job_urls_temp = sorted({a["href"] for a in job_cards if a.get("href")})
    job_url_list = job_url_list + job_urls_temp
```

**What this does**:
1. Creates an empty list to store URLs
2. Loops through 5 pages of job listings
3. Downloads each page's HTML
4. Parses the HTML with BeautifulSoup
5. Finds all links with class "jobcardStyle1"
6. Extracts the URLs and adds them to the list

**For C/C++ developers**:
- `[]` creates a dynamic array (like `std::vector`)
- `for i in range(5)` is like `for(int i=0; i<5; i++)`
- `f"string {variable}"` is string interpolation (like `printf` but safer)
- `{...}` inside the comprehension creates a set (unique values only)

**Cell 5-6: The `extract_job_data` Function**

This function extracts structured data from a job posting page. It's complex because websites vary, so it has fallback strategies:

1. **Try JSON-LD first**: Many sites embed structured data
2. **Fall back to DOM**: If no JSON-LD, search the HTML directly

**For Java developers**: The function uses Python's optional typing with `def function(param: Type) -> ReturnType`.

### `tutor/notebooks/web-scraping/html-and-beautifulsoup.ipynb`

This notebook teaches BeautifulSoup concepts progressively:

1. **Simplest example**: Parse one tag
2. **Multiple tags**: Use `find()` vs `find_all()`
3. **Classes**: Filter by CSS class names
4. **Connection to real code**: Reference `example.ipynb`
5. **Practice exercise**: Hands-on challenge

### `tutor/reference/web-scraping/beautifulsoup-cheatsheet.md`

A quick reference guide that:
- Lists common BeautifulSoup methods
- Shows examples from the actual codebase
- Includes line number references
- Has a "Common Mistakes" section

---

## 6. How Claude Code Output Styles Work

### What Are Output Styles?

Output styles are markdown files that customize how Claude responds. They're loaded when you run `/output-style <name>` in Claude Code.

### Why Output Styles Instead of Ad-hoc Prompting?

You can always prompt Claude directly to behave a certain way. But output styles offer significant architectural advantages:

| Aspect | Ad-hoc Prompting | Output Style |
|--------|------------------|--------------|
| **Persistence** | Per-message | Per-session |
| **Constraint enforcement** | Unreliable | Consistent |
| **Prompt overhead** | High (repeat instructions) | Zero (just ask questions) |
| **Completeness** | Usually incomplete | Structured, complete |
| **Switching contexts** | Paragraph of text | One command |
| **Shareability** | Copy-paste text | Copy file |
| **Version control** | Not practical | Git-friendly |
| **Project defaults** | Not possible | settings.local.json |
| **Artifact locations** | Random | Defined structure |

**The mental model:** Output styles are "compiled" personas - defined once, running consistently. Ad-hoc prompting is "interpreted" - must re-parse each time.

For tutors specifically, this means:
- Teaching constraints are **always enforced** (won't accidentally write code for you)
- Artifact locations are **predictable** (notebooks always in `tutor/notebooks/`)
- Switching between Python, Git, and Stock tutors is **one command**

[Read the full explanation](WHY_OUTPUT_STYLES.md)

### Style File Structure

```markdown
---
name: style-name
description: Brief description
---

# Custom Style Instructions

[Instructions that shape Claude's behavior]
```

### Where Styles Are Stored

**User-level** (applies to all projects):
```
~/.claude/output-styles/style-name.md
```

**Project-level** (applies to current project only):
```
project-root/.claude/output-styles/style-name.md
```

### Creating Your Own Style

1. Create the directory structure:
   ```bash
   mkdir -p .claude/output-styles
   ```

2. Create your style file:
   ```markdown
   ---
   name: my-custom-style
   description: What this style does
   ---

   # Custom Instructions

   ## How to Respond
   [Your instructions here]

   ## Examples
   [Show Claude what you want]
   ```

3. Activate it:
   ```
   /output-style my-custom-style
   ```

### Making a Style Permanent

Create `.claude/settings.local.json`:
```json
{
  "outputStyle": "python-tutor"
}
```

Now the style loads automatically when you start Claude Code in that directory.

---

## 7. The Tutor Type System

### Understanding Tutor Types

This project uses a **type system** to organize tutors. Every tutor file has a `type` field in its YAML frontmatter:

```yaml
---
name: tutor-name
type: method  # or 'topic' or 'combined'
description: What this tutor does
---
```

### The Three Types

| Type | Purpose | Examples |
|------|---------|----------|
| `method` | Defines HOW to teach (pedagogy) | socratic, eli5, rubber-duck |
| `topic` | Defines WHAT to teach (domain) | python-tutor, git-tutor |
| `combined` | Generated from method + topic | socratic-python-tutor |

### Method Tutors

Method tutors define a **teaching approach** that works with any subject:

```yaml
---
name: socratic
type: method
description: Teaches through guiding questions - never gives direct answers
keep-coding-instructions: false
---
```

**Key characteristics:**
- `keep-coding-instructions: false` - Makes them general-purpose (not coding-specific)
- Define interaction patterns, not domain knowledge
- Can be combined with any topic tutor

**Available methods:**
| Method | Core Approach |
|--------|---------------|
| `socratic` | Only asks guiding questions, never gives direct answers |
| `rubber-duck` | Makes user explain their thinking before offering insight |
| `eli5` | Uses simple analogies, no jargon ("Explain Like I'm 5") |
| `challenge-first` | Poses a puzzle before explaining the concept |
| `minimalist` | Ultra-concise responses under 50 words |

### Topic Tutors

Topic tutors define **domain knowledge** and teaching constraints:

```yaml
---
name: python-tutor
type: topic
description: Pedagogical Python assistant for complete beginners
---
```

**Key characteristics:**
- Define what subject matter to teach
- Include artifact locations (notebooks, cheatsheets)
- Define target user profile
- Set domain-specific constraints (e.g., "no trading advice")

**Available topics:**
| Topic | Domain |
|-------|--------|
| `python-tutor` | Python programming for beginners |
| `git-tutor` | Git version control with visual diagrams |
| `stock-indicators-tutor` | Financial indicators and analysis |

### Combined Tutors

Combined tutors merge a method with a topic:

```yaml
---
name: socratic-python-tutor
type: combined
description: Python tutor using Socratic questioning method
source-method: socratic
source-topic: python-tutor
---
```

**How they work:**
- Created via `/tutor combine <method> <topic>`
- Inherit teaching approach from method
- Inherit domain knowledge from topic
- Stored with method-first naming: `socratic-python-tutor.md`

### Creating a New Method Tutor

1. Create file in `.claude/output-styles/`:
   ```markdown
   ---
   name: your-method
   type: method
   description: One-line description
   keep-coding-instructions: false
   ---

   # Your Method Tutor

   ## Core Constraint
   **The key rule that defines this method.**

   ## How to Respond
   [Interaction patterns]

   ## Example Interaction
   [Show expected behavior]

   ## Boundary Test
   [How to check if you're following the method]
   ```

2. Test it: `/output-style your-method`

### Creating a New Topic Tutor

1. Create file in `.claude/output-styles/`:
   ```markdown
   ---
   name: your-topic-tutor
   type: topic
   description: One-line description
   ---

   # Your Topic Tutor

   ## Core Constraint
   **What this tutor will NOT do.**

   ## Target User
   [Who this tutor is for]

   ## Core Behaviors
   [Teaching behaviors specific to this domain]

   ## Artifacts
   - Notebooks: `tutor/notebooks/your-domain/`
   - Cheatsheets: `tutor/reference/your-domain/`
   ```

2. Test it: `/output-style your-topic-tutor`

### Backward Compatibility

Files without a `type` field are treated as `type: topic` for backward compatibility with existing tutors.

---

## 8. The /tutor Command

### What Is It?

The `/tutor` command is a custom slash command that provides a unified interface for managing all tutors. It's defined in `.claude/commands/tutor.md`.

### Available Subcommands

| Subcommand | Syntax | Purpose |
|------------|--------|---------|
| `list` | `/tutor list` | Show all tutors by type (fast - no file reads) |
| `describe` | `/tutor describe <name>` | Show tutor details |
| `combine` | `/tutor combine <A> <B>` | Create combined tutor |
| `create` | `/tutor create <name>` | Interactively create new tutor |
| `activate` | `/tutor activate <name>` | Instructions to activate |
| `delete` | `/tutor delete <name>` | Delete a tutor (with confirmation) |

### How `/tutor list` Works

For performance, `/tutor list` uses **filename-based type inference** instead of reading file contents:

| Pattern | Inferred Type |
|---------|---------------|
| Known methods: `socratic`, `eli5`, `rubber-duck`, `minimalist`, `challenge-first` | `method` |
| Ends with `-tutor` (e.g., `python-tutor`, `git-tutor`) | `topic` |
| Contains known method + another part (e.g., `socratic-python-tutor`) | `combined` |
| Anything else | `topic` (default) |

**Naming convention**: Topic tutors **must** end with `-tutor` (e.g., `python-tutor`) for correct type inference.

**Trade-off**: No descriptions shown in list output. Use `/tutor describe <name>` for details.

### How `/tutor delete` Works

The delete subcommand safely removes tutor files with confirmation:

1. **Validates** the tutor exists
2. **Prompts** for confirmation (cannot be undone)
3. **Deletes** the file from `.claude/output-styles/`
4. **Confirms** deletion

```
/tutor delete music-tutor

> Delete tutor 'music-tutor'? This cannot be undone.
> [Yes, delete it]

Deleted 'music-tutor'.
```

### How `/tutor combine` Works

#### Naming Normalization

To prevent duplicates, filenames are normalized:

| Combination | Output Filename |
|-------------|-----------------|
| method + topic | `METHOD-TOPIC.md` |
| topic + method | `METHOD-TOPIC.md` (swapped) |
| method + method | Alphabetical order |
| topic + topic | Alphabetical order |

**Example:**
```bash
/tutor combine socratic python-tutor  → socratic-python-tutor.md
/tutor combine python-tutor socratic  → socratic-python-tutor.md (same file!)
```

#### Validation

The command warns (but doesn't block) unusual combinations:
- **method + method**: "May produce conflicting instructions"
- **topic + topic**: "Will mix domains"

Users can proceed if they confirm.

#### Existence Checking

If the normalized filename already exists, the user is prompted:
```
socratic-python-tutor already exists. Regenerate? (y/n)
```

### How `/tutor create` Works

Interactive wizard that asks:

**For methods:**
1. Core teaching approach
2. Key constraint
3. Example interaction (optional)

**For topics:**
1. Domain/subject
2. Target user
3. What NOT to do

### Implementation Details

The command file (`.claude/commands/tutor.md`) contains:
- Frontmatter with allowed tools (Read, Write, Glob, Grep, Bash, AskUserQuestion)
- Subcommand routing logic
- Filename-based type inference rules for `/tutor list`
- Templates for file generation
- Confirmation flows for delete operations
- Error handling patterns

See [TUTOR_COMMAND.md](TUTOR_COMMAND.md) for complete documentation.

### Extending the /tutor Command

To add a new subcommand:

1. Open `.claude/commands/tutor.md`
2. Add a new section with the subcommand name
3. Define the trigger pattern
4. Specify the action steps
5. Include error handling

---

## 9. Web Scraping Fundamentals

Since the example uses web scraping, here's a primer for developers new to this domain.

### What is Web Scraping?

Web scraping extracts data from websites programmatically. It involves:
1. **Requesting** a web page (like a browser does)
2. **Parsing** the HTML structure
3. **Extracting** specific elements
4. **Storing** the data

### The HTTP Request/Response Cycle

```
Your Python Code                    Web Server
      │                                  │
      │  GET /page.html HTTP/1.1         │
      │─────────────────────────────────▶│
      │                                  │
      │  200 OK                          │
      │  Content-Type: text/html         │
      │  <html>...</html>                │
      │◀─────────────────────────────────│
      │                                  │
```

**In code**:
```python
import requests

response = requests.get("https://example.com/page.html")
html_content = response.text  # The raw HTML string
```

### HTML Structure Basics

HTML is a tree of nested elements (tags):

```html
<html>
  <body>
    <div class="job-listing">
      <h1>Software Engineer</h1>
      <p class="company">TechCorp</p>
      <a href="/apply/123">Apply Now</a>
    </div>
  </body>
</html>
```

**Key concepts**:
- **Tags**: `<h1>`, `<p>`, `<a>`, `<div>` - define element types
- **Attributes**: `class="job-listing"`, `href="/apply/123"` - extra info
- **Text content**: "Software Engineer", "TechCorp" - visible text
- **Nesting**: Elements contain other elements

### BeautifulSoup: The Parser

BeautifulSoup turns HTML strings into searchable Python objects:

```python
from bs4 import BeautifulSoup

html = "<h1>Hello</h1>"
soup = BeautifulSoup(html, "html.parser")

# Find elements
heading = soup.find("h1")       # Find first <h1>
all_links = soup.find_all("a")  # Find all <a> tags

# Get content
text = heading.text             # "Hello"
url = link["href"]              # Get attribute value
```

### CSS Selectors

CSS selectors let you target specific elements:

| Selector | Meaning |
|----------|---------|
| `h1` | All `<h1>` tags |
| `.job-listing` | Elements with `class="job-listing"` |
| `#main` | Element with `id="main"` |
| `div.job-listing` | `<div>` tags with that class |
| `div p` | `<p>` tags inside `<div>` tags |

**In BeautifulSoup**:
```python
soup.select_one(".job-listing")       # First match
soup.select(".job-listing")           # All matches
soup.select("div.job-listing h1")     # Nested search
```

---

## 10. Working with Jupyter Notebooks

### What Are Jupyter Notebooks?

Jupyter notebooks (`.ipynb` files) mix code, output, and documentation. They're interactive - you run cells one at a time and see results immediately.

**For C/C++ developers**: Instead of compile → run → view output, you write code in cells and execute each cell individually. Output appears inline.

**For Java developers**: Think of it like a REPL with persistent state and rich output formatting.

### Notebook Structure

A notebook is JSON internally, containing:
- **Cells**: Either code (Python) or markdown (documentation)
- **Outputs**: Results from running code cells
- **Metadata**: Kernel info, cell IDs

### Starting Jupyter Lab

```bash
# From the project directory
jupyter lab
```

This opens a browser tab with the Jupyter interface.

### Basic Operations

| Action | Keyboard Shortcut |
|--------|-------------------|
| Run cell | Shift+Enter |
| Run cell, stay in place | Ctrl+Enter |
| Insert cell below | B |
| Insert cell above | A |
| Delete cell | DD (press D twice) |
| Change to markdown | M |
| Change to code | Y |
| Save notebook | Ctrl+S |

### Creating a Teaching Notebook

Follow this structure (from the python-tutor style):

1. **Simplest example with output**
   ```python
   # Show the most basic usage
   result = simple_function()
   print(result)
   ```

2. **Break down what happened**
   ```markdown
   ### What happened?
   1. First, we...
   2. Then, it...
   ```

3. **Experiment prompt**
   ```markdown
   ### 🧪 Experiment: Change X and see what happens
   ```

4. **Build up one element**
   ```python
   # Add complexity incrementally
   ```

5. **Connect to actual code**
   ```markdown
   ### In Your Project
   This is used in `example.ipynb` line 45...
   ```

6. **Practice exercise with solution**
   ```python
   # Your turn:
   # 1. Do this
   # 2. Then this
   ```

---

## 11. Extending the Project

### Adding New Teaching Behaviors

To add a new behavior to the tutor:

1. Open `.claude/output-styles/python-tutor.md`
2. Add a new section under "## Core Behaviors":

```markdown
### 7. Your New Behavior
When user does X:
- First, do this
- Then, do that
- Finally, offer this
```

3. Update the "## Decision Flow" section:

```markdown
User asks about X          → Your New Behavior response
```

### Creating Domain-Specific Tutors

The power of this framework is that you can create tutors for **any domain** - not just programming:

**Cooking Tutor** (non-technical):
```markdown
---
name: cooking-tutor
type: topic
description: Teaches cooking techniques and recipes for home cooks
---

## Core Constraint
**Explain techniques, don't just list recipes.** Help users understand WHY techniques work.

## Target User
Home cook who wants to understand cooking, not just follow recipes

## Core Behaviors
### 1. Explain Techniques
When asked about a cooking method (sautéing, braising, etc.):
- Explain the science (heat transfer, Maillard reaction, etc.)
- Give sensory cues (what to look/listen/smell for)
- Common mistakes to avoid
```

**Language Learning Tutor**:
```markdown
---
name: spanish-tutor
type: topic
description: Teaches Spanish for English speakers
---

## Core Constraint
**Immersion over translation.** Use Spanish as much as possible, with context clues.

## Target User
English speaker learning Spanish, beginner to intermediate

## Core Behaviors
### 1. Vocabulary in Context
Never just translate - show words in sentences with situations
```

**Chess Tutor**:
```markdown
---
name: chess-tutor
type: topic
description: Teaches chess strategy and tactics
---

## Core Constraint
**Principles over memorization.** Teach the "why" behind moves.

## Target User
Beginner to intermediate player wanting to improve strategic thinking

## Core Behaviors
### 1. Analyze Positions
When shown a position:
- Identify key features (open files, weak squares, piece activity)
- Suggest candidate moves with reasoning
- Explain trade-offs
```

**Technical Examples** - Data Science Tutor:
```markdown
---
name: datascience-tutor
type: topic
description: Teaches pandas, numpy, and matplotlib
---

## Target User
Data analyst learning Python from Excel/SQL background

## Core Behaviors
### 1. Explain DataFrames
Compare to spreadsheets...
```

### Adding New Example Projects

To add a new teaching example:

1. Create a new notebook demonstrating a concept
2. Include comments explaining each step
3. Use realistic but simple data
4. Reference it from the tutor style

Example addition to `python-tutor.md`:
```markdown
## Example Projects
- `example.ipynb` - Web scraping fundamentals
- `api-example.ipynb` - REST API consumption (NEW)
```

### Extending Cheatsheets

When adding to cheatsheets:

1. Identify patterns from the codebase
2. Include line number references
3. Show minimal examples (2-5 lines)
4. Add common mistakes

Template:
```markdown
## New Concept

### Pattern Name

```python
# Minimal example
code_here()
```

**What it does:** [explanation]
**Where you use it:** `filename.py` line X

### ❌ Common Mistake

```python
# Wrong way
```

### ✅ Correct Way

```python
# Right way
```
```

---

## 12. Testing and Quality Assurance

### Manual Testing Checklist

Since there are no automated tests, use this checklist:

#### Style Loading
- [ ] `/output-style python-tutor` loads without errors
- [ ] Style persists across Claude Code restarts (if settings.local.json exists)
- [ ] User-level style works from any directory

#### Core Behaviors
- [ ] "Explain this file" produces summary, steps, and concepts
- [ ] "What is X?" provides definition, analogy, and notebook offer
- [ ] Pasting an error gets plain English translation
- [ ] "How do I add X?" gets conceptual guidance (not code)
- [ ] "Implement X for me" gets redirected to description only
- [ ] "How do files connect?" produces flow map

#### Artifacts
- [ ] Notebooks are created in `tutor/notebooks/`
- [ ] Cheatsheets are created in `tutor/reference/`
- [ ] Notebooks run without errors in Jupyter Lab
- [ ] Cheatsheets include line number references

### Testing Notebooks

```bash
# Run all cells in a notebook via command line
jupyter nbconvert --execute --to notebook tutor/notebooks/web-scraping/html-and-beautifulsoup.ipynb
```

If this completes without errors, the notebook works.

### Linting Python Code

```bash
# Install ruff (fast Python linter)
pip install ruff

# Check for issues
ruff check .

# Auto-fix issues
ruff check --fix .
```

### Adding Automated Tests (Future Enhancement)

If you want to add automated tests:

1. Create `tests/` directory
2. Install pytest: `pip install pytest`
3. Create test files:

```python
# tests/test_notebooks.py
import subprocess

def test_example_notebook_runs():
    """Verify example.ipynb executes without errors"""
    result = subprocess.run([
        "jupyter", "nbconvert",
        "--execute",
        "--to", "notebook",
        "--stdout",
        "example.ipynb"
    ], capture_output=True)
    assert result.returncode == 0
```

4. Run tests: `pytest tests/`

---

## 13. Deployment and Distribution

### Sharing Your Output Style

To share the python-tutor style with others:

#### Option 1: Git Repository
Users clone your repo and copy files:
```bash
cp -r .claude/output-styles ~/.claude/output-styles/
```

#### Option 2: Single File Distribution
Share just the style file:
```bash
# User saves this to:
# ~/.claude/output-styles/python-tutor.md
```

### Creating a Python Package (Advanced)

If you want to distribute as a pip package:

1. Update `pyproject.toml`:
```toml
[project]
name = "python-tutor-style"
version = "0.1.0"
description = "Claude Code output style for teaching Python"

[project.scripts]
install-tutor-style = "python_tutor:install"
```

2. Create install script:
```python
# python_tutor/__init__.py
import shutil
from pathlib import Path

def install():
    source = Path(__file__).parent / "output-styles" / "python-tutor.md"
    dest = Path.home() / ".claude" / "output-styles" / "python-tutor.md"
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy(source, dest)
    print(f"Installed python-tutor style to {dest}")
```

3. Build and publish:
```bash
pip install build twine
python -m build
twine upload dist/*
```

Users install with:
```bash
pip install python-tutor-style
install-tutor-style
```

---

## 14. Glossary

### Python Terms

**Module**: A `.py` file containing Python code. Similar to a class file in Java.

**Package**: A directory of modules with an `__init__.py` file. Similar to a Java package.

**pip**: Python's package installer. Like Maven or npm.

**uv**: A fast alternative to pip. Manages Python versions and packages.

**Virtual Environment**: An isolated Python installation. Prevents package conflicts between projects.

**List Comprehension**: `[x*2 for x in items]` - A compact way to create lists. Like streams in Java.

**Dictionary**: `{"key": "value"}` - Key-value storage. Like HashMap in Java.

**f-string**: `f"Hello {name}"` - String interpolation. Like String.format() in Java.

### Web Development Terms

**HTTP**: HyperText Transfer Protocol. How browsers talk to servers.

**HTML**: HyperText Markup Language. The structure of web pages.

**CSS**: Cascading Style Sheets. The appearance of web pages.

**DOM**: Document Object Model. HTML represented as a tree structure.

**Web Scraping**: Extracting data from websites programmatically.

**API**: Application Programming Interface. A structured way to request data from servers.

### Claude Code Terms

**Output Style**: A markdown file that customizes Claude's behavior.

**Claude Code**: Anthropic's command-line interface for Claude AI.

**Prompt**: Input text that instructs an AI model.

### Project-Specific Terms

**Artifact**: A notebook or cheatsheet created by the tutor.

**Teaching Behavior**: A specific way the tutor responds (explain, translate, guide, etc.).

**Fallback**: An alternative method when the primary one fails.

---

## Next Steps

After reading this guide:

1. **Run the example**: Start Jupyter Lab, open `example.ipynb`, and run all cells
2. **Try the tutor**: Start Claude Code, activate the style, ask questions
3. **Modify the style**: Make a small change to see how it affects responses
4. **Create a notebook**: Write a teaching notebook for a concept you know
5. **Share feedback**: Report issues or suggestions on GitHub

---

**Questions?** Open an issue at https://github.com/ShawhinT/AI-Builders-Bootcamp-8/issues
