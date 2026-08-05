# Prerequisites

## What we will implement

This part prepares the accounts, software, and access needed for the workshop.
You will not build an agent yet; you will leave with a ready workspace path for
building, testing, evaluating, and deploying one in the later parts.

Before starting the workshop, make sure you have the following:

## Accounts & Access

- [ ] GitHub account
- [ ] IBM partner account
- [ ] Access to TechZone
- [ ] Access to ticket creation

---

## Software Prerequisites

### Python 3.12

The workshop is tested with **Python 3.12**. Use Python 3.12 for all workshop
exercises; other versions are not covered by the workshop support path.

**macOS:**

```bash
# Option 1 — Homebrew (recommended)
brew install python@3.12

# Option 2 — python.org installer
# Download from https://www.python.org/downloads/ and run the .pkg file
```

> **Note:** macOS ships with `/usr/bin/python3` (Apple's system Python). Do **not** use it for the workshop — always use the version you install above.

**Windows:**

1. Download the Windows installer directly from python.org:
   - **Python 3.12.10** 👉 [https://www.python.org/downloads/release/python-31210/](https://www.python.org/downloads/release/python-31210/)
   Scroll to the **Files** section at the bottom of the page and choose:
   - **Windows installer (64-bit)** — for most modern PCs (e.g. `python-3.12.10-amd64.exe`)
   - **Windows installer (32-bit)** — only if your system is 32-bit

2. Run the downloaded `.exe` file
3. ⚠️ **On the first screen, check "Add Python 3.12 to PATH"** before clicking anything else — skipping this is the most common cause of `python not found` errors
4. Click **Install Now**

Verify the installation:

> **Windows users:** Open **PowerShell** (press `Win + R`, type `powershell`, press Enter) and run:

```powershell
python --version
```

> **macOS/Linux users:** Open your terminal and run:

```bash
python3 --version
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

Verify the installation in a terminal on either Windows or macOS:

```powershell
uv --version
```

---

## 1. Create a watsonx Orchestrate Instance on TechZone

- [Reserve environment (direct)](https://techzone.ibm.com/collection/69c6bb3c694109c9b9a8abac/journey-watsonx-overview?platform=69caeeed05954196b4ae266c)
- [watsonx Overview collection](https://techzone.ibm.com/collection/69c6bb3c694109c9b9a8abac/journey-watsonx-overview)

When creating the reservation, select **"watsonx Orchestrate Trial with CE"** as the reservation name.


---

## 2. Request a Bob Enterprise Account

Submit your request here:  
[https://www.ibm.com/support/pages/node/7159462](https://www.ibm.com/support/pages/node/7159462)

[User Onboarding Request](https://supportcontent.ibm.com/support/pages/bob-enterprise-subscription-%E2%80%93-user-onboarding-request-0)

### Alternative: Bob IDE trial

If a Bob Enterprise Account is not available, use the Bob IDE trial as a
backup: [download Bob IDE](https://bob.ibm.com/download).

---

Ready? Head to [Part 1: Setup & Environment](../part1-setup/README.md) →
