# Landscape survey — what I'd missed

**Why this note exists.** `notes/01` verified the roadmap's premise by reading the four papers *on the roadmap's list*. That is not a literature search. Asked whether FlyRoute was really the only relevant work, I checked — and it isn't. The field is considerably larger, and one paper on the roadmap's own list (*Tool-to-Agent Retrieval*) had never been opened.

This is the same failure the roadmap's gate exists to prevent, one level up: reasoning from a supplied list rather than from the literature.

---

## What the roadmap's landscape paragraph says

> "This area moved fast through 2026: SkillRouter (March), R3-Skill and set-valued routing (June), BoundaryRouter (May), FlyRoute (July)."

Four papers. The actual count of directly-relevant work is at least **ten**, spanning Feb 2025 – Aug 2026.

## What's actually out there

### Directly relevant — routing with memory or online adaptation

| Paper | arXiv | Date | What it does |
|---|---|---|---|
| **Agent-as-a-Router** | [2606.22902](https://arxiv.org/abs/2606.22902) | Jun 2026 | C-A-F loop (Context→Action→Feedback→Context) with a memory module, *"accumulating execution-grounded experience during deployment."* Critiques existing routers as *"a static, one-off classification problem"* — our critique, almost verbatim. Routes among LLM providers for coding tasks. 39pp "living technical report." |
| **GraphPlanner** | [2604.23626](https://arxiv.org/abs/2604.23626) | Apr 2026 | Heterogeneous graph memory (GARNet) storing *"interaction memories among queries, agents, and responses."* RL over an MDP to generate multi-agent workflows. ICLR-formatted preprint (only ICLR mention is the template's Code of Ethics — **not** an acceptance). |
| **TRACE-Router** | [2607.22465](https://arxiv.org/abs/2607.22465) | Jul 2026 | Contextual bandit; assigns a task to a model once at admission, pins all subsequent calls, updates policy on the task's terminal reward. |
| **Symphony-Coord** | [2602.00966](https://arxiv.org/abs/2602.00966) | Feb→May 2026 | Online multi-armed bandit (LinUCB) over agent selection, *"updated through delayed post-execution feedback"*, motivated by *"as agent pools and task distributions evolve."* |
| **Iterative Critique-and-Routing** | [2605.08686](https://arxiv.org/abs/2605.08686) | May 2026 | Contextual bandit where the router updates selection over rounds from user feedback. |
| **MasRouter** | [2502.11133](https://arxiv.org/abs/2502.11133) | Feb 2025 | Multi-Agent System Routing (MASR) — unified routing over MAS components. |
| **AgentRouter** | [2510.05445](https://arxiv.org/abs/2510.05445) | Oct 2025 | Knowledge-graph-guided router for collaborative multi-agent QA. |
| **SLMs as Multi-Agent Routers** | [2608.00030](https://arxiv.org/abs/2608.00030) | Aug 2026 | Progressive SFT + RL to make small models into multi-agent routers. |
| **AdaptOrch** | [2602.16873](https://arxiv.org/abs/2602.16873) | Feb 2026 | Topology selection as a function of task dependency structure. |
| **Tool-to-Agent Retrieval** | [2511.01854](https://arxiv.org/abs/2511.01854) | Nov 2025 | **On the roadmap's list, never read.** Embeds tools *and* parent agents in one vector space; retrieval at tool granularity avoids context dilution from chunking many tools per agent. +19.4% Recall@5 on LiveMCPBench. No memory of past decisions. |

**Venue status:** none of these show a venue or journal reference in arXiv metadata. Verified individually. The "everything is an unreviewed preprint" observation continues to hold across the wider field.

---

## The real new threat: bandits

This is the finding that matters, and it is not FlyRoute.

**Symphony-Coord, TRACE-Router and Iterative Critique-and-Routing all frame routing as a contextual bandit with delayed feedback.** And bandits handle non-stationarity *by construction* — it is a solved, decades-old sub-problem (sliding-window UCB, discounted UCB, change-point-detecting bandits).

So the claim **"nobody handles drift"** is under genuine threat. If an agent gets worse, a bandit's reward estimate for that arm falls and it routes away. No versioning required.

**This must be confronted directly, not ignored.** A reviewer who knows the bandit literature will raise it immediately.

### But it is also the opening

Ask *how* a bandit adapts. It adapts **statistically**: it needs to collect enough failures for the reward estimate to move. And it adapts **by forgetting** — discounting or windowing old rewards away.

Two consequences:

1. **A bandit needs N samples to unlearn. A version stamp needs zero.** A deploy event invalidates every affected entry instantly, with a date, before a single new query arrives.
2. **A bandit destroys the record it used.** You cannot afterwards ask "when did this boundary move, and what did it look like before?" — the discounting has erased it. That is the same objection as FlyRoute's distillation, arriving by a different route.

**This converts the drift experiment into a sharp, falsifiable comparison:**

> After a capability shift, how many queries does each approach need before routing recovers?
>
> - **Contextual bandit** — O(samples to re-converge), and worse for a rarely-selected arm
> - **FlyRoute flywheel** — slower still; successes only, so degradation cannot be recorded at all
> - **Versioned memory + deploy hook** — ~0 queries

Predicted result is clear, mechanically motivated, and the kind of thing a plot makes obvious.

### Consequence: the baseline set has changed

The roadmap specifies comparisons against *"FlyRoute, BoundaryRouter, and plain retrieve-and-rerank."* That is now **insufficient**. Required additions:

- **A contextual bandit baseline** (LinUCB) — the standard adaptive approach
- **A discounted / sliding-window bandit** — the *strongest* drift baseline, and the one to beat
- Possibly **Agent-as-a-Router**'s C-A-F loop, as the closest deployment-experience competitor

Without a bandit baseline the drift result is not credible.

---

## Still to do

- [ ] Read **Agent-as-a-Router** end to end — closest competitor on the "accumulate deployment experience" mechanism
- [ ] Read **GraphPlanner** end to end — closest on multi-agent routing *with* interaction memory
- [ ] Read **Symphony-Coord** — closest on online adaptation; establishes the bandit baseline
- [ ] Skim MasRouter, AgentRouter, SLMs-as-Routers for the N-agent problem framing
- [ ] Revisit whether "nobody stores the contested set" survives GraphPlanner's query–agent–response graph

**Do not pitch or draft until Agent-as-a-Router and GraphPlanner have been read.** Either could reshape the contribution again.
