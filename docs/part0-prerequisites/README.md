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

### Homebrew (macOS)

> **macOS only — Windows users skip this section.**

Homebrew is the recommended package manager for macOS. It is used to install
Python, `uv`, and other workshop dependencies.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The installer may prompt for your macOS password. After it finishes, follow
any printed instructions to add Homebrew to your `PATH` (typically needed on
Apple Silicon Macs):

```bash
# Apple Silicon (M1/M2/M3) — add to ~/.zprofile then reload
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel Macs — Homebrew is already on PATH, no extra step needed
```

Verify the installation:

```bash
brew --version
```


---

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

## 1. Create a watsonx Orchestrate Instance

### Primary: IBM watsonx Orchestrate Trial

Sign up for a free IBM watsonx Orchestrate trial account:

[Start watsonx Orchestrate Trial](https://www.ibm.com/account/reg/us-en/signup?formid=urx-52753)

The trial provides enough capacity to complete all workshop exercises.

### Backup 1: TechZone — Pilot reservation

If you have an IBM Opportunity ID, you can reserve a watsonx Orchestrate environment on TechZone:

- [Reserve environment (direct)](https://techzone.ibm.com/collection/69c6bb3c694109c9b9a8abac/journey-watsonx-overview?platform=69fc8b4940c49f77fbbc67b7)
- [watsonx Overview collection](https://techzone.ibm.com/collection/69c6bb3c694109c9b9a8abac/journey-watsonx-overview)

When opening the collection, select the **"watsonx Orchestrate essentials plan"** reservation from the list, then pick **Americas** as the region.

**Reservation type — use Pilot:**

On the reservation form you will be asked to choose a purpose. Select **Pilot** and enter your **Opportunity ID** in the field provided. Using Pilot with an Opportunity ID is required for partner workshop access; selecting a different purpose may result in the reservation being rejected.

!!! tip "Where to find your Opportunity ID"
    Your Opportunity ID is the CRM opportunity number associated with the partner engagement. Ask your IBM contact or account team if you do not have it.

### Backup 2: TechZone — Test environment (12 hours)

If you do not have an Opportunity ID, use this direct reservation link:

[Reserve watsonx Orchestrate — Test (12 hours)](https://techzone.ibm.com/my/reservations/create/67eead855c0ed683f94057fa)

On the reservation form, select **Test** as the purpose. This provisions a fully functional watsonx Orchestrate environment valid for **12 hours** — enough to complete the full workshop in a single session.

### Collect your instance URL and API key

Once your watsonx Orchestrate instance is ready and you have opened it:

1. Click your **account icon** in the top-right corner of the watsonx Orchestrate UI.
2. Select **Settings**.
3. Go to **API details**.
4. Copy the **Instance URL** and save it in a safe place (e.g. a local notes file).
5. Click **Generate API key**, copy the key immediately, and save it alongside the URL.

The Instance URL looks like this:

```text
https://api.us-south.watson-orchestrate.cloud.ibm.com/instances/20250101-1234-5678-abcd-1234567890ab
```

!!! warning "Save both values now"
    The API key is shown only once. If you navigate away without copying it you will need to generate a new one.

#### These are the only two credentials the workshop needs

You will be asked for the same two values in several places. There is no second
key and no separate IBM Cloud key to create — whenever a step asks for "the API
key" or "the instance URL", it means these:

| Value | Where you use it |
|---|---|
| **Instance URL** | [Part 1 §8](../part1-setup/README.md#8-connect-orchestrate-environment) (Environment Manager → Add) and [Part 7 §3](../part9-nl2sql/README.md#3-connect-watsonx-orchestrate) (accelerator field **WXO URL**) |
| **API key** | [Part 1 §8](../part1-setup/README.md#8-connect-orchestrate-environment) (activation prompt) and [Part 7 §3](../part9-nl2sql/README.md#3-connect-watsonx-orchestrate) (accelerator field **WXO API Key**) |

The optional Agent Evaluations & Red-Teaming module needs neither: its
evaluation commands reuse the environment you activate in Part 1.

!!! danger "Never paste the API key into Bob chat"
    Type it only into the Environment Manager activation prompt or the
    accelerator's own password field. Do not save it in a project file and do
    not commit it.

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
