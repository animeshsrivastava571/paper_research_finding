# BAICONF 2026 — abstract draft

**Deadline:** 19 September 2026 · **Conference:** 17–19 December 2026 · **Limit:** ~1,000 words

> ⚠️ **Before submitting:** (1) confirm with dcal@iimb.ac.in what "invited for publication" means — it affects whether FinNLP/ICAIF stays open; (2) confirm CBA disclosure clearance. This draft is deliberately generic: financial services as motivating context, no internal system names, no internal data.

---

## Title

**When the Agent Changes: Keeping Multi-Agent Routing Decisions Current in Enterprise Deployments**

## Keywords

agentic AI, multi-agent systems, query routing, memory systems, concept drift, model governance, financial services

---

## Abstract

**Motivation.** Enterprises are moving from single AI assistants to estates of specialised agents — one handling amendments to trade finance instruments, another issuance, a third general enquiries. As the estate grows, a new bottleneck appears: deciding which agent should handle each incoming request. This decision is made by a *router*, and its quality determines whether work reaches the right specialist or is misdirected, reworked, or escalated unnecessarily. In regulated industries the cost of misrouting is not only latency and compute; it is rework, inconsistent treatment of comparable cases, and an audit trail that is difficult to defend.

**The problem.** Routers conventionally decide by comparing a request against a written description of each agent's capabilities, registered when the agent is onboarded. This assumption fails in practice for a reason that has little to do with modelling and much to do with operations: **agents change continuously**. Prompts are revised, tools are added, underlying models are upgraded. Each change shifts what an agent can competently handle, while the routing logic continues to reflect the agent as it was at registration.

Recent research has responded by replacing written descriptions with *learned* evidence: routers that accumulate a memory of past interactions from live traffic and route by analogy to what has worked before. This is a genuine improvement, and reported gains are substantial. However, our review of recent work in this area identifies a shared and consequential limitation. Across four architecturally unrelated systems — one distilling accumulated evidence into refreshed capability descriptions, one appending interactions to a nearest-neighbour store, one encoding interaction history into graph neural network embeddings, and one deleting records found to conflict with fresh observations — **none is able to retire a memory while retaining it**. Knowledge can be added; it cannot be dated, scoped, or withdrawn.

The consequence is that when an agent's capability changes, every existing approach must either re-evaluate its entire benchmark against the changed agent, wait for accumulated statistics to drift, or discard the historical record altogether. Where systems record only *successful* interactions — a common design, since success is a natural quality filter — the situation is worse still: the system has no representation in which an agent becoming *less* capable can even be expressed.

**Proposed approach.** We propose treating routing memory as a **temporally versioned** record rather than an accumulating one. Each entry captures not only the request and the agent selected, but the set of agents that were plausible candidates, the observed outcome, the specific *version* of the agent involved, and a validity interval. When an agent is redeployed, the routing system does not need to infer that a change has occurred: in an enterprise setting a deployment is an observable, timestamped event recorded by the release pipeline. Every affected entry can therefore be marked superseded immediately — before the next request arrives — while remaining available for inspection.

Two properties follow, and both matter more in a regulated setting than in a research benchmark. First, invalidation is *localised and immediate*: the system knows precisely which historical evidence is no longer applicable and from what date, rather than discovering it through accumulated failure. Second, the historical record is *preserved*: it remains possible to reconstruct why a routing decision was reasonable at the time it was made — a requirement for auditability that approaches based on overwriting, compression, or deletion cannot satisfy.

We note explicitly that temporal versioning is not itself a novel mechanism; validity intervals and superseded records are long-established in data management practice. The contribution is the observation that routing memory is a setting in which this well-understood idea has not been applied, together with a quantification of what its absence costs.

**Evaluation design.** We evaluate on a purpose-built simulation in which agents are represented as competence regions over a query space. Overlapping regions produce genuinely contested requests, where more than one agent would succeed; requests outside every region are those for which no agent is appropriate and escalation is the correct outcome. Because capability is specified rather than inferred, a capability change can be introduced as a controlled intervention at a chosen point in the request stream — following an experimental methodology recently established for evaluating memory systems under environmental drift.

We compare versioned routing memory against static capability descriptions, a distillation-based learned-profile router, and contextual bandit routers including discounted and sliding-window variants, which represent the standard approach to non-stationarity. The primary measure is **recovery cost**: the number of misrouted requests incurred between a capability change and the restoration of pre-change routing accuracy. Secondary measures include cumulative regret, handling of contested requests, and correct abstention where no agent is suitable.

**Expected contributions.** (1) A characterisation of a shared limitation across current agent-routing systems: memory that accumulates but cannot expire. (2) A versioned routing-memory design in which invalidation is triggered by deployment events rather than inferred from degraded outcomes. (3) An openly available benchmark for agent routing under controlled capability shift, which to our knowledge does not currently exist — existing evaluations address *new* agents joining an estate, not *existing* agents whose behaviour has changed. (4) A discussion of the audit and governance implications for regulated deployments.

**Relevance to practice.** Organisations operating agent estates already experience this problem, typically as unexplained degradation in routing quality following unrelated agent updates. The mechanism we propose requires no retraining of the routing model and relies only on deployment metadata that release pipelines already produce, making it straightforward to adopt incrementally alongside an existing router.

---

*Word count (abstract body): ~940*

---

## Reviewer questions to expect

- *"You tell your method when the change happened; the baselines must infer it — is that fair?"* — The signal exists in any real deployment and is currently unused; we also report the case where no notification is available and change must be detected from outcomes.
- *"Versioned records are standard data management."* — Acknowledged explicitly above; the contribution is the application and the measured cost of its absence.
- *"Why simulation rather than production data?"* — Capability change must be controlled to be measured, and the benchmark must be reproducible. Production validation is complementary, not a substitute.
- *"Where is the dataset?"* — The generated benchmark, released with the simulation code.
