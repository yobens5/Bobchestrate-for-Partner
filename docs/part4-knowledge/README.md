# Part 4: Knowledge Bases & Collaborators

**Outcome:** The customer-support agent answers approved FAQs and delegates
exceptions to `escalation_agent`.

This part builds on the agent and tools from [Part 3](../part3-custom-tools/README.md).

## What we will implement

You will create an FAQ knowledge base, attach it to the customer-support agent,
and add an escalation collaborator for exceptions that need another agent.

A knowledge base is a collection of approved documents that the agent retrieves
to ground answers. A collaborator is another agent that handles a defined class
of requests delegated by the main agent.

## 1. Add the FAQ knowledge base

Download the workshop
<a href="customer-support-faq.txt" download="customer-support-faq.txt">customer-support-faq.txt</a>
to your browser's default download folder, then place it in `knowledge_bases/`,
then ask Bob:

```text
Inspect knowledge_bases/customer-support-faq.txt. Create
knowledge_bases/faq-knowledge-base.yaml for a knowledge base named
customer-support-faq using the project rules and ADK 2.13.0 documentation.
Keep the document path relative to the YAML. Validate the file, import it into
the active draft environment, and monitor its status until it is ready. Show me
the commands and results.
```

The tested YAML is available as
<a href="faq-knowledge-base.yaml" download="faq-knowledge-base.yaml">faq-knowledge-base.yaml</a>.
Review Bob's generated file against it rather than copying blindly.

Manual import fallback:

```bash
orchestrate knowledge-bases import \
  -f knowledge_bases/faq-knowledge-base.yaml

orchestrate knowledge-bases status -n customer-support-faq
```

Wait until indexing completes before testing.

## 2. Attach the knowledge base

Ask Bob:

```text
Update agents/customer-support-agent.yaml to use customer-support-faq for
shipping, returns, payment, and account questions. Tell the agent to say when
the knowledge base does not contain an answer. Show me the YAML change,
validate it, re-import the agent, and suggest three prompts that distinguish a
grounded answer, an unknown answer, and a tool request.
```

Manual fallback: add `customer-support-faq` under `knowledge_base:`, update the
instructions, then run:

```bash
orchestrate agents import -f agents/customer-support-agent.yaml
orchestrate chat ask --agent-name customer_support_agent
```

Try `What is your return policy?`. The answer should be grounded in the FAQ
rather than invented.

## 3. Add an escalation collaborator

Ask Bob:

```text
Create agents/escalation-agent.yaml for a native agent named escalation_agent.
It handles refunds above the main agent's limit, policy exceptions, serious
complaints, and requests for a manager. Reuse the two customer-support tools and
customer-support-faq knowledge base. Validate and import it. Then update
agents/customer-support-agent.yaml to use it as a collaborator for those exact
cases, validate and re-import the main agent, and verify both agents are listed.
```

The tested files are
<a href="escalation-agent.yaml" download="escalation-agent.yaml">escalation-agent.yaml</a>
and <a href="customer-support-agent.yaml" download="customer-support-agent.yaml">customer-support-agent.yaml</a>.

Manual import fallback:

```bash
orchestrate agents import -f agents/escalation-agent.yaml
orchestrate agents import -f agents/customer-support-agent.yaml
```

## 4. Test the complete flow

Ask Bob:

```text
Show me examples of questions I can ask customer_support_agent to test its
tools, knowledge base, FAQ answers, escalation path, and routing.
```

Manual fallback: run
`orchestrate chat ask --agent-name customer_support_agent`, then test one prompt
from each path:

| Path | Prompt |
|---|---|
| Tool | `What is the status of order ORD-12345?` |
| Knowledge | `How long do refunds normally take?` |
| Collaborator | `I need a $15,000 refund and want to speak with a manager.` |

The third prompt should delegate to `escalation_agent`.

!!! tip "Stuck?"
    Copy the tested files for this part from the
    [reference solution](../solution/README.md#part-4-knowledge-collaborators)
    and import them, then continue.

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

[Continue to Part 5: Guidelines & Guardrails →](../part5-guidelines-guardrails/README.md)
