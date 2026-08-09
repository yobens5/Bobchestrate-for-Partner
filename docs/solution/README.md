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
| <a href="workspace_config.yaml" download="workspace_config.yaml">workspace_config.yaml</a> | `workspace_config.yaml` |
| <a href="bob-config/mcp.json" download="mcp.json">bob-config/mcp.json</a> | `.bob/mcp.json` |
| <a href="bob-config/custom_modes.yaml" download="custom_modes.yaml">bob-config/custom_modes.yaml</a> | `.bob/custom_modes.yaml` |
| <a href="bob-config/rules/wxo-dev-rule-enhanced.txt" download="wxo-dev-rule-enhanced.md">bob-config/rules/wxo-dev-rule-enhanced.md</a> | `.bob/rules/wxo-dev-rule-enhanced.md` |
| <a href="scripts/add-wxo-env.sh" download="add-wxo-env.sh">scripts/add-wxo-env.sh</a> | `add-wxo-env.sh` (optional helper) |

Edit `.bob/mcp.json` and replace `<ABSOLUTE_PATH_TO_YOUR_WORKSPACE>` with the
full path to your project folder, then reload the Bob IDE window. Leaving the
placeholder in place stops the ADK MCP server from starting.

The rule file is stored with a `.txt` extension so the documentation site
serves it. Whatever your browser saves it as, rename it to
`wxo-dev-rule-enhanced.md` inside `.bob/rules/` — that is the name Bob looks
for.

Use `bob-config/mcp.json` for the regular setup. Windows users should use the
<a href="bob-config/mcp-windows-fallback.json" download="mcp.json">Windows fallback mcp.json</a>
only if the regular MCP setup does not work.

`add-wxo-env.sh` registers and activates an environment interactively:

```bash
./add-wxo-env.sh
```

### Part 2: First Agent

| File | Copy to |
|---|---|
| <a href="agents/hello-agent.yaml" download="hello-agent.yaml">agents/hello-agent.yaml</a> | `agents/hello-agent.yaml` |

```bash
orchestrate agents import -f agents/hello-agent.yaml
```

### Part 3: Custom Tools

| File | Copy to |
|---|---|
| <a href="tools/check_order_status.py" download="check_order_status.py">tools/check_order_status.py</a> | `tools/check_order_status.py` |
| <a href="tools/process_refund.py" download="process_refund.py">tools/process_refund.py</a> | `tools/process_refund.py` |
| <a href="requirements.txt" download="requirements.txt">requirements.txt</a> | `requirements.txt` |
| <a href="agents/customer_support_agent.part4.yaml" download="customer_support_agent.part4.yaml">agents/customer_support_agent.part4.yaml</a> | `agents/customer_support_agent.yaml` |

```bash
orchestrate tools import -k python -f tools/check_order_status.py -r requirements.txt
orchestrate tools import -k python -f tools/process_refund.py -r requirements.txt
orchestrate agents import -f agents/customer_support_agent.yaml
```

### Part 4: Knowledge & Collaborators

| File | Copy to |
|---|---|
| <a href="knowledge-bases/FAQ.pdf" download="FAQ.pdf">knowledge-bases/FAQ.pdf</a> | `knowledge-bases/FAQ.pdf` |
| <a href="knowledge-bases/customer-support-faq.yaml" download="customer-support-faq.yaml">knowledge-bases/customer-support-faq.yaml</a> | `knowledge-bases/customer-support-faq.yaml` |
| <a href="agents/escalation-agent.yaml" download="escalation-agent.yaml">agents/escalation-agent.yaml</a> | `agents/escalation-agent.yaml` |
| <a href="agents/customer_support_agent.part5.yaml" download="customer_support_agent.part5.yaml">agents/customer_support_agent.part5.yaml</a> | `agents/customer_support_agent.yaml` |

```bash
orchestrate knowledge-bases import -f knowledge-bases/customer-support-faq.yaml
orchestrate knowledge-bases status -n customer_support_faq
orchestrate agents import -f agents/escalation-agent.yaml
orchestrate agents import -f agents/customer_support_agent.yaml
```

Wait for the knowledge base to finish indexing before testing FAQ answers.

### Part 5: Guidelines & Guardrails

