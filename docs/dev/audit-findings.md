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

## Cross-platform (macOS & Windows) Findings — Plan 3

The items below were identified during the Plan 3 audit (July 2025, ADK 2.12.0).
Each item is tracked with a status and will be fixed in order.

---


## Part 2 Field Audit — Findings (2025-07, ADK 2.12.0)

---

### Finding 19 — Part 2: `hello-agent-EXAMPLE.yaml` missing `spec_version: v1`

**File:** `docs/part2-first-agent/hello-agent-EXAMPLE.yaml`
**Status:** ✅ CLOSED
**Problem:** The example YAML file started with `kind: native` but omitted the required `spec_version: v1` top-level field. Every agent spec must include it.
**Fix:** Added `spec_version: v1` as the first field.

---

### Finding 20 — Part 2: `chat_with_docs.citations` had invented sub-fields

**File:** `docs/part2-first-agent/README.md`, complete-example YAML
**Status:** ✅ CLOSED
**Problem:** The example YAML used:
```yaml
citations:
  enabled: true
  display_format: inline
```
Neither `enabled` nor `display_format` exist in the official schema. The only supported field under `citations` is `citations_shown` (number).
**Fix:** Replaced with `citations_shown: -1`.

---

### Finding 21 — Part 2: `chat_with_docs.generation` had invented sub-fields

**File:** `docs/part2-first-agent/README.md`, complete-example YAML
**Status:** ✅ CLOSED
**Problem:** The example YAML used:
```yaml
generation:
  max_tokens: 2000
  temperature: 0.7
```
These fields belong to `llm_config`, not `chat_with_docs.generation`. The only documented field under `chat_with_docs.generation` in the YAML spec is `idk_message`.
**Fix:** Replaced with `idk_message: "I don't have an answer based on the uploaded document."` and added correct `vector_index.extraction_strategy` sub-field.

---

### Finding 22 — Part 2: `chat_with_docs` field list missing `vector_index` and correct sub-field names

**File:** `docs/part2-first-agent/README.md`, field reference section
**Status:** ✅ CLOSED
**Problem:** The bullet list for `chat_with_docs` did not document the `vector_index` sub-object or the correct sub-field names for `citations` and `generation`.
**Fix:** Expanded the bullet list to include all three sub-objects with their correct fields and types matching official docs.

---

### Finding 23 — Part 2: `style` field missing `react_intrinsic` value

**File:** `docs/part2-first-agent/README.md`
**Status:** ✅ CLOSED
**Problem:** The `style` field listed `"default"`, `"react"`, `"planner"` but omitted `"react_intrinsic"`, which is a valid and documented style value.
**Fix:** Added `"react_intrinsic"` to the list of valid style values.

---

### Finding 24 — Part 2: `memory_enabled` field not documented

**File:** `docs/part2-first-agent/README.md`
**Status:** ✅ CLOSED
**Problem:** The official native agent spec includes `memory_enabled` (boolean, default `false`) as an optional field, but it was absent from Part 2's field reference.
**Fix:** Added `memory_enabled` under Core Optional Fields.

---

### Finding 25 — Part 2: `is_schedulable` field not documented

**File:** `docs/part2-first-agent/README.md`
**Status:** ✅ CLOSED
**Problem:** The official native agent spec includes `is_schedulable` (boolean, default `false`) as an optional field, but it was absent from Part 2's field reference.
**Fix:** Added `is_schedulable` under Advanced Configuration.

---

### Finding 26 — Part 2: LLM example used `watsonx/ibm/granite-3-8b-instruct`

**File:** `docs/part2-first-agent/README.md`
**Status:** ✅ CLOSED
**Problem:** The mandatory fields description and the complete-example YAML both used `watsonx/ibm/granite-3-8b-instruct` as the example LLM. The workshop standard model is `groq/openai/gpt-oss-120b`.
**Fix:** Replaced both occurrences with `groq/openai/gpt-oss-120b`.

---


### Finding 9 — Part 6: `orchestrate toolkit list` missing `s` (typo)

