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
    description: "Arguments for the subcommand (e.g., tutor name(s))"
    required: false
---

# /tutor Command

Unified command for managing tutors in this project.

## Subcommand Routing

Based on the `$ARGUMENTS` provided, execute ONE of the following subcommands:

---

## /tutor list

**Trigger:** `$ARGUMENTS` starts with "list" or is empty

**Action:**
1. Use Glob to get all `.md` filenames in `.claude/output-styles/` (do NOT read file contents)
2. For each filename, infer the tutor type using these rules:
   - **Known methods**: `socratic`, `eli5`, `rubber-duck`, `minimalist`, `challenge-first` → **method**
   - **Ends with `-tutor`** (e.g., `python-tutor`, `git-tutor`) → **topic**
   - **Contains a known method + another part** (e.g., `socratic-python-tutor`, `eli5-git-tutor`) → **combined**
   - **Anything else**: → **topic** (default)
3. Group tutors by inferred type: `method`, `topic`, `combined`

**Output format:**
```
Teaching Methods:
  challenge-first, eli5, minimalist, rubber-duck, socratic

Topic Tutors:
  git-tutor, python-tutor, stock-indicators-tutor

Combined Tutors:
  eli5-stock-indicators-tutor, socratic-python-tutor
  [or "None yet - run /tutor combine to create"]

Use /tutor describe <name> for details.
```

**Performance note:** This approach only reads filenames (via Glob), not file contents, making it very fast.

---

## /tutor describe <name>

**Trigger:** `$ARGUMENTS` starts with "describe"

**Action:**
1. Extract the tutor name from arguments (e.g., "describe socratic" → "socratic")
2. Read `.claude/output-styles/<name>.md`
3. If file doesn't exist: "Tutor '<name>' not found. Run /tutor list to see available tutors."
4. Extract and display:
   - Name and type
   - Description from frontmatter
   - Core constraint (look for "## Core Constraint" section)
   - Example interaction (look for "## Example" section) - truncate if very long

**Output format:**
```
TUTOR: <name>
TYPE: <method|topic|combined>
DESCRIPTION: <from frontmatter>

CORE CONSTRAINT:
  <extracted from ## Core Constraint section, or "See file for details">

FILE: .claude/output-styles/<name>.md
```

---

## /tutor combine <A> <B>

**Trigger:** `$ARGUMENTS` starts with "combine"

**Action:**

### Step 1: Parse arguments
Extract two tutor names from arguments (e.g., "combine socratic python-tutor" → A="socratic", B="python-tutor")

If only one name provided: "Usage: /tutor combine <tutor1> <tutor2>"

### Step 2: Validate both tutors exist
- Check if `.claude/output-styles/<A>.md` exists
- Check if `.claude/output-styles/<B>.md` exists

If either doesn't exist, output:
```
Tutor '<name>' not found.

Available methods: [list method tutors]
Available topics: [list topic tutors]

Run /tutor create <name> to create a new tutor.
```

### Step 3: Read frontmatter and determine types
- Read both files
- Extract `type` field from each (default to "topic" if missing)

### Step 4: Normalize the output filename

| A type | B type | Output name |
|--------|--------|-------------|
| method | topic | `<A>-<B>.md` (method first) |
| topic | method | `<B>-<A>.md` (method first - swap order) |
| method | method | Alphabetically sorted: `<min>-<max>.md` |
| topic | topic | Alphabetically sorted: `<min>-<max>.md` |

### Step 5: Validate combination type
If both are methods:
- Ask user: "Both are teaching methods. Combining <A> + <B> may produce conflicting instructions. Proceed anyway? (y/n)"
- If user says no, abort

If both are topics:
- Ask user: "Both are topic tutors. Combining <A> + <B> will mix domains. Proceed anyway? (y/n)"
- If user says no, abort

### Step 6: Check if combined file already exists
If `.claude/output-styles/<normalized-name>.md` exists:
- Ask user: "<normalized-name> already exists. Regenerate? (y/n)"
- If user says no, abort

### Step 7: Create the combined tutor

Read the full content of both source files and create a merged file with this structure:

```markdown
---
name: <normalized-name-without-.md>
type: combined
description: <Topic> tutor using <Method> teaching style
keep-coding-instructions: false
source-method: <method-tutor-name>
source-topic: <topic-tutor-name>
---

# <Method> <Topic> Tutor

This tutor combines the **<Method>** teaching style with the **<Topic>** domain knowledge.

## Teaching Method: <Method>

[Extract the core constraint and key behaviors from the method file]

## Topic Domain: <Topic>

[Extract the core constraint and key behaviors from the topic file]

## Combined Behaviors

When teaching <Topic> concepts:
1. Apply the <Method> approach to all explanations
2. Use <Method>'s interaction patterns
3. Stay within <Topic>'s domain constraints
4. Create artifacts in <Topic>'s designated locations

## Artifacts

[Copy artifact locations from the topic tutor, if present]
```

### Step 8: Save and confirm
Write the file to `.claude/output-styles/<normalized-name>.md`

Output:
```
Created <normalized-name>.

To activate this tutor, run:
  /output-style <normalized-name>
```

