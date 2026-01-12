# Python Tutor - User Guide

A friendly guide for anyone who wants to learn Python with the help of an AI tutor. No prior programming experience required!

---

## Table of Contents

1. [What is Python Tutor?](#1-what-is-python-tutor)
2. [Getting Started (First-Time Setup)](#2-getting-started-first-time-setup)
3. [Your First Conversation with the Tutor](#3-your-first-conversation-with-the-tutor)
4. [What Can the Tutor Do?](#4-what-can-the-tutor-do)
5. [Working with Practice Notebooks](#5-working-with-practice-notebooks)
6. [Using Cheatsheets](#6-using-cheatsheets)
7. [Understanding Error Messages](#7-understanding-error-messages)
8. [Learning from the Example Project](#8-learning-from-the-example-project)
9. [Tips for Effective Learning](#9-tips-for-effective-learning)
10. [Common Questions](#10-common-questions)

---

## 1. What is Python Tutor?

### The Problem It Solves

Many people today use AI tools like ChatGPT or Claude to write code for them. While this gets things working quickly, it creates a problem: you end up with code you don't understand and can't modify yourself.

**Python Tutor is different.** Instead of writing code for you, it **teaches you** what the code means. Think of it like having a patient teacher sitting next to you who:

- Explains code in plain English
- Uses everyday examples to clarify concepts
- Helps you understand error messages
- Creates practice exercises just for you
- Never makes you feel dumb for asking questions

### How It Works

Python Tutor is a special "personality" for Claude (an AI assistant). When you activate it, Claude stops trying to solve your problems by writing code. Instead, it focuses on helping you understand so you can write and modify code yourself.

### Why Use an Output Style Instead of Just Prompting?

You could tell Claude "act like a tutor" in every message - but output styles offer real advantages:

| What You Get | With Ad-hoc Prompting | With Output Style |
|--------------|----------------------|-------------------|
| **Persistence** | Must re-explain each message | Activates once, lasts all session |
| **Reliability** | Claude may drift from instructions | Hard boundaries always enforced |
| **Your effort** | Wasted on re-establishing persona | Focused purely on your questions |
| **Switching tutors** | Paragraphs of instructions | Just `/output-style git-tutor` |

**Key insight:** Output styles are like "compiled" tutors - defined once, running consistently. Ad-hoc prompting is "interpreted" - must re-parse every time.

[Read the full explanation](WHY_OUTPUT_STYLES.md)

### What You'll Get

- **Explanations**: Plain English descriptions of what code does
- **Practice Notebooks**: Interactive files where you can experiment safely
- **Cheatsheets**: Quick reference guides based on your actual code
- **Error Translation**: Error messages explained in human language
- **Guided Modifications**: Step-by-step descriptions of how to change code

---

## 2. Getting Started (First-Time Setup)

### What You Need Before Starting

Don't worry if these terms are unfamiliar - we'll explain each step.

- **A computer** (Windows, Mac, or Linux)
- **Internet connection**
- **About 30 minutes** for initial setup

### Step 1: Install Python

Python is the programming language you'll be learning. It needs to be installed on your computer.

#### Windows Users

1. Open your web browser and go to: https://www.python.org/downloads/
2. Click the big yellow button that says **"Download Python 3.13.x"**
3. Open the downloaded file
4. **VERY IMPORTANT**: At the bottom of the installer, check the box that says **"Add Python to PATH"**
5. Click **"Install Now"**
6. Wait for installation to complete
7. Click **"Close"**

To verify it worked:
1. Press `Windows key + R` (opens Run dialog)
2. Type `cmd` and press Enter (opens a black window called Command Prompt)
3. Type `python --version` and press Enter
4. You should see something like `Python 3.13.0`

#### Mac Users

1. Open your web browser and go to: https://www.python.org/downloads/
2. Click **"Download Python 3.13.x"**
3. Open the downloaded file
4. Follow the installation prompts
5. Click **"Install"** when prompted

To verify it worked:
1. Press `Cmd + Space` and type **"Terminal"**, then press Enter
2. In the Terminal window, type `python3 --version` and press Enter
3. You should see something like `Python 3.13.0`

### Step 2: Install Visual Studio Code (Recommended Editor)

Visual Studio Code (VS Code) is a free program where you'll write and view code.

1. Go to: https://code.visualstudio.com/
2. Click the big **"Download"** button
3. Open the downloaded file and follow installation prompts
4. Open VS Code after installation

### Step 3: Install Claude Code

Claude Code is the AI tool that becomes your tutor.

1. Open Terminal (Mac) or Command Prompt (Windows)
2. Type this command and press Enter:
   ```
   pip install claude-code
   ```
3. Wait for installation to complete

**Note**: You'll need an Anthropic API key. Get one from https://console.anthropic.com/

### Step 4: Get the Python Tutor Project

1. Open Terminal or Command Prompt
2. Navigate to where you want to store the project:
   ```
   cd Documents
   ```
3. Download the project:
   ```
   git clone https://github.com/ShawhinT/AI-Builders-Bootcamp-8.git
   ```
4. Go into the tutor folder:
   ```
   cd AI-Builders-Bootcamp-8/python-tutor
   ```

### Step 5: Install Project Dependencies

In the same terminal window:
```
pip install jupyterlab ipykernel requests beautifulsoup4 pandas
```

This installs the tools needed to run the example project.

### Step 6: Verify Everything Works

1. Start Jupyter Lab (the notebook environment):
   ```
   jupyter lab
   ```
   This opens a browser tab with Jupyter.

2. In a **new** terminal/command prompt window, start Claude:
   ```
   cd Documents/AI-Builders-Bootcamp-8/python-tutor
   claude
   ```

3. In Claude, type:
   ```
   /output-style python-tutor
   ```

4. You should see a message confirming the tutor style is active.

**Congratulations! You're ready to start learning!**

---

## 3. Your First Conversation with the Tutor

### Starting a Session

Every time you want to learn, follow these steps:

1. Open Terminal/Command Prompt
2. Navigate to your project:
   ```
   cd Documents/AI-Builders-Bootcamp-8/python-tutor
   ```
3. Start Claude:
   ```
   claude
   ```
4. Activate the tutor:
   ```
   /output-style python-tutor
   ```

### Your First Question

Let's try something simple. Type:

```
What is a variable?
```

The tutor will explain in plain English, give you an everyday analogy (like "a labeled box where you store things"), show a tiny example, and offer to create a practice notebook.

### Exploring the Example Code

Type:

```
Explain example.ipynb
```

The tutor will give you:
1. A one-sentence summary of what the file does
2. The main steps it performs
3. Key concepts it uses

### Asking Follow-Up Questions

The tutor remembers your conversation. Try:

```
What does "soup" mean in that code?
```

It will connect to what you just discussed and explain BeautifulSoup in context.

---

## 4. What Can the Tutor Do?

### Behavior 1: Explain Code

When you show the tutor code or ask about a file, it explains what the code does.

**How to use it:**
```
Explain example.ipynb
```

```
What does this code do?
[paste your code here]
```

**What you get:**
- One-sentence summary
- Step-by-step breakdown
- Key concepts highlighted

### Behavior 2: Explain Concepts

When you ask "what is X?", the tutor teaches the concept.

**How to use it:**
```
What is a list?
```

```
What is BeautifulSoup?
```

```
What does import mean?
```

**What you get:**
- Plain English definition
- Real-world analogy
- Small example
- Where it appears in your code
- Offer for practice notebook

### Behavior 3: Translate Errors

When you paste an error message, the tutor translates it to English.

**How to use it:**
```
I got this error:
TypeError: 'NoneType' object is not subscriptable
```

**What you get:**
- Plain English explanation
- Which line caused it
- Why it probably happened
- How to investigate

### Behavior 4: Guide Modifications

When you want to change code, the tutor describes what to do (without writing it for you).

**How to use it:**
```
How do I add email extraction to the job scraper?
```

**What you get:**
- Which file(s) to change
- Which lines to modify
- What each change involves conceptually
- Common mistakes to avoid
- **Note**: The tutor won't write the code - it describes so you can write it

### Behavior 5: Explain Project Flow

When you want to understand how files connect, the tutor maps it out.

**How to use it:**
```
How do the files in this project connect?
```

```
What happens when I run example.ipynb?
```

**What you get:**
- Map of files and their roles
- Execution flow (what runs first, second, etc.)
- Data flow (where information moves)
- What you can ignore for now

### Behavior 6: Check Code Quality

When you want feedback on code quality, the tutor reviews it.

**How to use it:**
```
Is this code good?
[paste your code]
```

```
What's wrong with this function?
```

**What you get:**
- Assessment of complexity
- AI-generated code quirks flagged
- Suggestions for improvement (concepts, not code)
- Offer for practice notebook

---

## 5. Working with Practice Notebooks

### What Are Notebooks?

Jupyter notebooks are interactive documents where you can:
- Read explanations
- Run code and see results immediately
- Experiment by changing code
- Practice exercises

### Opening Notebooks

1. Start Jupyter Lab:
   ```
   jupyter lab
   ```
2. In the browser, navigate to `tutor/notebooks/`
3. Click on a notebook file (ends in `.ipynb`)

### Running Code in Notebooks

Each notebook has **cells**. Some cells have text (explanations), others have code.

To run a code cell:
1. Click on the cell
2. Press **Shift + Enter**
3. See the output appear below the cell

### The Practice Notebook Structure

Every notebook the tutor creates follows this pattern:

1. **Simplest Example**
   - Shows the most basic version
   - You run it and see output immediately

2. **What Happened?**
   - Explains each step
   - Uses plain language

3. **🧪 Experiment**
   - Asks you to change something small
   - Helps you discover through doing

4. **Building Up**
   - Adds one new thing
   - Shows how concepts combine

5. **Connection to Your Code**
   - Points to where this appears in real code
   - Makes learning relevant

6. **Practice Exercise**
   - Challenges you to try yourself
   - Solution provided (try first!)

### Example: HTML and BeautifulSoup Notebook

Open `tutor/notebooks/web-scraping/html-and-beautifulsoup.ipynb`

This notebook teaches you:
- What HTML looks like
- How to find elements with BeautifulSoup
- The difference between `find()` and `find_all()`
- How to extract data from web pages

---

## 6. Using Cheatsheets

### What Are Cheatsheets?

Cheatsheets are quick reference guides. Instead of re-reading long explanations, you can glance at a cheatsheet to remember how something works.

### Where to Find Them

Look in `tutor/reference/` folder. Open them with any text editor or VS Code.

### How Cheatsheets Are Organized

Each cheatsheet contains:

**Method/Pattern Name**
```python
# Code example (2-5 lines)
```
- **What it does**: Plain explanation
- **Where you use it**: `filename.py` line X

**Common Mistakes Section**
- ❌ Wrong way (with explanation)
- ✅ Right way (with explanation)

### Example: BeautifulSoup Cheatsheet

Open `tutor/reference/web-scraping/beautifulsoup-cheatsheet.md`

Sections include:
- Creating a soup object
- Finding elements (`find()` vs `find_all()`)
- Getting text from elements
- Getting attributes (like URLs)
- Navigating the HTML tree
- Common patterns from your code

---

## 7. Understanding Error Messages

### Why Errors Happen

Errors are normal! Even experienced programmers see errors constantly. They're not failures - they're the computer telling you exactly what needs fixing.

### How to Get Help

When you see an error, copy the entire message and paste it to the tutor:

```
I got this error:

Traceback (most recent call last):
  File "example.py", line 23, in <module>
    title = soup.find("h1").text
AttributeError: 'NoneType' object has no attribute 'text'
```

### What the Tutor Tells You

1. **Plain English Translation**
   "You tried to get text from something that doesn't exist. The `find()` returned nothing (None), and you can't get `.text` from nothing."

2. **The Specific Line**
   "This happened on line 23."

3. **Most Likely Cause**
   "The page probably doesn't have an `<h1>` tag, so `find("h1")` returned `None`."

4. **How to Investigate**
   "Before getting `.text`, check if the result exists:
   - Try `print(soup.find("h1"))` first to see what you get
   - Add an `if` check before accessing `.text`"

### Common Error Types and What They Mean

| Error Type | Plain English |
|------------|---------------|
| `SyntaxError` | You made a typo or forgot punctuation |
| `NameError` | You used a word Python doesn't recognize |
| `TypeError` | You tried to use something the wrong way |
| `AttributeError` | You tried to access something that doesn't exist |
| `IndexError` | You tried to get an item from a list that isn't there |
| `KeyError` | You tried to get a dictionary item that doesn't exist |
| `FileNotFoundError` | The file you're looking for isn't there |

---

## 8. Learning from the Example Project

### What the Example Does

The `example.ipynb` notebook is a **job scraper** - it:
1. Visits a job board website (aijobs.ai)
2. Collects links to individual job postings
3. Extracts details from each job (title, company, salary, etc.)
4. Saves everything to a spreadsheet file

### Following the Example Step by Step

#### Part 1: Setup (Cell 1)
```python
import requests
from bs4 import BeautifulSoup
import json
import re
import pandas as pd
```

**What this does**: Loads tools the code needs.
- `requests`: For downloading web pages
- `BeautifulSoup`: For reading HTML
- `json`: For handling structured data
- `re`: For pattern matching in text
- `pandas`: For spreadsheets and data

#### Part 2: Getting Job URLs (Cell 2)
The code visits 5 pages of job listings and collects all the links.

**Ask the tutor**: "Explain what the loop in cell 2 does"

#### Part 3: Extracting Job Data (Cell 3)
The `extract_job_data` function visits each job page and pulls out details.

**Ask the tutor**: "What is the extract_job_data function doing?"

#### Part 4: Processing All Jobs (Cell 4)
Loops through all job URLs and extracts data from each.

**Ask the tutor**: "How does cell 4 use the extract_job_data function?"

#### Part 5: Creating a Spreadsheet (Cell 5)
Converts the data to a pandas DataFrame and saves as CSV.

**Ask the tutor**: "What is a DataFrame?"

### Suggested Learning Path

1. **Day 1**: Read through the notebook without running it
2. **Day 2**: Ask the tutor to explain each cell
3. **Day 3**: Run each cell and observe the output
4. **Day 4**: Try the BeautifulSoup practice notebook
5. **Day 5**: Ask "How would I add X to the scraper?" for something simple

---

## 9. Tips for Effective Learning

### Start Small

Don't try to understand everything at once. Focus on one concept at a time.

**Good**: "What is a for loop?"
**Then**: "Show me where for loops appear in example.ipynb"
**Then**: "Can I get a practice notebook for for loops?"

### Ask "Stupid" Questions

There are no stupid questions. The tutor is designed for beginners.

- "What does the dot mean in `soup.find()`?"
- "Why are there quotation marks around 'h1'?"
- "What happens if I forget a closing parenthesis?"

### Experiment Fearlessly

You can't break anything by experimenting! If code stops working:
1. Close and reopen the notebook
2. Run cells from the beginning
3. Everything is back to normal

### Use the "What Happened?" Pattern

After running any code, ask yourself:
1. What did I expect to happen?
2. What actually happened?
3. If different, why might that be?

Ask the tutor when you can't figure it out.

### Take Notes

Keep a personal notebook (paper or digital) with:
- New terms and their meanings
- Concepts that clicked
- Questions to ask later
- Code patterns you want to remember

### Practice Regularly

Short, frequent sessions beat long, rare ones.
- 20 minutes daily > 3 hours weekly
- Review yesterday's learning before adding new things

---

## 10. Common Questions

### "The tutor won't write code for me - why?"

That's by design! Writing code for you feels helpful but actually slows your learning. When you understand enough to write code yourself, you can:
- Fix problems independently
- Modify code for new situations
- Understand what AI-generated code does

### "How do I get actual code written?"

For getting code written:
- Use regular Claude (without the tutor style)
- Use ChatGPT or GitHub Copilot
- Write it yourself based on the tutor's guidance

The tutor is for **understanding**, other tools are for **doing**.

### "I don't understand the tutor's explanation"

Try these approaches:
1. Ask it to explain differently: "Can you explain that more simply?"
2. Ask for an analogy: "What's a real-world comparison for this?"
3. Ask for a smaller piece: "Just explain the first part"
4. Request a practice notebook: "Can I practice this concept?"

### "The example notebook won't run"

Common fixes:
1. Make sure you've installed dependencies:
   ```
   pip install requests beautifulsoup4 pandas
   ```
2. Run cells in order from top to bottom
3. Check you're using Python 3.13+

### "I'm not sure where to start"

Start here:
1. Open Claude Code in the project directory
2. Type: `/output-style python-tutor`
3. Type: `Explain example.ipynb`
4. Read the explanation, then ask about anything unclear

### "How long will it take to learn Python?"

There's no fixed timeline. Focus on:
- Understanding one concept well before moving on
- Regular practice (even 15 minutes counts)
- Asking questions when confused
- Celebrating small wins

Many people can read and modify simple code after 2-4 weeks of regular practice.

### "Can I use this for my own code?"

The tutor works with any code:
1. Copy the `.claude/output-styles/python-tutor.md` file to your project
2. Create `.claude/settings.local.json`:
   ```json
   {
     "outputStyle": "python-tutor"
   }
   ```
3. Start Claude Code in your project
4. Ask about your code!

---

## Getting Help

- **Technical issues**: Open an issue at https://github.com/ShawhinT/AI-Builders-Bootcamp-8/issues
- **Learning questions**: Ask the tutor! That's what it's for.
- **Community**: Look for the AI Builders Bootcamp community

---

**Remember**: Everyone starts as a beginner. The only way to learn is to start. You've got this!
