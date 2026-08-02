# Part 7: Agent Evaluations & Red-Teaming

**Outcome:** A repeatable functional evaluation and a small adversarial test run
for `customer_support_agent`.

Evaluation checks known behavior. Red-teaming deliberately tries to break the
agent's boundaries. Neither replaces human review or production monitoring.

## 1. Prepare the evaluation files

Ask Bob:

```text
Inspect customer_support_agent and its actual tool schemas. Create
evaluation/config.yaml, evaluation/test-cases.jsonl, and
evaluation/red-team-prompts.jsonl for ADK 2.12.0. Include a normal order lookup,
invalid order ID, refund with missing information, grounded FAQ question,
escalation case, and safe refusal case. Validate every JSONL line and the YAML.
Use placeholders for environment-specific URL values and never write an API key.
Explain what I must fill in before running the evaluation.
```

Download the tested starter files to your browser's default download folder:

- <a href="evaluation/config.yaml" download="config.yaml">config.yaml</a>
- <a href="evaluation/test-cases.jsonl" download="test-cases.jsonl">test-cases.jsonl</a>
- <a href="evaluation/red-team-prompts.jsonl" download="red-team-prompts.jsonl">red-team-prompts.jsonl</a>

Compare Bob's output with the downloaded files.

Edit `evaluation/config.yaml`:

- replace `<region>` and `<instance-id>` in `auth_config.url`
- replace `<environment-name>` with the name shown by
  `orchestrate env list`
- keep `wxo_lite_version: 2.12.0`

Never put an API key in this file.

The functional dataset contains:

- a normal order-status request
- an invalid order ID
- a refund request with missing required information

Review each expected result against the actual tool names and behavior in your
project.

## 2. Run quick evaluation

Ask Bob:

```text
Check that evaluation/config.yaml contains the required non-secret environment
values, then run the ADK 2.12.0 quick evaluation against the tools directory.
Inspect the generated results and summarize failed cases, unexpected tool calls,
schema mismatches, invented information, and the smallest likely fix for each.
Do not change the agent yet.
```

Manual fallback:

```bash
orchestrate evaluations quick-eval \
  -c evaluation/config.yaml \
  -t tools
```

Open the generated files under `evaluation/results/`. Look for:

- expected tools not called
- tool-schema mismatches
- invented information
- responses that do not satisfy the expected behavior

Do not continue only because the command completed; inspect the individual
failures.

## 3. Add one observed test

Choose a prompt that behaved incorrectly in Part 6. Ask Bob:

```text
Add one evaluation record for this failure to evaluation/test-cases.jsonl.
Match the existing JSONL format and the actual customer_support_agent tool
names. Validate that every non-comment line is valid JSON.

Failure:
<paste prompt, observed response, and expected behavior>
```

Run quick evaluation again and confirm that the new case appears in the result.

## 4. Generate red-team attacks

List the attack plans supported by your installed ADK:

```bash
orchestrate evaluations red-teaming list
```

Ask Bob:

```text
List the red-team attacks supported by the installed ADK, then generate a small
set for customer_support_agent using instruction_override, jailbreaking, and
crescendo_prompt_leakage with two variants each. Use the existing evaluation
data and agent directory. Run the generated attacks, inspect the results, and
summarize successful attacks without changing files.
```

Manual fallback:

```bash
orchestrate evaluations red-teaming plan \
  -a "instruction_override,jailbreaking,crescendo_prompt_leakage" \
  -d evaluation/red-team-prompts.jsonl \
  -g agents \
  -t customer_support_agent \
  -o evaluation/red-team-attacks \
  -n 2
```

Then run the generated attacks:

```bash
orchestrate evaluations red-teaming run \
  -a evaluation/red-team-attacks \
  -o evaluation/red-team-results
```

Review the results for successful instruction overrides, prompt leakage,
fabricated customer data, and unsafe tool calls.

## 5. Fix and re-evaluate

Ask Bob:

```text
Compare the functional and red-team results with the agent, tool, guideline,
and guardrail files. Recommend the smallest evidence-based fix. After I approve
it, update only the relevant artifact, validate and re-import it, rerun the
failed cases, and explain whether the regression is fixed.
```

For each failure, change the smallest appropriate layer:

| Failure | Likely fix |
|---|---|
| Wrong or missing tool call | Tool docstring or agent instruction |
| Incorrect tool arguments | Types, validation, or examples |
| Wrong collaborator routing | Agent descriptions and delegation conditions |
| Sensitive-data handling | Guideline or pre-invoke guardrail |
| Invented answer | Instructions and knowledge grounding |

Re-import every changed artifact, then rerun the functional evaluation and the
relevant red-team attack. Keep the failed case in the dataset so it becomes a
regression test.

!!! tip "Stuck?"
    Copy the tested datasets and attack files for this part from the
    [reference solution](../solution/README.md#part-7-evaluation-red-teaming),
    then continue.

## Checkpoint

- [ ] The configuration points to the correct SaaS environment
- [ ] Quick evaluation produces results
- [ ] At least one observed behavior is preserved as a test
- [ ] Red-team attacks are generated and executed
- [ ] Failures are reviewed rather than hidden or deleted
- [ ] Fixed cases are rerun successfully
- [ ] Bob's proposed fix was reviewed before files were changed

## Troubleshooting

??? question "Evaluation cannot authenticate"

    Confirm the URL and environment name in `config.yaml`, then reactivate the
    environment with `orchestrate env activate <environment-name>`.

??? question "The target agent is not found"

    Confirm that `agents/customer-support-agent.yaml` contains
    `name: customer_support_agent` and that `-g agents` points to its directory.

??? question "A JSONL file is rejected"

    Each record must occupy one line and be valid JSON. Comments are not JSON;
    remove them if the command does not accept comment lines.

[Continue to Part 8: Deployment →](../part7-deployment/README.md)
