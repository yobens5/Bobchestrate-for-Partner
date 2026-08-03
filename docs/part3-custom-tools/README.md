# Part 3: Adding Custom Tools

**Outcome:** `customer_support_agent` can check an order and process a simulated
refund.

A Python tool is a typed function decorated with `@tool`. Its name, docstring,
arguments, and return type tell the agent when and how to call it.

## 1. Create the tools

Ask Bob:

```text
Create two ADK 2.13.0 Python tools:

1. tools/check_order_status.py with a check_order_status(order_id: str) tool
2. tools/process_refund.py with a
   process_refund(order_id: str, reason: str, amount: float) tool

Use @tool, complete Google-style docstrings, type hints, input validation, and
structured dictionary responses. This is workshop code, so simulate the backend
locally. Also create requirements.txt for runtime dependencies.
```

Review Bob's output, or download the tested workshop files:

Click a file to download it to your browser's default download folder:

- <a href="check_order_status.py" download="check_order_status.py">check_order_status.py</a>
- <a href="process_refund.py" download="process_refund.py">process_refund.py</a>
- <a href="requirements.txt" download="requirements.txt">requirements.txt</a>

Place the Python files under `tools/` and `requirements.txt` at the project
root.

Ask Bob to review and test what it created:

```text
Review the two generated tools against the ADK documentation. Check their
schemas, docstrings, validation, and structured responses. Run a Python syntax
check and create or run small local tests for valid and invalid inputs. Fix only
confirmed problems and summarize the results.
```

Manual syntax check:

```bash
python -m py_compile tools/check_order_status.py tools/process_refund.py
```

## 2. Import the tools

Ask Bob:

```text
Using the existing .venv, import tools/check_order_status.py and
tools/process_refund.py into the active draft environment with the root
requirements.txt. Verify that both exact tool names appear in the tools list.
Show me the commands and results.
```

Manual fallback:

```bash
orchestrate tools import -k python \
  -f tools/check_order_status.py \
  -r requirements.txt

orchestrate tools import -k python \
  -f tools/process_refund.py \
  -r requirements.txt

orchestrate tools list
```

Confirm that `check_order_status` and `process_refund` appear.

## 3. Create the customer-support agent

Ask Bob:

```text
Create agents/customer-support-agent.yaml for a native agent named
customer_support_agent. Give it the imported check_order_status and
process_refund tools. It must collect missing inputs, confirm refund details
before processing, explain validation errors, and never invent backend data.
Use the project model and ADK 2.13.0 schema. Review the YAML with me, then import
it into draft and verify it is listed.
```

The tested fallback is
<a href="customer-support-agent.yaml" download="customer-support-agent.yaml">customer-support-agent.yaml</a>.
If importing manually:

```bash
orchestrate agents import -f agents/customer-support-agent.yaml
```

## 4. Test with Bob

Ask Bob:

```text
Inspect the customer_support_agent instructions and tool schemas. Suggest a
compact test set covering a valid order lookup, an invalid ID, a refund with
missing details, a confirmed refund, and an unrelated request. Start a chat
with the agent so I can run the prompts, and tell me which tool calls and
clarifying questions to expect.
```

Manual chat fallback:

```bash
orchestrate chat ask --agent-name customer_support_agent
```

At minimum, try `What is the status of order ORD-12345?` and a refund request
with order ID, reason, and amount. The agent should call the correct tool and
should not invent missing inputs.

!!! tip "Stuck?"
    Copy the tested files for this part from the
    [reference solution](../solution/README.md#part-3-custom-tools) and import
    them, then continue.

## Checkpoint

- [ ] Both Python files pass the syntax check
- [ ] Both tools appear in `orchestrate tools list`
- [ ] The agent imports successfully
- [ ] Order and refund prompts call the correct tools
- [ ] Bob proposed normal, edge, and error-path tests

## Troubleshooting

??? question "The agent answers without calling a tool"

    Check that the exact imported tool names appear under `tools:`. Make the
    tool docstring and agent instructions explicit about when the tool applies.

??? question "Python-tool import asks for requirements"

    Pass the root `requirements.txt` with `-r`, even when the example uses only
    the standard library.

Use the [Part 3 exercises](exercises.md) for additional practice.

[Continue to Part 4: Knowledge & Collaborators →](../part4-knowledge/README.md)
