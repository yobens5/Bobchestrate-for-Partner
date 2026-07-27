# Model Selection Checklist

Use this guide after running:

```bash
orchestrate models list
```

Model identifiers, availability, pricing, limits, and provider terms change.
Treat the connected environment and current provider documentation as the
source of truth.

## Start with the workshop model

Use `groq/openai/gpt-oss-120b` unless an evaluated requirement justifies another
model.

Consider an alternative only when you can name the unmet requirement, such as:

- required modality or context size
- deployment-region or data-residency constraint
- measured quality gap on representative cases
- latency, availability, or throughput target
- approved provider or hosting requirement

## Evidence to collect

Evaluate each candidate with the same dataset and record:

| Dimension | Question |
|---|---|
| Functional quality | Does it select the correct tools and arguments? |
| Grounding | Does it avoid invented answers? |
| Safety | Does it pass the same red-team cases? |
| Latency | What is the observed response-time distribution? |
| Reliability | What errors and rate limits occur? |
| Cost | What does the measured workload cost? |
| Governance | Where is data processed and retained? |
| Operations | Who owns credentials, monitoring, and incident response? |

Do not select a model from general reputation alone.

## Choose a policy

| Strategy | Use when |
|---|---|
| `single` | One approved model needs retry handling for transient errors |
| `fallback` | A separately evaluated backup may be used when the primary fails |
| `loadbalance` | Multiple equivalent targets have been tested and traffic distribution is intentional |

Fallback and load balancing can change behavior because different models may
select tools or phrase answers differently. Test every target independently and
test the combined policy.

## Credential rules

- Store provider keys in approved Orchestrate connections.
- Configure draft and live independently.
- Never commit keys or paste them into Bob prompts.
- Grant access only to the required models and environments.
- Define rotation and revocation ownership before deployment.

## Approval checklist

- [ ] Exact model identifiers came from `orchestrate models list`
- [ ] Representative functional and adversarial tests passed
- [ ] Data handling and region were approved
- [ ] Expected cost and rate limits were reviewed
- [ ] Credentials use approved connections
- [ ] Monitoring and rollback ownership are recorded
- [ ] The choice and evidence are documented

See [AI Gateway Models](README.md) for the hands-on policy exercise.
