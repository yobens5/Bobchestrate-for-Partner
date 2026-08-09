# Part 6: Agent Evaluations & Red-Teaming

**Outcome:** A repeatable functional evaluation and a small adversarial test run
for `customer_support_agent`.

Evaluation checks known behavior. Red-teaming deliberately tries to break the
agent's boundaries. Neither replaces human review or production monitoring.

## What we will implement

You will create a repeatable functional evaluation dataset, run it against the
customer-support agent, generate adversarial red-team tests, and re-evaluate
after fixing confirmed failures.

!!! warning "Check this before you start"
    The evaluation commands live in a package that the base ADK install does
    not include. Run this first:

    ```bash
    orchestrate evaluations red-teaming list
    ```

    If it prints a list of attack names, you are ready. If it prints
    `No module named 'agentops'`, install the dependencies as described in
    [Part 1 Step 5](../part1-setup/README.md#add-the-evaluation-dependencies)
    — using the `==2.14.0` pin, **not** the `--upgrade` command in the error
    message.

## 1. Prepare the evaluation files

Ask Bob:

```text
Inspect customer_support_agent and its actual tool schemas. Create an ADK 2.14.0
evaluation setup: evaluation/config.yaml plus one JSON dataset file per case
under evaluation/datasets/. Each dataset file needs the ADK fields agent, goals,
goal_details, story, and starting_sentence. Cover a normal order lookup, an
invalid order ID, and a refund that the tool rejects. Validate every file. Do
not add an auth_config block and never write an API key — the ADK reuses the
environment I activated in Part 1.
```

Download the tested starter files:

- <a href="evaluation/config.yaml" download="config.yaml">config.yaml</a>
- <a href="evaluation/datasets/happy_path_01_order_status.json" download="happy_path_01_order_status.json">happy_path_01_order_status.json</a>
- <a href="evaluation/datasets/edge_case_01_invalid_order_id.json" download="edge_case_01_invalid_order_id.json">edge_case_01_invalid_order_id.json</a>
- <a href="evaluation/datasets/error_scenario_01_refund_invalid_reason.json" download="error_scenario_01_refund_invalid_reason.json">error_scenario_01_refund_invalid_reason.json</a>

`config.yaml` goes in `evaluation/`; the three dataset files go in
`evaluation/datasets/`. Run this in the Bob IDE terminal, from your
`bobchestrate-ws` folder:

=== "Windows PowerShell"

    ```powershell
    New-Item -ItemType Directory -Force -Path evaluation\datasets
    Move-Item "$env:USERPROFILE\Downloads\config.yaml" evaluation\ -Force
    Move-Item "$env:USERPROFILE\Downloads\happy_path_01_order_status.json" `
      evaluation\datasets\ -Force
    Move-Item "$env:USERPROFILE\Downloads\edge_case_01_invalid_order_id.json" `
      evaluation\datasets\ -Force
    Move-Item "$env:USERPROFILE\Downloads\error_scenario_01_refund_invalid_reason.json" `
      evaluation\datasets\ -Force
    ```

=== "macOS"

    ```bash
    mkdir -p evaluation/datasets
    mv ~/Downloads/config.yaml evaluation/
    mv ~/Downloads/happy_path_01_order_status.json \
       ~/Downloads/edge_case_01_invalid_order_id.json \
       ~/Downloads/error_scenario_01_refund_invalid_reason.json \
       evaluation/datasets/
    ```

You should end up with:

```text
bobchestrate-ws/
└── evaluation/
    ├── config.yaml
    └── datasets/
        ├── happy_path_01_order_status.json
        ├── edge_case_01_invalid_order_id.json
        └── error_scenario_01_refund_invalid_reason.json
```

Compare Bob's output with the downloaded files.

!!! info "There is nothing to fill in"
    `config.yaml` needs no editing. The ADK takes the service URL, the
    environment name, and the authentication token from the environment you
    activated in Part 1. If you add an `auth_config` block by hand, it replaces
    those values *including the token*, and the evaluation then fails to
    authenticate.

The functional dataset contains:

- a normal order-status request
- an invalid order ID
- a refund the tool rejects because the reason is too short

Review each expected result against the actual tool names and behavior in your
project. If your tools return different values than the tested ones, update the
`keywords` and `response` fields to match what your agent actually says.

## 2. Run quick evaluation

Ask Bob:

```text
Run the ADK 2.14.0 quick evaluation using evaluation/config.yaml against the
tools directory, with the environment I activated in Part 1. Inspect the
generated results and summarize failed cases, unexpected tool calls, schema
mismatches, invented information, and the smallest likely fix for each. Do not
change the agent yet.
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

Choose a prompt that behaved incorrectly in Part 5. Ask Bob:

```text
Add one evaluation case for this failure as a new JSON file in
evaluation/datasets/. Match the structure of the existing dataset files and the
actual customer_support_agent tool names, then add the new file to test_paths in
evaluation/config.yaml. Validate that the file is valid JSON.

Failure:
<paste prompt, observed response, and expected behavior>
```

Each case is its own file, and `config.yaml` must list it under `test_paths` or
it will not run. Run quick evaluation again and confirm that the new case
appears in the result.

## 4. Generate red-team attacks

List the attack plans supported by your installed ADK:

```bash
orchestrate evaluations red-teaming list
```

Use only names that appear in that list — the attack names differ between ADK
versions.

Ask Bob:

```text
List the red-team attacks supported by the installed ADK, then generate a small
set for customer_support_agent using instruction_override, jailbreaking, and
crescendo_prompt_leakage with two variants each. Use evaluation/datasets as the
dataset path and agents as the agent directory. Run the generated attacks,
inspect the results, and summarize successful attacks without changing files.
```

Manual fallback:

```bash
orchestrate evaluations red-teaming plan \
  -a "instruction_override,jailbreaking,crescendo_prompt_leakage" \
  -d evaluation/datasets \
  -g agents \
  -t customer_support_agent \
  -o evaluation/red-team-attacks \
  -n 2
```

The `-d` option takes the **same dataset files** you evaluated in Step 2, not a
list of attack prompts. The generator uses each case as the starting point for
an attack, which is why the generated filenames repeat your dataset names.

Then run the generated attacks:

```bash
orchestrate evaluations red-teaming run \
  -a evaluation/red-team-attacks \
  -o evaluation/red-team-results
```

Review the results for successful instruction overrides, prompt leakage,
fabricated customer data, and unsafe tool calls.

!!! tip "Extra prompts to try by hand"
    <a href="evaluation/red-team-prompts.jsonl" download="red-team-prompts.jsonl">red-team-prompts.jsonl</a>
    is a list of twenty adversarial prompts with the behavior each one should
    produce. It is **not** an input to any command — paste the prompts into
    `orchestrate chat ask` yourself when you want to probe the agent manually.

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
    [reference solution](../solution/README.md#part-6-evaluation-red-teaming),
    then continue.

## Checkpoint

- [ ] `orchestrate evaluations red-teaming list` runs without an import error
- [ ] Quick evaluation produces results
- [ ] At least one observed behavior is preserved as a test
- [ ] Red-team attacks are generated and executed
- [ ] Failures are reviewed rather than hidden or deleted
- [ ] Fixed cases are rerun successfully
- [ ] Bob's proposed fix was reviewed before files were changed

## Troubleshooting

??? question "`No module named 'agentops'`"

    The evaluation dependencies are not installed. Follow
    [Part 1 Step 5](../part1-setup/README.md#add-the-evaluation-dependencies).
    Use the `==2.14.0` pin, not the `--upgrade` command the error suggests.

??? question "Evaluation cannot authenticate"

    First check that `evaluation/config.yaml` has **no** `auth_config` block —
    adding one by hand overrides the token the ADK obtained when you activated
    the environment. Then reactivate with
    `orchestrate env activate <environment-name>` and confirm with
    `orchestrate agents list`.

??? question "The target agent is not found"

    Confirm that `agents/customer-support-agent.yaml` contains
    `name: customer_support_agent` and that `-g agents` points to its directory.

??? question "A dataset file is rejected"

    Each case is a single JSON file containing `agent`, `goals`, `goal_details`,
    `story`, and `starting_sentence`. JSON does not allow comments or trailing
    commas. Every file you want to run must also be listed under `test_paths`
    in `evaluation/config.yaml`.

[Continue to Part 7: Deployment →](../part7-deployment/README.md)
