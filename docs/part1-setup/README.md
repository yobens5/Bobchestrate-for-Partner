# Part 1: Setup & Environment

**Outcome:** A new `bobchestrate-ws` project connected to the workshop
watsonx Orchestrate environment.

## What we will implement

You will create the participant workspace, Python environment, ADK 2.13.0
installation, Bob workshop configuration, MCP connections, and active
watsonx Orchestrate environment used by the later parts.

!!! info "Everything runs inside Bob IDE"
    All terminal commands and Command Palette actions in this workshop are
    performed **inside IBM Bob IDE** — not in a separate system terminal.

    **How to open a terminal in Bob IDE** (same as VS Code):

    - Menu: **Terminal → New Terminal**
    - Keyboard: `` Ctrl+` `` (backtick) on Windows/Linux, `` Ctrl+` `` on macOS

    The terminal opens at the bottom of the editor, already pointed at your
    project folder.

    **How to open the Command Palette:**

    - **macOS:** `Cmd+Shift+P`
    - **Windows:** `Ctrl+Shift+P`

    The Command Palette is a quick-search bar at the top of Bob IDE where you
    type a command name and press Enter to run it — you will use it throughout
    this workshop.

## 1. Verify prerequisites

Complete [Prerequisites](../part0-prerequisites/README.md), then open a terminal in Bob IDE:

=== "Windows PowerShell"

    ```powershell
    python --version
    uv --version
    ```

=== "macOS"

    ```bash
    python3 --version
    uv --version
    ```

Python must report `3.12.x`.

## 2. Create the participant project

Create a new empty folder; do not clone the workshop repository.

```bash
mkdir bobchestrate-ws
cd bobchestrate-ws
```

Open IBM Bob IDE, sign in with your IBM ID, and select
**File → Open Folder → bobchestrate-ws**. Trust the workspace when prompted.

## 3. Install the ADK extension

1. Open the Extensions panel: `Cmd+Shift+X` on macOS or `Ctrl+Shift+X` on Windows.
2. Search for and install **IBM watsonx Orchestrate ADK**.

The extension must be installed before creating the virtual environment so
that Bob IDE can detect it during the next step.

## 4. Create the virtual environment

1. Open the Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`).
2. Type **Python: Create Environment** and press Enter.
3. Choose **Venv**, then select the **Python 3.12** interpreter.
4. Open a new terminal in Bob IDE and confirm that `(.venv)` appears in its prompt.

### Terminal fallback

If **Python: Create Environment** is unavailable, open a terminal in
`bobchestrate-ws` and create the environment manually. Use the command for
your operating system:

=== "Windows PowerShell or Command Prompt"

    ```powershell
    python -m venv .venv
    ```

=== "macOS"

    ```bash
    python3 -m venv .venv
    ```

These commands use the Python 3.12 installation verified in Step 1. Then
activate `.venv` using the platform command below.

If automatic activation fails:

=== "Windows PowerShell"

    ```powershell
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    .venv\Scripts\Activate.ps1
    ```

=== "Windows Command Prompt"

    ```cmd
    .venv\Scripts\activate.bat
    ```

=== "macOS"

    ```bash
    source .venv/bin/activate
    ```

The PowerShell change applies only to the current terminal session.

## 5. Install ADK 2.13.0 into the virtual environment

In the Bob IDE status bar, select the red **ADK** status indicator and choose
to install the ADK into `.venv`. Then confirm the installed version in the
terminal:

```bash
orchestrate --version
```

### Terminal fallback

If the ADK extension installation is unavailable, install the pinned package
directly into `.venv` from a terminal in `bobchestrate-ws`:

=== "Windows PowerShell or Command Prompt"

    ```powershell
    .\.venv\Scripts\python.exe -m pip install ibm-watsonx-orchestrate==2.13.0
    ```

=== "macOS"

    ```bash
    ./.venv/bin/python -m pip install ibm-watsonx-orchestrate==2.13.0
    ```

Then activate `.venv` using the platform command in Step 4 and run
`orchestrate --version` to confirm the installation.

The first line must show `ADK Version: 2.13.0`. Ask the instructor before
continuing if another version is installed.

## 6. Initialise the workspace and MCP servers

Open the Command Palette (`Cmd+Shift+P` on macOS / `Ctrl+Shift+P` on Windows)
and run each of the following commands in order:

1. **watsonx Orchestrate: Initialise Workspace**
2. **watsonx Orchestrate: Install WXO MCP Servers**

Enter `2.13.0` when the MCP installer asks for a version.

Open **Settings → MCP** and confirm that both
`watsonx-orchestrate-adk` and `watsonx-orchestrate-adk-docs` are **green** and
show **Connected**. If either server is not green and connected, stop and ask
the instructor for help before continuing.

Open Bob chat and ask:

```text
What watsonx Orchestrate MCP servers are available?
```

Confirm that Bob reports both the ADK and ADK documentation servers. You can
also inspect them from the Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`)
by typing **MCP Servers**.

## 7. Configure Bob for the workshop

The custom mode gives Bob a watsonx Orchestrate role and the tools it needs.
The workspace rule applies the workshop's ADK 2.13.0 conventions, safety
requirements, and known pitfalls in every Bob mode.

### Import the WXO Agent Architect mode

1. Click <a href="files/wxo-agent-architect-export.yaml" download="wxo-agent-architect-export.yaml">Download the WXO Agent Architect YAML file</a>.
   Your browser should save it automatically in your **Downloads** folder. If
   it opens the YAML instead, right-click the link and choose **Save Link As…**
   (or **Download Linked File** on macOS).
