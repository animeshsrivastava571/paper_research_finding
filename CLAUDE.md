# CLAUDE.md

Research track of the Foundation Model Systems roadmap (`~/Documents/Tech_Roadmap_v4.pdf`, final section). Two decoupled outputs: an internal **agent router at CBA**, and a **paper** to a reviewed venue with proceedings. The router is useful whether or not the paper lands — don't let the paper drive the system design.

Owner: Animesh Srivastava. Day job context: production LangGraph/LangMem agents at CBA (Bank Guarantee RAG agent, BG Amendment agent).

---

## Where the argument stands

This has moved a long way from the roadmap's starting position. Read this section before proposing anything.

### 1. The original premise was falsified

The roadmap's claim — *"existing systems store capability profiles rather than routing decisions"* — **is false**. Verified by reading four papers end to end (`notes/01-premise-verification.md`).

- **BoundaryRouter** retrieves per-query behavioural records at routing time.
- **FlyRoute** retrieves per-agent success exemplars at routing time.
- BoundaryRouter's own ablation already shows "experience beats static profiles" (profile-only variant: 0.41–0.57; full method: 0.65–0.75).

**Do not reintroduce "remember decisions, not descriptions" as the novelty claim.** It's taken — an unreviewed arXiv preprint is still public, dated, citable prior art, and "it wasn't peer reviewed" is not a defence in review.

**But separate the claim from the evidence.** That ablation rests on 87 questions, with the Base Set doubling as the retrieval memory (so two of three test sets are effectively tested on their own training data), no repeated runs and no confidence intervals. The *direction* is established; the *magnitude* is not. Don't quote their +27.5% as settled, and it is fair to say in related work that the evidence is thin.

### 2. Decision memory goes stale too — this nearly killed the project

Animesh's objection, and it's correct: if memory says *"question A → Agent A, worked"* and Agent A then changes, that memory is now wrong. Memory doesn't fix staleness; it relocates it.

**The resolution, and it's now load-bearing:** both descriptions and decision records rot, but a decision record carries a **date and an agent name**, so you can draw a line through the store and say which entries are suspect. A description is one undated blob — when the agent changes, you cannot tell which half went wrong.

Consequence: **versioning is not a separate contribution, it's what makes decision-memory viable at all.** One idea with a mechanism, not four loose claims.

### 3. The reframed gap: nobody can *forget*

Everyone solved how to **build** routing memory. Nobody solved how to **maintain** it under change.

FlyRoute specifically cannot represent an agent getting *worse*, for two mechanical reasons in its own paper:
- Only quality-gated **successes** enter the store (`E ← E ∪ {new}`, nothing is ever removed). Failures leave no trace, so evidence of degradation cannot be recorded.
- Exploration uncertainty is `U = 1/(1+|E|^α)` — a large store means less re-probing. **An established agent that just changed is the least likely to be re-checked.** The error is self-reinforcing.

Working slogan: *FlyRoute can learn; it can't unlearn.*

### 4. How would a system even know an agent changed?

Two routes, and the distinction matters:

- **Told** — deploy events, version bumps, config changes. Cheap, exact, dated. This is the natural trigger for ending a validity interval. CBA plausibly has this in its deployment pipeline. FlyRoute has no hook for it and no version field to attach it to.
- **Inferred** — from outcomes: judge scores, user rephrasing, escalation to a human, work bouncing back. Slow and noisy. Note FlyRoute *already computes* a judge verdict and discards the failures — it detects what it cannot act on.

**Trap:** if the router stops sending traffic to an agent, it stops learning about that agent. Silence is not evidence, and a wrongly-demoted agent never recovers.

**This de-risks the research:** for the *paper*, drift is an intervention you cause, so detection isn't needed — you measure recovery speed. Detection is a *product* problem, not a paper problem.

### 5. What still stands as contribution

1. **Nobody stores the contested set.** Every store is keyed to one agent or a fixed solver pair. FlyRoute keeps the winner, drops the rest. BoundaryRouter runs both solvers every time, so no decision is ever made to record.
2. **Drift is unevaluated in routing** — FlyRoute names this as its own open limitation, verbatim, in its Limitations section. Quote it.
3. **Versioning vs. distillation** — FlyRoute calls distillation "profile compression" explicitly; GLOVE overwrites; SHIELDA names the failure without fixing it.
4. **"No route" is absent from every label space** — FlyRoute is single-gold; BoundaryRouter's rule is both-wrong → pick the agent.

