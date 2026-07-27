# Bobchestrate Workshop

A hands-on workshop for building AI agents with IBM watsonx Orchestrate and IBM
Bob. Participants work through the mandatory curriculum in a new, empty
`bobchestrate-ws` project.

Bob is the primary development interface: participants ask it to create,
validate, import, test, and improve artifacts. CLI examples remain available as
fallbacks and as a way to understand the commands Bob runs.

![Bobchestrate Workshop logo](docs/Bobchestrate_Workshop_logo_new.png)

## Workshop documentation

The maintained workshop guide starts at
[docs/index.md](docs/index.md). The published site navigation is defined in
[`mkdocs.yml`](mkdocs.yml).

The core path is:

1. [Prerequisites](docs/part0-prerequisites/README.md)
2. [Part 1 — Setup](docs/part1-setup/README.md)
3. [Part 2 — Bob Custom Rules](docs/part2b-bob-custom-rules/README.md)
4. [Part 3 — First Agent](docs/part2-first-agent/README.md)
5. [Part 4 — Custom Tools](docs/part3-custom-tools/README.md)
6. [Part 5 — Knowledge and Collaborators](docs/part4-knowledge/README.md)
7. [Part 6 — Guidelines and Guardrails](docs/part5-guidelines-guardrails/README.md)
8. [Part 7 — Agent Evaluation](docs/part6-agent-evaluation/README.md)
9. [Part 8 — Deployment](docs/part7-deployment/README.md)
10. [Part 9 — NL2SQL Accelerator](docs/part9-nl2sql/README.md)

Optional modules cover multi-agent orchestration, MCP servers, deterministic
agentic workflows, and AI Gateway model routing.

## Tested environment

Workshop commands and examples target **IBM watsonx Orchestrate ADK 2.12.0**.
See [AGENTS.md](AGENTS.md) for repository conventions and
[the audit ledger](docs/dev/audit-findings.md) for verified findings and fixes.

## Local documentation preview

```bash
pip install mkdocs-material mkdocs-glightbox
mkdocs serve
```

Then open the local address printed by MkDocs.
