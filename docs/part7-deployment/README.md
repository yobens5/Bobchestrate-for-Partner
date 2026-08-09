# Part 6: Testing & Deployment

**Outcome:** The tested customer-support agent is deployed to the live
environment and its webchat configuration can be generated.

Deployment makes an agent available to users. It does not by itself make the
workshop example production-ready.

## What we will implement

You will verify the draft artifacts, promote the customer-support agent to the
live environment, generate webchat configuration, and review basic monitoring
and recovery steps.

## 1. Pre-deployment check

Do not deploy until:

- `customer_support_agent` passes the manual test cases from
  [Part 5](../part5-guidelines-guardrails/README.md#3-test-guidelines-and-guardrails)
  — or, if you completed the optional
  [Agent Evaluations & Red-Teaming](../part6-agent-evaluation/README.md)
  module, its functional and red-team results
- both Python tools are imported and working
- `customer_support_faq` has finished indexing
- `escalation_agent` is available
- no API key or personal data is stored in project files

Record any accepted limitation before continuing.

Ask Bob to assemble the evidence:

```text
Perform a read-only deployment readiness review for customer_support_agent.
If an evaluation/ folder with results exists, check the latest evaluation and
red-team results; otherwise note that no automated evaluation was run. Check
imported tools and agents, knowledge-base status, unresolved failures, and
tracked files for likely secrets. Summarize pass, fail, and unknown items. Do
not deploy anything.
```

## 2. Verify the draft artifacts

All import commands target draft automatically. Re-import only artifacts changed
after evaluation:

Ask Bob:

```text
Using the existing .venv, import or re-import only the customer-support
artifacts changed since evaluation: Python tools, knowledge base, escalation
agent, then customer_support_agent. Respect dependency order. Verify the tools,
knowledge base, and agents are present, then start a draft chat and suggest one
final smoke-test prompt for each capability.
```

Manual fallback:

```bash
orchestrate tools import -k python \
  -f tools/check_order_status.py \
  -r requirements.txt

orchestrate tools import -k python \
  -f tools/process_refund.py \
  -r requirements.txt

orchestrate tools import -k python \
  -f tools/content_safety_plugin.py \
  -r requirements.txt

orchestrate knowledge-bases import \
  -f knowledge-bases/faq-knowledge-base.yaml

orchestrate agents import -f agents/escalation-agent.yaml
orchestrate agents import -f agents/customer-support-agent.yaml
```

Verify:

```bash
orchestrate tools list
orchestrate knowledge-bases list
orchestrate agents list
```

Run one final draft chat:

```bash
orchestrate chat ask --agent-name customer_support_agent
```

## 3. Deploy the agent

For SaaS or on-premises environments:

Ask Bob:

```text
Show me the exact ADK command that will deploy customer_support_agent from
draft to live and explain what it changes. Wait for my explicit confirmation.
After I approve, run it and verify the agent's live status.
```

Deployment is an external change. Review Bob's target environment and command
before approving it.

Manual fallback:

```bash
orchestrate agents deploy --name customer_support_agent
orchestrate agents list
```

Developer Edition does not support `orchestrate agents deploy`; imported draft
agents remain available locally.

## 4. Generate webchat configuration

Ask Bob:

```text
Generate the webchat embed configuration for the live
customer_support_agent. Create a minimal local HTML example that includes a
root element and the generated script. Do not include credentials, publish the
file, or make the chat public. Explain which authentication setting the host
application still needs.
```

Manual fallback for live:

```bash
orchestrate channels webchat embed \
  --agent-name customer_support_agent \
  --env live
```

For draft testing:

```bash
orchestrate channels webchat embed \
  --agent-name customer_support_agent \
  --env draft
```

Use the generated configuration in an HTML page that has:

- `<!DOCTYPE html>`
- an element with `id="root"`
- the generated script inside `<body>`
- the authentication mechanism required by your deployment

Do not publish workshop credentials or a publicly accessible unauthenticated
chat.

## 5. Monitor and recover

After deployment:

- review conversations and errors in the Orchestrate UI
- track failed tool calls, escalation rate, response latency, and recurring
  unanswered questions
- if you completed the optional
  [Agent Evaluations & Red-Teaming](../part6-agent-evaluation/README.md)
  module, add observed failures to its evaluation dataset and re-evaluate
  before deploying an updated version

Ask Bob to help turn observed behavior into regressions:

```text
Review the exported or pasted workshop conversation logs without retaining
personal data. Group recurring failures by tool, knowledge, routing, safety,
and response quality. Suggest one evaluation case per confirmed failure and
identify which artifact should be reviewed. Do not edit or redeploy yet.
```

If the deployed agent should no longer be available:

```bash
orchestrate agents undeploy --name customer_support_agent
```

Confirm the exact command against `orchestrate agents undeploy --help` before
using it in a shared environment.

!!! tip "Stuck?"
    Deployment adds no new files. If your agent is not in the expected state,
    restore it from the
    [reference solution](../solution/README.md#part-5-guidelines-guardrails)
    and re-import before promoting it.

## Checkpoint

- [ ] Draft artifacts and knowledge status are verified
- [ ] A final draft chat succeeds
- [ ] The tested agent is deployed to live
- [ ] Webchat configuration is generated for the intended environment
- [ ] Monitoring ownership and rollback criteria are recorded

[Continue to Part 7: NL2SQL Accelerator →](../part9-nl2sql/README.md)
