# Reference Solution

A complete, working snapshot of the workshop project after all core parts are
finished. Use it when something will not import, a step took longer than
expected, or you joined late and need to catch up.

!!! warning "Read this before copying"
    Copying files skips the learning, not the setup. You still need an active
    watsonx Orchestrate environment ([Part 1](../part1-setup/README.md)) and you
    still have to **import** every file you copy — the platform does not pick up
    files from disk on its own.

## How to use it

1. Find your part in the table below.
2. Copy only the files listed for the parts you have already passed, plus the
   part you are stuck on, into your own workspace.
3. Run the import commands for that part.
4. Continue the workshop from the next step.

Each file links directly to its source, so you can download a single file
instead of the whole folder.

## What goes where

Copy into the root of your workshop project, keeping this layout:

```text
your-project/
├── workspace_config.yaml
├── requirements.txt
├── .bob/                 ← from bob-config/ (renamed, see note below)
│   ├── mcp.json
│   ├── custom_modes.yaml
│   └── rules/wxo-dev-rule-enhanced.md
├── agents/
├── tools/
├── knowledge-bases/
└── evaluation/
```

!!! note "`bob-config/` is really `.bob/`"
    Git and MkDocs both skip dot-directories, so Bob's configuration is stored
    here as `bob-config/`. Copy it to `.bob/` in your own project.

## Part-by-part checkpoints

### Part 1: Setup

| File | Copy to |
|---|---|
| [`workspace_config.yaml`](workspace_config.yaml) | `workspace_config.yaml` |
| [`bob-config/mcp.json`](bob-config/mcp.json) | `.bob/mcp.json` |
| [`bob-config/custom_modes.yaml`](bob-config/custom_modes.yaml) | `.bob/custom_modes.yaml` |
| [`scripts/add-wxo-env.sh`](scripts/add-wxo-env.sh) | `add-wxo-env.sh` (optional helper) |

Edit `.bob/mcp.json` and replace `<ABSOLUTE_PATH_TO_YOUR_WORKSPACE>` with the
full path to your project folder, then reload the Bob IDE window.

`add-wxo-env.sh` registers and activates an environment interactively:

```bash
./add-wxo-env.sh
```

### Part 2: Bob Custom Rules

| File | Copy to |
|---|---|
| [`bob-config/rules/wxo-dev-rule-enhanced.md`](bob-config/rules/wxo-dev-rule-enhanced.md) | `.bob/rules/wxo-dev-rule-enhanced.md` |
| [`agents/test_rules_agent.agent.yaml`](agents/test_rules_agent.agent.yaml) | `agents/test_rules_agent.agent.yaml` |

The agent is the optional verification artifact from step 4 of that part.

### Part 3: First Agent

| File | Copy to |
|---|---|
| [`agents/hello-agent.yaml`](agents/hello-agent.yaml) | `agents/hello-agent.yaml` |

```bash
orchestrate agents import -f agents/hello-agent.yaml
```

### Part 4: Custom Tools

| File | Copy to |
|---|---|
| [`tools/check_order_status.py`](tools/check_order_status.py) | `tools/check_order_status.py` |
| [`tools/process_refund.py`](tools/process_refund.py) | `tools/process_refund.py` |
| [`requirements.txt`](requirements.txt) | `requirements.txt` |
| [`agents/customer_support_agent.part4.yaml`](agents/customer_support_agent.part4.yaml) | `agents/customer_support_agent.yaml` |

```bash
orchestrate tools import -k python -f tools/check_order_status.py -r requirements.txt
orchestrate tools import -k python -f tools/process_refund.py -r requirements.txt
orchestrate agents import -f agents/customer_support_agent.yaml
```

### Part 5: Knowledge & Collaborators

