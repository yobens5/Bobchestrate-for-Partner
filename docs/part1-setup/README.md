# Part 1: Setup & Environment

**Outcome:** A new `bobchestrate-ws` project connected to the workshop
watsonx Orchestrate environment.

## 1. Verify prerequisites

Complete [Prerequisites](../part0-prerequisites/README.md), then open a terminal:

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

Download Bob IDE from [bob.ibm.com/download](https://bob.ibm.com/download) if
needed.

## 3. Create the virtual environment

1. Open the Command Palette:
   `Cmd+Shift+P` on macOS or `Ctrl+Shift+P` on Windows.
2. Select **Python: Create Environment**.
3. Choose **Venv**, then the Python 3.12 interpreter.
4. Open a new terminal and confirm that `(.venv)` appears in its prompt.

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

## 4. Install ADK 2.12.0

1. Open Extensions (`Cmd+Shift+X` or `Ctrl+Shift+X`).
2. Install **IBM watsonx Orchestrate ADK**.
3. In the status bar, select the red ADK status indicator and install the ADK
   into `.venv`.
4. Confirm the installed version:

```bash
orchestrate --version
```

The first line must show `ADK Version: 2.12.0`. Ask the instructor before
continuing if another version is installed.

## 5. Initialise the workspace and MCP servers

Use the Command Palette to run:

1. **watsonx Orchestrate: Initialise Workspace**
2. **watsonx Orchestrate: Install WXO MCP Servers**

Enter `2.12.0` when the MCP installer asks for a version.

Open Bob chat and ask:

```text
What watsonx Orchestrate MCP servers are available?
```

Confirm that Bob reports both the ADK and ADK documentation servers. You can
also inspect them from the Command Palette under **MCP Servers**.

## 6. Import the WXO Agent Architect mode

1. Right-click
   [`wxo-agent-architect-export.yaml`](files/wxo-agent-architect-export.yaml)
   and choose **Save Link As…** (or **Download Linked File** on macOS).
   Save the file in your **Downloads** folder. Do not open the link normally;
   the browser may display the YAML instead of saving it.
2. Open the Command Palette and select **Modes**.
3. Select **Import** and choose the YAML file from your **Downloads** folder.
4. After the import completes, select **WXO Agent Architect** in Bob chat.

Checkpoint:

```text
What can you help me build in WXO Agent Architect mode?
```

Bob should mention watsonx Orchestrate agents and its MCP tools.

## 7. Connect the workshop environment

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

- `orchestrate --version` reports ADK 2.12.0
- `orchestrate agents list` succeeds
- WXO Agent Architect mode is selected
- Bob can access the two Orchestrate MCP servers

!!! tip "Stuck?"
    Copy the tested configuration files for this part from the
    [reference solution](../solution/README.md#part-1-setup), then continue.

## Troubleshooting

??? question "`orchestrate: command not found`"

    Activate `.venv` using the platform command in Step 3. If the ADK is still
    absent, reinstall it from the extension's status indicator.

??? question "Authentication failed"

    ```bash
    orchestrate env list
    orchestrate env activate <environment-name>
    orchestrate agents list
    ```

??? question "Bob cannot access the MCP servers"

    Open **MCP Servers** from the Command Palette. Restart any stopped server
    and confirm that its status is green.

[Continue to Part 2: Bob Custom Rules →](../part2b-bob-custom-rules/README.md)
