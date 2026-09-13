# Idea 03 — Do agent task-completion metrics agree on financial tasks?

**Status:** candidate, **not selected for BAICONF 2026**. Recorded 13 Sep 2026 for a future venue.
**Why not selected:** novelty unchecked, and it requires building a multi-agent system before any measurement can start — while idea 01 is already de-risked with six days to the deadline.

---

## 1. The idea

Practitioners pick an agent completion metric essentially at random. **Nobody has checked whether the standard ones give the same answer about the same system** — and nobody has checked it on financial tasks at all.

**Precedent for the study design exists** — voice agents ([2608.24314](https://arxiv.org/abs/2608.24314)) and legal agents (human-expert agreement only **κ=0.344**; LLM-vs-human 0.229–0.358 on subjective dimensions). **Neither covers finance.**

## 2. Source read 13 Sep — the metrics differ *mechanically*

**RAGAS `AgentGoalAccuracy`** — `src/ragas/metrics/_goal_accuracy.py`

Two LLM calls: infer `user_goal` + `end_state` from the workflow, then compare. Prompt: *"identify if they are **the same (1) or different (0)**"*.

```python
output_type = MetricOutputType.BINARY
verdict: t.Literal["0", "1"]
```

Two variants — `WithReference` (compares against a human-written `reference`) and `WithoutReference` (compares against the goal it inferred).

**DeepEval `TaskCompletionMetric`** — `deepeval/metrics/task_completion/`

Two LLM calls: extract `task` + `task_outcome`, explicitly *"solely factual, derived strictly from the workflow... **without any reasoning involved**"*, then score *"**how well** the actual outcome aligns"*.

```python
verdict: float   # 0.0 – 1.0
```

Its own example scores a partially-planned trip **0.85**.

| | RAGAS | DeepEval |
|---|---|---|
| Output | **binary 0/1** | **continuous 0–1** |
| Partial credit | none | yes |
| Goal source | inferred **or** human reference | **always inferred** |
| Judge asks | *"are they the same?"* | *"how well does it align?"* |

## 3. Four hypotheses, each with a mechanism

1. **Partial completion.** Agent answers 3 of 4 sub-questions. DeepEval ≈0.75; RAGAS must round to 0 or 1, arbitrarily. **Financial queries are frequently partial**, so this is the common case.
2. **Self-defined success criterion.** DeepEval extracts the task *from the workflow, including the agent's own response* — so an agent that confidently answers the **wrong question** has its misreading treated as the task and scores high. RAGAS-`WithReference` catches this; `WithoutReference` shares the flaw.
3. **Claimed vs actual success.** DeepEval instructs factual extraction; RAGAS does not. Different sensitivity to an agent that merely *says* it succeeded.
4. **Read-only tasks.** τ-bench's own documented limitation: *"on tasks that do not change the database state... agents can get positive evaluation results by **doing nothing**."* Most financial agent work is read-only, so state-based completion is structurally unavailable and both metrics collapse to judging text.

## 4. A fifth dimension — rich responses

Modern agent responses include charts, tables and UI components, not just text.

**Both metrics flatten the trajectory to a string** — RAGAS via `sample.pretty_repr()`, DeepEval via a text workflow. So when an agent returns a chart, the metric sees a serialised blob or nothing. **They are structurally blind to rich responses.**

And the irony: **a chart is *more* evaluable than prose**, because a chart spec is structured data. You can deterministically check whether its numbers match the tool output, whether the y-axis is zero-based, whether units are labelled. You cannot do any of that to a sentence.

**Standardisation approach:** normalise any chart format (Vega-Lite / Plotly / ECharts / LangGraph `push_ui_message` props / AG-UI events) into a minimal intermediate representation — `series`, `mark`, `axes`, `labels`, `source` — then run the checks once against the IR.

⚠️ **But this specific angle is heavily occupied** — see §6.

## 5. Design sketch

Build a small multi-agent financial system (2 RAG agents + 2 task agents) over public financial data. Run identical trajectories through RAGAS `AgentGoalAccuracy` (both variants), DeepEval `TaskCompletionMetric`, a plain LLM judge, and a reference-based check. Measure pairwise agreement, agreement with expert human labels, and where divergence is **systematic rather than noisy**.

**Headline shape:** *"On financial agent tasks these metrics agree only X% of the time. The divergence is systematic and traceable to two design choices — binary vs graded scoring, and self-inferred vs referenced goals. Here is which to use when."*

**Strengths:** nothing to invent; the result is near-guaranteed by construction (binary vs graded *must* disagree on partial tasks); no licence risk; the released dataset is your own trajectories and labels; and the human ground truth requires banking domain expertise — the one input nobody else can easily supply.

## 6. Rich-response angle: already occupied

Checked 13 Sep. **Do not build the chart-evaluation half as a contribution:**

| Work | Covers |
|---|---|
| **EvidFuse** ([2601.05487](https://arxiv.org/pdf/2601.05487)) | *"Writing-Time Evidence Learning for Consistent **Text-Chart** Data Reporting"* — the exact text/chart contradiction failure mode. Measured: 79% of claims faithful |
| **ChartAnchor** ([2512.01017](https://arxiv.org/pdf/2512.01017)) | *"functional correctness, visual integrity, and data faithfulness"* |
| **DV-World** ([2604.25914](https://arxiv.org/html/2604.25914.pdf)) | benchmarking **data visualization agents** |
| **EvoGenUI-Bench** ([2608.29387](https://arxiv.org/html/2608.29387)) | **multi-turn** generative UI, evidence-grounded |
| **MMDeepResearch-Bench** ([2601.12346](https://arxiv.org/pdf/2601.12346)) | multimodal deep research agents |
| Plus | VegaChat, FlowEval, WebCoderBench, FrontendBench, UXBench, Misleading ChartQA, MisVisFix |

**What may survive:** none of these is financial, and none frames misleading charts as a **regulatory** matter — financial promotions must be *"fair, clear and not misleading"*, so an agent rendering a truncated-axis performance chart creates compliance exposure, not merely a viz sin. Unverified.

## 7. To verify before this is viable

- [ ] **Has a metric-agreement study been done for general or financial agents?** Voice and legal exist; finance appears open. This is the novelty claim and it is **unchecked**.
- [ ] Confirm both libraries run on the same trajectory without contortion (RAGAS wants `MultiTurnSample`; DeepEval wants its own trace shape).
- [ ] Decide the human-labelling rubric and how many trajectories one expert can realistically label.
