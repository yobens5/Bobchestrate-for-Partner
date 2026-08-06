# Optional Module: Multi-Agent Orchestration

**Outcome:** A travel concierge routes requests to four specialist agents.

Use collaborators when responsibilities have distinct tools, instructions, or
ownership. Avoid extra layers that do not improve routing.

## What we will implement

You will build four specialist agents with mock tools and a `travel_concierge`
orchestrator that routes a request to the right specialist and combines the
results.

```text
travel_concierge
├── flight_specialist
├── hotel_specialist
├── activity_planner
└── budget_advisor
```

All tools in this example use simulated data.

## 1. Ask Bob to build the system

Ask Bob:

```text
Build a simulated multi-agent travel system for ADK 2.14.0. Create four
specialist agents—flight_specialist, hotel_specialist, activity_planner, and
budget_advisor—with distinct descriptions and mock Python tools. Create
travel_concierge as their orchestrator with explicit routing and synthesis
instructions. Put agents under agents/, tools under tools/, and dependencies in
requirements.txt. Add small local tests, run syntax and test checks, and
validate every YAML file. Do not import yet; summarize the artifacts for review.
```

Use these tested starter files if Bob needs a fallback or comparison.

Python files under `tools/`:

- <a href="flight_tools.py" download="flight_tools.py">flight_tools.py</a>
- <a href="hotel_tools.py" download="hotel_tools.py">hotel_tools.py</a>
- <a href="activity_tools.py" download="activity_tools.py">activity_tools.py</a>
- <a href="budget_tools.py" download="budget_tools.py">budget_tools.py</a>

YAML files under `agents/`:

- <a href="flight-specialist-agent.yaml" download="flight-specialist-agent.yaml">flight-specialist-agent.yaml</a>
- <a href="hotel-specialist-agent.yaml" download="hotel-specialist-agent.yaml">hotel-specialist-agent.yaml</a>
- <a href="activity-planner-agent.yaml" download="activity-planner-agent.yaml">activity-planner-agent.yaml</a>
- <a href="budget-advisor-agent.yaml" download="budget-advisor-agent.yaml">budget-advisor-agent.yaml</a>
- <a href="travel-concierge-agent.yaml" download="travel-concierge-agent.yaml">travel-concierge-agent.yaml</a>

Download <a href="requirements.txt" download="requirements.txt">requirements.txt</a>
and save it at the project root.

Review each specialist's description. The orchestrator uses those descriptions
to choose a collaborator.

## 2. Import tools

Ask Bob:

```text
Using the existing .venv and root requirements.txt, import the four travel tool
files into the active draft environment. Verify every expected tool is listed
and stop on the first unexplained failure.
```

Manual fallback:

```bash
orchestrate tools import -k python -f tools/flight_tools.py -r requirements.txt
orchestrate tools import -k python -f tools/hotel_tools.py -r requirements.txt
orchestrate tools import -k python -f tools/activity_tools.py -r requirements.txt
orchestrate tools import -k python -f tools/budget_tools.py -r requirements.txt
orchestrate tools list
```

## 3. Import specialists, then the concierge

Ask Bob:

```text
Import the four travel specialist agents first and travel_concierge last.
Validate each YAML before import, preserve dependency order, and verify all five
agents are listed. Show me the commands and results.
```

Manual fallback:

```bash
orchestrate agents import -f agents/flight-specialist-agent.yaml
orchestrate agents import -f agents/hotel-specialist-agent.yaml
orchestrate agents import -f agents/activity-planner-agent.yaml
orchestrate agents import -f agents/budget-advisor-agent.yaml
orchestrate agents import -f agents/travel-concierge-agent.yaml
orchestrate agents list
```

Import collaborators before the agent that references them.

## 4. Test routing

Ask Bob:

```text
Inspect the five travel agents and suggest a concise routing test set: one
prompt per specialist, one ambiguous prompt, and one combined request. Start a
chat with travel_concierge and tell me the expected collaborator route for each
test without inventing real booking confirmation.
```

Manual chat fallback:

```bash
orchestrate chat ask --agent-name travel_concierge
```

| Prompt | Expected collaborator |
|---|---|
| `Find a flight from Tel Aviv to Paris.` | `flight_specialist` |
| `Suggest a hotel in central Paris.` | `hotel_specialist` |
| `What should I do in Paris for two days?` | `activity_planner` |
| `Estimate the total trip cost.` | `budget_advisor` |

Finally try a combined request:

```text
Plan a three-day trip to Paris with flights, a central hotel, two activities,
and a budget summary.
```

Check that the concierge delegates to relevant specialists and combines their
answers without inventing unavailable booking confirmation.

## Checkpoint

- [ ] Each specialist has a distinct description and tool set
- [ ] All specialists import before the concierge
- [ ] Single-domain prompts route correctly
- [ ] The combined request invokes more than one relevant collaborator
- [ ] Responses clearly distinguish simulated results from real bookings

## Troubleshooting

??? question "The concierge answers everything itself"

    Make specialist descriptions more specific and tell the concierge when to
    delegate. Avoid duplicating specialist tools on the concierge.

??? question "The wrong specialist is selected"

    Remove overlapping descriptions and add concrete routing examples to the
    concierge instructions.
