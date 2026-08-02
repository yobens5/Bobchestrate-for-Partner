# Part 2: Using Custom Rules with Bob IDE

**Outcome:** Bob follows the workshop's watsonx Orchestrate conventions.

Custom rules store project-specific decisions that general documentation cannot
know: folder layout, naming, tested defaults, and known pitfalls. Current CLI
syntax and schemas should still come from the
`watsonx-orchestrate-adk-docs` MCP server.

## 1. Create the rules folder

=== "Windows PowerShell"

    ```powershell
    New-Item -ItemType Directory -Force -Path .bob\rules
    ```

=== "macOS"

    ```bash
    mkdir -p .bob/rules
    ```

## 2. Install the workshop rule

<a href="wxo-dev-rule-enhanced.txt" download="wxo-dev-rule-enhanced.md">Download the workshop rule file</a> and save it as:

```text
.bob/rules/wxo-dev-rule-enhanced.md
```

The rule tells Bob to:

- search the ADK documentation MCP before generating version-sensitive syntax
- place agents, tools, knowledge bases, and toolkits in consistent folders
- use `snake_case` agent names
- use the workshop model `groq/openai/gpt-oss-120b`
- avoid common collaborator, toolkit-prefix, flow-mapping, and plugin mistakes

The rule is intentionally short. Copying the full CLI or YAML reference into a
rule would make it stale and harder to maintain.

## 3. Verify the rule

Start a new Bob task in **WXO Agent Architect** mode and ask:

```text
Read the custom rules in this project. Summarize the watsonx Orchestrate
folder, naming, model, and documentation-lookup conventions you will follow.
Do not create or change files.
```

Bob should mention:

- `.bob/rules/`
- `agents/`, `tools/`, `knowledge_bases/`, and `toolkits/`
- `snake_case` agent names
- the default workshop model
- using the ADK documentation MCP for current syntax

## 4. Test a design decision

Ask Bob:

```text
Without creating files, propose the path and minimal YAML fields for a native
agent named test_rules_agent. Cite the ADK documentation you used.
```

Check that the proposed path is under `agents/` and that the YAML includes
`spec_version`, `kind`, `name`, `description`, and the workshop `llm`.

!!! tip "Stuck?"
    Copy the tested files for this part from the
    [reference solution](../solution/README.md#part-2-bob-custom-rules), then
    continue.

## Troubleshooting

If Bob does not see the rule:

1. Confirm the file ends in `.md` and is under `.bob/rules/`.
2. Start a new Bob task or reload the IDE window.
3. Ask Bob to list the rule files it can read.

If two rules conflict, keep the more project-specific instruction and remove
duplicated reference material. The ADK documentation MCP is authoritative for
ADK syntax.

[Continue to Part 3: Building Your First Agent →](../part2-first-agent/README.md)
