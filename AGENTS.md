# AGENTS.md — Project Overview for AI Agents & Contributors

## Purpose

This repository is the **Bobchestrate Workshop** — a hands-on learning experience for building AI agents with [IBM watsonx Orchestrate](https://developer.watson-orchestrate.ibm.com/) using [IBM Bob IDE](https://bob.ibm.com) as the AI pair programmer.

Participants learn to create, configure, evaluate, and deploy agentic AI systems — from a simple "Hello World" agent to a full multi-agent orchestration system.

## Workshop Schedule

- **Dates:** 10–11 August 2025
- **Format:** Two-day hands-on workshop

## Language Requirements

The workshop documentation is maintained in **both English and Hebrew**.

- **Workflow:** Complete and approve the English version first, then update the Hebrew version.
- Never update Hebrew content in parallel with English — always finish and approve English first.

## Tested ADK Version

> **IBM watsonx Orchestrate ADK `2.12.0`**

All workshop content, CLI commands, YAML schemas, and code examples have been verified against ADK version **2.12.0**. If you are running a different version, some commands or schema fields may behave differently — consult the [ADK release notes](https://developer.watson-orchestrate.ibm.com/release/release) for changes.

## Repository Structure

```
/
├── AGENTS.md                        # ← you are here
├── README.md                        # Main workshop guide (structure, overview, learning objectives)
├── docs/
│   ├── index.md                     # MkDocs site entry point
│   ├── part0-prerequisites/         # Pre-workshop requirements
│   ├── part1-setup/                 # Environment setup & Bob IDE configuration
│   ├── part2-first-agent/           # Hello World agent basics
│   ├── part2b-bob-custom-rules/     # Bob custom development rules
│   ├── part3-custom-tools/          # Python tools (@tool decorator)
│   ├── part4-knowledge/             # Knowledge bases & agent collaborators
│   ├── part5-guidelines-guardrails/ # Guidelines, guardrails & plugins
│   ├── part6-agent-evaluation/      # Evaluation datasets & red-teaming
│   ├── part7-deployment/            # Testing, deployment & webchat embed
│   ├── part8-multi-agent-orchestration/ # Multi-agent travel planning system
│   ├── part9-nl2sql/                # NL-to-SQL advanced exercise
│   ├── part10-mcp-servers/          # Optional: Building & importing MCP servers
│   ├── part11-agentic-workflows/    # Optional: Deterministic agentic workflows (@flow)
│   ├── part12-ai-gateway-models/    # Optional: AI Gateway & multi-model routing
│   ├── bob-prompts/                 # Curated Bob prompts for the workshop
│   └── dev/                        # ← Internal: findings, fixes, and change log
│       └── cli-audit-findings.md
├── mkdocs.yml                       # Documentation site config
└── .bob/                            # Bob IDE MCP server configuration
```

## Tracking Changes & Findings

All content corrections, CLI command fixes, schema updates, and verified findings are tracked in:

**[`docs/dev/cli-audit-findings.md`](docs/dev/cli-audit-findings.md)**

Every update to workshop content — whether fixing a broken command, dismissing a false positive, or clarifying workshop instructions — must be logged there with:
- The affected file and part number
- The original content
- The resolution (fixed / dismissed)
- The ADK version the fix was verified against

## Infrastructure & Provisioning

### watsonx Orchestrate — Primary: IBM TechZone

Orchestrate is provisioned for participants via **IBM TechZone**. Yohan has a Word document with step-by-step TechZone provisioning instructions — use it as the source of truth for the provisioning section of the workshop.

### watsonx Orchestrate — Backup Option

A backup provisioning path is needed in case TechZone is unavailable (e.g. trial account). **Open question: discuss backup options with Avi.**
See `docs/dev/audit-findings.md` → Plan 4 for tracking.

### IBM Bob IDE — Provisioning

Bob is provisioned via a **support ticket submitted by an admin**. This eliminates the need to send individual invitation emails to each participant.

- There is a link in the docs showing how participants can open a Bob ticket — this is confirmed present and correct.
- For workshop delivery, the admin must raise the provisioning ticket **as early as possible** before the workshop date.

## NL2SQL Module — Key Decisions

The NL2SQL module (Part 10) is kept **separate from the main agent storyline** — the workshop agents (Parts 1–9) will **not** be adapted or renamed to fit the NL2SQL use case. This decision was made to avoid the high effort of a full theme merge.

- The NL2SQL exercises use their own dedicated agents and database.
- **Database:** Use Yohan's **PostgreSQL** database instance (not Db2); reprovision it before the workshop.
- **Agent template:** Maria's NL2SQL agent template is hosted at https://agent-builder.2clsicnm3dwo.us-south.codeengine.appdomain.cloud/ — see `docs/dev/audit-findings.md` → Plan 5 for action items.

## Key Conventions

- **Agent names**: `snake_case`, no spaces (e.g. `customer_support_agent`)
- **Default LLM**: `groq/openai/gpt-oss-120b`
- **Tool imports**: `orchestrate tools import -k python -f <file> -r requirements.txt`
- **Workflow imports**: `orchestrate tools import -k flow -f <file>`
- **MCP toolkit imports**: `orchestrate toolkits import -f <spec.yaml>` (file-based) or `orchestrate toolkits add …` (CLI-based)
- **Draft vs. live**: all `import` commands target draft automatically; use `orchestrate agents deploy --name <agent>` to promote to live
- **Chat testing**: `orchestrate chat ask --agent-name <name>` (short: `-n`)

## Verification Requirement

Any stated gap, bug, issue, broken command, or incompatibility must be confirmed before it is documented or reported. Acceptable confirmation methods are:

- Verification with the watsonx Orchestrate ADK MCP tools
- Verification with web research using the Tavily MCP tools
- Verification by running relevant local commands and checking the actual output

Do not present unverified assumptions as findings. If something cannot be confirmed with one of the methods above, state that it is unverified and do not record it as a confirmed issue.
