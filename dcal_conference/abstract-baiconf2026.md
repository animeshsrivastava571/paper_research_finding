# BAICONF 2026 — abstract submission

**Deadline:** 19 September 2026 · **Conference:** 17–19 December 2026
**Limit:** ≤500 words, structured *background · need · aims · methods · expected findings*
**Theme:** Text Analytics (primary) · Text Mining (secondary)
**Keywords:** financial text analytics, conversational agents, memory systems, information loss, disclosure quality

> ⚠️ **Before submitting:** (1) email `baiconf2026@iimb.ac.in` on what the IIMB Management Review route commits to — it decides whether FinNLP/ICAIF stay open; (2) confirm nothing CBA-internal. This draft contains no internal references and uses only public data.

---

## Title

**When the Agent Remembers the Wrong Year: Measuring Memory-Induced Errors in Financial Document Analysis**

---

## Abstract

**Background.** Analysts increasingly work with conversational AI assistants over financial filings, asking sequences of related questions across long sessions and returning to the same companies over time. To remain within context limits, these systems compress conversation history into running summaries and persist extracted facts across sessions. Both behaviours now ship as defaults in widely used agent memory libraries. Compression is necessary and unavoidable at scale. Its cost, on financial text specifically, has not been measured.

**Need.** A financial figure is meaningless without its qualifiers: the fiscal period it belongs to, the entity it describes, and its scale. "Revenue was 233" is not a fact until one knows whose, when, and in what units — accounting standards exist largely to fix precisely these attributes. Summarisation, optimised for brevity, discards them, because qualifiers read as redundancy to a compressor. The consequences are decision-level rather than cosmetic: an assistant may answer a current-year question with a prior year's figure, omit "millions" from a value (an error of three orders of magnitude), or surface one company's figures within another's analysis. Recent work shows that compressing financial source material can change the investment judgment that material supports; where those errors originate, and which design choices cause them, remains unmeasured.

**Aims.** We quantify four memory-induced failure modes in financial document agents — context dilution, error propagation, temporal staleness, and cross-entity contamination — and identify which configuration choices produce them. We additionally localise where qualifiers are lost along the pipeline, and test which qualifier types prove most fragile.

**Methods.** We evaluate on ConvFinQA and FinQA: multi-turn analyst-style conversations grounded in S&P 500 annual reports from 1999 to 2019. Company and reporting year are recoverable from record identifiers, so cross-period and cross-entity conditions arise naturally rather than synthetically. Because individual conversations average under four turns — too short to trigger summarisation — we chain conversations on the same company into sessions of fifteen to twenty turns. Identical question sets are then run under five conditions: no memory (floor); a widely used memory library at its shipped defaults; the same library with qualifier-preserving summarisation instructions; with structured fact schemas and entity-scoped storage; and full history without summarisation (ceiling). Correctness is verified numerically against executed reference answers rather than by model judgement.

**Expected findings.** We expect qualifier retention to fall sharply once summarisation triggers and to degrade further with each subsequent round, with scale and unit qualifiers lost more readily than fiscal periods. We expect entity-agnostic default storage to produce measurable cross-entity contamination, rising with sector similarity. We anticipate that configuration changes recover a substantial but incomplete share of the ceiling, and will report residuals against that ceiling rather than improvements over the default. The derived evaluation set will be released.

---

*Word count (abstract body): 451 — 49 words of headroom under the 500 limit*

## Reviewer questions to expect

- *"Isn't this just a known property of summarisation?"* — Known in general; unmeasured on financial text, where qualifiers are mandatory rather than stylistic and the error magnitudes are large.
- *"Why this library?"* — Because the question is what shipped **defaults** do to practitioners who adopt them unchanged. That is necessarily library-specific.
- *"What if the effect is small?"* — A go/no-go check on ~50 cross-year pairs runs before the full study; a null result stops the work rather than being written up as one.
- *"Where is the dataset?"* — The derived cross-period and cross-entity pairs, released as CSV and Excel.
