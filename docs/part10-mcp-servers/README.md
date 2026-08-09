# Optional Module: MCP Servers

**Outcome:** A local MCP toolkit exposes product-catalog tools to a native
Orchestrate agent.

An MCP server groups related tools behind a standard protocol. Orchestrate
imports the server as a toolkit; agents reference individual tools using the
`toolkit-name:tool-name` prefix.

## What we will implement

You will build a local MCP product-catalog server, import it as a toolkit, and
connect its prefixed search, details, inventory, and recommendation tools to a
native Orchestrate agent.

!!! tip "Confirm Bob's mode if you're starting fresh"
    Starting this module in a new window or after a break? Check the mode
    selector in the chat input box and confirm it still reads **WXO Agent
    Architect** before asking Bob anything. Reimport it from
    [Part 1 Step 7](../part1-setup/README.md#import-the-wxo-agent-architect-mode)
    if needed.

## 1. Ask Bob to build the starter

Ask Bob:

```text
Create a local Python MCP product-catalog server under toolkits/ with tools for
search, product details, inventory, and recommendations using small mock data.
Also create requirements.txt, direct smoke tests, and an ADK 2.14.0 MCP toolkit
YAML. Create agents/product-assistant-agent.yaml for an agent named product_assistant,
using the correctly prefixed tool names. Run local syntax and smoke tests,
validate the YAML files, and summarize the artifacts. Do not import yet.
```

Use these tested files as fallbacks or comparisons.

Save under `toolkits/`:

- <a href="product_catalog_server.py" download="product_catalog_server.py">product_catalog_server.py</a>
- <a href="product-catalog-toolkit.yaml" download="product-catalog-toolkit.yaml">product-catalog-toolkit.yaml</a>
- <a href="requirements.txt" download="requirements.txt">requirements.txt</a>
- <a href="simple_test.py" download="simple_test.py">simple_test.py</a>

Download <a href="product-assistant-agent.yaml" download="product-assistant-agent.yaml">product-assistant-agent.yaml</a>
and save it under `agents/`.

The server exposes:

- `search_products`
- `get_product_details`
- `check_inventory`
- `get_recommendations`

## 2. Test locally

Ask Bob:

```text
Install the declared toolkit dependencies in the existing .venv, inspect the
MCP server and smoke tests, then run the tests. Fix only confirmed local
failures and show me the result for each of the four tools.
```

Manual fallback:

```bash
python -m pip install -r toolkits/requirements.txt
python toolkits/simple_test.py
```

All four direct tests should complete before the toolkit is imported.

## 3. Import the toolkit

The toolkit YAML must contain:

```yaml
spec_version: v1
kind: mcp
name: product-catalog
description: Product catalog search, details, inventory, and recommendations
package_root: ./
command: python3 product_catalog_server.py
tools:
  - "*"
```

Ask Bob:

```text
Review toolkits/product-catalog-toolkit.yaml against the ADK 2.14.0 MCP toolkit
schema. If valid, import it into the active draft environment using the
existing .venv. Verify the toolkit and all four product-catalog-prefixed tools
are listed.
```

Manual import fallback:

```bash
orchestrate toolkits import \
  -f toolkits/product-catalog-toolkit.yaml

orchestrate toolkits list
orchestrate tools list
```

Confirm that the imported tools use the `product-catalog:` prefix.

## 4. Import the agent

The tested agent references:

```yaml
tools:
  - product-catalog:search_products
  - product-catalog:get_product_details
  - product-catalog:check_inventory
  - product-catalog:get_recommendations
```

Ask Bob:

```text
Show me examples of questions I can ask product_assistant to test product
search, details, inventory checks, recommendations, and missing-product handling.
```

Manual fallback:

```bash
orchestrate agents import -f agents/product-assistant-agent.yaml
orchestrate chat ask --agent-name product_assistant
```

Try:

```text
Show me available laptops, then check inventory for the best match.
```

The agent should call prefixed MCP tools and should explain when the small dummy
catalog does not contain an item.

## Checkpoint

- [ ] The local server tests pass
- [ ] The toolkit imports with `spec_version: v1`
- [ ] Four prefixed tools appear
- [ ] `product_assistant` imports successfully
- [ ] Chat invokes the appropriate MCP tools

## Security and external servers

Before importing a third-party MCP server:

- review its source, publisher, dependencies, and requested credentials
- pin a reviewed package version
- use Orchestrate connections rather than hard-coded secrets
- expose only the tools the agent needs
- test error handling and timeouts

Package names shown in general MCP examples are not automatically trusted
workshop dependencies.

## Troubleshooting

??? question "The server does not start"

    Run `python toolkits/simple_test.py`, confirm the `mcp` dependency is
    installed, and inspect the full import error.

??? question "The agent cannot call a tool"

    Compare `orchestrate tools list` with the exact prefixed names under
    `tools:` in the agent YAML. Do not place a native toolkit under
    `toolkits:`.