| File | Copy to |
|---|---|
| [`knowledge-bases/FAQ.pdf`](knowledge-bases/FAQ.pdf) | `knowledge-bases/FAQ.pdf` |
| [`knowledge-bases/customer-support-faq.yaml`](knowledge-bases/customer-support-faq.yaml) | `knowledge-bases/customer-support-faq.yaml` |
| [`agents/escalation-agent.yaml`](agents/escalation-agent.yaml) | `agents/escalation-agent.yaml` |
| [`agents/customer_support_agent.part5.yaml`](agents/customer_support_agent.part5.yaml) | `agents/customer_support_agent.yaml` |

```bash
orchestrate knowledge-bases import -f knowledge-bases/customer-support-faq.yaml
orchestrate knowledge-bases status -n customer_support_faq
orchestrate agents import -f agents/escalation-agent.yaml
orchestrate agents import -f agents/customer_support_agent.yaml
```

Wait for the knowledge base to finish indexing before testing FAQ answers.

### Part 6: Guidelines & Guardrails

| File | Copy to |
|---|---|
| [`tools/data_access_guardrail.py`](tools/data_access_guardrail.py) | `tools/data_access_guardrail.py` |
| [`agents/customer_support_agent.yaml`](agents/customer_support_agent.yaml) | `agents/customer_support_agent.yaml` |

```bash
orchestrate tools import -k python -f tools/data_access_guardrail.py -r requirements.txt
orchestrate agents import -f agents/customer_support_agent.yaml
```

This is the final state of the main agent: tools, knowledge base, collaborator,
guidelines, and the pre-invoke guardrail plugin.

### Part 7: Evaluation & Red-Teaming

| File | Copy to |
|---|---|
| [`evaluation/config.yaml`](evaluation/config.yaml) | `evaluation/config.yaml` |
| `evaluation/datasets/*.json` (12 files) | `evaluation/datasets/` |
| `evaluation/red-teaming-attacks/*.json` (24 files) | `evaluation/red-teaming-attacks/` |

Fill in `<region>`, `<instance-id>`, and `<environment-name>` in
`evaluation/config.yaml` before running. Never add an API key to that file.

```bash
orchestrate evaluations quick-eval -c evaluation/config.yaml -t tools
orchestrate evaluations red-teaming run -a evaluation/red-teaming-attacks -o evaluation/red-teaming-results
```

The datasets cover six happy paths, three edge cases, and three error
scenarios. The attack set covers instruction override, crescendo, emotional
appeal, role playing, prompt leakage, jailbreaking, topic derailment, and
unsafe topics.

### Part 8: Deployment

Deployment produces no new files. Use the Part 6 agent state above, then follow
[Part 8](../part7-deployment/README.md).

## Known differences from the walkthrough text

This snapshot is one completed run of the workshop, not a regenerated copy of
the examples embedded in each part. A few things differ:

- Agent files use `customer_support_agent.yaml` (underscores); the part
  instructions write `customer-support-agent.yaml`. Only the `name:` field
  inside the YAML matters to the platform.
- The greeting agent here is named `hello_agent`, while
  [Part 3](../part2-first-agent/README.md) uses `hello_world_agent`.
- The guardrail plugin here is `data_access_guardrail`;
  [Part 6](../part5-guidelines-guardrails/README.md) builds
  `content_safety_guardrail`. They solve overlapping problems in different ways
  — either one satisfies the checkpoint.
- The knowledge base is built from `FAQ.pdf`, and the evaluation datasets are
  one JSON file per case (the layout the ADK's red-teaming commands produce)
  rather than a single JSONL file.
- `agents/customer_support_agent.part4.yaml` and `.part5.yaml` are the final
  agent with the later parts' sections removed, so each one imports cleanly at
  that stage of the workshop.

## Not included

- **Evaluation and red-team results.** Run outputs are environment-specific and
  the generated ADK config embeds a live authentication token, so they are
  deliberately left out. Generate your own with the commands above.
- **Credentials of any kind.** No API keys, tokens, or `.env` files. The Part 1
  files use placeholders you fill in yourself.
- **Optional modules.** Multi-agent orchestration, MCP servers, agentic
  workflows, AI gateway models, and NL2SQL ship their own files inside their
  own part folders.