**Part:** Part 6 (`docs/part6-mcp-servers/README.md`), line 957
**Status:** ✅ CLOSED
**Command (was):**
```bash
orchestrate toolkit list
```
**Should be:**
```bash
orchestrate toolkits list
```
**Evidence:** Official ADK docs at `tools/toolkits/manage_toolkits` confirm `orchestrate toolkits list` is the correct command. `toolkit` (singular) is not a valid subcommand.

---

### Finding 10 — Part 6: Second `--entries` call still uses JSON object syntax

**Part:** Part 6 (`docs/part6-mcp-servers/README.md`), line 776
**Status:** ✅ CLOSED
**Command (was):**
```bash
orchestrate connections set-credentials -a product-api-credentials \
  --env $env \
  --entries '{"API_KEY": "your-api-key", "API_URL": "https://api.example.com"}'
```
**Should be:**
```bash
orchestrate connections set-credentials -a product-api-credentials \
  --env $env \
  -e "API_KEY=your-api-key" \
  -e "API_URL=https://api.example.com"
```
**Evidence:** Official ADK docs (`connections/build_connections#key-value-connections`) confirm the flag is `--entries / -e` with `key=value` format. Multiple keys require repeating `-e`. JSON object syntax is invalid. Finding 7 already fixed the first occurrence (line 642); this second block was missed.

---

### Finding 11 — Part 1: Troubleshooting `pip install --user` is the wrong recovery path

**Part:** Part 1 (`docs/part1-setup/README.md`), line 445
**Status:** ✅ CLOSED
**Problem:** The "orchestrate: command not found" troubleshooting step says:
```bash
pip install --user ibm-watsonx-orchestrate
# Add ~/.local/bin to your PATH if needed
```
This contradicts the main flow (Step 10), which installs the ADK inside `.venv` via the VS Code extension. Installing with `--user` puts the package in the global Python user site, outside the venv, and `~/.local/bin` is macOS/Linux only — Windows PATH is `%APPDATA%\Python\PythonXY\Scripts`.

**Fix:** Replace with instructions to activate the venv and run `pip install ibm-watsonx-orchestrate`, plus platform-specific PATH notes.

---

### Finding 12 — Part 0 & Part 1: No Python installation instructions; only a "verify" step

**Part:** Part 0 (`docs/part0-prerequisites/README.md`) and Part 1 (`docs/part1-setup/README.md`), lines 6–11
**Status:** ✅ CLOSED
**Problem:** The prerequisites checklist says _"Python 3.12 installed"_ but never explains how to install it. A participant starting from a fresh machine has no guidance.

**Fix needed:**
- macOS: recommend Homebrew (`brew install python@3.12`) or python.org installer; note that `/usr/bin/python3` is Apple's system Python and should not be used
- Windows: python.org installer with explicit callout to check **"Add Python to PATH"** during setup — missing this checkbox is the #1 cause of `python not found` errors

---

### Finding 13 — Part 1: No `uv` installation step; only a "verify" step

**Part:** Part 1 (`docs/part1-setup/README.md`), lines 22–27
**Status:** ✅ CLOSED
**Problem:** Step 2 says "verify `uv`" but never explains how to install it. On a fresh machine, `uv` will not be present.

**Fix needed (before the verify step):**
- macOS: `brew install uv` or `curl -LsSf https://astral.sh/uv/install.sh | sh`
- Windows: `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"`

---

### Finding 14 — Part 1: No manual venv activation fallback documented

**Part:** Part 1 (`docs/part1-setup/README.md`), lines 177–184
**Status:** ✅ CLOSED
**Problem:** Step 9 uses the VS Code "Python: Create Environment" GUI command (cross-platform ✅). The note says Bob IDE will auto-activate the venv in new terminals. This is true inside Bob IDE terminals, but participants who open a standalone terminal, hit activation issues, or follow along outside the IDE have no fallback instructions.

**Fix:** Add a callout note after Step 9:
- macOS/Linux: `source .venv/bin/activate`
- Windows CMD: `.venv\Scripts\activate.bat`
- Windows PowerShell: `.venv\Scripts\Activate.ps1` (requires execution policy `RemoteSigned` if not already set)

