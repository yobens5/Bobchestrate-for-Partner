# watsonx Orchestrate Development Rule

## 0. Where knowledge lives (read this first)

This file carries **project conventions and known pitfalls** — the things retrieval won't save you from because you won't think to look them up. It is **not** API reference.

- For schemas, CLI syntax, YAML formats, flow node types, eval configs, and code examples: **search the `watsonx-orchestrate-adk-docs` MCP server first** (`SearchIbmWatsonxOrchestrateAdk` tool). Do this *before* writing any agent YAML, tool, flow, knowledge base, plugin, or evaluation config — not only when uncertain.
- To inspect the live platform (existing tools, agents, imports): use the `watsonx-orchestrate-adk` MCP server.
- **If the docs MCP contradicts this file, the MCP wins.** The docs track the current ADK release; this file may lag.

## 1. Project Structure

```
agents/          # Agent YAML configs
tools/           # Python tools and agentic workflows (flows)
toolkits/        # MCP and Python toolkit specs
knowledge_bases/ # KB configs + document files
models/          # LLM model configs
connections/     # API connection configs
channels/        # Channel configs (Slack, Teams, Web)
plugins/         # Guardrail plugins
evaluation/      # Test datasets and eval configs
import-all.sh    # Deploy everything
requirements.txt # Python deps — NEVER include ibm-watsonx-orchestrate
.env.example     # Env template — never commit .env
```

## 2. Environment & Auth

Pick ONE auth method in `.env` (see the docs MCP for full templates):

- **SaaS / Trial:** `WO_DEVELOPER_EDITION_SOURCE=orchestrate` + `WO_INSTANCE` + `WO_API_KEY`
- **myIBM (on-prem/purchased):** `WO_DEVELOPER_EDITION_SOURCE=myibm` + `WO_ENTITLEMENT_KEY` + `GROQ_API_KEY` + `WATSONX_APIKEY` + `WATSONX_SPACE_ID`
- **Custom registry:** `WO_DEVELOPER_EDITION_SOURCE=custom` + `REGISTRY_URL` / `REGISTRY_USERNAME` / `REGISTRY_PASSWORD`

**NEVER** use `ORCHESTRATE_API_KEY`, `ORCHESTRATE_ENVIRONMENT`, or `TIMEOUT_SECONDS` — these are plausible-looking names that do not exist in the ADK.

## 3. Core Conventions

1. Agent, tool, and KB names: **`snake_case` only** — `customer_support_agent`, never `customerSupportAgent` or `customer support agent`
2. Default LLM: `groq/openai/gpt-oss-120b`
3. Every tool parameter and return value needs **explicit type hints** — `Dict[str, Any]` not `dict`, `List[str]` not `list`
4. Google-style docstrings with types in parens (`param (str):`); the docstring return type must match the signature exactly
5. `@tool` with **no parentheses** for plain tools; tools return status dicts (`{"status": "success"|"error", ...}`) and catch their own exceptions
6. Use `--safe` on imports to prevent accidental overwrites; never commit `.env` or credentials — use connections
7. Use **flows (agentic workflows)** for deterministic sequences, **agents** for dynamic reasoning, **Python toolkits** for high-frequency related tools
8. Debug with `orchestrate observability traces search --last 1h`

## 4. Known Pitfalls

These are mistakes a model makes *confidently* — check this list before importing anything.

### Agent YAML
- In `guidelines`, the `tool:` field must name a **tool** — never a collaborator agent. Hand-offs to collaborators are expressed in the `action:` text only.
- `knowledge_base:` entries must exactly match the imported KB name.
- Reference plugins in agent YAML **only after** the plugin files are imported (`orchestrate tools import` first, then attach).

### Python tools & testing
- The `@tool` decorator changes return behaviour — **never import decorated functions in tests**. Copy the business logic into the test file without the decorator.
- Python toolkit tools share one persistent process — they must be **thread-safe** (no global mutable state).

### Flows (agentic workflows)
- **Always call `map_input`** on every node input — missing mappings cause "required property" errors at runtime.
- Tool names inside flows **must include the toolkit prefix**: `"loan-processing:check_credit_score"`, not `"check_credit_score"`.
- Import flows as flow-kind tools (`orchestrate tools import -k flow ...`); test through an agent that uses the flow — `compile_deploy()` is local-only.

### MCP toolkits
- Agents reference MCP/toolkit tools as `toolkit-name:tool-name` — always prefixed, in both `tools:` and `guidelines`.

### Knowledge bases
- Documents must be **external files** referenced by `path:` — inline content is not supported.
- The status command is `orchestrate knowledge-bases status --name X` — there is **no `get`** subcommand.

### Guardrail plugins
- Decorator must be `@tool(description="...", kind=PythonToolKind.AGENTPREINVOKE)` (or `AGENTPOSTINVOKE`). Bare `@tool` and `@plugin` are both wrong for plugins.

### Evaluation
- Config uses `test_paths:` — **not** `dataset_path:`.
- Do **not** configure `metrics:` — they are auto-computed.
- Do **not** put `tools_path` in the config — pass it with the `-t` CLI flag.

### Dependencies
- **Never** include `ibm-watsonx-orchestrate` in `requirements.txt` — the runtime provides it.
