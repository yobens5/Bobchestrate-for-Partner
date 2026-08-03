# Optional Module: AI Gateway Models

**Outcome:** An agent uses a validated model policy instead of a hard-coded
model target.

Model availability, identifiers, prices, and provider requirements change.
Always start from the models available in the connected environment rather than
copying a model name from an old example.

## What we will implement

You will inspect available models, create a validated retry policy, apply it to
a copy of an evaluated agent, and compare the original and policy-based agents
against the same behavior and safety cases.

## 1. Inspect available models

Ask Bob:

```text
Using the active environment and existing .venv, list the available Orchestrate
models. Help me compare candidates by exact identifier, tool-calling support,
region or data-handling constraints, rate limits, expected cost ownership, and
the evaluation cases they must pass. Do not request or store provider API keys.
```

Manual fallback:

```bash
orchestrate models list
```

For each candidate, record:

- provider and exact model identifier
- region and data-handling constraints
- tool-calling support
- rate limits and expected cost
- the evaluation cases it must pass

External providers require an approved connection and may generate charges.
Never store provider API keys in YAML, scripts, or chat messages.

## 2. Create a retry policy

Ask Bob:

```text
Create models/retry-policy.yaml for ADK 2.13.0 as a model policy named
workshop_model_retry. Use the tested workshop model as one target, two retries,
and only transient 503 and 504 status codes. Validate the schema, show me the
file, import it, and verify it is listed.
```

The expected policy is:

```yaml
spec_version: v1
kind: model
name: workshop_model_retry
display_name: Workshop Model with Retry
description: Retries the tested workshop model after a transient service error
policy:
  strategy:
    mode: single
  retry:
    attempts: 2
    on_status_codes: [503, 504]
  targets:
    - model_name: groq/openai/gpt-oss-120b
```

Manual import fallback:

```bash
orchestrate models policy import -f models/retry-policy.yaml
orchestrate models list
```

The policy uses `kind: model`; `kind: model_policy` is not valid for ADK 2.13.0
policy files.

## 3. Apply the policy

Ask Bob:

```text
Create a copy of an evaluated workshop agent and change only its llm reference
to workshop_model_retry. Show me the diff, validate and import the copied agent,
then identify the exact baseline evaluation cases to rerun. Run them after I
approve and compare tool selection, response quality, latency, and safety
behavior with the original.
```

The copied agent should reference:

```yaml
llm: workshop_model_retry
```

Re-import and run the same evaluation cases used for the original model. Do not
assume that changing the model preserves tool selection, response quality,
latency, or safety behavior.

## 4. Optional fallback exercise

If an instructor has configured and approved a second model, create a fallback
policy using the exact names from `orchestrate models list`. Ask Bob:

```text
Using only model identifiers currently listed in this environment, create a
two-target fallback policy with the approved primary and backup models. Show me
the data-handling and cost assumptions that require instructor confirmation.
After approval, validate and import the policy and propose a controlled test of
both the normal and fallback paths.
```

Manual YAML fallback:

```yaml
spec_version: v1
kind: model
name: workshop_model_fallback
display_name: Workshop Model Fallback
description: Uses an approved backup when the primary model is unavailable
policy:
  strategy:
    mode: fallback
  retry:
    attempts: 1
    on_status_codes: [500, 503, 504]
  targets:
    - model_name: <primary-model-name>
    - model_name: <approved-backup-model-name>
```

Replace both placeholders before importing. Test the normal path and a
controlled failure scenario.

## Checkpoint

- [ ] Model identifiers came from the connected environment
- [ ] The retry policy imports with `kind: model`
- [ ] An evaluated agent can reference the policy by name
- [ ] Agent behavior is re-evaluated after the model change
- [ ] External credentials are stored only in approved connections
- [ ] Cost and data-handling ownership are documented

Use the [Model Selection Guide](model-selection-guide.md) as a discussion aid,
but verify every current provider detail against the connected environment and
official documentation.
