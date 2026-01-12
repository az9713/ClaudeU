# Python Tutor - Quick Start Guide

Get up and running in 5 minutes, then try 12 educational use cases to experience the power of AI-assisted learning.

---

## Why Output Styles?

You might wonder: "Can't I just prompt Claude to act like a tutor?" You can - but output styles offer significant advantages:

| Ad-hoc Prompting | Output Style |
|------------------|--------------|
| Must re-explain each message | Behavior persists entire session |
| Claude may drift or forget rules | Hard boundaries always enforced |
| Your prompts wasted on re-establishing persona | Focus purely on your questions |
| Paragraphs of instructions to switch tutors | Just `/output-style git-tutor` |
| Copy-paste text to share | Copy the `.md` file |

**Think of it this way:** Output styles are "compiled" tutor personas. Ad-hoc prompting is "interpreted" - works but less reliable and more overhead per interaction.

[Read the full explanation](WHY_OUTPUT_STYLES.md)

---

## 5-Minute Setup

### Step 1: Open Your Terminal

**Windows**: Press `Win + R`, type `cmd`, press Enter
**Mac**: Press `Cmd + Space`, type `Terminal`, press Enter
**Linux**: Press `Ctrl + Alt + T`

### Step 2: Navigate to the Project

```bash
cd path/to/AI-Builders-Bootcamp-8/python-tutor
```

### Step 3: Start Jupyter Lab (in background)

```bash
jupyter lab &
```

This opens your browser with the notebook environment.

### Step 4: Start Claude Code (in a new terminal)

```bash
claude
```

### Step 5: Activate the Tutor

Type this in Claude Code:
```
/output-style python-tutor
```

**Done!** You're ready to learn.

---

## 12 Educational Use Cases

Each use case below teaches you something new while demonstrating the tutor's capabilities. Try them in order for the best learning experience.

---

### Use Case 1: Get a High-Level Overview

**Goal**: Understand what the example project does without reading all the code.

**What to type**:
```
Explain example.ipynb in simple terms
```

**What you'll learn**:
- One-sentence summary of the entire project
- The main steps the code performs
- Key concepts used (BeautifulSoup, requests, pandas)

**Try this next**:
```
Which parts of the code should I understand first?
```

---

### Use Case 2: Learn What "import" Means

**Goal**: Understand the first lines of any Python file.

**What to type**:
```
What does "import" do in Python?
```

**What you'll learn**:
- What imports are (loading tools into your code)
- Real-world analogy (like grabbing a specific tool from a toolbox)
- Why different imports exist

**Try this next**:
```
What is the difference between "import requests" and "from bs4 import BeautifulSoup"?
```

---

### Use Case 3: Understand a Specific Line of Code

**Goal**: Learn to break down code line by line.

**What to type**:
```
What does this line mean?
soup = BeautifulSoup(response.text, "html.parser")
```

**What you'll learn**:
- What each part of the line does
- What "response.text" contains (raw HTML)
- What "html.parser" means (how to read the HTML)
- What "soup" becomes (a searchable object)

**Try this next**:
```
Can I see what soup looks like if I print it?
```

---

### Use Case 4: Learn About For Loops

**Goal**: Understand one of the most important programming concepts.

**What to type**:
```
What is a for loop? Use a simple example.
```

**What you'll learn**:
- Plain English explanation (doing something repeatedly)
- Real-world analogy (like checking off items on a to-do list)
- Where for loops appear in example.ipynb
- Offer for a practice notebook

**Try this next**:
```
Create a practice notebook for for loops
```

Then open Jupyter Lab, go to `tutor/notebooks/`, and try the new notebook!

---

### Use Case 5: Decode an Error Message

**Goal**: Learn to read and understand Python errors.

**What to type**:
```
What does this error mean?

TypeError: 'NoneType' object is not subscriptable
```

**What you'll learn**:
- Plain English translation of the error
- Why this error typically happens
- How to investigate and fix it
- The concept of "None" in Python

**Try this next**:
```
What are the most common Python errors beginners see?
```

---

### Use Case 6: Understand List Comprehensions

**Goal**: Decode one of Python's most confusing-looking features.

**What to type**:
```
What is happening in this line?
job_urls = [a["href"] for a in job_cards if a.get("href")]
```

**What you'll learn**:
- What list comprehensions are
- How to read them (from right to left)
- The equivalent "long form" with a for loop
- When to use list comprehensions vs regular loops

**Try this next**:
```
Can you create a practice notebook for list comprehensions?
```

---

### Use Case 7: Learn HTML Basics for Web Scraping

**Goal**: Understand what web pages are made of.

**What to type**:
```
What is HTML and why do I need to know about it for web scraping?
```

**What you'll learn**:
- What HTML tags are
- How web pages are structured
- Why BeautifulSoup exists
- Connection to the job scraper code

**Try this next**:
```
Open the html-and-beautifulsoup notebook and try it
```

