# Why Output Styles? The Case for Structured AI Tutors

You can always prompt Claude directly in Claude Code CLI. So why bother with output styles? This document explains the significant advantages of defining tutors as output-style markdown files.

---

## The Core Problem

When you interact with Claude directly, you might say:

```
"Act as a Python tutor. Don't write code for me, just explain concepts.
Use analogies. Create practice notebooks when I need them..."
```

This works for one message. But then:
- **Message 2:** Did Claude remember all those instructions?
- **Message 5:** Claude starts writing implementation code
- **Message 10:** The teaching style has drifted completely
- **New session:** Start over from scratch

Output styles solve this by **compiling** your tutor persona into a persistent, reusable format.

---

## Key Advantages

### 1. Persistence Across the Entire Session

| Approach | Behavior |
|----------|----------|
| Ad-hoc prompting | Must re-explain constraints each message, or hope Claude remembers |
| Output style | Behavior persists for the entire session automatically |

With an output style, you activate it once:
```
/output-style python-tutor
```

Then every interaction follows the tutor's rules without reminders.

### 2. Consistent Constraint Enforcement

Each tutor has **hard boundaries** that prevent unhelpful responses:

| Tutor | Core Constraint | What It Prevents |
|-------|-----------------|------------------|
| Python Tutor | "Teaching only, no implementation" | Claude writing code you could copy-paste |
| Stock Tutor | "Understanding first, never trading advice" | Claude giving buy/sell recommendations |
| Git Tutor | "Understanding the model, not memorizing commands" | Claude giving commands without explanation |

With ad-hoc prompting, Claude might accidentally violate these boundaries if you forget to remind it. With output styles, the constraints are **always active**.

### 3. No "Prompt Tax" on Every Message

**Without output styles:**
```
You: "Remember, you're a tutor that explains concepts without writing
     implementation code. Use analogies. Offer notebooks for practice.
     Now, what is a list comprehension?"
```

**With output styles:**
```
You: "What is a list comprehension?"
```

Your mental energy and tokens go toward your actual questions, not re-establishing the persona.

### 4. Structured, Complete Definitions

Output styles force you to define all aspects of the tutor:

```markdown
## Core Constraint
What the tutor will NOT do (the boundary)

## Target User
Who this is for, what to assume they don't know

## Core Behaviors
The 6 specific teaching patterns

## Artifacts
What the tutor creates (notebooks, cheatsheets) and WHERE

## Decision Flow
Which behavior activates for which type of question
```

Ad-hoc prompts tend to be incomplete. You forget to mention artifact locations, or the target user's assumed knowledge level, or edge cases in the decision flow.

### 5. Instant Switching Between Tutors

Need to switch from Python concepts to stock analysis?

**Without output styles:**
```
You: "Actually, forget the Python tutor instructions. Now act as a
     stock analysis tutor that explains indicators without giving
     trading advice. Use formulas and interpretations..."
```

**With output styles:**
```
/output-style stock-indicators-tutor
```

One command. Complete context switch. No residual confusion.

### 6. Shareable and Version Controlled

Output styles are just markdown files. You can:
- **Copy** them to any project
- **Share** them with teammates or students
- **Version control** them with git
- **Fork and customize** them for specific needs

```bash
# Share your tutor with anyone
cp .claude/output-styles/python-tutor.md ~/my-other-project/.claude/output-styles/
```

### 7. Project-Level Defaults

With `settings.local.json`, a project can default to a specific tutor:

```json
{
  "outputStyle": "python-tutor"
}
```

Now anyone opening Claude Code in that directory automatically gets the tutor. No manual activation needed.

### 8. Consistent Artifact Organization

Output styles define WHERE learning artifacts go:

```
tutor/
├── notebooks/
│   └── <domain>/        # Practice notebooks by topic
└── reference/
    └── <domain>/        # Cheatsheets by topic
```

Without this, Claude might create files anywhere. With output styles, your project stays organized.

---

## Comparison Table

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

---

## When Ad-hoc Prompting Is Fine

Output styles aren't always necessary. Use ad-hoc prompting for:

- **One-off questions** - Quick clarification that doesn't need a full tutor
- **Exploration** - Testing whether a tutor concept works before formalizing
- **Simple tasks** - When you don't need persistent teaching behavior

---

## The Mental Model

Think of it this way:

| Concept | Analogy |
|---------|---------|
| Ad-hoc prompting | Interpreted code - runs but slower, must re-parse each time |
| Output style | Compiled code - defined once, runs consistently |

Or:

| Concept | Analogy |
|---------|---------|
| Ad-hoc prompting | Verbal agreement - easy to forget or misremember |
| Output style | Written contract - clear, persistent, enforceable |

---

## Creating Your Own Output Style

If you want to create a custom tutor, follow this structure:

```markdown
---
name: your-tutor-name
description: One-line description of what this tutor does
---

# Custom Style Instructions

You are an interactive CLI tool that helps users with [domain].

## Core Constraint
**[Your boundary statement]**
- What the tutor will NOT do
- Boundary test: If [condition], don't do it

## Target User
[Who this is for]
- What they know
- What they don't know (assume they don't know X, Y, Z)

## Core Behaviors
### 1. [Behavior Name]
When asked about [trigger]:
- Do X
- Do Y
- Offer Z

[Continue for all behaviors...]

## Artifacts
### Notebooks (`tutor/notebooks/<domain>/[name].ipynb`)
When to create, structure to follow

### Cheatsheets (`tutor/reference/<domain>/[name].md`)
When to create, structure to follow

## Decision Flow
```
User asks X → Behavior 1
User asks Y → Behavior 2
...
```
```

---

## Conclusion

Output styles transform Claude from a general-purpose assistant into a **specialized, consistent tutor** with:
- Persistent behavior across sessions
- Enforced teaching boundaries
- Zero prompt overhead
- Shareable, version-controlled definitions
- Organized artifact creation

For any teaching or specialized assistant use case that spans multiple interactions, output styles are the right tool.

---

## Related Resources

- [Quick Start Guide](QUICK_START.md) - Get running in 5 minutes
- [Developer Guide](DEVELOPER_GUIDE.md) - Creating custom tutors
- [Technical Architecture](TECHNICAL_ARCHITECTURE.md) - How output styles work
