# Part 4: Adding Custom Tools

**Outcome:** `customer_support_agent` can check an order and process a simulated
refund.

A Python tool is a typed function decorated with `@tool`. Its name, docstring,
arguments, and return type tell the agent when and how to call it.

## 1. Create the tools

Ask Bob:

```text
Create two ADK 2.12.0 Python tools:

1. tools/check_order_status.py with a check_order_status(order_id: str) tool
2. tools/process_refund.py with a
   process_refund(order_id: str, reason: str, amount: float) tool

Use @tool, complete Google-style docstrings, type hints, input validation, and
structured dictionary responses. This is workshop code, so simulate the backend
locally. Also create requirements.txt for runtime dependencies.
```

Review Bob's output, or download the tested workshop files:

- [`check_order_status.py`](check_order_status.py)
- [`process_refund.py`](process_refund.py)
- [`requirements.txt`](requirements.txt)

Place the Python files under `tools/` and `requirements.txt` at the project
root.

Syntax check:

```bash
python -m py_compile tools/check_order_status.py tools/process_refund.py
```

## 2. Import the tools

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

Create `agents/customer-support-agent.yaml`:

```yaml
spec_version: v1
kind: native
name: customer_support_agent
description: Checks order status and handles simulated refund requests
llm: groq/openai/gpt-oss-120b
instructions: |
  You are a concise and empathetic customer-support assistant.

  For order status:
  1. Ask for the order ID if it is missing.
  2. Call check_order_status.
  3. Explain the returned status clearly.

  For refunds:
  1. Collect the order ID, reason, and amount.
  2. Confirm the details with the customer.
  3. Call process_refund only after confirmation.

  Never invent order or refund data. Explain validation errors and ask the
  customer to correct the input.
tools:
  - check_order_status
  - process_refund
```

Import and test:

```bash
orchestrate agents import -f agents/customer-support-agent.yaml
orchestrate chat ask --agent-name customer_support_agent
```

Try:

```text
What is the status of order ORD-12345?
```

Then:

```text
I need a refund for order ORD-12345 because the product arrived damaged.
The amount is $99.99.
```

The agent should call the correct tool and should not invent missing inputs.

## Checkpoint

- [ ] Both Python files pass the syntax check
- [ ] Both tools appear in `orchestrate tools list`
- [ ] The agent imports successfully
- [ ] Order and refund prompts call the correct tools

## Troubleshooting

??? question "The agent answers without calling a tool"

    Check that the exact imported tool names appear under `tools:`. Make the
    tool docstring and agent instructions explicit about when the tool applies.

??? question "Python-tool import asks for requirements"

    Pass the root `requirements.txt` with `-r`, even when the example uses only
    the standard library.

Use the [Part 4 exercises](exercises.md) for additional practice.

[Continue to Part 5: Knowledge & Collaborators →](../part4-knowledge/README.md)
