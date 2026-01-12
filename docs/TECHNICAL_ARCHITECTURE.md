# ClaudeU - Technical Architecture

A detailed technical specification of how the ClaudeU system works, for developers who need to understand, maintain, or extend the project.

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Component Architecture](#2-component-architecture)
3. [Claude Code Integration](#3-claude-code-integration)
4. [Output Style Specification](#4-output-style-specification)
5. [Tutor Type System](#5-tutor-type-system)
6. [The /tutor Command](#6-the-tutor-command)
7. [Artifact Generation](#7-artifact-generation)
8. [Example Project Analysis](#8-example-project-analysis)
9. [Data Flow Diagrams](#9-data-flow-diagrams)
10. [Extension Points](#10-extension-points)
11. [Security Considerations](#11-security-considerations)
12. [Performance Characteristics](#12-performance-characteristics)

---

## 1. System Overview

### Architecture Classification

ClaudeU is a **prompt engineering project** that customizes AI assistant behavior through configuration, not traditional application code.

**Category**: AI Behavior Configuration
**Pattern**: System Prompt Customization
**Platform**: Claude Code CLI
**Language**: Markdown (configuration) + Python (examples)

### System Boundaries

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        EXTERNAL SYSTEMS                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌───────────────┐   │
│  │  Anthropic  │  │   GitHub    │  │ Target      │  │ User's        │   │
│  │  API        │  │   Repo      │  │ Websites    │  │ Browser       │   │
│  └─────────────┘  └─────────────┘  └─────────────┘  └───────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
           │                │                │                 │
           │ API Calls      │ Clone/Pull     │ HTTP Requests   │ Jupyter
           ▼                ▼                ▼                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         CLAUDEU SYSTEM                                   │
│                                                                          │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                     CLAUDE CODE RUNTIME                           │   │
│  │  ┌─────────────┐  ┌─────────────────┐  ┌─────────────────────┐   │   │
│  │  │ CLI Shell   │  │ Output Style    │  │ File System        │   │   │
│  │  │             │──│ Loader          │──│ Access             │   │   │
│  │  └─────────────┘  └─────────────────┘  └─────────────────────┘   │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                          │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                      PROJECT FILES                                │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐    │   │
│  │  │ Output Style │  │ Example      │  │ Generated Artifacts  │    │   │
│  │  │ Definition   │  │ Notebooks    │  │ (notebooks/refs)     │    │   │
│  │  └──────────────┘  └──────────────┘  └──────────────────────┘    │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| AI Runtime | Claude Code CLI | Command-line interface to Claude |
| Configuration | Markdown + YAML frontmatter | Behavior definition |
| Package Management | UV / pip | Dependency management |
| Interactive Environment | Jupyter Lab | Notebook execution |
| Example Code | Python 3.13+ | Teaching examples |
| Web Scraping | requests + BeautifulSoup4 | Data extraction demo |
| Data Processing | pandas | Tabular data handling |

---

## 2. Component Architecture

### Component Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     PROJECT ROOT                                 │
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                  CONFIGURATION LAYER                       │  │
│  │                                                            │  │
│  │  ┌────────────────────┐  ┌────────────────────────────┐   │  │
│  │  │ pyproject.toml     │  │ .claude/                   │   │  │
│  │  │                    │  │ ├── output-styles/         │   │  │
│  │  │ - Project metadata │  │ │   └── python-tutor.md    │   │  │
│  │  │ - Dependencies     │  │ └── settings.local.json    │   │  │
│  │  │ - Python version   │  │     (optional)             │   │  │
│  │  └────────────────────┘  └────────────────────────────┘   │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                   TEACHING LAYER                           │  │
│  │                                                            │  │
│  │  ┌────────────────────┐  ┌────────────────────────────┐   │  │
│  │  │ example.ipynb      │  │ tutor/                     │   │  │
│  │  │                    │  │ ├── notebooks/             │   │  │
│  │  │ Primary teaching   │  │ │   └── [concept].ipynb    │   │  │
│  │  │ example for        │  │ └── reference/             │   │  │
│  │  │ students           │  │     └── [topic].md         │   │  │
│  │  └────────────────────┘  └────────────────────────────┘   │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                  DOCUMENTATION LAYER                       │  │
│  │                                                            │  │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────────────┐  │  │
│  │  │README.md│ │CLAUDE.md│ │docs/    │ │uv.lock          │  │  │
│  │  │         │ │         │ │*.md     │ │.python-version  │  │  │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────────────┘  │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Component Descriptions

#### 1. Output Style Definition (`.claude/output-styles/python-tutor.md`)

**Purpose**: Defines Claude's pedagogical behavior

**Format**: Markdown with YAML frontmatter

**Structure**:
```markdown
---
name: [identifier]
description: [brief description]
---

# Custom Style Instructions
[Behavior definitions]
```

**Key Sections**:
| Section | Purpose |
|---------|---------|
| Core Constraint | The fundamental rule (teaching only, no implementation) |
| Target User | Profile of the intended learner |
| Core Behaviors | Six distinct response patterns |
| Artifacts | Notebook and cheatsheet specifications |
| Principles | Do's and don'ts |
| Decision Flow | Response selection logic |

#### 2. Example Notebook (`example.ipynb`)

**Purpose**: Working code sample for teaching

**Structure**: Jupyter notebook with markdown + code cells

**Key Functions**:
- `extract_job_data(soup: BeautifulSoup) -> dict`: Main data extraction logic
- Helper functions: `first_nonempty()`, `text_or_none()`

**Dependencies**:
- requests (HTTP client)
- beautifulsoup4 (HTML parser)
- pandas (data manipulation)
- json (JSON handling)
- re (regular expressions)

#### 3. Generated Artifacts (`tutor/`)

**Purpose**: Learning materials created by the tutor

**Structure**:
```
tutor/
├── notebooks/     # Hands-on practice (.ipynb files)
└── reference/     # Quick reference (.md files)
```

**Creation**: Claude generates these in response to user requests

---

## 3. Claude Code Integration

### How Output Styles Are Loaded

```
┌──────────────────┐    ┌────────────────────────┐
│ User starts      │───▶│ Claude Code initializes│
│ claude command   │    │                        │
└──────────────────┘    └───────────┬────────────┘
                                    │
                        ┌───────────▼────────────┐
                        │ Check for              │
                        │ .claude/settings.local │
                        │ .json                  │
                        └───────────┬────────────┘
                                    │
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
              ▼                     ▼                     ▼
     ┌────────────────┐   ┌────────────────┐   ┌────────────────┐
     │ outputStyle    │   │ outputStyle    │   │ No outputStyle │
     │ specified      │   │ not specified  │   │ file exists    │
     └───────┬────────┘   └───────┬────────┘   └───────┬────────┘
             │                    │                    │
             ▼                    ▼                    ▼
     ┌────────────────┐   ┌────────────────┐   ┌────────────────┐
     │ Load style     │   │ User types     │   │ Use default    │
     │ automatically  │   │ /output-style  │   │ Claude behavior│
     │                │   │ command        │   │                │
     └────────────────┘   └────────────────┘   └────────────────┘
```

### Style Loading Locations

Claude Code searches for output styles in this order:

1. **Project-level**: `.claude/output-styles/[name].md`
2. **User-level**: `~/.claude/output-styles/[name].md`

Project-level styles override user-level styles with the same name.

### Style Activation Methods

**Manual** (per-session):
```
/output-style python-tutor
```

**Automatic** (via settings):
```json
// .claude/settings.local.json
{
  "outputStyle": "python-tutor"
}
```

### API Interaction Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│    User      │     │  Claude Code │     │  Anthropic   │
│              │     │     CLI      │     │    API       │
└──────┬───────┘     └──────┬───────┘     └──────┬───────┘
       │                    │                    │
       │ "What is a loop?" │                    │
       │───────────────────▶│                    │
       │                    │                    │
       │                    │ Build prompt:      │
       │                    │ - System prompt    │
       │                    │ - Output style     │
       │                    │ - User message     │
       │                    │ - Context files    │
       │                    │                    │
       │                    │───────────────────▶│
       │                    │                    │
       │                    │◀───────────────────│
       │                    │  Claude response   │
       │                    │  (pedagogical)     │
       │                    │                    │
       │◀───────────────────│                    │
       │ Formatted response │                    │
       │                    │                    │
```

---

## 4. Output Style Specification

### Frontmatter Schema

```yaml
---
name: string                    # Unique identifier (kebab-case)
type: string                    # "method" | "topic" | "combined"
description: string             # One-line description
keep-coding-instructions: bool  # Optional, default varies by type
source-method: string           # Only for type: combined
source-topic: string            # Only for type: combined
---
```

| Field | Required | Default | Description |
|-------|----------|---------|-------------|
| `name` | Yes | - | Unique identifier, lowercase with hyphens |
| `type` | Yes* | "topic" | Classifies the tutor (see Type System section) |
| `description` | Yes | - | One-line description for `/tutor list` |
| `keep-coding-instructions` | No | false for methods, true for topics | Whether to include coding-specific system prompt |
| `source-method` | Combined only | - | The method tutor this was derived from |
| `source-topic` | Combined only | - | The topic tutor this was derived from |

*Files without `type` are treated as `topic` for backward compatibility.

### Behavior Definition Schema

```markdown
## Core Constraint
[Single overriding rule]

## Target User
[Profile description]
- Characteristic 1
- Characteristic 2

## Core Behaviors

### 1. Behavior Name
When [trigger condition]:
- Action 1
- Action 2
- [Follow-up offer]

### 2. Another Behavior
...

## Artifacts

### Notebooks (`path/`)
[Structure specification]

### Cheatsheets (`path/`)
[Structure specification]

## Principles

**Do:**
- Guideline 1
- Guideline 2

**Don't:**
- Anti-pattern 1
- Anti-pattern 2

## Decision Flow

```
User request type → Response behavior
```
```

### Current Behavior Definitions

| Behavior | Trigger | Response Structure |
|----------|---------|-------------------|
| Explain Code | File or snippet shown | Summary → Steps → Concepts |
| Explain Concepts | "What is X?" | Definition → Analogy → Example → Location → Notebook offer |
| Translate Errors | Error pasted | Translation → Line → Cause → Investigation |
| Guide Modifications | "How do I change X?" | Files → Lines → Concept → Mistakes |
| Explain Project Flow | "How do files connect?" | Map → Execution path → Data flow |
| Check Code Quality | "Is this good?" | Assessment → Flags → Suggestions |

---

## 5. Tutor Type System

### Type Classification

Every tutor file has a `type` field that determines its role:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        TUTOR TYPE HIERARCHY                              │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                     METHOD TUTORS                                │    │
│  │                 (type: method)                                   │    │
│  │                                                                  │    │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────────┐    │    │
│  │  │ socratic  │ │rubber-duck│ │   eli5    │ │challenge-first│    │    │
│  │  └───────────┘ └───────────┘ └───────────┘ └───────────────┘    │    │
│  │  ┌───────────┐                                                   │    │
│  │  │minimalist │                                                   │    │
│  │  └───────────┘                                                   │    │
│  │                                                                  │    │
│  │  Defines HOW to teach (pedagogy, interaction patterns)          │    │
│  │  keep-coding-instructions: false                                 │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                   │                                      │
│                                   │ /tutor combine                       │
│                                   ▼                                      │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                     TOPIC TUTORS                                 │    │
│  │                 (type: topic)                                    │    │
│  │                                                                  │    │
│  │  ┌─────────────┐ ┌─────────────┐ ┌──────────────────────────┐   │    │
│  │  │python-tutor │ │  git-tutor  │ │stock-indicators-tutor    │   │    │
│  │  └─────────────┘ └─────────────┘ └──────────────────────────┘   │    │
│  │                                                                  │    │
│  │  Defines WHAT to teach (domain, constraints, artifacts)         │    │
│  │  keep-coding-instructions: varies                                │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                   │                                      │
│                                   │ Result                               │
│                                   ▼                                      │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                     COMBINED TUTORS                              │    │
│  │                 (type: combined)                                 │    │
│  │                                                                  │    │
│  │  ┌─────────────────────────┐ ┌─────────────────────────┐        │    │
│  │  │socratic-python-tutor    │ │eli5-git-tutor           │        │    │
│  │  └─────────────────────────┘ └─────────────────────────┘        │    │
│  │                                                                  │    │
│  │  Generated via /tutor combine <method> <topic>                   │    │
│  │  Inherits: method's pedagogy + topic's domain                    │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Type Characteristics

| Type | Purpose | `keep-coding-instructions` | Artifact Locations |
|------|---------|---------------------------|-------------------|
| `method` | Defines pedagogy | `false` (general-purpose) | None |
| `topic` | Defines domain | Varies (often `true`) | Yes (`tutor/notebooks/`, etc.) |
| `combined` | Merges both | Inherited from topic | Inherited from topic |

### Method Tutor Structure

```markdown
---
name: method-name
type: method
description: One-line description
keep-coding-instructions: false
---

## Core Constraint
**The key behavioral rule** (e.g., "Never give direct answers")

## How to Respond
[Interaction patterns for any question type]

## Example Interaction
[Demonstrate the method in action]

## Boundary Test
[Self-check: "If I'm about to do X, stop and do Y instead"]
```

### Topic Tutor Structure

```markdown
---
name: topic-tutor
type: topic
description: One-line description
---

## Core Constraint
**What this tutor will NOT do** (e.g., "No implementation code")

## Target User
[Who this is for, what they know]

## Core Behaviors
[Domain-specific teaching patterns]

## Artifacts
- Notebooks: `tutor/notebooks/domain/`
- Cheatsheets: `tutor/reference/domain/`
```

### Combined Tutor Structure

```markdown
---
name: method-topic-tutor
type: combined
description: <Topic> tutor using <Method> teaching style
source-method: method-name
source-topic: topic-tutor
---

## Teaching Method: <Method>
[Extracted from method tutor]

## Topic Domain: <Topic>
[Extracted from topic tutor]

## Combined Behaviors
[How method applies to topic]

## Artifacts
[Inherited from topic tutor]
```

---

## 6. The /tutor Command

### Command Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        /tutor COMMAND FLOW                                   │
│                                                                              │
│  User: /tutor <subcommand> [args]                                            │
│         │                                                                    │
│         ▼                                                                    │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                     SUBCOMMAND ROUTER                                  │  │
│  │                                                                        │  │
│  │  ┌──────┐ ┌────────┐ ┌───────┐ ┌──────┐ ┌────────┐ ┌────────┐         │  │
│  │  │ list │ │describe│ │combine│ │create│ │activate│ │ delete │         │  │
│  │  └──┬───┘ └───┬────┘ └───┬───┘ └──┬───┘ └───┬────┘ └───┬────┘         │  │
│  └─────┼─────────┼──────────┼────────┼─────────┼──────────┼──────────────┘  │
│        │         │          │        │         │          │                  │
│        ▼         ▼          ▼        ▼         ▼          ▼                  │
│  ┌──────────┐ ┌────────┐ ┌────────┐ ┌──────┐ ┌────────┐ ┌──────────┐        │
│  │Glob file │ │Read one│ │Read two│ │Wizard│ │Show    │ │Confirm & │        │
│  │names,    │ │.md file│ │.md files│ │prompts│ │activate│ │delete    │        │
│  │infer type│ │extract │ │validate│ │generate│ │instruct│ │.md file  │        │
│  │(no reads)│ │details │ │& merge │ │new file│ │        │ │(Bash rm) │        │
│  └──────────┘ └────────┘ └────────┘ └──────┘ └────────┘ └──────────┘        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Command File Location

```
.claude/commands/tutor.md
```

### Frontmatter

```yaml
---
name: tutor
description: Manage tutors - list, describe, combine, create, activate, or delete
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
arguments:
  - name: subcommand
    description: "list | describe | combine | create | activate | delete"
    required: true
  - name: args
    description: "Arguments for the subcommand"
    required: false
---
```

### Subcommand Specifications

| Subcommand | Input | Output | Side Effects |
|------------|-------|--------|--------------|
| `list` | None | Categorized tutor list (no descriptions) | None |
| `describe` | Tutor name | Details + core constraint | None |
| `combine` | Two tutor names | Success message | Creates new .md file |
| `create` | New tutor name | Success message | Creates new .md file |
| `activate` | Tutor name | Instructions | None |
| `delete` | Tutor name | Success/cancelled message | Deletes .md file (after confirmation) |

### `/tutor list` Type Inference

For performance, `/tutor list` uses **filename-based inference** instead of reading file contents:

| Filename Pattern | Inferred Type |
|------------------|---------------|
| Known methods: `socratic`, `eli5`, `rubber-duck`, `minimalist`, `challenge-first` | `method` |
| Ends with `-tutor` (e.g., `python-tutor`, `git-tutor`) | `topic` |
| Contains known method prefix + another part (e.g., `socratic-python-tutor`) | `combined` |
| Anything else | `topic` (default) |

**Important**: Topic tutors should end with `-tutor` for correct classification.

### Naming Normalization Algorithm

```python
def normalize_combined_name(tutor_a, tutor_b, type_a, type_b):
    """
    Ensures consistent naming regardless of input order.

    Rules:
    1. method + topic → "METHOD-TOPIC"
    2. topic + method → "METHOD-TOPIC" (swapped)
    3. same types → alphabetical order
    """
    if type_a == "method" and type_b == "topic":
        return f"{tutor_a}-{tutor_b}"
    elif type_a == "topic" and type_b == "method":
        return f"{tutor_b}-{tutor_a}"  # Swap: method first
    else:
        # Same types: alphabetical
        return f"{min(tutor_a, tutor_b)}-{max(tutor_a, tutor_b)}"
```

### Validation Matrix

| Combination | Action | User Prompt |
|-------------|--------|-------------|
| method + topic | Proceed | None |
| topic + method | Swap & proceed | None |
| method + method | Warn | "May produce conflicting instructions. Proceed?" |
| topic + topic | Warn | "Will mix domains. Proceed?" |
| self + self | Error | "Cannot combine a tutor with itself." |
| missing + any | Error | "Tutor 'X' not found. Available: ..." |

---

## 7. Artifact Generation

### Notebook Generation

**Target Directory**: `tutor/notebooks/`
**File Format**: Jupyter Notebook (`.ipynb`)
**Naming Convention**: `[concept-name].ipynb` (kebab-case)

**Required Structure**:
```
1. Introduction (markdown)
2. Simplest Example (code + output)
3. Explanation (markdown)
4. Experiment Prompt (markdown)
5. Building Complexity (code + output)
6. Connection to Real Code (markdown)
7. Practice Exercise (code - empty)
8. Solution (code - hidden initially)
```

**Cell Type Distribution**:
- ~50% markdown (explanations)
- ~50% code (examples and exercises)

### Cheatsheet Generation

**Target Directory**: `tutor/reference/`
**File Format**: Markdown (`.md`)
**Naming Convention**: `[topic]-cheatsheet.md` (kebab-case)

**Required Structure**:
```markdown
# [Topic] Cheatsheet

Quick reference for [context].

---

## [Category 1]

### [Pattern Name]

```python
# Minimal example
```

**What it does:** [explanation]
**Where you use it:** `file.py` line X

---

## Common Mistakes

### ❌ Wrong: [Description]
```python
# Bad code
```

### ✅ Right: [Description]
```python
# Good code
```
```

---

## 8. Example Project Analysis

### `example.ipynb` Technical Breakdown

#### Cell 1: Imports

```python
import requests          # HTTP client (like curl)
from bs4 import BeautifulSoup  # HTML parser
import json             # JSON encoder/decoder
import re               # Regular expressions
import pandas as pd     # DataFrames
```

**Dependency Graph**:
```
requests ─────────────▶ HTTP response
                              │
                              ▼
beautifulsoup4 ─────▶ Parsed HTML (soup)
                              │
                   ┌──────────┴──────────┐
                   │                     │
                   ▼                     ▼
              json (LD data)      re (text patterns)
                   │                     │
                   └──────────┬──────────┘
                              │
                              ▼
                     pandas DataFrame
                              │
                              ▼
                        CSV output
```

#### Cell 2: URL Collection

**Algorithm**:
1. Initialize empty list
2. For each page (1-5):
   - Construct paginated URL
   - GET request
   - Parse HTML
   - Find all `<a class="jobcardStyle1">`
   - Extract `href` attributes
   - Deduplicate (set comprehension)
   - Extend list

**Complexity**: O(n × m) where n = pages, m = jobs per page

#### Cell 3: Data Extraction Function

**Function Signature**:
```python
def extract_job_data(soup: BeautifulSoup) -> dict
```

**Extraction Strategy**:
```
┌─────────────────────────────────────────┐
│              INPUT: soup                │
└─────────────────────┬───────────────────┘
                      │
           ┌──────────▼──────────┐
           │ Try JSON-LD first   │
           │ (script type=       │
           │  application/ld+json)│
           └──────────┬──────────┘
                      │
        ┌─────────────┴─────────────┐
        │ Found?                    │
        │                           │
    ┌───▼───┐                  ┌────▼────┐
    │  Yes  │                  │   No    │
    └───┬───┘                  └────┬────┘
        │                           │
        ▼                           ▼
┌───────────────┐         ┌────────────────┐
│ Extract from  │         │ DOM Fallbacks: │
│ JSON-LD:      │         │ - CSS selectors│
│ - title       │         │ - find() calls │
│ - org         │         │ - regex search │
│ - salary      │         │                │
│ - location    │         │                │
│ - description │         │                │
│ - job_type    │         │                │
└───────┬───────┘         └───────┬────────┘
        │                         │
        └───────────┬─────────────┘
                    │
           ┌────────▼────────┐
           │ Merge & Clean   │
           │ (use first non- │
           │  empty value)   │
           └────────┬────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │ OUTPUT: dict with     │
        │ - job_title           │
        │ - organization        │
        │ - min_salary          │
        │ - max_salary          │
        │ - location            │
        │ - job_description     │
        │ - job_type            │
        └───────────────────────┘
```

**Return Type**:
```python
{
    "job_title": str,
    "organization": str,
    "min_salary": str,
    "max_salary": str,
    "location": str,
    "job_description": str,
    "job_type": str
}
```

---

## 9. Data Flow Diagrams

### Complete System Data Flow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   aijobs.ai │───▶│   requests  │───▶│ HTTP        │
│   Server    │ HTTP│   .get()    │    │ Response    │
└─────────────┘    └─────────────┘    └──────┬──────┘
                                             │
                                             │ response.text
                                             ▼
                                    ┌────────────────┐
                                    │ Raw HTML       │
                                    │ (string)       │
                                    └───────┬────────┘
                                            │
                                            │ BeautifulSoup()
                                            ▼
                                    ┌────────────────┐
                                    │ soup           │
                                    │ (parsed DOM)   │
                                    └───────┬────────┘
                                            │
                           ┌────────────────┴────────────────┐
                           │                                 │
                           ▼                                 ▼
                  ┌────────────────┐               ┌────────────────┐
                  │ find_all()     │               │ extract_job_   │
                  │ for job links  │               │ data() for     │
                  │                │               │ individual job │
                  └───────┬────────┘               └───────┬────────┘
                          │                                │
                          │ list of URLs                   │ dict
                          ▼                                ▼
                  ┌────────────────┐               ┌────────────────┐
                  │ job_url_list   │               │ job_data_list  │
                  │ [str, ...]     │               │ [dict, ...]    │
                  └───────┬────────┘               └───────┬────────┘
                          │                                │
                          │                                │ pd.DataFrame()
                          │                                ▼
                          │                       ┌────────────────┐
                          │                       │ df             │
                          │                       │ (DataFrame)    │
                          │                       └───────┬────────┘
                          │                               │
                          │                               │ df.to_csv()
                          │                               ▼
                          │                       ┌────────────────┐
                          │                       │ job_data.csv   │
                          │                       │ (file)         │
                          │                       └────────────────┘
                          │
                          │ (iterated for each URL)
                          │
                          ▼
                  ┌────────────────┐
                  │ Loop: requests │
                  │ .get(job_url)  │
                  └────────────────┘
```

### User Interaction Data Flow

```
┌─────────────┐
│    User     │
└──────┬──────┘
       │ Types question
       ▼
┌─────────────────────┐
│   Claude Code CLI   │
│                     │
│ Input processing:   │
│ - Parse command     │
│ - Load output style │
│ - Read project files│
└──────────┬──────────┘
           │
           │ API request with:
           │ - System prompt
           │ - Output style
           │ - User message
           │ - File context
           ▼
┌─────────────────────┐
│   Anthropic API     │
│                     │
│ Claude processes:   │
│ - Follows style     │
│ - Generates response│
└──────────┬──────────┘
           │
           │ Response stream
           ▼
┌─────────────────────┐
│   Claude Code CLI   │
│                     │
│ Output processing:  │
│ - Format markdown   │
│ - Write files       │
│   (if artifacts)    │
└──────────┬──────────┘
           │
           │ Formatted response
           ▼
┌─────────────────────┐
│    User Terminal    │
└─────────────────────┘
```

---

## 10. Extension Points

### Adding New Behaviors

**Location**: `.claude/output-styles/python-tutor.md`

**Process**:
1. Identify new user request pattern
2. Define trigger condition
3. Specify response structure
4. Add to Core Behaviors section
5. Update Decision Flow

**Template**:
```markdown
### N. New Behavior Name
When [user does/asks X]:
- [First response element]
- [Second response element]
- [Optional follow-up offer]
```

### Creating New Output Styles

**Process**:
1. Create `.claude/output-styles/[name].md`
2. Define frontmatter (name, description)
3. Define target user
4. Define behaviors
5. Define artifacts (if any)
6. Define principles
7. Define decision flow

**Example domains**:
- Data science tutor
- Web development tutor
- Testing methodology tutor
- Code review style

### Adding New Example Projects

**Requirements**:
- Self-contained (all dependencies documented)
- Progressively complex
- Real-world applicable
- Heavily commented

**Process**:
1. Create notebook in project root
2. Document all dependencies
3. Include sample data or reliable data sources
4. Add markdown explanations between code
5. Reference from output style

---

## 11. Security Considerations

### Web Scraping Risks

**Risk**: Target website changes or blocks requests
**Mitigation**: Example uses stable public website; not production code

**Risk**: Malicious HTML injection
**Mitigation**: BeautifulSoup sanitizes input; no `eval()` or `exec()`

**Risk**: Rate limiting / IP blocking
**Mitigation**: Example makes limited requests; teaches concept not production scraping

### API Key Security

**Risk**: API key exposure
**Mitigation**: Keys stored as environment variables; never in code

**Risk**: Excessive API usage
**Mitigation**: Claude Code has built-in usage limits

### User Input

**Risk**: Malicious code in user questions
**Mitigation**: Claude Code sandboxes execution; tutor doesn't execute user code

---

## 12. Performance Characteristics

### Latency Sources

| Component | Typical Latency |
|-----------|-----------------|
| Claude Code startup | 1-2 seconds |
| Output style loading | <100ms |
| API round-trip | 1-5 seconds (depends on response length) |
| Jupyter Lab startup | 3-5 seconds |
| Notebook execution | Varies (web requests dominate) |

### Resource Usage

**Claude Code CLI**:
- Memory: ~50-100 MB
- CPU: Minimal (waiting for API responses)
- Network: Depends on conversation length

**Jupyter Lab**:
- Memory: ~200-500 MB
- CPU: Spike during cell execution
- Network: Minimal (local server)

**Example Notebook Execution**:
- Time: 30-120 seconds (5 pages × ~20 jobs)
- Network: ~100+ HTTP requests
- Memory: ~100 MB (DataFrame in memory)

### Optimization Opportunities

1. **Notebook caching**: Cache HTTP responses during development
2. **Async requests**: Could use `aiohttp` for parallel job fetching
3. **Incremental processing**: Process jobs as they're fetched

**Note**: Optimizations not implemented because educational clarity > performance for this project.

---

## Appendix: File Format Specifications

### Jupyter Notebook Format (`.ipynb`)

```json
{
  "cells": [
    {
      "cell_type": "markdown",  // or "code"
      "metadata": {},
      "source": ["Line 1\n", "Line 2"]
    }
  ],
  "metadata": {
    "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
    }
  },
  "nbformat": 4,
  "nbformat_minor": 5
}
```

### TOML Configuration (`pyproject.toml`)

```toml
[project]
name = "string"
version = "X.Y.Z"
description = "string"
readme = "README.md"
requires-python = ">=3.13"
dependencies = [
    "package>=version",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

### UV Lock File (`uv.lock`)

Auto-generated. Do not edit manually. Contains exact versions of all direct and transitive dependencies.
