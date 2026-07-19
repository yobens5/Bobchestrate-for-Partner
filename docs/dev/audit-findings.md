# Workshop Audit — Findings & Fixes

This file tracks all quality issues found in the Bobchestrate workshop docs (`docs/part1` through `docs/part9`).
It covers CLI commands, YAML schemas, platform compatibility, UX clarity, and anything else that could block or mislead a workshop participant.

Audit started: 2025-07 · ADK version under test: **2.12.0**
Source of truth for CLI/API: official ADK docs via `watsonx-orchestrate-adk-docs` MCP server.

---

## Status legend

| Symbol | Meaning |
|--------|---------|
| ✅ CLOSED | Fixed in docs |
| ➖ DISMISSED | Confirmed not an issue / working as expected |
| ⏳ TODO | Identified, not yet investigated or fixed |

---

## Planned Work

The following items have been identified and agreed on. Each will be tracked as a separate task when picked up.

---

### Plan 1 — Content cleanup: remove unnecessary parts, keep the core

**Status:** ⏳ TODO
**Priority:** High — reduces cognitive load for workshop participants

Remove or significantly trim any parts, sections, or steps that are not essential to understanding how to build agents with watsonx Orchestrate. Keep only what a participant must know to complete the workshop and walk away productive.

**What to evaluate for removal or trimming:**
- Parts or sections that duplicate content already covered elsewhere
- Over-long explanations where a one-liner would do
- Optional/advanced callout blocks that distract from the main flow
- Any part that has no corresponding hands-on exercise

**Outcome:** A leaner workshop that participants can complete in the stated time without skipping anything.

---

### Plan 2 — Theme adaptation: align content to insurance or retail industry

**Status:** ⏳ TODO
**Priority:** High — makes examples feel real and relevant to the audience

The current agent and tool examples use generic "customer support" framing. The workshop should be adapted to a concrete industry vertical. Two candidate themes:

- **Insurance:** Claims processing, policy lookup, coverage questions, escalation to human adjusters
- **Retail:** Product catalog search, order status, returns, loyalty program — consistent with the NL2SQL retail videos already present in `docs/part10-nl2sql/`

**Decision needed:** Confirm which vertical to use (insurance or retail). Retail is already partially set up via the NL2SQL videos.

**Scope of changes when picked up:**
- Agent names, tool names, and descriptions (e.g. `customer_support_agent` → `claims_agent` or `retail_support_agent`)
- Sample data in tools and knowledge bases (shipping/returns FAQ → policy FAQ or product catalog)
- Evaluation dataset stories and starting sentences
- Screenshots and diagrams if any show generic placeholder names
- `docs/part10-nl2sql/` retail videos are already aligned — use them as the anchor for the retail theme if that direction is chosen

---

### Plan 3 — Platform parity: validate macOS and Windows setup instructions

**Status:** ⏳ TODO
**Priority:** High — a broken setup step on Day 1 loses the participant entirely

Audit all setup and installation steps assuming a **fresh machine** on both platforms. See full checklist below.

#### macOS checklist
- [ ] Python installation path covered (Homebrew / python.org / pyenv)
- [ ] `python3` / `pip3` command naming (vs `python` / `pip`)
- [ ] Virtual environment creation and activation (`. .venv/bin/activate`)
- [ ] `orchestrate` CLI available on PATH after `pip install`
- [ ] Shell assumed is zsh (macOS default) — any bash-specific syntax flagged

