# Optional Module: AI Gateway Models

**Outcome:** An agent uses a validated model policy instead of a hard-coded
model target.

Model availability, identifiers, prices, and provider requirements change.
Always start from the models available in the connected environment rather than
copying a model name from an old example.

## 1. Inspect available models

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

Create `models/retry-policy.yaml`:

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

Import it:

```bash
orchestrate models policy import -f models/retry-policy.yaml
orchestrate models list
```

The policy uses `kind: model`; `kind: model_policy` is not valid for ADK 2.12.0
policy files.

## 3. Apply the policy

In a copy of an evaluated agent, replace its direct model:

```yaml
llm: workshop_model_retry
```

Re-import and run the same evaluation cases used for the original model. Do not
assume that changing the model preserves tool selection, response quality,
latency, or safety behavior.

## 4. Optional fallback exercise

If an instructor has configured and approved a second model, create a fallback
policy using the exact names from `orchestrate models list`:

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