---

### Finding 15 — Part 1: Option A shell script (`.sh`) is Unix-only; Windows users blocked

**Part:** Part 1 (`docs/part1-setup/README.md`), lines 251–315
**Status:** ✅ CLOSED
**Problem:** Option A instructed participants to ask Bob to generate an `add_wxo_env.sh` shell script. On Windows without Git Bash or WSL, `.sh` files cannot be executed directly in CMD or PowerShell.

**Fix (updated):** The Bob prompt itself was updated to instruct Bob to first detect the user's OS and then generate a single platform-appropriate script: `.sh` for macOS/Linux or `.ps1` for Windows PowerShell. No Git Bash or WSL required. Step 3 and Step 8 in the surrounding instructions were updated to reflect both filename variants.

---

### Finding 16 — Part 11 & Part 9: Bob prompts generate `.sh` scripts with no Windows warning

**Part:** Part 11 (`docs/part11-ai-gateway-models/README.md`); Part 9 (`docs/part9-multi-agent-orchestration/README.md`)
**Status:** ✅ CLOSED
**Problem:** Bob prompts in these parts asked for `.sh` shell scripts that are then run directly. Windows users without Git Bash/WSL cannot run them.

**Fix (updated):** All three Bob prompts (Part 1, Part 11 ×2, Part 9) were updated to instruct Bob to first detect the user's OS, then generate a single platform-appropriate script (`.sh` for macOS/Linux, `.ps1` for Windows PowerShell). No Git Bash, WSL, or extra tooling required on any platform.

---

### Finding 17 — Part 6: Inconsistent Python version (`3.9+` vs `3.12`)

**Part:** Part 6 (`docs/part6-mcp-servers/README.md`), line 947
**Status:** ✅ CLOSED
**Problem:** Troubleshooting section says "Check Python version (3.9+)" but the workshop requires 3.12 (stated in Part 1, line 9). A participant checking this step would think their Python 3.10 install is fine when it isn't.

**Fix:** Change `3.9+` → `3.12` to be consistent with the rest of the workshop.

---

### Finding 18 — Part 6 & Part 6b: `command: python3` in YAML fails on Windows

**Part:** Part 6 (`docs/part6-mcp-servers/README.md`), line 398; Part 6b (`docs/part6b-agentic-workflows/README.md`), line 273
**Status:** ➖ DISMISSED
**Original concern:** `command: python3` would fail on Windows because Windows does not create a `python3` alias by default.
**Resolution:** The `command` field in a local MCP toolkit YAML is **not executed on the participant's machine**. Per official ADK docs (`tools/toolkits/overview`): _"Local MCP toolkits run **inside the watsonx Orchestrate runtime** using stdio transport."_ The platform runtime is always Linux, where `python3` is the correct command. The YAML `command` is correct as-is. The erroneous Windows note that was added has been reverted.

---

### Dismissed — `for env in draft live; do ... done` bash loops

**Part:** Part 6 (`docs/part6-mcp-servers/README.md`), lines 634, 768
**Status:** ➖ DISMISSED
**Original concern (Plan 3):** These POSIX bash loops would fail on Windows CMD/PowerShell without Git Bash or WSL.
**Resolution:** The **official ADK documentation** (`tools/toolkits/local_mcp_toolkits`, `connections/build_connections`) uses the exact same `for env in draft live; do ... done` pattern in all its code examples. Since the ADK docs set this as the canonical pattern, we defer to them — the loops are correct for macOS/Linux. Windows coverage is addressed by Finding 15/16 (adding a global note about Git Bash/WSL for shell scripts). No change to the loop syntax itself.

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

### Plan 4 — Orchestrate provisioning: confirm backup path

**Status:** ⏳ TODO
**Priority:** High — workshop blocked if TechZone is unavailable on the day
**Owner:** Igor / Avi

Primary provisioning is via IBM TechZone. A backup path must be confirmed before 10 August.

