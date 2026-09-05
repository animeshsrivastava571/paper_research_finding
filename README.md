# Research track — memory-driven routing

Working repo for the research track of the Foundation Model Systems roadmap (v4).

**Goal:** a router at CBA that learns from its own routing history, plus a paper to a reviewed AI venue. The two outputs run on separate timelines and are deliberately not coupled — the internal system is useful whether or not anything is accepted.

## Status

| Step | State |
|---|---|
| Premise verification (roadmap's "read before committing" gate) | **done** — [`notes/01-premise-verification.md`](notes/01-premise-verification.md) |
| FlyRoute walkthrough | **done** — [`summaries/flyroute.md`](summaries/flyroute.md) |
| BoundaryRouter / SkillRouter / R3-Skill walkthroughs | not started |
| GLOVE end-to-end read | not started — promoted to premise risk |
| Ground-truth definition for contested routing cases | not started — **blocks everything downstream** |
| Drift benchmark spec | not started |
| CBA disclosure review | not started — long lead, start early |

Full working context in [`CLAUDE.md`](CLAUDE.md).

## Where the premise landed

The original claim — *existing systems store capability profiles rather than routing decisions* — **did not survive**. BoundaryRouter and FlyRoute both keep and retrieve decision-level evidence, and BoundaryRouter's ablation already publishes the "experience beats profiles" result.

What survives is narrower and better defined: nobody stores the **contested set**, nobody evaluates **drift** in routing (FlyRoute names this as its own open limitation), versioning-vs-distillation is genuinely untried, and **"no route"** is missing from every label space examined.

## Layout

```
notes/     working notes, numbered in reading order
papers/    extracted full text of papers read end to end
papers/raw/  source HTML as downloaded
```

Papers are stored as text because the premise questions turn on method-section details — what the memory unit is, what enters the store, what is dropped — that abstracts consistently misrepresent.
