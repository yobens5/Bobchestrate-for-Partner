"""
Pre-invoke guardrail plugin for the customer support agent.

Detects and blocks requests that attempt unauthorized data access, including:
  - Requests for other customers' account or order data
  - Prompts that try to dump all records, list all users, or enumerate the database
  - SQL/NoSQL injection patterns embedded in natural language
  - Attempts to access internal system info (configs, env vars, credentials, source code)
  - Prompt-injection keywords designed to override system instructions

When a violation is detected the plugin sets continue_processing=False and
replaces the message text with a safe refusal string so the agent never sees
the original payload.
"""

import re
from ibm_watsonx_orchestrate.agent_builder.tools import tool
from ibm_watsonx_orchestrate.agent_builder.tools.types import (
    AgentPreInvokePayload,
    AgentPreInvokeResult,
    PythonToolKind,
    PluginContext,
)

# ---------------------------------------------------------------------------
# Detection patterns
# ---------------------------------------------------------------------------

# Requests that try to access another customer's data by referencing a
# different user/account/email explicitly.
_OTHER_CUSTOMER_PATTERNS = [
    r"\bother\s+customer\b",
    r"\bsomeone\s+else['s]?\s+(order|account|data|refund)\b",
    r"\blist\s+all\s+(customers?|users?|accounts?|orders?)\b",
    r"\ball\s+(customers?|users?|accounts?|orders?)\b",
    r"\bevery\s+(customer|user|account|order)\b",
    r"\bdump\b.{0,30}\b(customers?|users?|orders?|database|table)\b",
    r"\bshow\s+me\s+all\b",
    r"\bget\s+all\s+(records?|rows?|entries|data)\b",
]

# SQL / NoSQL injection fragments that could be embedded in natural language
_INJECTION_PATTERNS = [
    r"\bSELECT\b.{0,60}\bFROM\b",
    r"\bDROP\s+(TABLE|DATABASE)\b",
    r"\bINSERT\s+INTO\b",
    r"\bUPDATE\b.{0,40}\bSET\b",
    r"\bDELETE\s+FROM\b",
    r"--\s*$",                          # SQL line comment at end of message
    r";\s*(DROP|SELECT|INSERT|UPDATE|DELETE)",
    r"\$where\b",                        # MongoDB operator
    r"\$gt\b|\$lt\b|\$ne\b|\$or\b|\$and\b",
]

# Internal / system resource probing
_SYSTEM_PROBE_PATTERNS = [
    r"\bsystem\s+prompt\b",
    r"\byour\s+(instructions?|configuration|config|source\s+code)\b",
    r"\bignore\s+(previous|all|above|prior)\s+(instructions?|rules?|context)\b",
    r"\bact\s+as\s+(a\s+)?(?!customer support)[\w\s]{1,40}",  # "act as X" (not the agent itself)
    r"\benv(ironment)?\s+var(iable)?s?\b",
    r"\bcredentials?\b.{0,30}\b(password|secret|key|token)\b",
    r"\b(api|secret|access)\s+key\b",
    r"\bprint\s*\(|exec\s*\(|eval\s*\(",  # code execution attempts
    r"\bos\.environ\b|\bos\.getenv\b",
]

# Compile all patterns once at import time (case-insensitive)
_COMPILED: list = [
    re.compile(p, re.IGNORECASE | re.DOTALL)
    for p in (_OTHER_CUSTOMER_PATTERNS + _INJECTION_PATTERNS + _SYSTEM_PROBE_PATTERNS)
]

_BLOCK_MESSAGE = (
    "I'm sorry, but I'm unable to process that request. "
    "I can only access information related to your own orders. "
    "Please provide your order ID to get started, or let me know "
    "if there's something else I can help you with."
)


def _is_unauthorized_access_attempt(text: str) -> bool:
    """Return True if the text matches any unauthorized-access pattern.

    Args:
        text (str): The raw user message to inspect.

    Returns:
        bool: True when at least one pattern matches.
    """
    for pattern in _COMPILED:
        if pattern.search(text):
            return True
    return False


# ---------------------------------------------------------------------------
# Plugin entry point
# ---------------------------------------------------------------------------

@tool(description="Pre-invoke guardrail that detects and blocks unauthorized data access attempts before the customer support agent processes the request.", kind=PythonToolKind.AGENTPREINVOKE)
def data_access_guardrail(
    plugin_context: PluginContext,
    agent_pre_invoke_payload: AgentPreInvokePayload,
) -> AgentPreInvokeResult:
    """Blocks requests that attempt unauthorized data access.

    Inspects the latest user message for patterns indicating attempts to
    access other customers' data, inject database queries, or probe internal
    system resources. Violations halt agent processing and return a safe
    refusal message instead.

    Args:
        plugin_context (PluginContext): Runtime context provided by the platform.
        agent_pre_invoke_payload (AgentPreInvokePayload): The incoming message
            payload to inspect and potentially modify.

    Returns:
        AgentPreInvokeResult: Result containing continue_processing flag and
            the (possibly modified) payload.
    """
    result = AgentPreInvokeResult()
    result.modified_payload = agent_pre_invoke_payload

    # Guard: nothing to inspect if there are no messages
    if (
        agent_pre_invoke_payload is None
        or not agent_pre_invoke_payload.messages
    ):
        result.continue_processing = True
        return result

    last_message = agent_pre_invoke_payload.messages[-1]
    user_text: str = ""
    try:
        user_text = last_message.content.text or ""
    except AttributeError:
        # content shape differs — allow through, agent will handle it
        result.continue_processing = True
        return result

    if _is_unauthorized_access_attempt(user_text):
        # Replace the message text with a safe refusal and halt processing
        last_message.content.text = _BLOCK_MESSAGE
        agent_pre_invoke_payload.messages[-1] = last_message
        result.modified_payload = agent_pre_invoke_payload
        result.continue_processing = False
        return result

    # No violation — pass the original payload through unchanged
    result.continue_processing = True
    return result
