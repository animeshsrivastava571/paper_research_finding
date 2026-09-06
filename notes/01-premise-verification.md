# Premise verification — memory-driven routing

**Gate:** the roadmap says *"The boundary-memory idea rests on the claim that existing systems store capability profiles rather than routing decisions. That claim comes from reading abstracts, not papers. Read FlyRoute, BoundaryRouter, SkillRouter and R3-Skill end to end first — if any of them already keep decision-level memory, the project changes shape."*

**Status:** gate cleared. All four read in full (arXiv HTML, saved under `papers/`). Plus GLOVE, SHIELDA and the abstention paper, which bear on the same question.

---

## Verdict

**The premise as written is false.** Two of the four already keep decision-level memory and retrieve it at routing time:

- **BoundaryRouter** retrieves per-query behavioural records to decide each route.
- **FlyRoute** retrieves per-agent success exemplars alongside the profile.

Worse for the original framing: **"decision-level evidence beats static profiles" has already been shown.** BoundaryRouter's own ablation table is exactly that experiment — its `Prompt Routing` variant routes "based only on these capability profiles" and is the weakest of three variants across all three backbones (0.41–0.57 vs 0.65–0.75 for the full method). That claim is no longer available as a contribution.

**Caveat on strength of evidence.** BoundaryRouter is an unreviewed arXiv preprint (as are all the papers here — see Sources). That does *not* free up the claim: it is public, dated 8 May 2026, indexed and citable, and "it wasn't peer reviewed" is not a defence in review. But it does mean the result is unvetted, and it is thin — 87 questions, the Base Set doubling as the retrieval memory (so two of three test sets are effectively tested on their own training data), no repeated runs, no confidence intervals. **The direction is established; the magnitude is not.** Re-establishing it properly at N-agent scale is a legitimate component of a larger contribution, though not a paper on its own.

**The project does not die, but the contribution moves.** It moves off *"decisions, not profiles"* and onto three narrower things that survive contact with the papers — and one of them is named as open by the closest competitor, in its own words.

---

## What each system actually stores

| | Stored memory? | The unit | Populated from | Records the outcome? | Records the *contest*? | Updated after deploy? | Evaluated under drift? |
|---|---|---|---|---|---|---|---|
| **SkillRouter** | none | — | — | — | — | — | — |
| **R3-Skill** | training data only | (query, skill-set, accept/reject + reason) | offline LLM synthesis | judge verdict, not deployment | set-compatibility, not agent contest | no — frozen into weights | no |
| **BoundaryRouter** | yes, retrieved at inference | (query, LLM output, agent output, both latencies) | offline seed set, **both** solvers run | **explicitly not** | no contest exists — both always run | no — built once | no |
| **FlyRoute** | yes, retrieved at inference | (query, response, quality score) attached to **one** agent | live routed traffic, quality-gated | successes only; failures dropped | no — only the winner is kept | yes, streaming + periodic distillation | **no — states this as its own limitation** |

### BoundaryRouter (`2605.07180`) — the closest thing to decision memory, and it isn't one

Memory is `M = {(x_i, y_LLM, y_Agent, t_LLM, t_Agent)}`, and the paper is emphatic: *"Crucially, we do not store gold answers, correctness labels, or rewards."*

Three things follow. It is a **behavioural probe corpus, not routing history** — it never records what the router chose or what happened next, because both solvers are run on every seed query. It is **static**: built once from an 87-question seed set (30 GAIA + 57 MMLU), never appended to at deployment. And it is **binary** — LLM vs. one agent pipeline. Their own closing line: *"our current framework focuses on binary routing between an LLM and a single agent pipeline; future work may explore more complex routing scenarios involving multiple agents."*

Note also its ground-truth rule: *"If both solvers are incorrect, choose the agent."* Declining is not representable in the label space.

### FlyRoute (`2605.22057`) — the real competitor, and it hands you the gap

