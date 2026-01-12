# Python Tutor

A Claude Code output-style that turns Claude into a Python tutor for complete beginners. Instead of implementing code for you, it teaches concepts through plain English explanations, hands-on notebooks, and guided exploration.

## Why Output Styles Instead of Just Prompting?

You can always prompt Claude directly. So why use output styles?

| Aspect | Ad-hoc Prompting | Output Style |
|--------|------------------|--------------|
| **Persistence** | Must re-explain each message | Behavior persists entire session |
| **Constraints** | Claude may drift or forget rules | Hard boundaries always enforced |
| **Your prompts** | Wasted on re-establishing persona | Focus purely on your questions |
| **Switching tutors** | Paragraphs of instructions | Just `/output-style git-tutor` |
| **Sharing** | Copy-paste text | Copy the `.md` file |

**Key insight:** Output styles are "compiled" tutor personas. Ad-hoc prompting is "interpreted" - works but less reliable and more overhead per interaction.

[Read the full explanation](docs/WHY_OUTPUT_STYLES.md)

## Available Tutors

| Tutor | Output Style | Description |
|-------|--------------|-------------|
| **Python Tutor** | `python-tutor` | Core Python programming concepts for beginners |
| **Stock Indicators Tutor** | `stock-indicators-tutor` | Fundamental and technical analysis indicators (~100+ indicators) |
| **Git Tutor** | `git-tutor` | Version control concepts with visual diagrams and mental models |

**To switch tutors:** Run `/output-style <tutor-name>` in Claude Code (e.g., `/output-style stock-indicators-tutor`)

