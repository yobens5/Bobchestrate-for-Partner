# Part 10: NL2SQL Agent with the Accelerator

**Duration:** 30 min  
**Level:** Intermediate  
**Objective:** Use the IBM NL2SQL accelerator to generate a working Natural Language to SQL agent directly in watsonx Orchestrate — no coding required. Then pick up where the accelerator leaves off and continue developing the agent with Bob.

---

## What You'll Build

A fully functional **NL2SQL agent** that lets users query a database in plain English. The agent is generated automatically by the accelerator and deployed straight into watsonx Orchestrate.

---

## How It Works

```
Database  →  Data Discovery  →  NL2SQL Asset  →  watsonx Orchestrate Agent
                                                          ↓
                                              Continue development with Bob
```

The accelerator handles everything up to agent generation. Once the agent is live in Orchestrate, you can extend and customise it using Bob.

!!! note "No Bob in this part"
    This part uses the IBM NL2SQL accelerator only — IBM Bob is not involved until the very end. You don't need the ADK or Python environment.

---

## Step 1 — Connect Your Database & Run Data Discovery

The first step is connecting your database to the accelerator and running a data discovery to understand the schema.

### 1.1 Open the accelerator

<!-- SCREENSHOT PLACEHOLDER: accelerator home screen -->
![Accelerator home screen](images/step1-1-accelerator-home.png)

### 1.2 Add a new database connection

Fill in your database credentials (host, port, database name, username, password).

<!-- SCREENSHOT PLACEHOLDER: database connection form -->
![Database connection form](images/step1-2-db-connection.png)

### 1.3 Run Data Discovery

Click **Run Discovery**. The accelerator scans your database and extracts:

- Table names and descriptions
- Column names, types, and sample values
- Foreign key relationships
- Query patterns

<!-- SCREENSHOT PLACEHOLDER: discovery running -->
![Data discovery in progress](images/step1-3-discovery-running.png)

### 1.4 Explore the discovery results

Once complete, review the results screen by screen:

**Tables overview** — all detected tables with row counts and descriptions.

<!-- SCREENSHOT PLACEHOLDER: tables overview -->
![Tables overview](images/step1-4-tables-overview.png)

**Column details** — for each table, inspect column types, sample values, and nullable flags.

<!-- SCREENSHOT PLACEHOLDER: column details -->
![Column details](images/step1-5-column-details.png)

**Relationships** — visualise the foreign key graph between tables.

<!-- SCREENSHOT PLACEHOLDER: relationships graph -->
![Relationships graph](images/step1-6-relationships.png)

**Query samples** — the accelerator suggests example natural language queries based on the schema.

<!-- SCREENSHOT PLACEHOLDER: query samples -->
![Query samples](images/step1-7-query-samples.png)

!!! tip
    Review and correct table/column descriptions at this stage — the better the metadata, the more accurate the generated SQL.

---

## Step 2 — Connect to the NL2SQL Asset & Configure watsonx Orchestrate

Now connect the discovery output to the NL2SQL asset and point it at your watsonx Orchestrate instance.

### 2.1 Start a new NL2SQL asset

From the discovery results, click **Create Agent**.

<!-- SCREENSHOT PLACEHOLDER: create agent button -->
![Create agent](images/step2-1-create-agent.png)

### 2.2 Connect your watsonx Orchestrate instance

Enter your watsonx Orchestrate credentials:

| Field | Value |
|---|---|
| Instance URL | Your WXO instance URL (from TechZone or SaaS) |
| API Key | Your WXO API key |

<!-- SCREENSHOT PLACEHOLDER: wxo credentials form -->
![WXO credentials](images/step2-2-wxo-credentials.png)

### 2.3 Explore the asset features

Before generating, walk through what the asset offers:

**Schema editor** — edit table/column descriptions to improve query accuracy.

<!-- SCREENSHOT PLACEHOLDER: schema editor -->
![Schema editor](images/step2-3-schema-editor.png)

**SQL validation** — test natural language queries against the database before deploying.

<!-- SCREENSHOT PLACEHOLDER: SQL validation -->
![SQL validation](images/step2-4-sql-validation.png)

**Agent configuration** — set the agent name, instructions, and which tables to expose.

<!-- SCREENSHOT PLACEHOLDER: agent configuration -->
![Agent configuration](images/step2-5-agent-config.png)

**Access controls** — restrict which users or groups can query which tables.

<!-- SCREENSHOT PLACEHOLDER: access controls -->
![Access controls](images/step2-6-access-controls.png)

---

## Step 3 — Generate the Agent

When you're happy with the configuration, click **Generate Agent**.

<!-- SCREENSHOT PLACEHOLDER: generate agent button -->
![Generate agent](images/step3-1-generate.png)

The accelerator:

1. Creates the NL2SQL agent in your watsonx Orchestrate instance
2. Configures it with the schema metadata
3. Connects it to your database
4. Makes it available in the Orchestrate chat interface

<!-- SCREENSHOT PLACEHOLDER: generation complete confirmation -->
![Generation complete](images/step3-2-complete.png)

---

## Step 4 — Test the Agent (Quick Demo)

Open watsonx Orchestrate and find your new NL2SQL agent. Try a few natural language queries:

> *"How many orders were placed last month?"*

> *"Show me the top 10 customers by revenue."*

> *"What products have inventory below 50 units?"*

<!-- SCREENSHOT PLACEHOLDER: agent responding to NL query in Orchestrate -->
![NL2SQL agent demo](images/step4-demo.png)

The agent translates your question into SQL, runs it against the database, and returns the results in plain language.

---

## What's Next — Continue with Bob

You now have a working NL2SQL agent in watsonx Orchestrate. The accelerator got you there fast — but Bob can take it further.

Here are things you can do next with Bob:

- **Add custom tools** — enrich the agent with tools that combine SQL results with business logic
- **Add guidelines** — control which types of queries the agent accepts or rejects
- **Add guardrails** — prevent SQL injection or sensitive data exposure
- **Add collaborators** — connect the NL2SQL agent to other specialist agents
- **Add a knowledge base** — let the agent explain query results using business documentation

### Ask Bob to help:

```
Bob, I have a NL2SQL agent in watsonx Orchestrate. Help me add a guardrail 
that prevents queries on the 'users' table.
```

```
Bob, add a custom tool to my NL2SQL agent that formats SQL results as a 
summary report.
```

---

## Key Takeaways

✅ The NL2SQL accelerator creates a production-ready agent without writing any code  
✅ Data discovery gives the LLM the context it needs to generate accurate SQL  
✅ The agent is fully editable in watsonx Orchestrate once generated  
✅ Bob picks up exactly where the accelerator leaves off

---

**Next:** [Part 9: Multi-Agent Orchestration](../part9-multi-agent-orchestration/README.md) ← or go back to any earlier part to deepen your knowledge.
