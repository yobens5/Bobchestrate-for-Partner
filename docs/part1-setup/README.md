# Part 1: Setup & Environment

**Duration:** 15 minutes  
**Objective:** Get your development environment ready for building watsonx Orchestrate agents

## Prerequisites Check

Before starting, ensure you have:

- [ ] Python 3.12 installed — see [Prerequisites](../part0-prerequisites/README.md#python-312) for install instructions
- [ ] `uv` installed — see [Prerequisites](../part0-prerequisites/README.md#uv) for install instructions
- [ ] IBM Bob IDE installed
- [ ] watsonx Orchestrate access (SaaS or Developer Edition)

## Step 1: Verify Python Installation

Open a terminal and run:
```bash
python --version   # Windows
python3 --version  # macOS/Linux
```

Expected output: `Python 3.12.x`

## Step 2: Verify uv Installation

Open a terminal and run:
```bash
uv --version
```

If `uv` is not installed, go back to [Prerequisites](../part0-prerequisites/README.md#uv) for install instructions.

## Step 3: Create Workshop Folder

Create a dedicated folder for your workshop project - you can place it where ever you want:

```bash
mkdir bobchestrate-ws
cd bobchestrate-ws
```

This folder will contain all your workshop files, agents, and tools.
## Step 4: Open IBM Bob IDE and Login with your IBM ID

> **Download IBM Bob IDE:** If you haven't installed IBM Bob IDE yet, download it from [bob.ibm.com/download](https://bob.ibm.com/download)

<img src="images/image-0.png" alt="Getting started" width="700px">

> **Detailed Installation Instructions:** For complete installation guidance, visit [bob.ibm.com/docs/ide/getting-started/install](https://bob.ibm.com/docs/ide/getting-started/install)

### ⚠️ IMPORTANT ⚠️ ###
> You must be logged in to use Bob's AI capabilities throughout the workshop. If you encounter any login issues, contact your instructor.

## Step 5: Open Folder in IBM Bob IDE

1. When Bob IDE opened:
2. Click **File** → **Open Folder**

   <img src="images/image.png" alt="IBM Bob IDE File menu showing Open Folder option" width="250px">

3. Navigate to and select the `bobchestrate-ws` folder
4. Click **Open**
5. Click **Yes, I trust the author** to trust the workspace

   <img src="images/image-1.png" alt="IBM Bob IDE File menu showing Open Folder option" width="400px">

The empty workspace will open.

## Step 6: Install watsonx Orchestrate ADK VS Code Extension

Install the watsonx Orchestrate extension for IBM Bob IDE:

1. Open the Extensions view in IBM Bob IDE (Click the Extensions icon in the Activity Bar or press `Cmd+Shift+X` on Mac / `Ctrl+Shift+X` on Windows/Linux)

   <img src="images/image-2.png" alt="IBM Bob IDE File menu showing Open Folder option" width="50px">

2. Search for "watsonx Orchestrate"

    <img src="images/image-4.png" alt="IBM Bob IDE File menu showing Open Folder option" width="350px">

3. Click **Install** on the "IBM watsonx Orchestrate ADK" extension
4. Wait for the installation to complete
5. Reload VS Code if prompted
6. You should now see the extension icon appear in the Activity Bar:

   <img src="images/image-3.png" alt="IBM Bob IDE File menu showing Open Folder option" width="75px">

The extension provides:
- Syntax highlighting for agent YAML files
- IntelliSense for agent configuration
- Quick access to watsonx Orchestrate commands
- Integration with the Orchestrate CLI

## Step 7: Install watsonx Orchestrate MCP Servers

Install the watsonx Orchestrate MCP servers through the ADK extension:

1. Open the Command Palette in IBM Bob IDE (press `Cmd+Shift+P` on Mac / `Ctrl+Shift+P` on Windows/Linux)
2. Type "watsonx Orchestrate: Install WXO MCP Servers" and select it
3. When prompted for a version, type **`2.12.0`** and press Enter
4. Wait for the installation to complete
5. You should see a confirmation message that the MCP servers have been installed successfully

**Verify the installation:**

To confirm the MCP servers are installed and working:

1. Open Bob's chat panel in IBM Bob IDE
2. Ask Bob: "What MCP servers are available?"
3. You should see the following watsonx Orchestrate MCP servers listed:
   - `watsonx-orchestrate-adk` - Provides tools for interacting with watsonx Orchestrate (list agents, tools, etc.)
   - `watsonx-orchestrate-adk-docs` - Provides access to watsonx Orchestrate documentation

Alternatively, you can check the MCP servers configuration:

1. Open the Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`)
2. Type "MCP Servers" and select it
3. Verify that the watsonx Orchestrate MCP servers are listed in the configuration and both of them marked with a green bullet point

   <img src="images/image-5.png" alt="IBM Bob IDE MCP settings panel showing two watsonx Orchestrate MCP servers with green status indicators" width="650px">

The MCP servers provide:
- Access to watsonx Orchestrate documentation
- Integration with the watsonx Orchestrate ADK
- Tools for listing agents, tools, and other resources
- Enhanced Bob capabilities for watsonx Orchestrate development

## Step 8: Import WXO Agent Architect Mode

Import a pre-configured custom mode specialized for building watsonx Orchestrate agents:


1. Download the mode configuration file:
   - The file is located at: [wxo-agent-architect-export.yaml](files/wxo-agent-architect-export.yaml)

   - The link opens the file in your browser — to save it, **right-click the link and choose "Save As…"**. Make sure the filename ends with **`.yaml`** before saving.

   - Save the file to your Downloads folder or a location you can easily access

2. Open the Command Palette in IBM Bob IDE (press `Cmd+Shift+P` on Mac / `Ctrl+Shift+P` on Windows/Linux)

3. Type "Modes" and select it

4. Click on **Import** icon in the modes panel

   <img src="images/image-11.png" alt="Import custom mode" width="400px">
   
5. Select the `wxo-agent-architect-export.yaml` file you downloaded and click **Open**

6. You should see a confirmation message that the mode was imported successfully and see the mode appear in the modes panel

The imported "WXO Agent Architect" mode includes:
- **Role Definition**: Specialized for building watsonx Orchestrate agents
- **Custom Instructions**: Guidance on using MCP servers for agent development
- **MCP Server Integration**: Automatically uses both `watsonx-orchestrate-adk` and `watsonx-orchestrate-adk-docs` servers
- **Tool Groups**: Access to read, edit, browser, command, and MCP tools

**Verify the mode:**

1. Open Bob's chat panel if not already open
2. Click on the mode selector (usually shows the current mode like "Code" or "Ask")
3. You should see "WXO Agent Architect" in the list of available modes
4. Select "WXO Agent Architect" mode
5. Ask Bob: "What can you help me with in this mode?"
6. Bob should respond with information about building watsonx Orchestrate agents and mention the available MCP servers

## Step 9: Create Python Virtual Environment

Create a virtual environment for the workshop to keep dependencies isolated using IBM Bob IDE's built-in commands:

1. Open the Command Palette in IBM Bob IDE (press `Cmd+Shift+P` on Mac / `Ctrl+Shift+P` on Windows/Linux)
2. Type "Python: Create Environment" and select it
3. Choose "Venv" as the environment type
4. Select your Python interpreter (Python 3.12)
5. Wait for the virtual environment to be created

You can now see the .venv folder in your workspace explorer view.

<img src="images/image-6.png" alt="IBM Bob IDE Explorer showing the .venv folder in the workspace" width="350px">

IBM Bob IDE will automatically:
- Create a `.venv` folder in your workspace
- Activate the virtual environment in new terminals
- Show `(.venv)` in your terminal prompt

> **_Note:_** The virtual environment will be automatically activated when you open new terminals in IBM Bob IDE.

> **_Note2:_** If you're wondering about the .bob folder, it was created automatically when you installed the MCP Servers for Orchestrate. This folder contains all the IBM Bob IDE configuration files for the MCP Servers for Orchestrate. It's safe to leave it there.

> **_Manual activation (if needed):_** If you open a terminal outside of Bob IDE, or if the venv is not activated automatically, use the appropriate command for your platform:
> ```bash
> # macOS/Linux
> source .venv/bin/activate
> ```
> ```cmd
> # Windows CMD
> .venv\Scripts\activate.bat
> ```
> ```powershell
> # Windows PowerShell
> .venv\Scripts\Activate.ps1
> ```
> If PowerShell blocks the script, run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once first, then retry.

## Step 10: Install watsonx Orchestrate SDK

Since you have the watsonx Orchestrate ADK extension installed, you will see the ADK informaton in the bottom Status Bar. Since we just created a fresh Python virtual environment to our workspace, you should see just a red cross ❌ stating that you need to install the ADK.

<img src="images/image-7.png" alt="IBM Bob IDE Status Bar showing ADK not installed" width="300px">

Click on the red cross to install the ADK. This will open a couple of commands to the search/command bar. Select the one to install the ADK.

<img src="images/image-8.png" alt="IBM Bob IDE Command Palette showing Install ADK command" width="500px">

Wait for the installation to complete. After a while, you should see a notification and a green checkmark in the Status Bar with the version number of the ADK.

> **Note:** This workshop has been tested with **ADK version 2.12.0**. If a different version is installed, you may encounter differences in CLI commands or YAML schemas.

<img src="images/image-9.png" alt="IBM Bob IDE Status Bar showing ADK installed" width="300px">

## Step 11: Get Your watsonx Orchestrate API key and API URL

For the workshop, we will use the watsonx Orchestrate ADK to interact with a watsonx Orchestrate SaaS instance. The ADK requires your API key and API URL to authenticate and connect to your watsonx Orchestrate instance.

> **_Note:_** `Your instructor will provide you with the API key and API URL for your watsonx Orchestrate instance.` If you are using your own instance, you can follow the instructions below to get the needed API key and the API URL.

### OPTIONAL: Using your own watsonx Orchestrate SaaS instance

<ins>To generate an API key for the ADK:</ins>

1. In your watsonx Orchestrate console, click on your **profile icon** in the top-right corner
2. Select **Settings** from the dropdown menu
3. Navigate to the **API details** tab
4. Click **Generate API key** button

   <img src="images/image-12.png" alt="Generate API key button highlighted" width="350px">

5. When the key is generated, click **Copy** to save it to your clipboard
6. **Important**: Copy the API key immediately and _store_ it securely
   - The key will only be shown once
   - If you lose it, you'll need to create a new one

> **Security Best Practice**: Treat your API key like a password. Never commit it to version control or share it publicly.

<ins>To get the API URL:</ins>

Copy the **Service instance URL** from the API details information. This is the base URL for your watsonx Orchestrate instance.

   <img src="images/image-13.png" alt="Get the service URL" width="600px">

### Configure the ADK Environment

#### Option A: Using the watsonx Orchestrate extension

Use the extension's **Environment Manager** to add and activate your environment directly from IBM Bob IDE.

1. Open the **watsonx Orchestrate** extension from the Activity Bar.

2. In the **Environment Manager** section at the bottom of the extension view, click **Add**.

   <img src="images/environment-manager-add-dialog.png" alt="Environment Manager with Add button highlighted" width="500px">

3. In the add environment dialog, enter a name for your environment and paste the watsonx Orchestrate URL that you copied earlier.

   <img src="images/environment-manager-activate-environment.png" alt="Add environment dialog showing name and URL fields" width="500px">

4. After the environment appears in the environment list, select it and click **Activate**.

   <img src="images/environment-manager-api-key.png" alt="Environment list showing an environment selected with the Activate button" width="500px">

5. Confirm that the environment is active in the Environment Manager.

   <img src="images/environment-manager-active-environment.png" alt="Environment Manager showing an active environment" width="500px">

6. When prompted, paste your API key. The extension will activate the environment for you.

   <img src="images/environment-manager-extension-view.png" alt="API key prompt for environment activation" width="300px">

7. Verify your connection is working. Open a terminal in IBM Bob IDE and run:

   ```bash
   orchestrate agents list
   ```

   If configured correctly, this command will list any agents in your environment, or show an empty list if you have not created any agents yet.

#### Option B: Using the ADK CLI (fallback)

1. Open a terminal window within Bob IDE:

   - From the Bob main menu bar, select **Terminal** > **New Terminal**

      <img src="images/image-14.png" alt="Open terminal" width="500px">
   
   - This will open a terminal window in the Bob IDE - notice that your Python virtual environment is automatically activated

      <img src="images/image-15.png" alt="Terminal window opened in Bob IDE" width="700px">

2. Run the following command in your terminal to **add** your environment:

   ```bash
   orchestrate env add -n <your-env-name> -u <your-api-url>
   ```
   Where `<your-env-name>` is a name you choose for your environment (e.g., "my-wxo-cloud") and `<your-api-url>` is the URL you got in Step 10.
   
   After running the command, you should see a message: `[INFO] Environment '<your-env-name>' has been created`

3. Run the following command to **activate** the environment:

   ```bash
   orchestrate env activate <your-env-name> -a <your-api-key>
   ```
   Where `<your-env-name>` is a name you choose for your environment (e.g., "my-wxo-cloud") and `<your-api-key>` is the API key you got in Step 10.
   
   After running the command, you should see a message: `[INFO] Environment '<your-env-name>' is now active`. This means your environment is now active and ready to use with the ADK. You can ignore the warning regarding the Auth Type.

#### Option C: Using Bob to help you 😃

Now that you have watsonx Orchestrate MCP servers and the WXO Agent Architect mode enabled, you can use Bob to help you with the setup.

1. Make sure that you have the **WXO Agent Architect** mode selected for your Bob chat. Then ask Bob to create a script to add and activate a new watsonx Orchestrate environment for the ADK:

   ```
   Create a script to add and activate a new watsonx Orchestrate SaaS environment for the ADK. I have the environment URL and API key ready. First detect my operating system, then generate a single script for my platform: a .sh file for macOS/Linux or a .ps1 file for Windows PowerShell. Do not require Git Bash or WSL.
   ```

   <img src="images/image-16.png" alt="Create a script to add and activate a new watsonx Orchestrate environment for the ADK" width="400px">

2. When Bob starts working, it will ask for permission to access the `watsonx-orchestrate-adk-docs` MCP server. Click **Approve** to allow access.

   > **Note:** You can check **Always allow** to skip approving access to this MCP server each time. You can also enable **Auto-approval**.

   <img src="images/image-17.png" alt="Approve access to the MCP server" width="350px">

3. After Bob creates the script, it will ask for permission to save it. Click **Save**.

4. Bob may then ask for permission to make the script executable. Click **Run** to execute that command.

5. Open a terminal window within IBM Bob IDE:

   - From the Bob main menu bar, select **Terminal** > **New Terminal**

      <img src="images/image-14.png" alt="Open terminal" width="550px">

   - This opens a terminal window in IBM Bob IDE. Notice that your Python environment is automatically activated.

      <img src="images/image-15.png" alt="Terminal window opened in IBM Bob IDE" width="700px">

6. Run the script in the terminal to add your environment:

   ```bash
   # macOS/Linux
   ./add_wxo_env.sh
   ```
   ```powershell
   # Windows PowerShell
   .\add_wxo_env.ps1
   ```

7. When prompted, provide a name for your environment, for example `my-wxo-cloud`.

   <img src="images/image-19.png" alt="Prompt for environment name" width="450px">

8. When prompted, provide the URL of your watsonx Orchestrate instance.

   <img src="images/image-20.png" alt="Prompt for environment URL" width="700px">

9. When prompted, provide the API key of your watsonx Orchestrate instance. The script then creates the environment and activates it.

   <img src="images/image-21.png" alt="Prompt for environment API key" width="450px">

10. Verify your connection is working:

   ```bash
   orchestrate agents list
   ```

   If configured correctly, this command will list any agents in your environment, or show an empty list if you have not created any agents yet.

> [!IMPORTANT]
> Authentication against a remote environment expires every two hours. After expiration, reactivate the environment from the extension or run `orchestrate env activate` again. Keep your API key available and ready to use.

## Step 12: Confirm Your Participant Workspace Structure

After completing the setup, your workspace should look similar to this:

```
Bobchestrate-for-Partner-test/
├── workspace_config.yaml          # watsonx Orchestrate folder path configuration
├── add-wxo-env.sh                 # Optional helper script for environment setup
│
├── agents/                        # Agent YAML files you create during the workshop
├── tools/                         # Python tools you create during the workshop
├── toolkits/                      # Toolkit definitions
├── connections/                   # Connection definitions
├── models/                        # Model definitions
├── knowledge-bases/               # Knowledge base files and configs
│
├── .bob/
│   ├── custom_modes.yaml
│   └── mcp.json
│
└── .venv/                         # Python virtual environment
```

Some folders may still be empty at this stage. That is expected. You will start adding files to them in the next parts of the workshop.

## Using Bob Throughout the Workshop

Bob is your AI pair programmer for this workshop. Here's how to use Bob effectively:

### Good Bob Prompts:
✅ "Bob, create a Python tool that checks order status given an order ID"  
✅ "Bob, why is my agent not responding to user messages?"  
✅ "Bob, explain what agent instructions do in watsonx Orchestrate"  
✅ "Bob, refactor this tool to handle errors better"  

### Less Effective Prompts:
❌ "Bob, fix this" (too vague)  
❌ "Bob, make it work" (no context)  
❌ "Bob, do everything for me" (you won't learn!)  

### Bob's Special Powers:
- 🔍 **Search docs**: Bob can search watsonx Orchestrate documentation
- 💻 **Write code**: Bob can create Python tools and agent specs
- 🐛 **Debug**: Bob can analyze errors and suggest fixes
- 📚 **Explain**: Bob can explain concepts and best practices
- 🔧 **Refactor**: Bob can improve your code

### Managing Bob Chat Sessions:
- ✅ **Continue in same session**: When working on related tasks or the same topic/artifacts, continue in the same Bob chat session to maintain context
- 🆕 **Start new task**: When switching to a completely different topic or unrelated work, start a new task with Bob for a clean context
  - Click the "Start New Task" button in Bob's chat panel to start a new task
  - This helps Bob focus on the new topic without confusion from previous context
- 💡 **Best practice**: Think of each Bob session as a focused work session - keep related work together, separate unrelated work

## Troubleshooting

### Issue: "orchestrate: command not found"
**Solution:** The ADK was installed inside your `.venv` in Step 10. Make sure the virtual environment is active and re-run the install if needed:

```bash
# macOS/Linux — activate venv first
source .venv/bin/activate
pip install ibm-watsonx-orchestrate

# Windows PowerShell — activate venv first
.venv\Scripts\Activate.ps1
pip install ibm-watsonx-orchestrate

# Windows CMD — activate venv first
.venv\Scripts\activate.bat
pip install ibm-watsonx-orchestrate
```

> **Note:** Do **not** use `pip install --user` — that installs outside the venv and the `orchestrate` command will not be visible in your workspace terminal.

### Issue: "Authentication failed"
**Solution:** Check your environment configuration:
```bash
# List environments
orchestrate env list

# Add/update environment
orchestrate env add

# Activate environment
orchestrate env activate <name>
```

### Issue: Bob isn't responding
**Solution:**

1. Restart Bob IDE
2. Check the Bob output panel for errors

## Quick Reference

### Useful Commands
```bash
# Add environment
orchestrate env add

# List environments
orchestrate env list

# Activate environment
orchestrate env activate <name>

# List agents
orchestrate agents list

# List tools
orchestrate tools list

# Get help
orchestrate --help

# Check version
orchestrate --version
```

## Next Steps

Once your setup is verified:

1. ✅ You can connect to watsonx Orchestrate
2. ✅ Bob is responding to your questions
3. ✅ You understand the workshop structure

**You're ready to build your first agent!**

Continue to [Part 2: Building Your First Agent](../part2-first-agent/README.md) →

## Additional Resources

- [Installation Guide](https://developer.watson-orchestrate.ibm.com/getting_started/installing)
- [Environment Configuration](https://developer.watson-orchestrate.ibm.com/environment/initiate_environment)
- [Developer Edition Setup](https://developer.watson-orchestrate.ibm.com/developer_edition/wxOde_setup)

---

**💡 Pro Tip:** Keep Bob's chat panel open throughout the workshop. Whenever you're stuck, just ask Bob for help!