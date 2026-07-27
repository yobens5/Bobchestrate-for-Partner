import uuid
from datetime import datetime, timedelta, timezone
from typing import Dict, Any, List

from ibm_watsonx_orchestrate.agent_builder.tools import tool

# Valid refund reasons accepted by the system
_VALID_REASONS: List[str] = [
    "defective_product",
    "wrong_item",
    "not_as_described",
    "damaged_in_shipping",
    "changed_mind",
    "duplicate_order",
]

# Mock order registry — mirrors check_order_status.py
# Maps order_id -> (order_total, eligible_for_refund)
# Orders in "Processing" state cannot be refunded (must be cancelled instead).
_ORDER_REGISTRY: Dict[str, Dict[str, Any]] = {
    "ORD-1001": {"total": 109.97, "eligible": True,  "order_status": "Shipped"},
    "ORD-1002": {"total":  39.99, "eligible": False, "order_status": "Processing"},
    "ORD-1003": {"total": 164.97, "eligible": True,  "order_status": "Delivered"},
}

_MAX_REFUND_DAYS: int = 30  # refund window in days


@tool
def process_refund(order_id: str, reason: str, amount: float) -> Dict[str, Any]:
    """Validates and processes a refund request for a given order.

    Performs the following checks before approving:
    - The order exists in the system.
    - The order is in a refund-eligible state (Shipped or Delivered).
    - The refund reason is one of the accepted values.
    - The requested amount is positive and does not exceed the order total.

    Args:
        order_id (str): The unique order identifier (for example, ORD-1001).
        reason (str): The reason for the refund. Must be one of:
            defective_product, wrong_item, not_as_described,
            damaged_in_shipping, changed_mind, duplicate_order.
        amount (float): The refund amount in USD. Must be greater than 0
            and no more than the order total.

    Returns:
        Dict[str, Any]: A dictionary with the following keys:
            - status (str): "success" or "error".
            - order_id (str): The order identifier supplied in the request.
            - refund_id (str): Unique refund reference (present on success).
            - amount (float): Approved refund amount (present on success).
            - reason (str): Validated refund reason (present on success).
            - estimated_credit_date (str): Expected credit date in YYYY-MM-DD
              format (present on success).
            - message (str): Human-readable outcome or error description.
    """
    try:
        order_id = order_id.strip().upper()

        # ── Validate order exists ──────────────────────────────────────────
        order = _ORDER_REGISTRY.get(order_id)
        if order is None:
            return {
                "status": "error",
                "order_id": order_id,
                "message": f"Order '{order_id}' not found. Please check the order ID.",
            }

        # ── Validate order eligibility ─────────────────────────────────────
        if not order["eligible"]:
            return {
                "status": "error",
                "order_id": order_id,
                "message": (
                    f"Order '{order_id}' has status '{order['order_status']}' "
                    "and is not eligible for a refund. "
                    "Orders in Processing must be cancelled instead."
                ),
            }

        # ── Validate reason ────────────────────────────────────────────────
        reason_normalised = reason.strip().lower().replace(" ", "_")
        if reason_normalised not in _VALID_REASONS:
            return {
                "status": "error",
                "order_id": order_id,
                "message": (
                    f"Invalid refund reason '{reason}'. "
                    f"Accepted reasons: {', '.join(_VALID_REASONS)}."
                ),
            }

        # ── Validate amount ────────────────────────────────────────────────
        if amount <= 0:
            return {
                "status": "error",
                "order_id": order_id,
                "message": "Refund amount must be greater than $0.00.",
            }

        order_total = order["total"]
        if amount > order_total:
            return {
                "status": "error",
                "order_id": order_id,
                "message": (
                    f"Requested refund of ${amount:.2f} exceeds the order total "
                    f"of ${order_total:.2f}."
                ),
            }

        # ── Approve refund ─────────────────────────────────────────────────
        refund_id = f"REF-{uuid.uuid4().hex[:8].upper()}"
        credit_date = (datetime.now(timezone.utc) + timedelta(days=_MAX_REFUND_DAYS)).strftime(
            "%Y-%m-%d"
        )

        return {
            "status": "success",
            "order_id": order_id,
            "refund_id": refund_id,
            "amount": round(amount, 2),
            "reason": reason_normalised,
            "estimated_credit_date": credit_date,
            "message": (
                f"Refund of ${amount:.2f} for order {order_id} has been approved "
                f"(ref: {refund_id}). The credit will be applied by {credit_date}."
            ),
        }

    except Exception as exc:
        return {
            "status": "error",
            "order_id": order_id,
            "message": f"An unexpected error occurred: {str(exc)}",
        }
