# Optional Module: MCP Servers

**Outcome:** A local MCP toolkit exposes product-catalog tools to a native
Orchestrate agent.

An MCP server groups related tools behind a standard protocol. Orchestrate
imports the server as a toolkit; agents reference individual tools using the
`toolkit-name:tool-name` prefix.

## 1. Download the starter

Save under `toolkits/`:

- [`product_catalog_server.py`](product_catalog_server.py)
- [`product-catalog-toolkit.yaml`](product-catalog-toolkit.yaml)
- [`requirements.txt`](requirements.txt)
- [`simple_test.py`](simple_test.py)

Save [`product-assistant-agent.yaml`](product-assistant-agent.yaml) under
`agents/`.

The server exposes:

- `search_products`
- `get_product_details`
- `check_inventory`
- `get_recommendations`

## 2. Test locally

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

Import and verify:

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

Import and test:

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