2. Open the Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`) and type **Modes**, then press Enter.
3. Select **Import** and choose the YAML file from your **Downloads** folder.
4. After the import completes, select **WXO Agent Architect** in Bob chat.

### Install the workspace rule

<a href="files/wxo-dev-rule-enhanced.txt" download="wxo-dev-rule-enhanced.md">Download the workshop workspace rule</a>.
The downloaded file is named `wxo-dev-rule-enhanced.md`.

Move it from **Downloads** into `.bob/rules/`:

=== "Windows PowerShell"

    ```powershell
    New-Item -ItemType Directory -Force -Path .bob\rules
    Move-Item "$env:USERPROFILE\Downloads\wxo-dev-rule-enhanced.md" `
      .bob\rules\wxo-dev-rule-enhanced.md -Force
    ```

=== "macOS"

    ```bash
    mkdir -p .bob/rules
    mv ~/Downloads/wxo-dev-rule-enhanced.md .bob/rules/
    ```

Start a new Bob task after installing the rule.

Checkpoint:

```text
Read the workspace rule in .bob/rules/. Summarize the ADK version, folder,
naming, model, documentation-lookup, and safety conventions you will follow.
Do not create or change files.
```

Bob should mention ADK 2.13.0, the workshop folders, `snake_case`,
`groq/openai/gpt-oss-120b`, the documentation MCP, and credential safety.

## 8. Connect the workshop environment

Use the watsonx Orchestrate instance URL and API key from your own provisioned
environment. Treat the API key like a password: do not paste it into chat, save
it in source files, or commit it.

In the watsonx Orchestrate extension:

1. Open **Environment Manager** and select **Add**.
2. Enter a short environment name and the supplied instance URL.
3. Select the environment and choose **Activate**.
4. Paste the API key only into the activation prompt.

Verify the connection:

```bash
orchestrate agents list
```

An empty agent list is a successful result.

??? abstract "CLI fallback"

    ```bash
    orchestrate env add -n <environment-name> -u <instance-url>
    orchestrate env activate <environment-name> -a <api-key>
    orchestrate agents list
    ```

    If activation prints a warning, use `orchestrate agents list` to confirm
    authentication before proceeding.

!!! important
    Remote authentication expires periodically. If commands later return an
    authentication error, reactivate the environment from Environment Manager
    or run `orchestrate env activate <environment-name>` again.

## Setup checkpoint

Ask Bob to perform the non-secret checks:

```text
Inspect this workshop workspace and verify the setup without changing files.
Use the existing .venv. Check the Python and ADK versions, active Orchestrate
environment, expected workspace folders, and access to both Orchestrate MCP
servers. Run safe list or version commands where useful. Summarize anything I
must fix, but do not ask me to paste an API key into chat.
```

Your project should now contain a structure similar to:

```text
bobchestrate-ws/
├── .venv/
├── .bob/
│   └── rules/
│       └── wxo-dev-rule-enhanced.md
├── agents/
├── tools/
├── toolkits/
├── connections/
├── models/
├── knowledge_bases/
└── workspace_config.yaml
```

Empty folders are expected.

Before continuing, confirm:

- `orchestrate --version` reports ADK 2.13.0
- `orchestrate agents list` succeeds
- WXO Agent Architect mode is selected
- `.bob/rules/wxo-dev-rule-enhanced.md` exists
- Bob can access the two Orchestrate MCP servers

!!! tip "Stuck?"
    Copy the tested configuration files for this part from the
    [reference solution](../solution/README.md#part-1-setup), then continue.

## Troubleshooting

??? question "`orchestrate: command not found`"

    Activate `.venv` using the platform command in Step 4. If the ADK is still
    absent, reinstall it from the extension's status indicator.

??? question "Authentication failed"

    ```bash
    orchestrate env list
    orchestrate env activate <environment-name>
    orchestrate agents list
    ```

??? question "Bob cannot access the MCP servers"

    Open **Settings → MCP** and confirm that both
    `watsonx-orchestrate-adk` and `watsonx-orchestrate-adk-docs` are green and
    connected. Restart any stopped server. If either server remains unhealthy,
    ask the instructor for help instead of continuing.

??? question "Windows MCP documentation server fails to start"

    Use this Windows-only fallback only if the regular MCP setup does not work.
    Download the
    <a href="../solution/bob-config/mcp-windows-fallback.json" download="mcp.json">Windows fallback mcp.json</a>
    and replace `.bob/mcp.json`, then reload Bob. Do not use this fallback on
    macOS.

    A common Windows cause is an incompatible `mcp` SDK selected by
    `mcp-proxy`. Because its dependency range has no upper bound, the resolver
    can select an SDK that causes `ImportError: cannot import name
    'request_ctx'`. Reconfigure the documentation server with the compatible
    SDK pin and system certificate support. In PowerShell, use:

    ```powershell
    uvx --system-certs `
      --with mcp==1.28.0 `
      mcp-proxy `
      --transport streamablehttp `
      https://developer.watson-orchestrate.ibm.com/mcp
    ```

    If the error is certificate-related, prefer the organization's CA bundle:

    ```text
    --verify-ssl C:\path\to\company-ca-bundle.pem
    ```

    Use `--verify-ssl false` only as a temporary diagnostic workaround, not as
    the permanent configuration. The Watsonx endpoint may still be healthy;
    this workaround only diagnoses local certificate trust. After updating the
    server, return to **Settings → MCP** and confirm that both servers are green
    and connected.

[Continue to Part 2: Building Your First Agent →](../part2-first-agent/README.md)