#### Windows checklist
- [ ] Python installation from python.org — "Add to PATH" checkbox called out explicitly
- [ ] `python` / `py` launcher vs `python3` naming difference documented
- [ ] Venv activation: `.venv\Scripts\activate` (CMD) or `.venv\Scripts\Activate.ps1` (PowerShell)
- [ ] PowerShell execution policy: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`
- [ ] `orchestrate` CLI accessible on PATH after install
- [ ] Bash-only shell constructs identified and replaced or given Windows alternatives:
  - `for env in draft live; do ... done` loop (Part 6, line ~633) → PowerShell equivalent provided
  - Any use of `source`, `export`, `chmod` → Windows alternatives noted
- [ ] Path separator differences (`/` vs `\`) in any CLI arguments flagged

#### Acceptance criteria
- A participant with zero prior Python experience on either platform can complete Part 1 without external help
- Minimum Python version is stated explicitly at the top of Part 1
- All shell blocks that behave differently across platforms have a clear platform note or split tab

#### Primary files to audit
- `docs/part1-setup/README.md` — full environment bootstrap
- `docs/part6-mcp-servers/README.md` — bash loop on line ~633
- Any other part using `source`, `export`, or multi-line shell scripts

---

## Closed & Dismissed Findings

---

## Finding 1 — `orchestrate env activate -a <api-key>` flag

**Part:** Part 1 (`docs/part1-setup/README.md`)
**Status:** ➖ DISMISSED
**Original concern:** The `-a` flag was thought not to exist on `env activate`.
**Resolution:** User confirmed `-a` works in practice. No change needed.

---

## Finding 2 — `orchestrate knowledge-bases status -n <name>` flag

**Part:** Part 4 (`docs/part4-knowledge/README.md`)
**Status:** ➖ DISMISSED
**Command in docs:**
```bash
orchestrate knowledge-bases status -n customer-support-faq-<your_initials_here>
```
**Resolution:** Verified live via `orchestrate knowledge-bases status --help`. The CLI confirms `-n` is the official short alias for `--name` on this subcommand:
```
--name  -n  TEXT  Name of the knowledge base you wish to get the status of
```
No change needed in the docs.

---

## Finding 3 — `orchestrate chat -a loan_processor_agent`

**Part:** Part 6b (`docs/part6b-agentic-workflows/README.md`)
**Status:** ✅ CLOSED
**Command in docs (was line 462):**
```bash
orchestrate chat -a loan_processor_agent
```
**Fixed to:**
```bash
orchestrate chat ask --agent-name loan_processor_agent
```
**Evidence:** The bare `orchestrate chat -a` subcommand does not exist. `orchestrate chat ask` is the correct command (ADK v2.3.0+). User also confirmed `orchestrate chat ask -n AskOrchestrate` works, so `-n` / `--agent-name` are both valid.

---

## Finding 4 — `orchestrate env set draft` / `orchestrate env set live`

**Part:** Part 8 (`docs/part8-deployment/README.md`)
**Status:** ✅ CLOSED
**Commands in docs (were lines 632, 655):**
```bash
orchestrate env set draft
orchestrate env set live
```

### What was this trying to do?

In Part 8, Step 2 (Deploy to Draft) and Step 3 (Deploy to Live), the intent was:

> "Make sure you are targeting the draft environment before importing, then switch to live and repeat."

The `orchestrate env set` command was used as a shorthand to express "switch the active target to draft/live". However:

- There is **no** `orchestrate env set` command in the ADK CLI.
- **Draft vs. live** is not a separate environment you `activate` — it is a **state** within a single SaaS tenant. Draft = not yet published, live = deployed/published.
- The env you activate is always the **tenant** (e.g. `my-wxo-cloud`). All `import` commands always target the draft state automatically.
- Promoting to live is done exclusively with `orchestrate agents deploy --name <agent>`.

### Fix applied

Both `orchestrate env set draft` and `orchestrate env set live` lines were **removed**. Step 2 now reads:

> "Import all components (always targets draft state)"

Step 3 now reads:

> "Import all components first (if not already done in Step 2)" then `orchestrate agents deploy --name customer-support-agent`

The surrounding import and verify commands were already correct and unchanged.

---

## Finding 5 — Part 4 Option A: inline `title:`/`content:` KB YAML

**Part:** Part 4 (`docs/part4-knowledge/README.md`) — Option A, and `docs/part4-knowledge/faq-knowledge-base.yaml`
**Status:** ✅ CLOSED
**Problem:** The knowledge base YAML showed documents with `title:` and `content:` fields, which are **not valid** in the watsonx Orchestrate KB schema. Only `path:` file references are supported.

**Source:** ADK project rule: _"Knowledge bases in watsonx Orchestrate MUST reference external document files. Inline document content is NOT supported."_

**Changes made:**
1. `docs/part4-knowledge/README.md` — Option A rewritten to explain the two-file approach (text file + YAML with `path:`). YAML example replaced with correct `spec_version: v1` + `path:` structure.
2. `docs/part4-knowledge/faq-knowledge-base.yaml` — Completely rewritten: removed all `title:`/`content:` entries; replaced with `path: customer-support-faq.txt`; added `spec_version: v1`, `vector_index`, and `conversational_search_tool` sections.
3. `docs/part4-knowledge/customer-support-faq.txt` — **New file** created with the FAQ content (shipping, returns, payments, account management, order tracking) as a plain-text document for the KB to reference.

---

## Finding 6 — Part 6 Step 1: first toolkit YAML missing `spec_version` and has invalid `language:` field

**Part:** Part 6 (`docs/part6-mcp-servers/README.md`), line ~368
**Status:** ✅ CLOSED
**Broken YAML (was):**
```yaml
kind: mcp
name: product-catalog
description: Product catalog tools for searching, viewing details, and checking inventory
language: python
package_root: ./
command: python product_catalog_server.py
tools:
  - "*"
```

**Issues:**
- Missing `spec_version: v1` (required top-level field)
- `language:` is a **CLI flag** (`orchestrate toolkits add --language`), not a valid YAML field

**Fixed YAML (now):**
```yaml
spec_version: v1
kind: mcp
name: product-catalog
description: Product catalog tools for searching, viewing details, and checking inventory
package_root: ./
command: python product_catalog_server.py
env: []
tools:
  - "*"
