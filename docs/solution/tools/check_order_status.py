from typing import Dict, Any

from ibm_watsonx_orchestrate.agent_builder.tools import tool

_MOCK_ORDERS: Dict[str, Dict[str, Any]] = {
    "ORD-1001": {
        "status": "Shipped",
        "items": [
            {"name": "Wireless Keyboard", "quantity": 1, "price": 49.99},
            {"name": "USB-C Hub", "quantity": 2, "price": 29.99},
        ],
        "delivery_date": "2025-08-10",
    },
    "ORD-1002": {
        "status": "Processing",
        "items": [
            {"name": "Laptop Stand", "quantity": 1, "price": 39.99},
        ],
        "delivery_date": "2025-08-15",
    },
    "ORD-1003": {
        "status": "Delivered",
        "items": [
            {"name": "Mechanical Keyboard", "quantity": 1, "price": 129.99},
            {"name": "Mouse Pad XL", "quantity": 1, "price": 19.99},
            {"name": "Cable Management Kit", "quantity": 1, "price": 14.99},
        ],
        "delivery_date": "2025-07-28",
    },
}


@tool
def check_order_status(order_id: str) -> Dict[str, Any]:
    """Retrieves the current status and details for a given order.

    Args:
        order_id (str): The unique order identifier (for example, ORD-1001).

    Returns:
        Dict[str, Any]: A dictionary with the following keys:
            - status (str): "success" or "error".
            - order_id (str): The queried order identifier.
            - order_status (str): Current fulfilment status of the order.
            - items (list): List of ordered items, each containing name,
              quantity, and price.
            - delivery_date (str): Estimated or actual delivery date in
              YYYY-MM-DD format.
            - message (str): Human-readable summary, or an error description
              when status is "error".
    """
    try:
        order = _MOCK_ORDERS.get(order_id.strip().upper())

        if order is None:
            return {
                "status": "error",
                "order_id": order_id,
                "message": f"Order '{order_id}' not found. Please check the order ID and try again.",
            }

        return {
            "status": "success",
            "order_id": order_id,
            "order_status": order["status"],
            "items": order["items"],
            "delivery_date": order["delivery_date"],
            "message": f"Order {order_id} is currently {order['status']} and is expected to be delivered on {order['delivery_date']}.",
        }
    except Exception as exc:
        return {
            "status": "error",
            "order_id": order_id,
            "message": f"An unexpected error occurred: {str(exc)}",
        }
