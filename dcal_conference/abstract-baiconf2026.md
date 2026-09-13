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

**Background.** Analysts increasingly work with AI assistants over financial documents — filings, credit files, transaction records — asking related questions across long sessions and revisiting the same companies. To stay within context limits they compress conversation history and persist facts across sessions — both defaults in widely used memory libraries. In multi-agent deployments memory is shared between agents and compressed again at each handoff. Compression is unavoidable at scale; its cost on financial text is unmeasured.

**Need.** Drop "millions" from a figure and the answer is wrong by a factor of a thousand while looking entirely normal. A financial figure is meaningless without its qualifiers — period, entity, scale, and the basis on which it was prepared. "Revenue was 233" is not a fact until one knows whose and when. Default summarisation prompts never mention these; to a compressor, qualifiers read as redundancy. The resulting failure is silent: an unqualified figure can be literally correct and still mislead, so nothing looks wrong and nothing gets checked. The same loss yields prior-year figures for current-year questions, and one company's figures in another's analysis. Recent work shows compression can change the investment judgment a source supports; where these errors originate is unknown.

**Aims.** The study has two parts. First, we quantify five failure modes — context dilution, error propagation, temporal staleness, cross-entity contamination, and loss at inter-agent handoff — localise where qualifiers are lost, and establish which are most fragile. Second, we evaluate a remedy: qualifier-preserving summarisation instructions, structured fact schemas carrying period, entity, scale and basis, and entity-scoped storage. All are documented parameters of existing libraries, not new software, adoptable without re-engineering.

**Methods.** We evaluate on ConvFinQA and FinQA: multi-turn analyst conversations over S&P 500 annual reports, 1999–2019. Company and year are recoverable from record identifiers, so cross-period and cross-entity conditions arise naturally. Because conversations average under four turns — too short to trigger summarisation — we chain same-company conversations into sessions of fifteen to twenty turns. Identical question sets run through a two-agent pipeline — retrieval and analysis, sharing memory — under five conditions: no memory (floor); a widely used memory library at its shipped defaults; the same library with qualifier-preserving summarisation instructions; with structured fact schemas and entity-scoped storage; and full history without summarisation (ceiling). Correctness is verified numerically against executed reference answers, not by model judgement.

**Expected findings.** We expect retention to fall sharply once summarisation triggers, degrading further each round and handoff, with scale lost more readily than period. We expect entity-agnostic storage to produce cross-entity contamination, rising with sector similarity. We expect the loss to prove structural rather than instructional: with a fixed summary budget and each round re-compressing the last, instructing the summariser should not suffice, and structured storage should be required. Three deliverables follow: a loss profile across configurations and failure modes, as residuals against the ceiling; a turn threshold beyond which retention degrades, with guidance on which setting fixes which failure; and a released evaluation set of cross-period and cross-entity pairs.

---

*Word count (abstract body): 498 — 2 words under the limit*

## Reviewer questions to expect

- *"Isn't this just a known property of summarisation?"* — Known in general; unmeasured on financial text, where qualifiers are mandatory rather than stylistic and the error magnitudes are large.
- *"Why this library?"* — Because the question is what shipped **defaults** do to practitioners who adopt them unchanged. That is necessarily library-specific.
- *"If the default prompt is poor, why not just write a better one? The library allows it."* — **The strongest objection.** Three answers: defaults are what gets deployed, and quantifying their cost is what tells practitioners to change them; we *test* whether a better prompt works, and expect it to be insufficient alone (fixed summary budget, and each round re-compresses the last rather than the original); and a prompt does nothing for cross-company bleed, handoff loss or cross-session staleness — three of five modes live in the store and the graph, not the summariser.
- *"What if the effect is small?"* — A go/no-go check on ~50 cross-year pairs runs before the full study; a null result stops the work rather than being written up as one.
- *"Where is the dataset?"* — The derived cross-period and cross-entity pairs, released as CSV and Excel.
