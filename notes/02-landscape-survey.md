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

---

## Agent-as-a-Router (ACRouter) — read in full, 6 Sep 2026

[2606.22902](https://arxiv.org/abs/2606.22902) v3, Jun 2026, cs.AI, 39pp "living technical report". No venue. Full text: `/tmp/aar.txt` (re-fetch via arxiv.org/html/2606.22902v3).

**This is the closest published work to our idea — closer than FlyRoute.**

### What it does

Routes coding tasks across LLM providers (GPT / Claude / Gemini / Qwen / GLM / Kimi). Diagnoses existing routers as suffering **"information deficit"** — *"static routers are structurally unable to [acquire execution-grounded information] since their information state is frozen."* Nearly our critique, in their words.

Architecture: **C-A-F loop** (Context → Action → Feedback → Context), three modules — Orchestrator (decides), Verifier (runs code in a sandbox), Memory (accumulates).

### Its memory is decision-level, with outcomes

> *"Memory is an online vector store keyed by task embeddings (voyage-code-3 / BGE-large) whose value logs the chosen model, performance, cost, and verification traces."* Retrieved by cosine kNN.

| | Memory unit | Failures kept? |
|---|---|---|
| FlyRoute | (query, response, score) → one agent | no, quality-gated out |
| BoundaryRouter | (query, both answers, both latencies) | no outcome stored |
| **ACRouter** | (task → **chosen model**, performance, cost, trace) | **yes** |

**Their feedback signal is execution, not a judge.** Coding gives ground truth free — tests pass or fail. We are in FlyRoute's situation, not theirs: no test suite for a bank guarantee answer. Our feedback problem is strictly harder.

### What this takes from us

1. **The bandit comparison is done.** They ran LinUCB and LinTS. Regret: bandits 297–307, static 284–317, **ACRouter 205.5**. Their reading: bandits *"lack the context-aware reasoning that Orchestrator and Memory provide."* So "memory beats bandits" is no longer ours to claim — though it does validate the direction.
2. **Cumulative regret as the streaming metric is taken.** They close by framing C-A-F as *"naturally formalizable as a contextual bandit with cumulative regret as its streaming metric."* This was going to be our close-call grading proposal.

### What survives — checked their Limitations section directly

Their limitations cover cost estimation and step limits. **No capability-drift experiment.** Their "OOD" test is new *task types* (SWE-bench Verified), not changed *models*.

- ✅ **Drift under capability shift** — still open. FlyRoute and ACRouter both skip it.
- ✅ **Versioning / supersession** — still open. Append-only kNN vector store, no invalidation, no validity intervals.
- ✅ **Declining to route** — still open.
- ⚠️ **Contested set** — weakened. Regret implicitly handles "several would have worked", though they never study the contested case as such.

### The gift

On adding or changing a model:

> *"New models need responses + scoring."*
> *"In V2, new models join by generating responses on the existing task set."*

**They re-run the entire benchmark against a changed model.** Brute force, full re-evaluation, no incremental invalidation — and they don't present this as a limitation. That cost is precisely what versioning removes. Their own operating practice demonstrates the problem we propose to solve.

Also note they acknowledge the setting is inherently non-stationary — *"Each new model generation introduces new strengths (GLM-5 on algorithms, Qwen3-Max on test generation, Kimi-K2.5 on data science)"* — without ever measuring adaptation to it.

---

## GraphPlanner — read in full, 6 Sep 2026

[2604.23626](https://arxiv.org/abs/2604.23626), Apr 2026, UIUC. Preprint, ICLR-formatted, not accepted. Full summary: `summaries/graphplanner.md`.

**Not a competitor.** Its "agents" are fixed workflow roles (Planner / Executor / Summarizer) and the task is composing a pipeline and staffing each stage with an LLM backbone — not deciding which of several overlapping specialists owns a query.

**But it settles the versioning claim.** GARNet stores queries, roles and responses, with edges *"enriched with task performance and cost information"* — genuinely rich interaction memory over multi-agent routing. And it has **no temporal structure**:

> *"This implicitly connects different rounds through shared neighbors rather than **explicit temporal edges**."*

No dates, no ordering, no way to invalidate a range. History is averaged into node embeddings by message passing.

### The pattern is now three for three

| System | How memory is maintained | Can you invalidate a date range? |
|---|---|---|
| FlyRoute | distils successes into a description | no — compression destroys the record |
| Agent-as-a-Router | appends to a kNN vector store | no — append-only, nothing is retired |
| GraphPlanner | blends into GNN node embeddings | no — no temporal edges at all |

Three different architectures — LLM-prompt, vector store, graph network — and **none can express "this is out of date from here."** That is a much stronger statement than "FlyRoute distils," and it is the core of the versioning argument.

### A distinction worth naming in the write-up

GraphPlanner generalises zero-shot to **unseen** LLMs. That is **cold start** — a new agent joins the pool. It is *not* **drift** — an existing agent's behaviour changes.

Papers conflate these routinely, and reviewers will too. Define them apart early:
- **Cold start:** a new agent, no history. Solved (FlyRoute seeds, GraphPlanner zero-shot).
- **Drift:** an existing agent with history that is now wrong. **Unaddressed everywhere.**

Our contribution is entirely in the second, and the confusion is a live risk to how the work is read.

Also note the direction of their future work — *"richer agent profiles"*. The field is drifting back toward profiles, not decisions.