```

**Source:** ADK MCP toolkit YAML format from project rules and official ADK docs.

---

## Finding 7 — Part 6 auth section: `--entries` JSON object syntax

**Part:** Part 6 (`docs/part6-mcp-servers/README.md`), line ~641
**Status:** ✅ CLOSED
**Command (was):**
```bash
orchestrate connections set-credentials -a external-api \
  --env $env \
  --entries '{"API_KEY": "your-api-key-here"}'
```

**Problem:** The `--entries` flag on `orchestrate connections set-credentials` accepts `key=value` pairs, **not** JSON object syntax. Passing a JSON object causes a parse error.

**Fixed command (now):**
```bash
orchestrate connections set-credentials -a external-api \
  --env $env \
  --entries "API_KEY=your-api-key-here"
```

**Source:** ADK project rule: _"Set the API key as a key-value pair: `--entries \"api_key=$YOUR_API_KEY\"`"_. Also confirmed by ADK v1.9.0 bug-fix note: _"Fixed an issue where the ADK failed to accept connection configurations when the API key contained an equals sign (`=`)"_ — confirming `=`-separated pairs are the intended format.

---

## Finding 8 — Part 8: `orchestrate evaluations generate` wrong flags

**Part:** Part 8 (`docs/part8-deployment/README.md`), line ~288
**Status:** ✅ CLOSED
**Command (was):**
```bash
orchestrate evaluations generate \
  -s evaluation/user-stories.txt \
  -g . \
  -t customer-support-agent \
  -o evaluation/datasets/
```

**Problems found (confirmed against official ADK docs at `evaluate/create_data`):**

| Flag | Was | Correct |
|------|-----|---------|
| `-s` | `evaluation/user-stories.txt` | File extension must be `.csv` — stories file needs `story,agent` columns |
| `-t` | `customer-support-agent` (agent name) | Must be a **path to a Python file** with `@tool` definitions |
| `-g` | `.` | **Does not exist** — no `-g` flag on `generate` |

The official signature is:
```bash
orchestrate evaluations generate \
  --stories-path <path-to-csv> \
  --tools-path <path-to-python-file> \
  [--output-dir <dir>]
```

**Fixed command (now):**
```bash
orchestrate evaluations generate \
  -s evaluation/user-stories.csv \
  -t tools/customer_support_tools.py \
  -o evaluation/datasets/
```

**Source:** `evaluate/create_data` in official ADK docs — _"The `generate` command transforms user stories into structured test cases using your tool definitions."_ Flags: `--stories-path / -s`, `--tools-path / -t`, `--output-dir / -o`.

---

## Pending Audit — Cross-platform setup instructions (macOS & Windows)

**Status:** ⏳ TODO
**Scope:** All parts that contain setup, installation, or prerequisite steps — primarily `docs/part1-setup/` but also any shell commands throughout parts 1–9 that differ between platforms.

### What needs to be checked

Walk through every setup and installation step assuming a **fresh machine** on both platforms:

#### macOS
- Python installation (Homebrew vs python.org installer vs pyenv)
- `python3` / `pip3` vs `python` / `pip` command naming
- Virtual environment creation and activation (`. .venv/bin/activate` syntax)
- `brew` dependency installs (if any referenced)
- `orchestrate` CLI PATH after `pip install`
- Any shell-specific instructions (zsh vs bash — macOS default is zsh)

#### Windows
- Python installation from python.org (including "Add to PATH" checkbox)
- `python` / `py` launcher vs `python3` naming
- Virtual environment activation syntax (`.venv\Scripts\activate` vs `.venv/Scripts/activate.ps1`)
- PowerShell execution policy (`Set-ExecutionPolicy RemoteSigned`)
- Path separator differences in any CLI commands (forward vs back slash)
- Whether `orchestrate` CLI is accessible after install (PATH on Windows)
- Any `bash`-style shell scripts (`for env in draft live; do ... done`) — these don't run in CMD or PowerShell without WSL or Git Bash
- `curl` availability (built into Windows 10+ PowerShell but syntax differs)

### Acceptance criteria

- A Windows user starting from zero Python should be able to follow every step without hitting an undocumented error
- A macOS user starting from zero Python should be able to follow every step without hitting an undocumented error
- All shell command blocks that differ between platforms should have platform-specific tabs or callout notes
- Minimum Python version required should be explicitly stated upfront

### Files to audit

- `docs/part1-setup/README.md` — primary target (full environment setup)
- `docs/part6-mcp-servers/README.md` — contains a `for ... do` bash loop (line ~633) that breaks on Windows CMD/PowerShell
- Any other part that references `source`, `export`, `chmod`, or other Unix-only shell constructs