| File | Copy to |
|---|---|
| <a href="tools/content_safety_plugin.py" download="content_safety_plugin.py">tools/content_safety_plugin.py</a> | `tools/content_safety_plugin.py` |
| <a href="agents/customer_support_agent.yaml" download="customer_support_agent.yaml">agents/customer_support_agent.yaml</a> | `agents/customer_support_agent.yaml` |

```bash
orchestrate tools import -k python -f tools/content_safety_plugin.py -r requirements.txt
orchestrate agents import -f agents/customer_support_agent.yaml
```

This is the final state of the main agent: tools, knowledge base, collaborator,
guidelines, and the pre-invoke guardrail plugin.

!!! note "A second guardrail is included"
    <a href="tools/data_access_guardrail.py" download="data_access_guardrail.py">tools/data_access_guardrail.py</a>
    is an alternative pre-invoke plugin that focuses on unauthorized data
    access rather than content safety. The agent above does not reference it.
    To try it instead, import it and change `plugin_name` to
    `data_access_guardrail`.

### Part 6: Deployment

Deployment produces no new files. Use the Part 5 agent state above, then follow
[Part 6](../part7-deployment/README.md).

### Agent Evaluations & Red-Teaming (Optional)

Not required before deployment — Part 6 accepts the manual Part 5 test
evidence as an alternative. Use these files if you take the optional
[Agent Evaluations & Red-Teaming](../part6-agent-evaluation/README.md) module.

| File | Copy to |
|---|---|
| <a href="evaluation/config.yaml" download="config.yaml">evaluation/config.yaml</a> | `evaluation/config.yaml` |
| `evaluation/datasets/*.json` (12 files) | `evaluation/datasets/` |
| `evaluation/red-teaming-attacks/*.json` (24 files) | `evaluation/red-teaming-attacks/` |

These commands need the evaluation dependencies from
[Part 1 Step 5](../part1-setup/README.md#add-the-evaluation-dependencies).
`evaluation/config.yaml` needs no editing: the ADK reuses the environment you
activated in Part 1. Do not add an `auth_config` block — it overrides the
authentication token the ADK already holds. Never add an API key to that file.

```bash
orchestrate evaluations quick-eval -c evaluation/config.yaml -t tools
orchestrate evaluations red-teaming run -a evaluation/red-teaming-attacks -o evaluation/red-teaming-results
```

The datasets cover six happy paths, three edge cases, and three error
scenarios. The attack set covers instruction override, crescendo, emotional
appeal, role playing, prompt leakage, jailbreaking, topic derailment, and
unsafe topics.

## Known differences from the walkthrough text

This snapshot is one completed run of the workshop, not a regenerated copy of
the examples embedded in each part. Agent, tool, knowledge-base, and plugin
**names** match the walkthrough, so you can mix files from here with files you
built yourself. The remaining differences are cosmetic or structural:

- Agent **filenames** use underscores (`customer_support_agent.yaml`); the part
  instructions write `customer-support-agent.yaml`. Only the `name:` field
  inside the YAML matters to the platform — but if you copy a file from here,
  use the filename in the import command you run.
- The knowledge base is built from `FAQ.pdf` rather than the
  `customer-support-faq.txt` used in
  [Part 4](../part4-knowledge/README.md). The knowledge-base name is
  `customer_support_faq` in both.
- The instructions and guidelines here are longer and more detailed than the
  minimal examples in the parts. Both satisfy the checkpoints.
- `agents/customer_support_agent.part4.yaml` and `.part5.yaml` are the final
  agent with the later parts' sections removed, so each one imports cleanly at
  that stage of the workshop.
- `tools/data_access_guardrail.py` is an extra alternative guardrail that no
  agent here references. See the note under Part 5 above.

## Not included

- **Evaluation and red-team results.** Run outputs are environment-specific and
  the generated ADK config embeds a live authentication token, so they are
  deliberately left out. Generate your own with the commands above.
- **Credentials of any kind.** No API keys, tokens, or `.env` files. The Part 1
  files use placeholders you fill in yourself.
- **Optional modules.** Multi-agent orchestration, MCP servers, agentic
  workflows, AI gateway models, and NL2SQL ship their own files inside their
  own part folders.
