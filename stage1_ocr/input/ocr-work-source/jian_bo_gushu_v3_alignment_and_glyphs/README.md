# Jian Bo Gushu — PAGE XML alignment revision and glyph archive (v3)

## Status
**Partially visually corrected — not fully verified Ground Truth.** All 20 pages are included, but every individual line has NOT been compared character-by-character against the scanned images. Do not mark these as verified Ground Truth without a final review.

## What changed from v2
* Corrected scan-confirmed line-break errors on selected strips of pages 1, 13, 19 and 20, and checked the year split on page 7. For instance, the full printed year `2013` now remains at the end of its printed line on page 19.
* Applied 58 additional *typographic* line-boundary adjustments throughout the 20-page set (mainly moving non-initial Chinese punctuation and completing numerals). These are **NOT all individually visually verified**; see `review/changes.csv`. The change log differentiates them from visually anchored corrections.
* Extracted **11 historical glyph images** embedded directly in the original DOCX. Previous plain-text extraction omitted them. The glyphs are stored in `glyph_images/IMAGE_0001.png` through `IMAGE_0011.png` and inserted at their matching text positions in PAGE XML as textual tokens `⟦IMAGE_0001⟧`, etc. Exact locations are in `review/glyph_reference_manifest.csv`.
* Retained v2 improvements: subscript equals sign `₌`, CJK editorial brackets `〈 〉`, previous alignment improvements and 20 original page scans.
* Preserved all existing geometry: region coordinates, line IDs, baselines and line polygons.

## Contents
* `page_xml/` — 20 revised PAGE XML files
* `images/` — original 20 scans
* `glyph_images/` — 11 recovered PNG glyphs
* `glyph_catalogue.png` — visual index to glyph references
* `review/glyph_reference_manifest.csv` — glyph, original Word media, page, region and TextLine mapping
* `review/training_exclusions.csv` — lines containing unresolved image tokens
* `review/changes.csv` — changes to line boundaries, scan-checked vs typographic
* `review/previous_v2_alignment_review.csv` — earlier candidate review scores
* `review/validation_summary.json` — XML and geometry QA counts
* `original_transcription.docx` — supplied source Word document

## Important: training and platform limits
The glyph PNGs are **not embedded inline in Transkribus's transcription editor**. Their references are plain Unicode text tokens in `TextEquiv/Unicode`. Store the images alongside PAGE XML for archival retrieval. The literal `⟦IMAGE_0001⟧` is not a legitimate character transcription and must NOT be presented to OCR training as ground truth. Until a stable Unicode / IDS / private-use solution exists, tag the affected passages as unclear/gap and exclude those 11 lines from OCR training (or set them aside).

You can use the XML documents for manual checking, but a working import/replacement path into an *existing* Transkribus web collection is still not established. PAGE XML import in eScriptorium is an alternative.

## Validation
XMLs parsed successfully; all page/line IDs unique within pages, all 1,465 line and 61 region geometries unchanged from v2; 11 placeholder references match 11 extracted image files. All revised region text matches v2 exactly after removing the 11 image reference tokens. This proves content order preservation, not correctness relative to the scans.
