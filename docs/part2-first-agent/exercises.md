# Part 2 — Optional Exercises

Complete these only after `hello_world_agent` passes the main checkpoint.

## Exercise 1: Change the persona

Ask Bob to create `agents/workshop_guide.yaml` for an agent that:

- welcomes participants
- explains the eight mandatory parts
- answers in no more than four sentences
- says when it does not know an answer

Ask Bob to validate and import the file, then suggest prompts that test every
requirement. Manual fallback:

```bash
orchestrate agents import -f agents/workshop_guide.yaml
orchestrate chat ask --agent-name workshop_guide
```

Success means the name uses `snake_case`, the YAML validates, and the response
follows the length and uncertainty instructions.

## Exercise 2: Repair an agent

Ask Bob to identify the problems before changing anything:

```yaml
spec_version: v1
kind: native
name: broken_agent
description: An agent that does not work properly
llm: invalid-model-name
instructions: |
  Be helpful.
hidden: true
```

Expected observations:

- the model is not one of the workshop's available models
- the instructions do not define a useful role or boundaries
- `hidden: true` prevents normal discovery in the UI
- the description is too vague for collaborator routing

After reviewing the diagnosis, ask Bob to fix the file, validate and import it,
suggest one test for each change, and explain why the change was needed.

## Exercise 3: Add starter prompts

Ask Bob to add two starter prompts to `workshop_guide`. Each prompt needs a
unique `id`, title, subtitle, and prompt:

```yaml
starter_prompts:
  prompts:
    - id: explain-workshop
      title: Explain the workshop
      subtitle: See the learning path
      prompt: What will I build in this workshop?
```

Ask Bob to create the second prompt, validate and re-import the agent, generate
draft webchat configuration, and help you confirm that both prompts appear.

[Return to Part 2](README.md) or
[continue to Part 3](../part3-custom-tools/README.md).