**Action:**
- [ ] Discuss backup options with Avi (e.g. free trial account, SaaS trial, other IBM-internal path)
- [ ] Document the agreed backup procedure in `docs/part0-prerequisites/README.md` or `docs/part1-setup/README.md` under a "Backup provisioning" callout
- [ ] Test the backup path end-to-end at least once before the workshop

---

### Plan 5 — NL2SQL module: content and media refresh

**Status:** ⏳ TODO
**Priority:** High — workshop is 10–11 August; videos and template must be ready
**Owner:** Igor / Yohan

#### Video replacements

The current NL2SQL videos in `docs/part10-nl2sql/videos/` are low quality. Replace with Yohan's locally recorded versions.

- [ ] Obtain Yohan's local video files
- [ ] Replace the five existing `.mp4` files in `docs/part10-nl2sql/videos/`
- [ ] Record a new video showing the **final result of Parts 1–9** (the complete agent before NL2SQL) — this serves as a "where we are" orientation before Part 10
- [ ] Verify all video embeds in `docs/part10-nl2sql/README.md` still work after replacement

#### Agent template (Maria's NL2SQL template)

Maria has shared a template for creating NL2SQL agents, hosted here:

> **Template URL:** https://data-agent-builder.1v4cskc77bqd.us-east.codeengine.appdomain.cloud/

- [ ] Review Maria's template and assess whether to include it directly in Part 10 instructions or link to it as a reference
- [ ] Add screenshots for the NL2SQL template usage flow once Igor has tested it
- [ ] Document any deviations from the template that the workshop version requires

#### Database

- [ ] Use Yohan's **PostgreSQL** database for the NL2SQL exercises (not Db2)
- [ ] Reprovision Yohan's PostgreSQL database before the workshop and confirm connection details work end-to-end

---

### Plan 3 — Platform parity: validate macOS and Windows setup instructions

**Status:** ✅ CLOSED
**Priority:** High — a broken setup step on Day 1 loses the participant entirely

Audit all setup and installation steps assuming a **fresh machine** on both platforms. See full checklist below.

#### macOS checklist
- [x] Python installation path covered (Homebrew / python.org / pyenv) — Part 0 covers both options
- [x] `python3` / `pip3` command naming (vs `python` / `pip`) — Part 0 and Part 1 Step 1 both show platform-specific variants
- [x] Virtual environment creation and activation (`. .venv/bin/activate`) — Part 1 Step 9 has manual activation callout
- [x] `orchestrate` CLI available on PATH after `pip install` — Part 1 Troubleshooting section covers this with platform-specific venv activation
- [x] Shell assumed is zsh (macOS default) — no bash-specific syntax found; `for` loops are in explicit `bash` blocks (dismissed as canonical ADK pattern)

#### Windows checklist
- [x] Python installation from python.org — "Add to PATH" checkbox called out explicitly in Part 0
- [x] `python` / `py` launcher vs `python3` naming difference documented — Part 0 and Part 1 Step 1 show both
- [x] Venv activation: `.venv\Scripts\activate` (CMD) or `.venv\Scripts\Activate.ps1` (PowerShell) — Part 1 Step 9 has all three blocks
- [x] PowerShell execution policy: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` — Part 1 Step 9 includes this note
- [x] `orchestrate` CLI accessible on PATH after install — Part 1 Troubleshooting covers Windows CMD and PowerShell activation
- [x] Bash-only shell constructs identified and replaced or given Windows alternatives:
  - `for env in draft live; do ... done` loop (Part 6) — **DISMISSED** (Finding 18 / loop dismissal above; canonical ADK pattern)
  - `.sh` scripts in Part 1 Option B, Part 11, Part 9 — Windows warning added to all three (Findings 15 & 16)
  - `source .venv/bin/activate` — wrapped in platform-specific blocks with CMD and PS alternatives
- [x] Path separator differences (`/` vs `\`) — no CLI arguments use OS-specific separators; venv activation blocks already use correct `\` for Windows

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

**Status:** ✅ CLOSED — merged into Plan 3 above; all items verified and resolved via Findings 11–18.