**Resources:**
- [Video explainer](https://youtu.be/8FpZT6-h8wY)

## Documentation

| Document | Audience | Description |
|----------|----------|-------------|
| [Why Output Styles?](docs/WHY_OUTPUT_STYLES.md) | Everyone | Why tutors-as-output-styles beat ad-hoc prompting |
| [Quick Start Guide](docs/QUICK_START.md) | Everyone | Get running in 5 minutes + 12 educational use cases |
| [User Guide](docs/USER_GUIDE.md) | Learners | Complete guide for using the tutor |
| [Developer Guide](docs/DEVELOPER_GUIDE.md) | Developers | Deep dive for extending the project |
| [Technical Architecture](docs/TECHNICAL_ARCHITECTURE.md) | Developers | System design and specifications |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Everyone | Solutions to common problems |
| [CLAUDE.md](CLAUDE.md) | Claude Code | Quick reference for AI assistance |

## Key Features

**Six core teaching behaviors:**
- **Explain Code** - One-sentence summaries, key steps, and core concepts from your files
- **Explain Concepts** - Plain English definitions with real-world analogies and minimal examples
- **Translate Errors** - Error messages in plain English with investigation guidance
- **Guide Modifications** - Describe what to change and where, conceptually (no implementation)
- **Explain Project Flow** - Map how your files connect and trace execution paths
- **Check Code Quality** - Flag AI-generated code quirks and overcomplicated patterns

**Creates learning artifacts:**
- **Notebooks** (`tutor/notebooks/<domain>/`) - Hands-on practice with progressive complexity
- **Cheatsheets** (`tutor/reference/<domain>/`) - Quick references using concepts from your actual code

## Stock Indicators Tutor

The Stock Indicators Tutor teaches fundamental and technical analysis indicators for beginners learning stock market analysis.

**Core Principle:** Understanding first, never trading advice.

**Six teaching behaviors:**
- **Explain Indicators** - P/E, RSI, MACD with formulas, analogies, and interpretation ranges
- **Explain Concepts** - Enterprise value, trailing twelve months, leading vs lagging indicators
- **Translate Financial Data** - Interpret statements and indicator values in plain English
- **Guide Analysis** - Which indicators to use when, in what order, and common mistakes
- **Explain Relationships** - How indicators confirm/contradict each other, divergence patterns
- **Check Analysis Quality** - Flag missing indicators, over-reliance on single metrics

**Stock Analysis Resources:**

| Resource | Path | Description |
|----------|------|-------------|
| Full Example | `examples/stock-analysis.ipynb` | Complete analysis with real Apple data |
| Valuation Ratios | `tutor/notebooks/stock-analysis/fundamental-ratios.ipynb` | P/E, P/B, EV/EBITDA practice |
| Technical Indicators | `tutor/notebooks/stock-analysis/technical-indicators.ipynb` | RSI, MACD, Bollinger Bands |
| Stock Screener | `tutor/notebooks/stock-analysis/stock-screener.ipynb` | Build multi-factor screens |
| Valuation Cheatsheet | `tutor/reference/stock-analysis/valuation-ratios.md` | Quick reference for valuations |
| Technical Cheatsheet | `tutor/reference/stock-analysis/technical-indicators.md` | Quick reference for technicals |
| Composite Scores | `tutor/reference/stock-analysis/composite-scores.md` | F-Score, Z-Score, M-Score |
| Full Indicator List | `docs/stock-indicators.md` | 100+ indicators reference |

**Stock Analysis Example Prompts:**
```
"What is the P/E ratio?"
"Explain RSI and when to use it"
"What does Apple's P/E of 28 and P/B of 45 mean?"
"How do I analyze if Tesla is overvalued?"
"Why might RSI contradict MACD?"
```

## Git Tutor

The Git Tutor teaches version control concepts through visual diagrams and plain English explanations. Perfect for developers who copy-paste git commands without understanding what they do.

**Core Principle:** Understanding the model, not memorizing commands.

**Six teaching behaviors:**
- **Explain Commands** - What git add/commit/reset actually do, with before/after visuals
- **Explain Concepts** - Staging area, HEAD, branches with ASCII diagrams
- **Translate Git Messages** - "Your branch is 3 commits behind" in plain English
- **Visualize Git State** - Commit graphs, branch structures, remote tracking
- **Guide Workflows** - Feature branch workflow, handling conflicts, rebasing vs merging
- **Check Git Hygiene** - Commit message quality, branch organization, history cleanliness

**Git Resources:**

| Resource | Path | Description |
|----------|------|-------------|
| Basics Tutorial | `tutor/notebooks/git/basics.ipynb` | add, commit, push, status, log |
| Branching Tutorial | `tutor/notebooks/git/branching.ipynb` | create, merge, conflicts |
| Undoing Changes | `tutor/notebooks/git/undoing-changes.ipynb` | reset, revert, stash, reflog |
| Commands Cheatsheet | `tutor/reference/git/commands-cheatsheet.md` | All commands with visuals |
| Mental Model | `tutor/reference/git/mental-model.md` | Three trees, HEAD, branches |
| Workflows | `tutor/reference/git/workflows-cheatsheet.md` | Feature branch, rebasing |
| Practice Playground | `examples/git-playground/` | Safe sandbox for experimenting |

**Git Example Prompts:**
```
"What does git add actually do?"
"What is the staging area?"
"I got 'detached HEAD' - what happened?"
"How do I undo my last commit?"
"Show me what my repo looks like as a diagram"
```

## Setup Instructions

**User-level:**

To use the tutor across any project:

1. Copy `.claude/output-styles/python-tutor.md` to your `~/.claude/output-styles` directory
2. In any Claude Code session, run: `/output-style python-tutor`
- *Note: You must activate it manually each time you start Claude Code. User-level settings are overridden by project-level settings if both exist.*

**Project-level:**

This repo uses project-level configuration. To use it in your own projects:

1. Copy `.claude/output-styles/python-tutor.md` to your project directory
2. Create `.claude/settings.local.json` in your project:
3. 
   ```json
   {
     "outputStyle": "python-tutor"
   }
   ```
4. Start Claude Code in that directory (tutor style activates automatically).

## Usage Examples

**Running this example repo:**

```bash
# Clone and navigate to this directory
git clone https://github.com/ShawhinT/AI-Builders-Bootcamp-8.git
cd AI-Builders-Bootcamp-8/python-tutor

# Install dependencies (choose one)
uv sync
# or
pip install jupyterlab ipykernel

# Start Claude Code
claude
```

**Interaction examples:**

```
You: "explain example.ipynb"
Claude: [Provides one-sentence summary of the job scraper,
         lists key steps, highlights 3 core concepts like
         BeautifulSoup, data extraction patterns, and DataFrame usage]
```

```
You: "what is a list comprehension?"
Claude: [Plain English definition with real-world analogy,
         minimal runnable example, explanation of why it exists,
         shows where it appears in your code, offers practice notebook]
```

```
You: [Pastes AttributeError traceback]
Claude: [Translates to "You tried to access an attribute that doesn't exist",
         points to the specific line, explains likely cause,
         suggests how to investigate]
```

```
You: "how do I add email extraction to the job scraper?"
Claude: [Describes which file and lines to modify (example.ipynb:45-60),
         explains the conceptual approach (add new find() call in
         extract_job_data function, handle missing emails),
         notes ripple effects and common mistakes,
         does NOT write the implementation code]
```
