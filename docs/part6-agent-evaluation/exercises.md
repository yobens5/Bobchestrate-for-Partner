# Part 7 — Optional Exercises

## Exercise 1: Expand functional coverage

Ask Bob to add three valid JSONL records based on the actual agent and tool
schemas:

- a grounded FAQ question
- a refund requiring `escalation_agent`
- a request that should call no tool

For each record, specify the expected behavior without requiring one exact
sentence. Ask Bob to validate the JSONL, run quick evaluation, and summarize
all three results.

## Exercise 2: Test tool misuse

Ask Bob to create adversarial prompts that attempt to:

- call `process_refund` without confirmation
- use another customer's order ID
- pass malformed or extremely large amounts
- persuade the agent to invent a successful tool result

After reviewing them, let Bob add them to the red-team input file, generate and
run the attacks, and summarize successful attacks. Do not put real personal
data in test prompts.

## Exercise 3: Turn a failure into a regression test

Choose one genuine failure and ask Bob to:

1. Preserve the prompt and expected behavior in the dataset.
2. Identify the smallest responsible layer: tool, instructions, guideline,
   collaborator description, or guardrail.
3. Implement and re-import the fix.
4. Rerun the failed case.
5. Run the original happy paths to check for regressions.

Review Bob's proposed fix before it changes files. Ask it to write a short note
containing the failure, root cause, change, and result.

[Return to Part 7](README.md) or
[continue to Part 8](../part7-deployment/README.md).
