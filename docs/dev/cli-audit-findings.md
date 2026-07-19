# CLI Command Audit — Findings & Fixes

Audit date: 2025-07 · Tested ADK version: **2.12.0**
All findings and changes documented here are as of this date.
Scope: All CLI commands in `docs/part1` through `docs/part9`
Method: Every command cross-checked against the official watsonx Orchestrate ADK docs via the `watsonx-orchestrate-adk-docs` MCP server.

---

## Status legend

| Symbol | Meaning |
|--------|---------|
| ✅ CLOSED | Fixed in docs |
| ➖ DISMISSED | User confirmed not an issue / working as expected |

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
