# Part 10: NL2SQL Agent with the IBM CE Accelerator

**Duration:** 30 min  
**Level:** Intermediate  
**Objective:** Use the IBM Client Engineering NL2SQL accelerator to generate a working Natural Language to SQL agent directly in watsonx Orchestrate — no coding required. Then pick up where the accelerator leaves off and continue developing the agent with Bob.

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

## Demo 1 — Query Your Data in Plain English

Before building the agent, here is what it can do once deployed: ask a business question in natural language (for example, checking which stores are open for an event) and get the answer directly from the database — without writing a single line of SQL. The agent translates the question into a SQL query, runs it, and returns a readable result.

<video controls width="100%" style="border-radius:6px; margin: 1rem 0;">
  <source src="https://github.com/yobens5/Bobchestrate-for-Partner/releases/download/videos-v1/1-demo-open-stores.mov" type="video/quicktime">
  Your browser does not support the video tag.
</video>

---

## Demo 2 — Results with Charts

The agent is not limited to text answers — it can also generate visual charts from query results, making data easier to analyse and share with business users.

<video controls width="100%" style="border-radius:6px; margin: 1rem 0;">
  <source src="https://github.com/yobens5/Bobchestrate-for-Partner/releases/download/videos-v1/2-demo-graph.mov" type="video/quicktime">
  Your browser does not support the video tag.
</video>

---

## Step 1 — Connect the Database & Run Data Discovery

The first step is connecting your source database to the accelerator. This connection triggers the **data discovery** phase: the accelerator scans the database schema (tables, columns, relationships) to understand the data structure. This understanding is what enables the agent to generate accurate SQL queries.

<video controls width="100%" style="border-radius:6px; margin: 1rem 0;">
  <source src="https://github.com/yobens5/Bobchestrate-for-Partner/releases/download/videos-v1/3-connect-db-discovery.mov" type="video/quicktime">
  Your browser does not support the video tag.
</video>

!!! tip
    Review and correct table and column descriptions after discovery — the better the metadata, the more accurate the generated SQL.

---

## Step 2 — Connect the wxo API Key & Create the Agent

Once data discovery is complete, connect your watsonx Orchestrate API key to the accelerator. This allows the accelerator to deploy the agent directly onto the platform. Then launch the NL2SQL agent creation from the accelerator — it uses the discovery results to configure the agent automatically.

<video controls width="100%" style="border-radius:6px; margin: 1rem 0;">
  <source src="https://github.com/yobens5/Bobchestrate-for-Partner/releases/download/videos-v1/4-connect-wxo-create-agent.mov" type="video/quicktime">
  Your browser does not support the video tag.
</video>

---

## Step 3 — The Agent is Ready on watsonx Orchestrate

The agent is now deployed and available on the watsonx Orchestrate platform. Users can start asking questions in natural language straight away — the agent queries the connected database and returns the answer, exactly as shown in Demos 1 and 2.

<video controls width="100%" style="border-radius:6px; margin: 1rem 0;">
  <source src="https://github.com/yobens5/Bobchestrate-for-Partner/releases/download/videos-v1/5-agent-ready.mov" type="video/quicktime">
  Your browser does not support the video tag.
</video>

---

## Summary

| # | Step | Video |
|---|---|---|
| 1 | Demo: business question in natural language | Demo 1 — Open stores |
| 2 | Demo: results with charts | Demo 2 — Graph |
| 3 | Connect the database + data discovery | Step 1 |
| 4 | Connect the wxo API key + create the agent | Step 2 |
| 5 | Agent live on watsonx Orchestrate | Step 3 |

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
