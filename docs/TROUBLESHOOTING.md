# Python Tutor - Troubleshooting Guide

A comprehensive guide to solving common problems. If your issue isn't listed here, open an issue on GitHub.

---

## Table of Contents

1. [Installation Problems](#1-installation-problems)
2. [Claude Code Issues](#2-claude-code-issues)
3. [Jupyter Lab Problems](#3-jupyter-lab-problems)
4. [Notebook Execution Errors](#4-notebook-execution-errors)
5. [Output Style Issues](#5-output-style-issues)
6. [Web Scraping Errors](#6-web-scraping-errors)
7. [Python Environment Issues](#7-python-environment-issues)
8. [Common Error Messages](#8-common-error-messages)
9. [Performance Issues](#9-performance-issues)
10. [Getting More Help](#10-getting-more-help)

---

## 1. Installation Problems

### Python Not Found

**Symptom**:
```
'python' is not recognized as an internal or external command
```

**Cause**: Python isn't installed or isn't in your PATH.

**Solution (Windows)**:
1. Reinstall Python from https://python.org
2. **Check "Add Python to PATH"** during installation
3. Restart your terminal

**Solution (Mac/Linux)**:
```bash
# Check if python3 works instead
python3 --version

# If that works, use python3 instead of python
# Or create an alias:
alias python=python3
```

---

### pip Not Found

**Symptom**:
```
'pip' is not recognized as an internal or external command
```

**Solution (Windows)**:
```cmd
# Try using Python -m pip
python -m pip install [package]

# If that works, always use python -m pip
```

**Solution (Mac/Linux)**:
```bash
# Try pip3
pip3 install [package]

# Or use Python module
python3 -m pip install [package]
```

---

### UV Installation Failed

**Symptom**:
```
Failed to install uv
```

**Solution**: UV is optional. Use pip instead:
```bash
# Instead of: uv sync
# Use:
pip install -r requirements.txt

# Or install dependencies manually:
pip install jupyterlab ipykernel requests beautifulsoup4 pandas
```

---

### Permission Denied During Installation

**Symptom**:
```
PermissionError: [Errno 13] Permission denied
```

**Solution (Windows)**: Run Command Prompt as Administrator

**Solution (Mac/Linux)**:
```bash
# Option 1: Use --user flag
pip install --user [package]

# Option 2: Use sudo (not recommended for pip)
sudo pip install [package]

# Option 3: Use a virtual environment (recommended)
python -m venv .venv
source .venv/bin/activate  # Mac/Linux
.venv\Scripts\activate     # Windows
pip install [package]
```

---

## 2. Claude Code Issues

### Claude Code Not Found

**Symptom**:
```
'claude' is not recognized as an internal or external command
```

**Solution**:
```bash
# Reinstall Claude Code
pip install claude-code

# Verify installation
pip show claude-code

# If installed but not found, check PATH
# The executable should be in your Python scripts folder
```

---

### API Key Not Set

**Symptom**:
```
Error: ANTHROPIC_API_KEY environment variable not set
```

**Solution (Windows - PowerShell)**:
```powershell
# Set for current session
$env:ANTHROPIC_API_KEY="your-api-key-here"

# Set permanently
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "your-api-key-here", "User")
```

**Solution (Windows - Command Prompt)**:
```cmd
# Set for current session
set ANTHROPIC_API_KEY=your-api-key-here

# Set permanently (via System Properties > Environment Variables)
```

**Solution (Mac/Linux)**:
```bash
# Set for current session
export ANTHROPIC_API_KEY="your-api-key-here"

# Set permanently (add to ~/.bashrc or ~/.zshrc)
echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.bashrc
source ~/.bashrc
```

---

### API Key Invalid

**Symptom**:
```
Error: Invalid API key
```

**Causes and Solutions**:
1. **Key copied incorrectly**: Re-copy from https://console.anthropic.com/
2. **Key has extra spaces**: Remove any leading/trailing whitespace
3. **Key revoked**: Generate a new key from the console
4. **Wrong key type**: Ensure it's an API key, not another credential

---

### Claude Code Hangs/No Response

**Symptom**: Claude Code starts but doesn't respond to input

**Solutions**:
1. Check internet connection
2. Try restarting Claude Code
3. Check API status at https://status.anthropic.com/
4. Try a simple command first: `hello`

---

## 3. Jupyter Lab Problems

### Jupyter Lab Won't Start

**Symptom**:
```
jupyter: command not found
```

**Solution**:
```bash
# Reinstall Jupyter Lab
pip install jupyterlab

# If still not found, use full path
python -m jupyter lab
```

---

### Jupyter Lab Opens But Is Blank

**Symptom**: Browser opens but shows empty page

**Solutions**:
1. Clear browser cache
2. Try a different browser
3. Check the terminal for the correct URL (might not be localhost:8888)
4. Try starting on a different port:
   ```bash
   jupyter lab --port=8889
   ```

---

### Can't Connect to Kernel

**Symptom**: Notebook shows "Connecting to kernel..." indefinitely

**Solutions**:
1. Install ipykernel:
   ```bash
   pip install ipykernel
   ```
2. Register the kernel:
   ```bash
   python -m ipykernel install --user --name python3
   ```
3. Restart Jupyter Lab

---

### Kernel Dies When Running Code

**Symptom**: "The kernel appears to have died"

**Causes and Solutions**:

| Cause | Solution |
|-------|----------|
| Out of memory | Reduce data size or restart kernel |
| Infinite loop | Add print statements to debug |
| Conflicting packages | Create fresh virtual environment |
| Corrupted kernel | Reinstall ipykernel |

---

## 4. Notebook Execution Errors

### ModuleNotFoundError

**Symptom**:
```python
ModuleNotFoundError: No module named 'requests'
```

**Solution**:
```bash
# Install the missing module
pip install requests

# For other common modules:
pip install beautifulsoup4  # for BeautifulSoup
pip install pandas          # for pandas
pip install lxml            # alternative HTML parser
```

---

### Cells Running Out of Order

**Symptom**: `NameError: name 'variable' is not defined`

**Cause**: Running cells out of order; a cell depends on a previous cell.

**Solution**:
1. Go to menu: **Kernel → Restart Kernel and Run All Cells**
2. Or run cells from top to bottom in order

---

### Output Not Showing

**Symptom**: Code runs but nothing appears below the cell

**Common Causes**:
1. Code doesn't produce output (no `print()` or return value)
2. The last line isn't an expression

**Solution**:
```python
# Add explicit print
result = some_function()
print(result)

# Or put the variable on its own line
result = some_function()
result  # This will display in Jupyter
```

---

## 5. Output Style Issues

### Style Not Loading

**Symptom**: `/output-style python-tutor` shows error

**Solutions**:

1. **Check file exists**:
   ```bash
   ls -la .claude/output-styles/
   # Should show python-tutor.md
   ```

2. **Check file path**:
   - Project level: `.claude/output-styles/python-tutor.md`
   - User level: `~/.claude/output-styles/python-tutor.md`

3. **Check file format**:
   ```bash
   head -10 .claude/output-styles/python-tutor.md
   # Should show YAML frontmatter (---)
   ```

---

### Style Not Activating Automatically

**Symptom**: Have to manually run `/output-style` every time

**Solution**: Create settings file:
```bash
# Create .claude/settings.local.json with:
{
  "outputStyle": "python-tutor"
}
```

**Important**: The file must be valid JSON (proper quotes, no trailing commas).

---

### Style Behavior Incorrect

**Symptom**: Claude isn't following the style rules

**Solutions**:
1. Verify style is active: Look for confirmation message
2. Check for syntax errors in the style file
3. Style rules may be overridden by user requests

---

## 6. Web Scraping Errors

### Connection Error

**Symptom**:
```python
requests.exceptions.ConnectionError: Failed to establish connection
```

**Causes and Solutions**:

| Cause | Solution |
|-------|----------|
| No internet | Check network connection |
| Website down | Try again later |
| Firewall blocking | Check firewall settings |
| VPN issues | Try with/without VPN |

---

### HTTP 403 Forbidden

**Symptom**:
```python
Response status code: 403
```

**Cause**: Website blocking automated requests

**Solutions**:
1. Add a User-Agent header:
   ```python
   headers = {'User-Agent': 'Mozilla/5.0'}
   response = requests.get(url, headers=headers)
   ```
2. Reduce request frequency
3. Website may have anti-scraping measures

---

### HTTP 429 Too Many Requests

**Symptom**:
```python
Response status code: 429
```

**Cause**: Rate limiting - too many requests too fast

**Solution**: Add delays between requests:
```python
import time

for url in urls:
    response = requests.get(url)
    time.sleep(1)  # Wait 1 second between requests
```

---

### BeautifulSoup Returns None

**Symptom**:
```python
soup.find("h1")  # Returns None
```

**Causes and Solutions**:
1. **Element doesn't exist**: Check the actual HTML
   ```python
   print(soup.prettify()[:2000])  # View first 2000 chars
   ```
2. **Wrong selector**: Inspect the page in browser
3. **Dynamic content**: Page uses JavaScript (BeautifulSoup can't see it)

---

### AttributeError: NoneType has no attribute 'text'

**Symptom**:
```python
AttributeError: 'NoneType' object has no attribute 'text'
```

**Cause**: Trying to get `.text` from a `find()` that returned `None`

**Solution**: Check before accessing:
```python
element = soup.find("h1")
if element:
    text = element.text
else:
    text = "Not found"
```

---

## 7. Python Environment Issues

### Wrong Python Version

**Symptom**:
```
SyntaxError: invalid syntax
# (for code that works in Python 3.13)
```

**Solution**:
```bash
# Check version
python --version

# If less than 3.13, install newer Python
# Or use pyenv to manage versions:
pyenv install 3.13
pyenv local 3.13
```

---

### Virtual Environment Not Activating

**Symptom**: Packages not found despite being installed

**Solution**:
```bash
# Windows
.venv\Scripts\activate

# Mac/Linux
source .venv/bin/activate

# Verify activation (should show .venv in prompt)
which python  # Should point to .venv/
```

---

### Package Version Conflicts

**Symptom**:
```
ERROR: Cannot install X because conflicts with Y
```

**Solutions**:
1. Create a fresh virtual environment:
   ```bash
   python -m venv fresh_env
   source fresh_env/bin/activate
   pip install -r requirements.txt
   ```
2. Use `uv` for better dependency resolution:
   ```bash
   uv sync
   ```

---

## 8. Common Error Messages

### Quick Reference Table

| Error | Meaning | Quick Fix |
|-------|---------|-----------|
| `SyntaxError` | Typo or missing punctuation | Check colons, parentheses, quotes |
| `NameError` | Variable not defined | Run cells in order; check spelling |
| `TypeError` | Wrong type for operation | Check what type your variable is |
| `IndexError` | List index out of range | Check list length before accessing |
| `KeyError` | Dictionary key doesn't exist | Use `.get()` instead of `[]` |
| `ImportError` | Module not installed | `pip install [module]` |
| `FileNotFoundError` | File path incorrect | Check path; use absolute paths |
| `IndentationError` | Wrong indentation | Use consistent spaces (4 spaces) |
| `AttributeError` | Object doesn't have that property | Check if None; verify object type |

---

### Detailed Error Explanations

#### SyntaxError: invalid syntax

**Example**:
```python
if x == 5  # Missing colon
    print("Five")
```

**Fix**:
```python
if x == 5:  # Add colon
    print("Five")
```

---

#### NameError: name 'x' is not defined

**Causes**:
1. Variable not yet created
2. Variable name misspelled
3. Cell not run yet

**Fix**: Run the cell that creates the variable first.

---

#### TypeError: unsupported operand type

**Example**:
```python
"5" + 5  # Can't add string and integer
```

**Fix**:
```python
int("5") + 5  # Convert string to integer
# or
"5" + str(5)  # Convert integer to string
```

---

#### IndexError: list index out of range

**Example**:
```python
items = [1, 2, 3]
print(items[5])  # Only indices 0, 1, 2 exist
```

**Fix**:
```python
# Check length first
if len(items) > 5:
    print(items[5])

# Or use safe access
print(items[5] if len(items) > 5 else "Not found")
```

---

## 9. Performance Issues

### Notebook Running Slowly

**Solutions**:
1. Process data in smaller chunks
2. Add progress indicators:
   ```python
   from tqdm import tqdm
   for item in tqdm(items):
       process(item)
   ```
3. Reduce web requests (cache responses)

---

### High Memory Usage

**Solutions**:
1. Delete variables when done:
   ```python
   del large_dataframe
   ```
2. Process files in chunks:
   ```python
   pd.read_csv('file.csv', chunksize=1000)
   ```
3. Restart kernel to clear memory

---

### Jupyter Lab Slow to Start

**Solutions**:
1. Clear Jupyter cache:
   ```bash
   jupyter lab clean
   ```
2. Disable extensions you don't use
3. Use JupyterLab in simple mode:
   ```bash
   jupyter lab --core-mode
   ```

---

## 10. Getting More Help

### Self-Diagnosis Checklist

Before asking for help, check:
- [ ] Python version is 3.13+
- [ ] All dependencies installed
- [ ] Running from correct directory
- [ ] Virtual environment activated (if using one)
- [ ] API key set (for Claude Code)
- [ ] Internet connection working
- [ ] Files exist where expected

### Gathering Information

When asking for help, include:
```bash
# System info
python --version
pip --version
jupyter --version

# Installed packages
pip list

# Full error message (copy entire traceback)
```

### Where to Get Help

1. **GitHub Issues**: https://github.com/ShawhinT/AI-Builders-Bootcamp-8/issues
   - Search existing issues first
   - Include system info and full error

2. **Ask the Tutor**: If Claude Code is working, ask it to help debug!
   ```
   I'm getting this error: [paste error]
   ```

3. **Python Discord**: https://discord.gg/python
   - Large community of helpers
   - Good for general Python questions

4. **Stack Overflow**: https://stackoverflow.com
   - Search before posting
   - Follow question guidelines

### Creating a Good Bug Report

**Template**:
```
## What I was trying to do
[Brief description]

## What happened instead
[Error message or unexpected behavior]

## Steps to reproduce
1. First I did...
2. Then I...
3. Error occurred

## Environment
- OS: Windows 11 / macOS 14 / Ubuntu 22
- Python: 3.13.0
- Claude Code: X.X.X

## Full error message
```
[paste complete traceback]
```
```

---

**Remember**: Every programmer sees errors constantly. They're not failures - they're opportunities to learn!
