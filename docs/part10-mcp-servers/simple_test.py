"""Direct smoke tests for the product catalog MCP tool handler."""

import asyncio
import json

from product_catalog_server import call_tool, list_tools


async def test_all_tools() -> None:
    """Exercise every declared MCP tool with the bundled catalog."""
    declared = {tool.name for tool in await list_tools()}
    expected = {
        "search_products",
        "get_product_details",
        "check_inventory",
        "get_recommendations",
    }
    assert declared == expected

    search = await call_tool("search_products", {"query": "laptop"})
    search_data = json.loads(search[0].text)
    assert search_data["count"] == 1
    assert search_data["results"][0]["id"] == "LAPTOP-001"

    details = await call_tool(
        "get_product_details", {"product_id": "LAPTOP-001"}
    )
    assert json.loads(details[0].text)["name"] == "ProBook 15"

    inventory = await call_tool(
        "check_inventory", {"product_id": "PHONE-001"}
    )
    inventory_data = json.loads(inventory[0].text)
    assert inventory_data["in_stock"] is True
    assert inventory_data["quantity"] == 25

    recommendations = await call_tool(
        "get_recommendations", {"category": "Audio", "max_results": 3}
    )
    recommendation_data = json.loads(recommendations[0].text)
    assert recommendation_data["count"] == 1
    assert recommendation_data["recommendations"][0]["id"] == "HEADPHONES-001"

    missing = await call_tool(
        "get_product_details", {"product_id": "MISSING-001"}
    )
    assert "error" in json.loads(missing[0].text)

    print("Product catalog MCP smoke tests passed.")


if __name__ == "__main__":
    asyncio.run(test_all_tools())
