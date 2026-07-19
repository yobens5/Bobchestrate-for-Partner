# AGENTS.md — Project Overview for AI Agents & Contributors

## Purpose

This repository is the **Bobchestrate Workshop** — a hands-on learning experience for building AI agents with [IBM watsonx Orchestrate](https://developer.watson-orchestrate.ibm.com/) using [IBM Bob IDE](https://bob.ibm.com) as the AI pair programmer.

Participants learn to create, configure, evaluate, and deploy agentic AI systems — from a simple "Hello World" agent to a full multi-agent orchestration system.

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
│   ├── part3b-ai-gateway-models/    # AI Gateway & multi-model routing
│   ├── part4-knowledge/             # Knowledge bases & agent collaborators
│   ├── part5-guidelines-guardrails/ # Guidelines, guardrails & plugins
│   ├── part6-mcp-servers/           # Building & importing MCP servers
│   ├── part6b-agentic-workflows/    # Deterministic agentic workflows (@flow)
│   ├── part7-agent-evaluation/      # Evaluation datasets & red-teaming
│   ├── part8-deployment/            # Testing, deployment & webchat embed
│   ├── part9-multi-agent-orchestration/ # Multi-agent travel planning system
│   ├── part10-nl2sql/               # NL-to-SQL advanced exercise
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

## Key Conventions

- **Agent names**: `snake_case`, no spaces (e.g. `customer_support_agent`)
- **Default LLM**: `groq/openai/gpt-oss-120b`
- **Tool imports**: `orchestrate tools import -k python -f <file> -r requirements.txt`
- **Workflow imports**: `orchestrate tools import -k flow -f <file>`
- **MCP toolkit imports**: `orchestrate toolkits import -f <spec.yaml>` (file-based) or `orchestrate toolkits add …` (CLI-based)
- **Draft vs. live**: all `import` commands target draft automatically; use `orchestrate agents deploy --name <agent>` to promote to live
- **Chat testing**: `orchestrate chat ask --agent-name <name>` (short: `-n`)
