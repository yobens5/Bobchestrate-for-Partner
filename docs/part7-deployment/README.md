# Part 8: Testing & Deployment

**Outcome:** The evaluated customer-support agent is deployed to the live
environment and its webchat configuration can be generated.

Deployment makes an agent available to users. It does not by itself make the
workshop example production-ready.

## 1. Pre-deployment check

Do not deploy until:

- `customer_support_agent` passes the agreed functional tests
- red-team results have no unresolved critical failures
- both Python tools are imported and working
- `customer-support-faq` has finished indexing
- `escalation_agent` is available
- no API key or personal data is stored in project files

Record any accepted limitation before continuing.

## 2. Verify the draft artifacts

All import commands target draft automatically. Re-import only artifacts changed
after evaluation:

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
  -f knowledge_bases/faq-knowledge-base.yaml

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

```bash
orchestrate agents deploy --name customer_support_agent
orchestrate agents list
```

Developer Edition does not support `orchestrate agents deploy`; imported draft
agents remain available locally.

## 4. Generate webchat configuration

Live:

```bash
orchestrate channels webchat embed \
  --agent-name customer_support_agent \
  --env live
```

Draft testing:

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
- add observed failures to the evaluation dataset
- re-evaluate before deploying an updated version

If the deployed agent should no longer be available:

```bash
orchestrate agents undeploy --name customer_support_agent
```

Confirm the exact command against `orchestrate agents undeploy --help` before
using it in a shared environment.

## Checkpoint

- [ ] Draft artifacts and knowledge status are verified
- [ ] A final draft chat succeeds
- [ ] The evaluated agent is deployed to live
- [ ] Webchat configuration is generated for the intended environment
- [ ] Monitoring ownership and rollback criteria are recorded

[Continue to Part 9: NL2SQL Accelerator →](../part9-nl2sql/README.md)
