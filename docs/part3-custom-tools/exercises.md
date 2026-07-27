# Part 4 — Optional Exercises

Complete these after both customer-support tools work.

## Exercise 1: Add a cancellation tool

Create `tools/cancel_order.py` with:

```python
cancel_order(order_id: str, reason: str) -> dict
```

Requirements:

- use `@tool`, type hints, and a complete docstring
- accept only order IDs in the `ORD-12345` format
- require a non-empty reason
- return a structured success or validation-error dictionary
- clearly state that the operation is simulated

Import it:

```bash
orchestrate tools import -k python \
  -f tools/cancel_order.py \
  -r requirements.txt
```

Attach it to `customer_support_agent` and test a valid and invalid order ID.

## Exercise 2: Make refund behavior safer

Update `process_refund` so it:

- rejects booleans as numeric amounts
- normalizes surrounding whitespace
- never returns a successful refund above the agent's authority
- returns stable error fields that the agent can explain

Ask Bob to write local unit tests before changing the implementation. Run the
tests, re-import the tool, and repeat the refund chat scenario.

## Exercise 3: Improve tool selection

Create three prompts:

1. clearly requires `check_order_status`
2. clearly requires `process_refund`
3. should not call either tool

If the agent selects the wrong tool, adjust only the relevant docstring or agent
instruction. Record the prompt and expected behavior for Part 7 evaluation.

[Return to Part 4](README.md) or
[continue to Part 5](../part4-knowledge/README.md).
