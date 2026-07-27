# Part 4 — Optional Exercises

Complete these after both customer-support tools work.

## Exercise 1: Add a cancellation tool

Ask Bob to create `tools/cancel_order.py` with:

```python
cancel_order(order_id: str, reason: str) -> dict
```

Requirements:

- use `@tool`, type hints, and a complete docstring
- accept only order IDs in the `ORD-12345` format
- require a non-empty reason
- return a structured success or validation-error dictionary
- clearly state that the operation is simulated

Ask Bob to add local tests, run them, import the validated tool, attach it to
`customer_support_agent`, re-import the agent, and suggest valid and invalid
chat prompts. Manual import fallback:

```bash
orchestrate tools import -k python \
  -f tools/cancel_order.py \
  -r requirements.txt
```

## Exercise 2: Make refund behavior safer

Update `process_refund` so it:

- rejects booleans as numeric amounts
- normalizes surrounding whitespace
- never returns a successful refund above the agent's authority
- returns stable error fields that the agent can explain

Ask Bob to write local unit tests before changing the implementation. After you
review the tests, let Bob implement the change, run the tests, re-import the
tool, and suggest refund regression prompts.

## Exercise 3: Improve tool selection

Ask Bob to inspect the two tool schemas and create three prompts:

1. clearly requires `check_order_status`
2. clearly requires `process_refund`
3. should not call either tool

If the agent selects the wrong tool, ask Bob to diagnose the smallest relevant
docstring or instruction change. Review it before Bob updates, validates,
re-imports, and records the prompt as a Part 7 evaluation case.

[Return to Part 4](README.md) or
[continue to Part 5](../part4-knowledge/README.md).
