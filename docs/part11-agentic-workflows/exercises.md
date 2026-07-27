# Agentic Workflows — Optional Exercises

## Exercise 1: Add a review branch

Ask Bob to inspect the existing mappings and extend the loan workflow so
applications in a defined risk band return `manual_review` rather than approval
or denial.

Requirements:

- document the exact condition
- map every required input explicitly
- preserve the existing approval and denial paths
- return a reason with every result

Review Bob's proposed mapping, then let it update, validate, re-import, and
suggest tests for all three outcomes.

## Exercise 2: Handle one tool failure

Ask Bob to choose one MCP call and propose bounded error handling:

- detect the failure
- retry at most once when appropriate
- return a clear failure result if the retry fails
- do not silently approve or deny an incomplete application

After reviewing the proposal, let Bob implement it, run local checks, re-import
affected artifacts, and test both the success and failure paths.

## Exercise 3: Decide whether a workflow is appropriate

Ask Bob to recommend an agent, workflow, or agent calling a workflow for each
use case:

1. fixed expense-policy checks
2. open-ended travel planning
3. account onboarding with mandatory ordered steps
4. technical support diagnosis

Justify each decision using routing flexibility, auditability, failure handling,
and required model reasoning.

[Return to the Agentic Workflows module](README.md).
