# Optional Module: Agentic Workflows

**Outcome:** A fixed loan-approval flow calls four MCP tools in a defined order.

Use a workflow when routing and parameter mapping should be configured in
advance. Use an agent when the model must decide dynamically what to do next.
Actual latency and cost depend on the tools and models used.

## 1. Ask Bob to build the workflow

Ask Bob:

```text
Build an ADK 2.12.0 loan-processing example with four mock MCP tools: credit
check, income verification, debt-to-income calculation, and final decision.
Create a deterministic @flow workflow that calls them in that order with
explicit map_input mappings, plus a native loan_processor_agent that uses only
the workflow tool. Put the files in tools/ and agents/, add requirements, run
local syntax checks, and validate all schemas. Do not import yet; explain every
input mapping.
```

Use these tested files as fallbacks or comparisons.

Save under `tools/`:

- [`loan_processing_server.py`](tools/loan_processing_server.py)
- [`loan-processing-toolkit.yaml`](tools/loan-processing-toolkit.yaml)
- [`loan_approval_workflow.py`](tools/loan_approval_workflow.py)
- [`requirements.txt`](tools/requirements.txt)

Save
[`loan-processor-agent.yaml`](agents/loan-processor-agent.yaml) under `agents/`.

The workflow performs:

```text
credit check → income verification → debt-to-income calculation → decision
```

Review every `map_input()` call. It explicitly connects flow inputs and earlier
tool outputs to the next tool's parameters.

## 2. Validate and import the MCP toolkit

Ask Bob:

```text
Inspect the generated loan MCP server, toolkit YAML, workflow, and
requirements. Run Python syntax checks and any local smoke tests. If they pass,
import the MCP toolkit into draft and verify that all loan-processing-prefixed
tools are listed.
```

Manual syntax and import fallback:

```bash
python -m py_compile \
  tools/loan_processing_server.py \
  tools/loan_approval_workflow.py

orchestrate toolkits import -f tools/loan-processing-toolkit.yaml
orchestrate tools list
```

Confirm that the `loan-processing:` tools appear.

The toolkit's `command: python3` runs inside the Orchestrate runtime, not in the
participant's local Windows or macOS shell.

## 3. Import the flow

Ask Bob:

```text
Validate every required workflow argument and map_input expression against the
imported tool schemas. If they match, import loan_approval_workflow as a flow
tool and verify it is listed. Show me any inferred mapping before changing it.
```

Manual fallback:

```bash
orchestrate tools import \
  -k flow \
  -f tools/loan_approval_workflow.py

orchestrate tools list
```

Confirm that `loan_approval_workflow` appears.

## 4. Import and test the agent

Ask Bob:

```text
Validate and import agents/loan-processor-agent.yaml, then suggest a valid loan
request, missing-input case, adverse decision case, and boundary-value case.
Start a chat so I can test them. Explain which workflow outputs should appear
in each response.
```

Manual fallback:

```bash
orchestrate agents import -f agents/loan-processor-agent.yaml
orchestrate chat ask --agent-name loan_processor_agent
```

Try:

```text
Process a loan request for applicant APP-12345 for $250,000.
```

Check that the workflow runs once, required parameters are mapped, and the final
decision explains the returned values without inventing them.

## Checkpoint

- [ ] The MCP toolkit imports and exposes its tools
- [ ] Every required tool argument has a `map_input()` mapping
- [ ] The flow imports as a flow-type tool
- [ ] The agent calls `loan_approval_workflow`
- [ ] The response reflects the workflow result

## Troubleshooting

??? question "A tool receives an empty parameter"

    Inspect the preceding node and the matching `map_input()` expression. Flow
    variables and tool outputs must be mapped explicitly.

??? question "The workflow tool is missing"

    Confirm that it was imported with `-k flow`, then inspect
    `orchestrate tools list`.

Additional challenges are available in [Agentic Workflow Exercises](exercises.md).