Profile = (seed description, learned description, success store `E_i = {(q_j, r_j, s_j)}` with `s_j ≥ θ`). Only quality-gated **successes** enter, attached to a single agent. Distillation is described in the paper as *"profile compression"* — precisely the operation the boundary-memory argument objects to.

Then, from its Limitations section, verbatim:

> "A second limitation concerns the distinction between profile evolution and agent evolution. FlyRoute is motivated by real deployments in which agent capabilities change over time through prompt updates, tool additions, or model replacements. **However, our experiments evaluate continual profile refinement under a largely stationary set of expert agents rather than performing controlled capability-shift interventions. Demonstrating adaptation under explicit prompt, tool, or model changes remains an important direction for future work.**"

That is the drift experiment from the roadmap, declared open by the group best positioned to have run it. It is the single most valuable sentence found in this pass.

Also relevant: FlyRoute is single-gold — *"Each benchmark example pairs a query `q` with exactly one supervising specialist"* — so contested cases are definitionally absent, and the benchmark is proprietary Huawei enterprise support logs, so **no direct comparison on their data is possible**.

### SkillRouter (`2603.22455`) — no memory, but a useful result

Pure retrieve-and-rerank over ~80K skills; no history, no adaptation. Its finding is independent support for the motivation from a different direction: hiding the skill **body** and routing on descriptions alone costs **37–44 percentage points** of accuracy, and body-distilled descriptions still trail direct all-field routing by 7–21 points. Descriptions really are lossy. SkillRouter's answer is "read the whole body"; it is not "remember what happened."

### R3-Skill (`2606.03565`) — the roadmap mislabels this one

Actual title: *"Skill Is Not Document: Query-Conditioned Compatibility for LLM Agent Skill Routing."* The roadmap glosses it as *"rejection as a routing resource"*, which reads as declining to route. It is not that. The retained rejections are **synthesis-time LLM judgements that a sampled skill combination isn't naturally combinable** — negative supervision for training an embedder and reranker, not deployment decisions, not retrievable, not a decline. Their own result is that the signal *"is stage-dependent, helping cross-encoder reranking while providing no benefit for the tested bi-encoder objective."*

**Do not cite this as prior work on abstention.** The abstention leg is not occupied by it.

### Three from the roadmap's own list that matter here

- **GLOVE** (`2601.19249`) — the sharpest threat to the versioning leg, and it wasn't flagged as one. It detects conflicts between stored memory and fresh observations by active probing, and evaluates on benchmarks *"augmented with controlled environmental drifts."* Someone has already done drift-with-controlled-interventions on agent memory. Two distinctions preserve room: it operates on task memory in web-nav/planning/control environments, **not routing**; and it *realigns* — updates entries toward the environment — which is closer to FlyRoute's overwrite than to keep-and-supersede. Cite it, position against it, don't ignore it.
- **SHIELDA** (`2508.07935`) — the roadmap's gloss is accurate (I initially doubted it; checked the full text). It names "Outdated Memory" and "misaligned experience replay" as exception types in a 36-type taxonomy. It is a taxonomy plus a handling framework, validated on one case study — it names the failure modes without measuring them in routing. Useful for vocabulary and for justifying why staleness deserves a mechanism.
- **Designing for Doubt** (`2606.02965`) — position paper with preliminary eval (144 scenarios, 7 model families), arguing benchmarks embed "compliance bias" by rewarding agents for proceeding. It establishes the problem for the alignment leg; it does not build a router with declining as an outcome. That space is open.

---

## What survives

**1. Nobody stores the contested set.** Every store above is keyed to a single agent or a fixed solver pair. FlyRoute keeps the winner and drops the rest — a near-miss on a competing agent leaves no trace. BoundaryRouter runs both solvers every time, so no decision is ever made to record. *The boundary between two plausible agents is not in any of these stores.* This is the strongest survivor and it is the original insight, intact but narrowed: not "decisions vs profiles", but **the contest specifically**.

**2. Drift is unevaluated in routing.** FlyRoute names it as future work. BoundaryRouter's memory is frozen. SkillRouter has none. GLOVE does controlled drift but not for routing. The roadmap's chosen experiment — *change an agent's capability partway through the query stream and measure adaptation rate* — is open.

