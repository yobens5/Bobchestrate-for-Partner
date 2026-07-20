# Prerequisites

Before starting the workshop, make sure you have the following:

## Accounts & Access

- [ ] GitHub account
- [ ] IBM partner account
- [ ] Access to TechZone
- [ ] Access to ticket creation

---

## Software Prerequisites

### Python 3.12

The workshop requires **Python 3.12**. Other versions are not tested and not supported.

**macOS:**

```bash
# Option 1 — Homebrew (recommended)
brew install python@3.12

# Option 2 — python.org installer
# Download from https://www.python.org/downloads/ and run the .pkg file
```

> **Note:** macOS ships with `/usr/bin/python3` (Apple's system Python). Do **not** use it for the workshop — always use the version you install above.

**Windows:**

1. Download the installer from [https://www.python.org/downloads/](https://www.python.org/downloads/)
2. Run the installer
3. ⚠️ **Check "Add Python to PATH"** on the first screen — this is the most common cause of `python not found` errors
4. Click **Install Now**

Verify the installation:

```bash
python --version   # Windows
python3 --version  # macOS/Linux
```

### uv

`uv` is used by the ADK extension to manage packages. Install it before starting Part 1.

**macOS/Linux:**

```bash
# Option 1 — Homebrew
brew install uv

# Option 2 — installer script
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows (PowerShell):**

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Verify the installation:

```bash
uv --version
```

---

## 1. Create a watsonx Orchestrate Instance on TechZone

- [Reserve environment (direct)](https://techzone.ibm.com/collection/6939fccc3fc778c2abfc1e25/environments?platform=69fe3e8a6a38f6a7c980166c)
- [watsonx Overview collection](https://techzone.ibm.com/collection/69c6bb3c694109c9b9a8abac/journey-watsonx-overview?platform=69caeeed05954196b4ae266c)

> Detailed documentation in the provider file **Create wxo techzone**.

---

## 2. Request a Bob Enterprise Account

Submit your request here:  
[https://www.ibm.com/support/pages/node/7159462](https://www.ibm.com/support/pages/node/7159462)

> Details on the link.

---

Ready? Head to [Part 1: Setup & Environment](../part1-setup/README.md) →
