#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# add-wxo-env.sh
# Add and activate a watsonx Orchestrate SaaS environment for the ADK.
#
# Usage (interactive):  ./add-wxo-env.sh
# Usage (non-interactive / CI):
#   ENV_NAME=myenv ENV_URL=https://... API_KEY=... ./add-wxo-env.sh
# ──────────────────────────────────────────────────────────────────────────────
set -euo pipefail

# ── helpers ───────────────────────────────────────────────────────────────────
print_step() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
print_ok()   { printf '\033[1;32m✔  %s\033[0m\n'   "$*"; }
print_err()  { printf '\033[1;31m✘  %s\033[0m\n'   "$*" >&2; }

# ── prereq check ──────────────────────────────────────────────────────────────
print_step "Checking prerequisites"

if ! command -v orchestrate &>/dev/null; then
  print_err "'orchestrate' CLI not found."
  echo "  Install the ADK first:  pip install --upgrade ibm-watsonx-orchestrate"
  exit 1
fi

ADK_VERSION=$(orchestrate --version 2>&1 || true)
print_ok "orchestrate CLI found  ($ADK_VERSION)"

# ── collect inputs ────────────────────────────────────────────────────────────
print_step "Environment details"

# Allow pre-set env vars for non-interactive / CI use
if [[ -z "${ENV_NAME:-}" ]]; then
  read -r -p "  Environment name (e.g. my-wxo-prod): " ENV_NAME
fi

if [[ -z "${ENV_URL:-}" ]]; then
  read -r -p "  Service instance URL: " ENV_URL
fi

if [[ -z "${API_KEY:-}" ]]; then
  # read -s hides the input (no echo)
  read -r -s -p "  API key (input hidden): " API_KEY
  echo ""   # newline after hidden input
fi

# Trim accidental whitespace
ENV_NAME="${ENV_NAME// /}"
ENV_URL="${ENV_URL%/}"        # strip trailing slash
API_KEY="${API_KEY// /}"

if [[ -z "$ENV_NAME" || -z "$ENV_URL" || -z "$API_KEY" ]]; then
  print_err "Environment name, URL, and API key are all required."
  exit 1
fi

# ── infer auth type from URL ───────────────────────────────────────────────────
# IBM Cloud URLs contain  .assistant.watson.cloud.ibm.com
# AWS / SaaS URLs contain  .assistant.us-east.ibm.com  or  similar non-ibmcloud domains
# The ADK auto-detects in most cases; we pass an explicit --type only when we
# can be confident, to avoid overriding correct auto-detection on edge cases.

AUTH_TYPE_FLAG=""
if [[ "$ENV_URL" == *"watson-orchestrate.cloud.ibm.com"* ]] || \
   [[ "$ENV_URL" == *"watson.cloud.ibm.com"* ]]; then
  AUTH_TYPE_FLAG="--type ibm_iam"
  print_ok "Detected IBM Cloud environment  →  auth type: ibm_iam"
elif [[ "$ENV_URL" == *"watson-orchestrate"*".ibm.com"* ]] && \
     [[ "$ENV_URL" != *".cloud.ibm.com"* ]]; then
  AUTH_TYPE_FLAG="--type mcsp"
  print_ok "Detected AWS/SaaS environment   →  auth type: mcsp"
else
  print_ok "URL pattern unrecognised — letting the ADK auto-detect auth type"
fi

# ── add environment ───────────────────────────────────────────────────────────
print_step "Adding environment  '$ENV_NAME'"

# shellcheck disable=SC2086
orchestrate env add \
  --name "$ENV_NAME" \
  --url  "$ENV_URL"  \
  $AUTH_TYPE_FLAG

print_ok "Environment '$ENV_NAME' registered"

# ── activate environment ──────────────────────────────────────────────────────
print_step "Activating environment  '$ENV_NAME'"

orchestrate env activate "$ENV_NAME" --api-key "$API_KEY"

print_ok "Environment '$ENV_NAME' is now active"

# ── confirm ───────────────────────────────────────────────────────────────────
printf '\n\033[1;32m────────────────────────────────────────────────────\033[0m\n'
printf '\033[1;32m  Done! Active environment: %s\033[0m\n' "$ENV_NAME"
printf '\033[1;32m  Note: authentication expires every 2 hours.\033[0m\n'
printf '\033[1;32m  Re-run this script or run:\033[0m\n'
printf '\033[1;32m    orchestrate env activate %s --api-key <key>\033[0m\n' "$ENV_NAME"
printf '\033[1;32m────────────────────────────────────────────────────\033[0m\n\n'
