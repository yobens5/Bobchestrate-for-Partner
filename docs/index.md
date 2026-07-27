# Enable Partner Bobchestrate Workshop

![Workshop logo](Bobchestrate_Workshop_logo_new.png)

Build, evaluate, and deploy AI agents with IBM watsonx Orchestrate while using
IBM Bob as your development partner.

## Format

- **Length:** Two days, approximately 3.5–4 hours per day including practice,
  troubleshooting, breaks, and discussion
- **Level:** Beginner to intermediate
- **Tested ADK:** IBM watsonx Orchestrate ADK **2.12.0**
- **Participant project:** a new, empty `bobchestrate-ws` folder

!!! warning "Use the tested version"
    Commands and YAML examples target ADK 2.12.0. If your version differs,
    consult the [ADK release notes](https://developer.watson-orchestrate.ibm.com/release/release).

## Before the workshop

You need:

- a GitHub account and IBM partner account
- a reserved watsonx Orchestrate environment from
  [TechZone](https://techzone.ibm.com/collection/6939fccc3fc778c2abfc1e25/environments?platform=69fe3e8a6a38f6a7c980166c)
- a Bob enterprise account requested through
  [IBM Support](https://www.ibm.com/support/pages/node/7159462)
- IBM Bob IDE, Python 3.12, and `uv`

Complete the [Prerequisites](part0-prerequisites/README.md) before Day 1.

## Two-day agenda

### Day 1 — Build the customer-support system

| Part | Outcome |
|---|---|
| [1. Setup](part1-setup/README.md) | Prepare Bob IDE, Python, ADK, MCP servers, and the workshop environment |
| [2. Bob Custom Rules](part2b-bob-custom-rules/README.md) | Give Bob the project conventions it should follow |
| [3. First Agent](part2-first-agent/README.md) | Create, import, and test a native agent |
| [4. Custom Tools](part3-custom-tools/README.md) | Add order-status and refund tools |
| [5. Knowledge & Collaborators](part4-knowledge/README.md) | Add FAQs and an escalation agent |

### Day 2 — Make it safer, evaluate it, and deploy

| Part | Outcome |
|---|---|
| [6. Guidelines & Guardrails](part5-guidelines-guardrails/README.md) | Add behavioral guidance and input controls |
| [7. Evaluation & Red-Teaming](part6-agent-evaluation/README.md) | Test expected behavior and adversarial prompts |
| [8. Deployment](part7-deployment/README.md) | Promote the agent and generate webchat configuration |
| [9. NL2SQL Accelerator](part9-nl2sql/README.md) | Discover a database and generate an editable NL2SQL agent |

NL2SQL is a mandatory standalone use case. It does not modify or rename the
customer-support agents created in Parts 3–8.

## Optional modules

These modules are independent extensions and are not required for the two-day
core:

- [Multi-Agent Orchestration](part8-multi-agent-orchestration/README.md)
- [MCP Servers](part10-mcp-servers/README.md)
- [Agentic Workflows](part11-agentic-workflows/README.md)
- [AI Gateway Models](part12-ai-gateway-models/README.md)

## What you will leave with

By the end of the core workshop, you will be able to:

- define native agents with validated YAML
- build and import Python tools
- attach knowledge bases and collaborators
- add guidelines and guardrail plugins
- create evaluation datasets and run red-team checks
- deploy a tested draft agent
- generate an NL2SQL agent from discovered database metadata
- use Bob to create, review, and troubleshoot Orchestrate artifacts

## Working style

For each exercise:

1. Ask Bob using the provided prompt or use the manual fallback.
2. Review generated files before running commands.
3. Import one component at a time.
4. Run the checkpoint before continuing.

If you get stuck, include the command, exact error, operating system, and
relevant file when asking Bob for help. More examples are available in
[Helpful Bob Prompts](bob-prompts/helpful-prompts.md).

[Start with the prerequisites →](part0-prerequisites/README.md)