**3. Versioning vs. distillation is a live technical disagreement, not a strawman.** FlyRoute compresses by design; GLOVE overwrites; SHIELDA names the resulting failure without fixing it at the store level. Keep-and-supersede with validity intervals is untried in routing.

**4. "No route" is absent from every label space.** FlyRoute: single-gold. BoundaryRouter: both-wrong falls back to the agent. R3-Skill: rejection means skill-set incompatibility. The reward-signal leg — task success is wrong whenever the correct route was no route — stands unoccupied.

## Reshaped claim

> Routing memory should record the **boundary event** — which agents were plausible, which was chosen, what happened — kept as a **versioned, superseded-not-overwritten** record, evaluated under **controlled capability shift**, with **declining** as a first-class outcome.

Every clause now does work that a specific paper does not do. Compare with the original framing, where the load-bearing clause ("decisions, not profiles") was already carrying published results.

## Risks this pass surfaced

- **You cannot benchmark against FlyRoute directly.** Proprietary data, Huawei internal. Reproduce the method on your own benchmark or don't claim the comparison.
- **The benchmark may be the bigger contribution than the router.** No public N-agent routing benchmark with controlled capability shift exists. RouteBench is binary and 87 questions. Building the drift benchmark is defensible standalone work — and it's what FlyRoute's limitation is asking for.
- **Single-gold labelling is universal, and contested cases are by definition not single-gold.** You need a ground-truth story for "both were plausible" before any of this is measurable. Unsolved, and load-bearing.
- **GLOVE overlaps more than expected.** Re-read it end to end before writing the versioning section.

## Next

1. Read GLOVE end to end — it is now the second premise risk, and it wasn't on the original gate list.
2. Decide the ground-truth definition for a contested routing case. Everything downstream blocks on this.
3. Specify the drift benchmark: N agents, a capability-shift intervention mid-stream, adaptation rate as the metric. Quote FlyRoute's limitation in the motivation — it is the strongest available justification.
4. Start the CBA disclosure review (roadmap flags this as the real schedule risk; begin while drafting).

## Corrections to fold back into the roadmap

- **R3-Skill** is *"Skill Is Not Document"*, about query-conditioned set compatibility. "Rejection as a routing resource" overstates it — its rejections are synthesis-time, not routing declines.
- **BoundaryRouter** routes **LLM vs. agent** (an escalation decision), not among an agent estate. It is a different problem from yours; cite it for the experience-memory mechanism and for the profiles-lose ablation, not as a competitor.
- **FlyRoute** is the actual competitor, and the landscape line in the roadmap describes it correctly.
- **GLOVE** deserves promotion from the Memory reading list to the premise-risk list.

## Sources

| Paper | arXiv | Local |
|---|---|---|
| FlyRoute: Self-Evolving Agent Profiling via Data Flywheel | [2605.22057](https://arxiv.org/abs/2605.22057) v2 | `papers/2605.22057.txt` |
| Learning Agent Routing From Early Experience (BoundaryRouter / RouteBench) | [2605.07180](https://arxiv.org/abs/2605.07180) v1 | `papers/2605.07180.txt` |
| SkillRouter: Skill Routing for LLM Agents at Scale | [2603.22455](https://arxiv.org/abs/2603.22455) v3 | `papers/2603.22455.txt` |
| Skill Is Not Document (R3-Skill) | [2606.03565](https://arxiv.org/abs/2606.03565) v3 | `papers/2606.03565.txt` |
| GLOVE: Global Verifier for LLM Memory-Environment Realignment | [2601.19249](https://arxiv.org/abs/2601.19249) | abstract only |
| SHIELDA: Structured Handling of Exceptions in LLM-Driven Agentic Workflows | [2508.07935](https://arxiv.org/abs/2508.07935) | `papers/raw/` |
| Designing for Doubt: Informed Abstention in Autonomous Agents | [2606.02965](https://arxiv.org/abs/2606.02965) | abstract only |
