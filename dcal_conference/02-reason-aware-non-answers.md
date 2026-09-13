# Idea 02 — Reason-aware non-answers in earnings call Q&A

**Status:** candidate, **not selected for BAICONF 2026**. Recorded 13 Sep 2026 for a future venue.
**Why not selected:** unverified on three fronts (see §5) while idea 01 is already de-risked, with six days to the abstract deadline.

---

## 1. The idea

Every quarter, listed companies hold earnings calls — management presents, analysts question, all publicly transcribed. **About 11% of analyst questions get a non-answer**, and research shows non-responses measurably shift analyst forecasts. Refusing to answer moves markets.

**[EvasionBench](https://arxiv.org/abs/2601.09142)** (2601.09142, CC BY 4.0) classifies these by **degree** — *direct → intermediate → fully evasive* — across 22.7M Q&A pairs from S&P Capital IQ transcripts, with a fine-tuned baseline (Eva-4B, 84.9% Macro-F1, beating Claude Opus 4.5 and GPT-5.2).

It measures **how much** was dodged. It never asks **why**.

## 2. Why "why" is the whole thing

Four fundamentally different reasons a CFO doesn't answer:

| Reason | What it sounds like |
|---|---|
| **Legally prohibited** | *"We're in a quiet period ahead of the transaction."* Pending M&A, live litigation, Reg FD |
| **Competitively sensitive** | *"We don't break out pricing by segment."* Legitimate commercial restraint |
| **Genuinely doesn't know** | *"I don't have that figure in front of me."* |
| **Actually evading** | *"Let's take that offline."* Knows, could say, chooses not to |

**Only the fourth is what analysts believe they are detecting.** The other three are lawful restraint.

A model scoring all four identically says a company in a quiet period is being shifty. That is a **systematically unfair inference about management**, and these models feed analyst tooling.

## 3. The gap is real and grounded in the accounting literature

**Gow, Larcker & Zakolyukina** already separate **"Refuse"** (mean 8.2% of questions) from **"Unable"** (3.6%).

> **Finance academics know non-answers have different causes. The ML benchmark collapses them into one scale.**

So this is not an invented distinction — it exists in the domain literature and is missing from the ML measurement.

## 4. The paper

1. Take a slice of EvasionBench
2. Add a **reason** label on top of the existing degree label
3. Measure how often current models — including the published baseline — call a legally-constrained non-answer "evasive"
4. Test whether reason is **predictable** from the text
5. Release the reason-labelled subset

**Headline to aim for:** *"X% of non-answers labelled evasive in the standard benchmark are legally or commercially constrained — they are not evasion at all."* If X is 25–35%, that is a measurement critique **with a number attached**.

**Why it is probably tractable:** managers usually *announce* the reason — *"quiet period"*, *"subject to ongoing litigation"*, *"we don't disclose that"*, *"I don't have it to hand"*. Surface lexical cues, not deep reasoning.

**Venue fit:** classic financial text analytics — maps to **Text Analytics**, **Text Mining** and **Sentiment Analysis**, and sits in the long tradition of earnings-call language research (tone, hedging, Loughran–McDonald). Business consequence is clear: mislabelled disclosure behaviour → wrong inference about management.

## 5. Must verify before this is viable

- [ ] **Read EvasionBench in full.** Confirm the taxonomy is genuinely degree-only with no reason dimension anywhere in the annotation schema. Current read is from the abstract — that has been wrong repeatedly in this project.
- [ ] **Data licence.** ⚠️ **The main risk.** EvasionBench derives from S&P Capital IQ transcripts; redistribution may be restricted. If so, the derived labelled set may not be releasable — which breaks BAICONF's mandatory-dataset requirement. *Fallback: public transcript sources exist.*
- [ ] **Novelty.** Has anyone added a reason dimension — legally compelled non-disclosure, Reg FD, quiet periods — to evasion detection? Unchecked, and it is the claim.
- [ ] **Labelling rubric.** "Legally constrained" needs a defensible definition. Ground it in Gow/Larcker/Zakolyukina's refuse/unable coding plus named securities-law categories.
- [ ] **Labelling volume.** How many examples can one domain expert realistically label in the time available?

## 6. Related

- **DualEvasion** ([2608.28040](https://arxiv.org/html/2608.28040)) — text + audio evasion, 505 pairs, Aug 2026
- *How do managers' non-responses during earnings calls affect analyst forecasts* ([2505.18419](https://pith.science/paper/2505.18419))