---

## /tutor create <name>

**Trigger:** `$ARGUMENTS` starts with "create"

**Action:**

### Step 1: Parse and validate name
- Extract name from arguments
- Convert to lowercase with hyphens (no spaces, no underscores)
- Check if `.claude/output-styles/<name>.md` already exists
  - If yes: Ask "Tutor '<name>' already exists. Overwrite? (y/n)"

### Step 2: Infer or ask type
- If name ends with "-tutor": suggest "topic"
- If name matches known pedagogy (socratic, eli5, etc.): suggest "method"
- Otherwise, ask user:
  ```
  Is '<name>' a teaching METHOD or a TOPIC tutor?
  1. Method (defines HOW to teach - like socratic, eli5)
  2. Topic (defines WHAT to teach - like python-tutor, git-tutor)
  ```

### Step 3: Gather information based on type

**For METHOD style, ask:**
1. "What is the core teaching approach in one sentence?"
2. "What constraint defines this method? (e.g., 'never give direct answers')"
3. "Provide a brief example interaction (optional - press Enter to skip)"

**For TOPIC tutor, ask:**
1. "What domain/subject does this tutor cover?"
2. "Who is the target user? What do they already know?"
3. "What should this tutor NOT do? (e.g., 'no trading advice', 'no code implementation')"

### Step 4: Generate the tutor file

**For METHOD:**
```markdown
---
name: <name>
type: method
description: <from question 1>
keep-coding-instructions: false
---

# <Name> Tutor

You are an interactive CLI tool that teaches using the <name> method.

## Core Constraint

**<from question 2>**

## How to Respond

[Generated guidance based on the constraint]

## Example Interaction

[From question 3, if provided]
```

**For TOPIC:**
```markdown
---
name: <name>
type: topic
description: <subject> tutor for <target user>
keep-coding-instructions: false
---

# <Name> Tutor

You are an interactive CLI tool that helps users learn <subject>.

## Core Constraint

**<from question 3 - what NOT to do>**

## Target User

<from question 2>

## Teaching Behaviors

[Generated based on subject]
```

### Step 5: Save and confirm
```
Created <name>.

To activate this tutor, run:
  /output-style <name>

To combine with another tutor:
  /tutor combine <method> <name>
```

---

## /tutor activate <name>

**Trigger:** `$ARGUMENTS` starts with "activate"

**Action:**
1. Extract tutor name from arguments
2. Check if `.claude/output-styles/<name>.md` exists
   - If not: "Tutor '<name>' not found. Run /tutor list to see available tutors."
3. Output:
   ```
   To activate '<name>', run:
     /output-style <name>
   ```

**Note:** Slash commands cannot directly invoke other slash commands, so we provide instructions instead.

---

## /tutor delete <name>

**Trigger:** `$ARGUMENTS` starts with "delete"

**Action:**
1. Extract tutor name from arguments (e.g., "delete socratic" → "socratic")
2. If no name provided: "Usage: /tutor delete <name>"
3. Check if `.claude/output-styles/<name>.md` exists
   - If not: "Tutor '<name>' not found. Run /tutor list to see available tutors."
4. Ask for confirmation using AskUserQuestion:
   - "Delete tutor '<name>'? This cannot be undone."
   - Options: "Yes, delete it" / "No, cancel"
5. If confirmed:
   - Delete the file `.claude/output-styles/<name>.md` using Bash `rm`
   - Output: "Deleted '<name>'."
6. If cancelled:
   - Output: "Cancelled."

**Example:**
```
/tutor delete test-tutor

> Delete tutor 'test-tutor'? This cannot be undone.
> [Yes, delete it]

Deleted 'test-tutor'.
```

**Safety:** Always requires confirmation before deletion.

---

## Error Handling

### No subcommand provided
If `$ARGUMENTS` is empty, treat as `/tutor list`.

### Unknown subcommand
If subcommand doesn't match list/describe/combine/create/activate/delete:
```
Unknown subcommand: <subcommand>

Available subcommands:
  /tutor list              - Show all available tutors
  /tutor describe <name>   - Show details about a tutor
  /tutor combine <A> <B>   - Combine two tutors
  /tutor create <name>     - Create a new tutor
  /tutor activate <name>   - Instructions to activate a tutor
  /tutor delete <name>     - Delete a tutor (with confirmation)
```

### Self-combination
If user runs `/tutor combine X X`:
```
Cannot combine a tutor with itself.
```

---

## Implementation Notes

- All tutor names should be lowercase with hyphens
- `/tutor list` uses filename inference only (no file reads) for speed
- Known methods for inference: `socratic`, `eli5`, `rubber-duck`, `minimalist`, `challenge-first`
- `/tutor describe` reads frontmatter using YAML parsing (split on `---`)
- `/tutor combine` reads both source files to merge content
- `/tutor delete` always requires confirmation before deleting
- Default `type` to "topic" for backward compatibility (in describe/combine)
- When merging, preserve the spirit of both tutors while resolving conflicts
- Combined tutors should inherit `keep-coding-instructions: false` unless either source has it true
