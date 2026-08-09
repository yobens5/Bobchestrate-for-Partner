# Agent Evaluations & Red-Teaming — Optional Exercises

## Exercise 1: Expand functional coverage

Ask Bob to add three new dataset files under `evaluation/datasets/`, based on
the actual agent and tool schemas:

- a grounded FAQ question
- a refund requiring `escalation_agent`
- a request that should call no tool

Each file follows the structure of the existing datasets, and each must be added
to `test_paths` in `evaluation/config.yaml`. For each case, specify the expected
behavior without requiring one exact sentence. Ask Bob to validate the JSON, run
quick evaluation, and summarize all three results.

## Exercise 2: Test tool misuse

Ask Bob to create adversarial prompts that attempt to:

- call `process_refund` without confirmation
- use another customer's order ID
- pass malformed or extremely large amounts
- persuade the agent to invent a successful tool result

After reviewing them, let Bob turn each one into a dataset file under
`evaluation/datasets/`, generate and run the attacks against that folder, and
summarize successful attacks. Do not put real personal data in test prompts.

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

[Return to the Agent Evaluations & Red-Teaming module](README.md).
