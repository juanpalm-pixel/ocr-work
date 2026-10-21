# Jian Bo Gushu — Consolidated training data (20 pages)

This package brings together the original page scans and three **separate annotation sets** for Transkribus. These model types learn different tasks; the annotation directories are not interchangeable.

## Contents

```text
Jian_Bo_Gushu_All_Models/
├── images/                         20 original scanned PNG pages
├── models/
│   ├── 01_Text_Recognition/        20 PAGE XML (2013) files with transcription + line geometry
│   │   └── unencoded_glyphs/       11 PNG images referenced by IMAGE_0001–IMAGE_0011
│   ├── 02_Baselines/               20 PAGE XML files with regions, baselines and line polygons; NO text
│   └── 03_Field_Recognition/       20 PAGE XML files with region boundaries and labels; NO lines or text
├── original_transcription.docx     Unmodified original Word transcription
└── README.md                       This file
```

## How each model works

### 01 — Text Recognition Model

The PAGE XML files include text regions, line geometry, reading order and the corrected *provisional* Unicode transcriptions from revision v3. This preserves the use of subscript equals `₌` and Chinese angle brackets `〈 〉`. Eleven rare glyph images from the original DOCX are provided in `unencoded_glyphs/`; the corresponding PAGE XML transcription uses **literal placeholder tokens**, e.g., `⟦IMAGE_0001⟧`.

**Do not train the OCR model to output the literal IMAGE_XXXX placeholders.** For the affected lines, either establish suitable Unicode/IDS labels or tag/exclude those lines in Transkribus before training. The glyph PNG files are archival reference images, not directly embedded glyphs in the PAGE XML text field.

### 02 — Baselines Model

The PAGE XML files retain each text region, each line's baseline, its line polygon and their reading order, but have **no transcriptions**. Use these to train a **Baselines Model** (layout analysis), not a text-recognition model.

### 03 — Field Recognition Model

The PAGE XML files contain region polygons and the associated structural labels (`caption`, `heading`, `paragraph`) and reading order. Individual text lines and transcriptions are removed. Use these for a **Field Model** to recognise running headers, headings, and column regions. In Field Model configuration, select those structural labels **only if they are present in the Transkribus collection**; otherwise inspect the imported annotations or use the untagged-region option as appropriate.

## Alignment and quality limits

* There are **20 page scans** with **20 PAGE XML annotations per model type**, for a total of **60 PAGE XML files**.
* Overall, the source annotations contain **61 regions**. The Baselines and Text Recognition sets contain **1,465 baselines and 1,465 line polygons**; the Field set has no text lines.
* The Text Recognition transcriptions are **revision v3** (visually corrected for selected lines, but **not exhaustively verified**). Some line-level alignment mistakes can remain. The region and baseline geometries were not individually visually verified across all pages.
* The original Word document is copied without modification. No review reports or review folder are included, as requested.
* The PAGE XML uses Transkribus PAGE XML 2013 markup and its `imageFilename` values match the original scan basenames.

## Import / training note

This is an organised archival/training-data ZIP, **not a guaranteed one-click Transkribus import format**. The matching annotations must be attached to the corresponding pages in a Transkribus collection before that model's training wizard can use them. Uploading PNG files alone does not attach PAGE XML annotations. Check the import workflow supported by your Transkribus installation and test on a single page before processing all 20.

Use a train/validation/test split that keeps unseen pages out of training, and check problematic annotations before treating them as Ground Truth.
