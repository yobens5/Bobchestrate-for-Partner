# Agentic Workflows — Optional Exercises

## Exercise 1: Add a review branch

Extend the loan workflow so applications in a defined risk band return
`manual_review` rather than approval or denial.

Requirements:

- document the exact condition
- map every required input explicitly
- preserve the existing approval and denial paths
- return a reason with every result

## Exercise 2: Handle one tool failure

Choose one MCP call and add bounded error handling:

- detect the failure
- retry at most once when appropriate
- return a clear failure result if the retry fails
- do not silently approve or deny an incomplete application

Test both the success and failure paths.

## Exercise 3: Decide whether a workflow is appropriate

For each use case, choose an agent, workflow, or agent calling a workflow:

1. fixed expense-policy checks
2. open-ended travel planning
3. account onboarding with mandatory ordered steps
4. technical support diagnosis

Justify each decision using routing flexibility, auditability, failure handling,
and required model reasoning.

[Return to the Agentic Workflows module](README.md).
