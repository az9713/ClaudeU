# CLAUDE.md - Python Tutor Project Guide

This file provides essential context for Claude Code when working with this project.

## Project Overview

**Python Tutor** is a Claude Code output-style that transforms Claude into an interactive Python tutor for complete beginners. Instead of implementing code, it teaches concepts through plain English explanations, hands-on Jupyter notebooks, and guided exploration.

**Primary Purpose**: Help beginners who use AI to generate code understand what that code actually does, so they can modify and extend it themselves.

## Quick Commands

```bash
# Install dependencies
uv sync                    # Preferred method (uses uv package manager)
pip install -r requirements.txt  # Alternative method

# Start Jupyter Lab to work with notebooks
jupyter lab

# Activate the tutor style in Claude Code
/output-style python-tutor
```

## Project Structure

```
python-tutor/
├── .claude/
│   └── output-styles/
│       └── python-tutor.md    # The core tutor behavior definition
├── tutor/
│   ├── notebooks/             # Hands-on practice notebooks (created by tutor)
│   │   └── html-and-beautifulsoup.ipynb
│   └── reference/             # Quick reference cheatsheets (created by tutor)
│       └── beautifulsoup-cheatsheet.md
├── example.ipynb              # Example job scraper for learning
├── pyproject.toml             # Project configuration (Python 3.13+)
├── .python-version            # Python version specification
└── uv.lock                    # Locked dependencies
```

## Architecture Overview

### Output Style System
- **Location**: `.claude/output-styles/python-tutor.md`
- **Purpose**: Defines Claude's pedagogical behavior
- **Key Constraint**: Teaching only, no implementation code

### Six Core Teaching Behaviors
1. **Explain Code** - One-sentence summaries with key steps and concepts
2. **Explain Concepts** - Plain English definitions with real-world analogies
3. **Translate Errors** - Error messages in plain English with investigation guidance
4. **Guide Modifications** - Describe what to change conceptually (no implementation)
5. **Explain Project Flow** - Map file connections and execution paths
6. **Check Code Quality** - Flag AI-generated code quirks and overcomplicated patterns

### Learning Artifacts
- **Notebooks** (`tutor/notebooks/`): Hands-on practice with progressive complexity
- **Cheatsheets** (`tutor/reference/`): Quick references based on user's actual code

## Code Conventions

### Python Style
- Python 3.13+ required
- Use type hints for function signatures
- Follow PEP 8 naming conventions
- Notebooks use clear, educational variable names

### Notebook Structure (when creating teaching notebooks)
1. Simplest possible example with output
2. Break down what happened
3. Experiment prompt (modify and rerun)
4. Build up one element
5. Connect to user's actual code
6. Practice exercise with solution

### Cheatsheet Structure
- Focus on patterns actually used in the project
- Include file and line number references
- Minimal examples (2-5 lines)
- Common mistakes section

## Dependencies

Core dependencies (from `pyproject.toml`):
- `ipykernel>=7.1.0` - Jupyter kernel for Python
- `jupyterlab>=4.5.1` - Interactive notebook environment

Example notebook additional dependencies:
- `requests` - HTTP requests for web scraping
- `beautifulsoup4` - HTML parsing
- `pandas` - Data manipulation
- `lxml` or `html.parser` - HTML parser backend

## Key Files to Understand

### `.claude/output-styles/python-tutor.md`
The brain of the tutor. Defines:
- Target user profile (complete beginner)
- Core teaching behaviors
- Decision flow for different user requests
- Artifact creation guidelines
- Principles (do's and don'ts)

### `example.ipynb`
A complete, working job scraper that:
1. Fetches job listings from aijobs.ai
2. Extracts job data (title, company, salary, location, description)
3. Handles JSON-LD structured data with DOM fallbacks
4. Saves results to CSV

This serves as the primary learning example for students.

## Testing

No automated tests exist yet. Manual testing involves:
1. Starting Claude Code in the project directory
2. Verifying `/output-style python-tutor` activates the tutor
3. Testing each core behavior with sample requests
4. Checking that notebooks run without errors in Jupyter Lab

## Common Tasks

### Adding a New Teaching Notebook
1. Create file in `tutor/notebooks/[concept].ipynb`
2. Follow the 6-step notebook structure
3. Include runnable sample data
4. Add experiment prompts for students

### Adding a New Cheatsheet
1. Create file in `tutor/reference/[name].md`
2. Scan codebase for relevant patterns
3. Include line number references
4. Add common mistakes section

### Modifying Tutor Behavior
1. Edit `.claude/output-styles/python-tutor.md`
2. Test changes with various user prompts
3. Ensure consistency with teaching-only constraint

## Important Constraints

1. **No Implementation Code**: The tutor describes changes but doesn't write production code
2. **Beginner-First Language**: Avoid jargon without explanation
3. **Reference Actual Code**: Always point to specific files and line numbers
4. **Progressive Complexity**: Start simpler than feels necessary

## Troubleshooting

### Common Issues
- **Tutor style not activating**: Ensure `.claude/settings.local.json` exists with `{"outputStyle": "python-tutor"}`
- **Notebooks won't run**: Check that `uv sync` or `pip install` completed successfully
- **Missing dependencies**: Run `pip install requests beautifulsoup4 pandas` for example notebook

### Debug Commands
```bash
# Check Python version
python --version

# Verify Jupyter installation
jupyter --version

# List installed packages
pip list
```
