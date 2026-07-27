# Part 5: Knowledge Bases & Collaborators

**Outcome:** The customer-support agent answers approved FAQs and delegates
exceptions to `escalation_agent`.

This part builds on the agent and tools from [Part 4](../part3-custom-tools/README.md).

## 1. Add the FAQ knowledge base

Download these tested files into `knowledge_bases/`:

- [`customer-support-faq.txt`](customer-support-faq.txt)
- [`faq-knowledge-base.yaml`](faq-knowledge-base.yaml)

The YAML defines a knowledge base named `customer-support-faq` and points to the
FAQ document beside it.

Import it:

```bash
orchestrate knowledge-bases import \
  -f knowledge_bases/faq-knowledge-base.yaml

orchestrate knowledge-bases status -n customer-support-faq
```

Wait until indexing completes before testing.

## 2. Attach the knowledge base

Add this field to `agents/customer-support-agent.yaml`:

```yaml
knowledge_base:
  - customer-support-faq
```

Also tell the agent to use the FAQ for shipping, returns, payment, and account
questions, and to say when the FAQ does not contain an answer.

Re-import and test:

```bash
orchestrate agents import -f agents/customer-support-agent.yaml
orchestrate chat ask --agent-name customer_support_agent
```

Try:

```text
What is your return policy?
```

The answer should be grounded in the FAQ rather than invented.

## 3. Add an escalation collaborator

Download [`escalation-agent.yaml`](escalation-agent.yaml) into `agents/`, or ask
Bob:

```text
Create agents/escalation-agent.yaml for a native agent named escalation_agent.
It handles refunds above the main agent's limit, policy exceptions, serious
complaints, and requests for a manager. Reuse the two customer-support tools and
customer-support-faq knowledge base. Validate it against ADK 2.12.0.
```

Import it:

```bash
orchestrate agents import -f agents/escalation-agent.yaml
```

Add it to the main agent:

```yaml
collaborators:
  - escalation_agent
```

Update the main instructions to delegate:

- refunds above $10,000
- policy exceptions
- requests for a manager
- serious complaints or legal threats

Then re-import:

```bash
orchestrate agents import -f agents/customer-support-agent.yaml
```

The complete tested example is available as
[`customer-support-agent.yaml`](customer-support-agent.yaml).

## 4. Test the complete flow

```bash
orchestrate chat ask --agent-name customer_support_agent
```

Test one prompt from each path:

| Path | Prompt |
|---|---|
| Tool | `What is the status of order ORD-12345?` |
| Knowledge | `How long do refunds normally take?` |
| Collaborator | `I need a $15,000 refund and want to speak with a manager.` |

The third prompt should delegate to `escalation_agent`.

## Checkpoint

- [ ] The knowledge base finishes indexing
- [ ] FAQ answers are grounded in the supplied document
- [ ] `escalation_agent` imports successfully
- [ ] The main agent delegates only the documented exception cases

## Troubleshooting

??? question "The agent cannot find FAQ content"

    Check knowledge-base status, document path, and the exact knowledge-base
    name under `knowledge_base:`.

??? question "Delegation does not happen"

    Confirm that `escalation_agent` exists, is listed under `collaborators:`,
    and has a clear description. State the delegation conditions explicitly in
    the main agent's instructions.

[Continue to Part 6: Guidelines & Guardrails →](../part5-guidelines-guardrails/README.md)