Go to Jupyter Lab, open `tutor/notebooks/web-scraping/html-and-beautifulsoup.ipynb`, and run through it cell by cell.

---

### Use Case 8: Understand Functions

**Goal**: Learn what functions are and how they work.

**What to type**:
```
What is the extract_job_data function and why is it separate from the rest of the code?
```

**What you'll learn**:
- What functions are (reusable blocks of code)
- Why we organize code into functions
- How data goes in (parameters) and comes out (return values)
- The structure of the extract_job_data function

**Try this next**:
```
Walk me through extract_job_data step by step
```

---

### Use Case 9: Learn to Modify Code Conceptually

**Goal**: Understand how to add features without getting code written for you.

**What to type**:
```
How would I modify the job scraper to also extract the application deadline?
```

**What you'll learn**:
- Which file and which function to modify
- What concepts are involved (finding HTML elements, handling missing data)
- Common mistakes to avoid
- The approach to take

**Important**: The tutor describes what to do, but doesn't write the code. This helps you learn!

**Try this next**:
```
What mistakes do beginners commonly make when adding new data fields to scrapers?
```

---

### Use Case 10: Understand Data Flow

**Goal**: See how data moves through a program.

**What to type**:
```
How does data flow through example.ipynb from start to finish?
```

**What you'll learn**:
- Where the data starts (web requests)
- How it transforms (HTML → BeautifulSoup → dictionary → list → DataFrame)
- Where it ends up (CSV file)
- The role of each code section

**Try this next**:
```
What would happen if I ran the code twice? Would I get duplicate data?
```

---

### Use Case 11: Get a Quick Reference

**Goal**: Create a personalized cheatsheet based on your code.

**What to type**:
```
Create a cheatsheet for the requests library based on how it's used in example.ipynb
```

**What you'll learn**:
- The specific requests methods used in your project
- Line numbers where each method appears
- Minimal examples
- Common mistakes

The cheatsheet will be saved to `tutor/reference/requests-cheatsheet.md`

**Try this next**:
```
Look at the beautifulsoup-cheatsheet.md file and ask about anything unclear
```

---

### Use Case 12: Review Code Quality

**Goal**: Learn to evaluate whether code is well-written.

**What to type**:
```
Is the extract_job_data function well-written? What could be improved?
```

**What you'll learn**:
- How to evaluate code complexity
- Signs of AI-generated code (verbosity, over-engineering)
- Concepts that could simplify the code
- Trade-offs between simplicity and robustness

**Try this next**:
```
What would a simpler version of extract_job_data look like conceptually?
```

---

## Quick Reference Card

Print this and keep it by your computer!

### Starting a Session
```bash
cd path/to/python-tutor
jupyter lab &           # Start notebooks (background)
claude                  # Start Claude Code
/output-style python-tutor  # Activate tutor
```

### Essential Commands

| What You Want | What to Type |
|---------------|--------------|
| Overview of a file | `Explain [filename]` |
| Learn a concept | `What is [concept]?` |
| Understand code | `What does this code do? [paste code]` |
| Translate an error | `What does this error mean? [paste error]` |
| Add a feature | `How would I add [feature]?` |
| Understand connections | `How do the files connect?` |
| Get feedback | `Is this code good? [paste code]` |
| Practice | `Create a notebook for [concept]` |
| Quick reference | `Create a cheatsheet for [topic]` |

### Jupyter Notebook Shortcuts

| Action | Shortcut |
|--------|----------|
| Run cell | Shift + Enter |
| Run cell, stay | Ctrl + Enter |
| New cell below | B |
| New cell above | A |
| Delete cell | D, D (press D twice) |
| Save | Ctrl + S |

### Getting Unstuck

1. **Can't understand an explanation?**
   - "Can you explain that more simply?"
   - "What's a real-world example?"

2. **Notebook won't run?**
   - Run cells from top to bottom
   - Check for missing dependencies

3. **Error messages?**
   - Copy and paste the full error
   - Ask "What does this error mean?"

---

## Next Steps After Quick Start

### Week 1: Foundation
- [ ] Complete all 12 use cases above
- [ ] Run through the BeautifulSoup notebook
- [ ] Ask about any term you don't understand

### Week 2: Deep Dive
- [ ] Read `example.ipynb` cell by cell
- [ ] Ask the tutor to explain each cell
- [ ] Create your own practice notebooks

### Week 3: Application
- [ ] Ask "How would I modify X?" questions
- [ ] Try making small changes yourself
- [ ] Learn from any errors you encounter

### Week 4: Independence
- [ ] Use the tutor with your own code
- [ ] Explain concepts to someone else (great way to learn!)
- [ ] Start a simple project of your own

---

## Celebrating Your Progress

Each of these is a real achievement:

- [ ] First conversation with the tutor
- [ ] First notebook completed
- [ ] First error message decoded
- [ ] First concept truly understood
- [ ] First code modification (even one line!)
- [ ] First time explaining code to someone else
- [ ] First personal project started

---

**You're on your way! Each question you ask is a step forward.**
