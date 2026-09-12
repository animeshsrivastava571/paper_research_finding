# Research track — memory-driven routing

Working repo for the research track of the Foundation Model Systems roadmap (v4).

**Goal:** a router at CBA that learns from its own routing history, plus a paper to a reviewed AI venue. The two outputs run on separate timelines and are deliberately not coupled — the internal system is useful whether or not anything is accepted.

## Status

| Step | State |
|---|---|
| Premise verification (roadmap's "read before committing" gate) | **done** — [`notes/01-premise-verification.md`](notes/01-premise-verification.md) |
| FlyRoute walkthrough | **done** — [`summaries/flyroute.md`](summaries/flyroute.md) |
| BoundaryRouter, GraphPlanner, GLOVE walkthroughs | **done** — `summaries/` |
| SkillRouter / R3-Skill walkthroughs | not started — background only, low priority |
| Landscape survey | **done** — [`notes/02-landscape-survey.md`](notes/02-landscape-survey.md) |
| GLOVE end-to-end read | **done** — [`summaries/glove.md`](summaries/glove.md) |
| Ground-truth for contested cases | **dissolved for the paper** — defined by construction in simulation (the overlap region). Still open for the CBA product. |
| **Idea 01 — versioned routing memory** | **designed** — [`ideas/01-versioned-routing-memory.md`](ideas/01-versioned-routing-memory.md) |
| Build: simulated world + drift intervention | not started — next |
| **BAICONF 2026 — idea 01 locked** | [`dcal_conference/01-memory-qualifier-loss.md`](dcal_conference/01-memory-qualifier-loss.md) · more candidates to come |
| BAICONF abstract (500 words) | **not written — due 19 Sep 2026** |
| CBA disclosure review | not started — long lead, start early |

Full working context in [`CLAUDE.md`](CLAUDE.md).

## Where it landed

The original claim — *existing systems store capability profiles rather than routing decisions* — **did not survive**. BoundaryRouter and FlyRoute both keep and retrieve decision-level evidence, and BoundaryRouter's ablation already shows "experience beats profiles".

What replaced it, after six papers read end to end: **every routing memory system can add records, and none can retire one while keeping it.**

| System | How memory is maintained | Old record survives? |
|---|---|---|
| FlyRoute | distils successes into a description | no — compressed away |
| Agent-as-a-Router | appends to a kNN vector store | nothing is ever retired |
| GraphPlanner | blends into GNN node embeddings | no — *"no explicit temporal edges"* |
| GLOVE | `D ← D \ N` | no — explicitly deleted |

Four unrelated architectures, the same gap. And nobody evaluates drift: the field solves **cold start** (a new agent, no history) and leaves **drift** (an existing agent whose history is now wrong) untouched.

The proposal is in [`ideas/01-versioned-routing-memory.md`](ideas/01-versioned-routing-memory.md).

## Layout

```
ideas/       proposed work, numbered — start here
dcal_conference/  BAICONF 2026 candidates + venue constraints
notes/       working notes, numbered in reading order
summaries/   per-paper walkthroughs, each with a relevance verdict
submissions/ conference submissions in progress
scripts/     fetch_papers.sh regenerates the gitignored paper texts
papers/      extracted full text of papers read end to end (gitignored)
```

Papers are stored as text because the premise questions turn on method-section details — what the memory unit is, what enters the store, what is dropped — that abstracts consistently misrepresent.
