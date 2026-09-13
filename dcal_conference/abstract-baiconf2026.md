# BAICONF 2026 — abstract submission

**Deadline:** 19 September 2026 · **Conference:** 17–19 December 2026
**Limit:** ≤500 words, structured *background · need · aims · methods · expected findings*
**Theme:** Text Analytics (primary) · Text Mining (secondary)
**Keywords:** financial text analytics, multi-agent systems, agent memory, information loss, disclosure quality

> ⚠️ **Before submitting:** (1) email `baiconf2026@iimb.ac.in` on what the IIMB Management Review route commits to — it decides whether FinNLP/ICAIF stay open; (2) confirm nothing CBA-internal. This draft contains no internal references and uses only public data.

---

## Title

**Lost in Handoff: Memory-Induced Errors in Multi-Agent Financial Document Systems**

*Alternatives considered:*
- *When the Number Loses Its Label: Measuring and Preventing Memory-Induced Errors in Financial Document Analysis* — accurate but single-agent, and does not signal the multi-agent scope
- *Broken Telephone: Qualifier Loss in Multi-Agent Financial Document Analysis* — apt metaphor (each round re-summarises the previous summary) but **rejected: the idiom does not travel.** Known as "Chinese whispers" in Indian and British English, "telephone" in American, and a title that needs explaining is a bad title
- *"Revenue Was 233": Measuring Qualifier Loss in Conversational Financial Document Analysis* — uses the paper's own example as the hook; more memorable, slightly riskier with a conservative reviewer
- *Measuring Qualifier Loss in Agent Memory for Financial Document Analysis* — plain and safe, no hook

*Rejected: "When the Agent Remembers the Wrong Year…" — too narrow. The scope is four qualifier types (period, entity, scale, basis), not just the year, and scale and basis errors are the more dangerous ones.*

---

## Abstract

**Background.** Analysts increasingly work with AI assistants over financial documents — filings, credit files, transactions — across long sessions, revisiting the same firms. To stay within context limits they compress history and persist facts across sessions, both library defaults. In multi-agent systems memory is shared and compressed again at each handoff. Compression is unavoidable at scale; its cost on financial text is unmeasured.

**Need.** Drop "millions" from a figure and the answer is wrong by a thousandfold while looking normal. "Revenue was 233" is not a fact until one knows whose, when, and in what unit. A running summary is one prose string under a fixed budget, re-compressed each round from the previous summary: there is nowhere for a qualifier to live, and instruction cannot create a slot that does not exist. The failure is silent: an unqualified figure can be correct and still mislead, so nothing looks wrong and nothing gets checked. Compression harms three ways: omitting what should be kept, carrying wrong values forward, and stripping figures of the context that gives them meaning. Only the third is distinctive to finance, where accounting mandates context. Recent work shows compression can change the investment judgment a source supports; where these errors arise is unknown.

**Aims.** First, we quantify five failure modes spanning those families — dilution, error propagation, staleness, cross-entity contamination, handoff loss — and localise where qualifiers are lost. Second, we ask whether the loss is instructional or structural, and propose a structural remedy: typed facts carrying mandatory entity, period and unit context, so qualifiers are schema fields rather than prose, with context-matched retrieval. Financial reporting mandates such a representation — XBRL — which agent memory discards. An instructed summariser is the control.

**Methods.** We evaluate on ConvFinQA — 3,892 multi-turn analyst conversations over FinQA's S&P 500 annual reports, 1999–2019 — whose identifiers carry company and year, so cross-period and cross-entity conditions arise naturally. Because conversations average under four turns — too short to trigger summarisation — we chain them into sessions of 15–20. Identical question sets run through a two-agent pipeline — retrieval and analysis, sharing memory — under five conditions: no memory (floor); a widely used memory library at its defaults; the same library with qualifier-preserving instructions; with typed facts, context-matched retrieval and entity-scoped storage; and full history without summarisation (ceiling). Correctness is verified numerically against executed reference answers; retention by extracting fields from memory and comparing them to source.

**Expected findings.** We expect retention to fall sharply once summarisation triggers, degrading further each round and handoff, with unit lost sooner than period. We expect entity-agnostic storage to produce cross-entity contamination, rising with sector similarity. We expect instruction to prove insufficient and structure to be necessary: a prose summary has no field to protect. Three deliverables follow: a loss profile across configurations and modes, as residuals against the ceiling; a turn threshold beyond which retention degrades, with guidance on which setting fixes which failure; and a released evaluation set of cross-period and cross-entity pairs.

---

*Word count (abstract body): 498 — 2 words under the limit*

## Reviewer questions to expect

- *"Isn't this just a known property of summarisation?"* — Known in general; unmeasured on financial text, where qualifiers are mandatory rather than stylistic and the error magnitudes are large.
- *"Why this library?"* — Because the question is what shipped **defaults** do to practitioners who adopt them unchanged. That is necessarily library-specific.
- *"If the default prompt is poor, why not just write a better one? The library allows it."* — **The strongest objection, and the abstract is now framed to defeat it.** The cause is not the prompt: a running summary is a flat string under a fixed budget, re-compressed each round from the previous summary, so there is no field a qualifier can occupy. Instruction cannot create one. The instructed summariser is therefore a **control arm**, not the remedy — it is the obvious fix, tested and expected to fail. The remedy is structural: typed memory and entity-scoped storage. And a prompt does nothing for three of five modes, which live in the store and the graph rather than the summariser.
- *"What if the effect is small?"* — A go/no-go check on ~50 cross-year pairs runs before the full study; a null result stops the work rather than being written up as one.
- *"Where is the dataset?"* — The derived cross-period and cross-entity pairs, released as CSV and Excel.