### 6. The blocking problem

**How do you grade a close call?** Answer keys say "Agent B is correct." Your project is about cases where B *and* C are both reasonable. Call one correct and you discard the phenomenon; call both correct and every router scores 100%.

Nothing can be measured until this is settled — not the router, not the drift test.

Starting point, not a blank page: BoundaryRouter's ground-truth rule already resolves a 2-way close call by efficiency (both right → the faster one wins). Extend that to N agents, and replace their rule 3 (both wrong → pick the agent) with the decline case.

---

## Landscape facts worth keeping

- **None of the five key papers is peer reviewed.** FlyRoute, BoundaryRouter, SkillRouter, R3-Skill, GLOVE — all arXiv preprints, no venue, no journal ref. The publication route is open, and their numbers deserve less weight than reviewed work. They are still prior art for novelty.
- **FlyRoute's four agents are Huawei's own** (Huawei Cloud, Ascend, Kunpeng, HarmonyOS) — cleanly separated product lines, so contested cases are rare *by construction*. They owned every agent and still didn't run a capability-shift test. Its headline +17pp rests mostly on one domain (Server Hardware 37→81) whose description was hopeless.
- **GLOVE is the second premise risk**, not background reading. It does conflict detection between stored memory and fresh observation under controlled drift. Different setting (web nav / planning / control, not routing) and it *realigns* rather than versions — but it's the closest thing to the versioning leg. **Not yet read end to end.**
- **R3-Skill is mislabelled in the roadmap.** Its "rejections" are synthesis-time judgements that skills don't combine — not routing declines. The abstention angle is still open.
- **BoundaryRouter routes LLM-vs-agent** (escalation), not among an estate. Cite for mechanism, not as competitor. **FlyRoute is the competitor.**

---

## Repo conventions

```
notes/       working notes, numbered in reading order
summaries/   per-paper descriptive walkthroughs — Animesh reads these, then adds
             his own notes under the "## My notes" heading at the bottom
papers/      extracted plain text of papers read end to end
papers/raw/  source HTML as downloaded
```

- Papers are stored as **text**, not PDFs, because the questions that matter turn on method-section details (what the memory unit is, what enters the store, what is dropped) that abstracts consistently misrepresent. This project has already been burned twice by abstract-level reading.
- Extract with: download `arxiv.org/html/<id>`, strip tags with BeautifulSoup (`libs/` in the scratchpad has it).
- **Summaries are descriptive, not critical.** Explain what the paper does and how, then close with a "things to look at closely" section of *questions*, not conclusions — Animesh forms his own view first. Sharp critique belongs in `notes/`.
- Diagrams: **Mermaid** inside markdown (diffs in git, renders on GitHub). Markdown Preview Enhanced is installed. Draw.io only for polished paper figures.
- Every summary should record **venue status** — most of this literature is unreviewed preprints and that changes how much weight a claim gets.

## Working style

- **Plain language.** Short sentences, concrete analogies, no jargon-stacking. Explain mechanisms rather than naming them.
- Animesh pushes back hard and is usually right to — the "decision memories go stale too" and "how would it know retrospectively?" objections both reshaped the project. Treat challenges as substantive, not as requests for reassurance.
- Say plainly when something I asserted was unjustified.

---

## Status

| Step | State |
|---|---|
| Premise verification (roadmap's "read before committing" gate) | **done** — `notes/01-premise-verification.md` |
| FlyRoute summary | **done** — `summaries/flyroute.md` |
| BoundaryRouter / SkillRouter / R3-Skill summaries | not started |
| GLOVE end-to-end read | not started — promoted to premise risk |
| Close-call ground truth | **not started — blocks everything downstream** |
| Drift benchmark spec | not started |
| CBA disclosure review | not started — long lead time, start early |

## Open questions for Animesh

- **Does CBA have routing history?** The project needs a record of past routing decisions to learn from. If it exists, that's the dataset. If not, data collection precedes everything. Worth answering now, not in three months.
- Which CBA agents actually overlap enough to produce contested cases?
