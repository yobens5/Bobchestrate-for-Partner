# Part 2b: Using Custom Rules with Bob IDE

**Duration:** 10 minutes  
**Objective:** Learn how to configure Bob IDE with custom development rules for watsonx Orchestrate projects

## What You'll Learn

- How to create custom rules for Bob IDE
- How to configure Bob to follow project-specific conventions
- How to leverage custom rules for consistent development practices
- How to use the watsonx Orchestrate development rule

## Why Custom Rules Matter

Bob IDE can be configured with custom rules that guide its behavior when working on your projects. These rules help Bob:

- Follow project-specific conventions and patterns
- Use the correct folder structure for different artifact types
- Apply best practices automatically
- Leverage the right tools and MCP servers for your technology stack

## Understanding Bob's Custom Rules

Bob IDE supports custom rules through `.md` files that define project-specific guidelines. These rules are automatically applied when Bob works in your project directory.

For more information, see the [official Bob documentation on custom rules](https://bob.ibm.com/docs/ide/configuration/rules).

### Rule File Location

Custom rules should be placed in your project's `.bob/` directory:
```
your-project/
├── .bob/
│   └── rules/
│       └── your-rule.md
├── agents/
├── tools/
└── ...
```

## Step 1: Understanding the watsonx Orchestrate Development Rule

Let's examine the watsonx Orchestrate development rule that helps Bob work effectively with ADK projects.

### Design Principle: Rules Carry What Retrieval Can't

Your project already has the `watsonx-orchestrate-adk-docs` MCP server configured (see `.bob/mcp.json`), which gives Bob searchable access to the full, always-current ADK documentation. So the rule file should **not** duplicate reference material — CLI syntax, YAML schemas, and code examples belong to the docs MCP, which never goes stale.

What the rule file *should* carry is what retrieval can't provide:

- **Your project's conventions** — folder layout, naming, defaults the docs can't know
- **A lookup policy** — telling Bob to search the docs MCP *before* writing ADK artifacts
- **Known pitfalls** — mistakes an AI makes *confidently* (wrong env var names, wrong field usage). Bob will never search the docs for something it isn't uncertain about, so these must be in-context.

### Rule Structure

A good custom rule includes:

1. **Knowledge policy**: Where to look things up, and what wins on conflict
2. **Project Structure**: Folder conventions and organization
3. **Core Conventions**: Naming, defaults, and key patterns
4. **Known Pitfalls**: Specific mistakes to avoid — the "never do X" list

### Example: watsonx Orchestrate Development Rule

Here's a simple example for a development rule for watsonx Orchestrate projects:

```markdown
## watsonx Orchestrate Development Rule

When working with IBM watsonx Orchestrate or watsonx Orchestrate ADK projects:

1. **Project Structure and folders**: Follow ADK conventions when creating and saving artefacts:
   - tools/ for flows and Python tools
   - agents/ for YAML configurations
   - knowledge_bases/ for knowledge bases
   - models/ for LLM configurations
   - toolkits/ for MCP toolkits
   - import-all.sh for deployment
   - README.md with architecture + workflow diagrams

2. **Key Patterns**:
   - Use @flow decorator for flows
   - Use @tool decorator for Python tools
   - Include inline KVP schemas for document processing
   - Create native agents for document handling
   - Preferably use Command Line Interface to import the agents and tools

3. **MCP Server Integration**:
   - Use `watsonx-orchestrate-adk-docs` MCP server to search IBM watson Orchestrate ADK documentation
   - Leverage MCP tools for finding API references, code examples, and implementation guides
   - Query the knowledge base when uncertain about ADK features or best practices
```

## Step 2: Setting Up Custom Rules in Your Environment

### Download the Enhanced Rule File

1. **Create the rules directory structure:**
   ```bash
   # macOS/Linux
   mkdir -p .bob/rules
   ```
   ```powershell
   # Windows PowerShell
   New-Item -ItemType Directory -Force -Path .bob\rules
   ```

2. **Download the enhanced rule file:**
   
   Download more comprehensive <a href="https://github.com/yobens5/Bobchestrate-for-Partner/blob/main/docs/part2b-bob-custom-rules/wxo-dev-rule-enhanced.md" target="_blank">wxo-dev-rule-enhanced.md</a> file from the workshop repository.
   
   Click the link above to view the file, then click the "Download raw file" button in GitHub to download it and save it to your local machine.

3. **Place the file in your rules directory:**
   ```bash
   # macOS/Linux — move from Downloads folder
   mv ~/Downloads/wxo-dev-rule-enhanced.md .bob/rules/
   ```
   ```powershell
   # Windows PowerShell — move from Downloads folder
   Move-Item "$env:USERPROFILE\Downloads\wxo-dev-rule-enhanced.md" .bob\rules\
   ```

### What's in the Enhanced Rule File?

The enhanced rule file is deliberately compact (~80 lines) and works *together with* the docs MCP server rather than duplicating it:

- **Knowledge policy** - Search the docs MCP first for schemas, CLI syntax, and examples; the MCP wins on any conflict with the rule
- **Project Structure** - Complete directory organization for ADK projects
- **Environment & Auth** - The three valid auth methods, plus env var names that look right but don't exist
- **Core Conventions** - `snake_case` naming, default LLM, type hints, docstring format, when to use flows vs agents vs toolkits
- **Known Pitfalls** - The mistakes an AI makes confidently: collaborators in the `tool:` field, missing `map_input`, unprefixed toolkit tool names, wrong plugin decorators, invalid eval config keys, and more

Everything else — full CLI command reference, YAML schemas, workflow node types, code examples — is retrieved fresh from the docs MCP when needed, so it never goes stale as the ADK evolves.

## Step 3: Verify Bob Recognizes Your Rules

Ask Bob to confirm it's using your custom rules:

```
Bob, what custom rules are you following for this watsonx Orchestrate project?
```

Bob should acknowledge the watsonx Orchestrate development rule and explain how it will apply the conventions.


## Step 4: Test the Custom Rules

Let's test that Bob follows the custom rules by asking it to create a new agent:

```
Bob, create a new agent called "test-rules-agent" that demonstrates you're following the watsonx Orchestrate development conventions.
```
>NOTE: Bob might work for a while. Be patient 😇 and let it create the agent and all the other files. Keep your eye on the chat as well, since Bob might ask you to confirm some of the actions.

**What to observe:**
- ✅ Bob should save the agent YAML in the `agents/` directory
- ✅ Bob should use proper ADK conventions in the agent specification
- ✅ Bob should reference the MCP server documentation when needed

## Step 5: Creating Your Own Custom Rules

You can create additional custom rules for your specific needs. Here's a template:

```markdown
## [Your Rule Name]

When working with [technology/framework]:

1. **Project Structure**:
   - [folder1]/ for [purpose]
   - [folder2]/ for [purpose]
   - [file] for [purpose]

2. **Key Patterns**:
   - Use [pattern] for [use case]
   - Follow [convention] when [scenario]
   - Prefer [approach] over [alternative]

3. **Tool Integration**:
   - Use [tool/server] for [purpose]
   - Leverage [feature] when [condition]
   - Query [resource] for [information]

4. **Best Practices**:
   - Always [practice]
   - Never [anti-pattern]
   - Consider [guideline] when [situation]
```

## Benefits of Custom Rules

### Consistency
- All team members (and Bob) follow the same conventions
- Reduces code review friction
- Maintains project structure integrity

### Efficiency
- Bob automatically applies best practices
- Less time explaining project conventions
- Faster onboarding for new developers

### Quality
- Enforces architectural patterns
- Prevents common mistakes
- Leverages project-specific tools correctly

## Common Use Cases for Custom Rules

1. **Framework-Specific Conventions**
   - React component structure
   - Django app organization
   - FastAPI project layout

2. **Company Standards**
   - Naming conventions
   - Documentation requirements
   - Testing patterns

3. **Technology Stack Integration**
   - Database access patterns
   - API design guidelines
   - Deployment procedures

4. **Domain-Specific Patterns**
   - Healthcare compliance requirements
   - Financial data handling
   - E-commerce workflows

## Tips for Writing Effective Custom Rules

### Do's ✅
- **Be specific**: "Use `@tool` decorator for Python tools" vs "Use decorators"
- **Provide context**: Explain when and why rules apply
- **Include examples**: Show concrete implementations
- **Reference tools**: Mention specific MCP servers or utilities
- **Keep it concise**: Focus on essential guidelines

### Don'ts ❌
- **Don't be vague**: Avoid "follow best practices" without specifics
- **Don't overload**: Too many rules become hard to follow
- **Don't duplicate retrieval**: If an MCP server can serve it fresh (API reference, CLI syntax, schemas), point to the server instead of copying it into the rule — copies go stale, and stale in-context text outcompetes fresh search results
- **Don't contradict**: Ensure rules work together harmoniously
- **Don't forget updates**: Keep rules current with project evolution

## Troubleshooting

### Bob Isn't Following My Rules

**Check:**
1. Rule file is in `.bob/rules/` directory
2. File has `.md` extension
3. Rule syntax is valid markdown
4. Bob has been restarted or refreshed

**Solution:**
```
Bob, please reload your custom rules and confirm you can see the watsonx Orchestrate development rule.
```

### Rules Conflict with Each Other

**Solution:**
- Review all rule files in `.bob/rules/`
- Consolidate overlapping rules
- Establish clear priority order
- Remove or update conflicting guidelines

### Bob Misinterprets a Rule

**Solution:**
- Make the rule more specific
- Add examples to clarify intent
- Break complex rules into simpler steps
- Test with Bob and iterate

## Key Takeaways

✅ Custom rules guide Bob's behavior in your projects  
✅ Rules should be specific, contextual, and actionable  
✅ The `.bob/rules/` directory contains project-specific guidelines  
✅ watsonx Orchestrate projects benefit from ADK-specific rules  
✅ Good rules improve consistency, efficiency, and code quality  

## Next Steps

Now that you understand how to configure Bob with custom rules, you're ready to add more powerful capabilities to your agents!

Continue to [Part 3: Adding Custom Tools](../part3-custom-tools/README.md) →

## Additional Resources

- [Bob IDE Documentation](https://docs.bob-ide.com/custom-rules)
- [watsonx Orchestrate ADK Best Practices](https://developer.watson-orchestrate.ibm.com/getting_started/best_practices)
- [Project Structure Guidelines](https://developer.watson-orchestrate.ibm.com/getting_started/project_structure)

---

**💡 Pro Tip:** Start with a simple rule file and expand it as you discover patterns in your project. Let Bob help you refine the rules based on real usage!