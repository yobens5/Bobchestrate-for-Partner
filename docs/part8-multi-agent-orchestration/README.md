# Optional Module: Multi-Agent Orchestration

**Outcome:** A travel concierge routes requests to four specialist agents.

Use collaborators when responsibilities have distinct tools, instructions, or
ownership. Avoid extra layers that do not improve routing.

```text
travel_concierge
├── flight_specialist
├── hotel_specialist
├── activity_planner
└── budget_advisor
```

All tools in this example use simulated data.

## 1. Download the starter files

Save the Python files under `tools/`:

- [`flight_tools.py`](flight_tools.py)
- [`hotel_tools.py`](hotel_tools.py)
- [`activity_tools.py`](activity_tools.py)
- [`budget_tools.py`](budget_tools.py)

Save the YAML files under `agents/`:

- [`flight-specialist-agent.yaml`](flight-specialist-agent.yaml)
- [`hotel-specialist-agent.yaml`](hotel-specialist-agent.yaml)
- [`activity-planner-agent.yaml`](activity-planner-agent.yaml)
- [`budget-advisor-agent.yaml`](budget-advisor-agent.yaml)
- [`travel-concierge-agent.yaml`](travel-concierge-agent.yaml)

Save [`requirements.txt`](requirements.txt) at the project root.

Review each specialist's description. The orchestrator uses those descriptions
to choose a collaborator.

## 2. Import tools

```bash
orchestrate tools import -k python -f tools/flight_tools.py -r requirements.txt
orchestrate tools import -k python -f tools/hotel_tools.py -r requirements.txt
orchestrate tools import -k python -f tools/activity_tools.py -r requirements.txt
orchestrate tools import -k python -f tools/budget_tools.py -r requirements.txt
orchestrate tools list
```

## 3. Import specialists, then the concierge

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
