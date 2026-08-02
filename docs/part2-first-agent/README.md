# Part 3: Building Your First Agent

**Outcome:** A native `hello_world_agent` imported and tested in the draft
environment.

## Minimal native-agent structure

ADK 2.12.0 requires `spec_version`, `name`, and `description` when importing a
native-agent YAML file. The workshop also writes `kind` and `llm` explicitly so
the configuration is easy to review.

```yaml
spec_version: v1
kind: native
name: hello_world_agent
description: A friendly workshop agent that greets users
llm: groq/openai/gpt-oss-120b
instructions: |
  You are HelloBot, a concise and friendly workshop assistant.
  Greet the user, introduce yourself, and explain that you are a demo agent
  built with watsonx Orchestrate.
```

Agent names use `snake_case`. The `instructions` field describes the agent's
role, boundaries, and expected behavior.

## 1. Create the agent

Ask Bob:

```text
Create agents/hello-agent.yaml for a native watsonx Orchestrate agent named
hello_world_agent. It should greet users and briefly introduce itself. Use the
project rules and validate the YAML against ADK 2.12.0 before saving it.
```

Alternatively, copy the YAML above or
<a href="hello-agent-EXAMPLE.yaml" download="hello-agent-EXAMPLE.yaml">download hello-agent-EXAMPLE.yaml</a>.

Review the file before importing it. Confirm:

- the name is `hello_world_agent`
- the model is `groq/openai/gpt-oss-120b`
- the description is specific enough to distinguish the agent
- the instructions do not claim tools or data the agent does not have

## 2. Import it

Ask Bob:

```text
Review agents/hello-agent.yaml against the project rules and ADK 2.12.0
documentation. If it is valid, import it into the active draft environment
using the existing .venv, then verify that hello_world_agent is listed. Show me
the command and result.
```

Manual fallback:

```bash
orchestrate agents import -f agents/hello-agent.yaml
orchestrate agents list
```

The agent should appear in the draft environment.

## 3. Test it

Ask Bob:

```text
Suggest three short chat prompts that test hello_world_agent's greeting, stated
capabilities, and boundaries. Then start a chat with the agent so I can try
them. Tell me what behavior I should observe for each prompt.
```

Manual fallback:

```bash
orchestrate chat ask --agent-name hello_world_agent
```

Try:

```text
Hello. Who are you, and what can you do?
```

The response should be brief, friendly, and consistent with the instructions.
Exit chat with `Ctrl+C`.

## 4. Make one change

Ask Bob:

```text
Update agents/hello-agent.yaml so HelloBot also explains one practical benefit
of agentic AI. Show me the change, validate the file, re-import it, and suggest
one prompt that proves the updated behavior is active.
```

Manual fallback: update the instructions, save the file, and re-import it:

```bash
orchestrate agents import -f agents/hello-agent.yaml
```

Test again and confirm that the new behavior appears.

!!! tip "Stuck?"
    Copy the tested files for this part from the
    [reference solution](../solution/README.md#part-3-first-agent) and import
    them, then continue.

## Checkpoint

- [ ] The YAML imports without validation errors
- [ ] `orchestrate agents list` shows `hello_world_agent`
- [ ] Chat behavior matches the instructions
- [ ] Re-importing updates the existing agent

## Troubleshooting

??? question "The YAML is rejected"

    Check indentation and confirm that `spec_version`, `name`, and
    `description` are present. Ask Bob to validate the exact file against ADK
    2.12.0 rather than rewriting it from memory.

??? question "The agent is missing from the list"

    Confirm the active environment with `orchestrate env list`, then import the
    file again and read the full error.

??? question "The behavior did not change"

    Confirm that you saved and re-imported the same file, then start a fresh
    chat session.

For more practice, use the [Part 3 exercises](exercises.md).

[Continue to Part 4: Custom Tools →](../part3-custom-tools/README.md)
