# OCR workspace: Chinese historical print pages

This Ubuntu workspace is `~/projects/my-projects/ocr`. It uses Kraken with the CHAT Chinese historical text models and eScriptorium for visual review, transcription, and layout annotation.

## What is here

- `stage1_ocr/input/ocr-work-source/Jian_Bo_Gushu_All_Models/` is the extracted consolidated ZIP supplied in the Windows OCR work folder; the original ZIP is beside it. It contains the 20 scans, original transcription, glyph references, and three separate PAGE XML annotation sets. The earlier source folder and ZIPs are retained alongside it.
- `stage2_htr/export/escriptorium_import/jian_bo_gushu_fields_and_lines.zip` is a prepared eScriptorium import archive derived from the consolidated ZIP's baseline annotations. It preserves the source rectangular field zones and line geometry, has no text transcription, and labels the zones `Caption`, `Title`, `Paragraph 1`, and `Paragraph 2`.
- `stage1_ocr/models/CHAT_models/models/chat_rec.mlmodel` is the CHAT historical Chinese recognition model. `chat_seg.mlmodel` is also available for layout/line segmentation experiments. The CHAT model repository is licensed CC BY-NC 4.0; see `stage1_ocr/models/CHAT_models/LICENCE` before reusing or redistributing it.
- `stage1_ocr/output/ocr-work-source/kraken_batch/` contains copies of the input PAGE XML and Kraken's generated `.chat.xml` results. The original PAGE XML under `stage1_ocr/input/` was not overwritten.

The consolidated ZIP separates three PAGE XML annotation sets: `01_Text_Recognition` has provisional transcription, regions, and lines; `02_Baselines` has rectangular regions and line geometry but no text; `03_Field_Recognition` has region geometry and field labels but no lines or text. The text has only been visually corrected in part, and geometry has not been verified on every page, so none of these annotations should be treated as fully checked ground truth. The supplied field labels distinguish the caption and (where present) heading, while the two paragraph columns are given separate labels in the prepared eScriptorium archive.

## Kraken environment and models

Kraken 7.1.1 is installed in the `session04-ocr` Conda environment:

```bash
conda activate session04-ocr
kraken --version
```

The CHAT model files are already downloaded in `stage1_ocr/models/CHAT_models/models/`. The model project describes `chat_rec.mlmodel` as trained on historical Chinese prints and manuscripts. Results still depend on matching the source page layout, line direction, and image preparation; the run in this workspace did not produce usable recognition for these pages.

The completed PAGE XML output is useful as a record of the experiment, but the original transcription and layout remain the working reference:

```text
Input/reference: stage1_ocr/input/ocr-work-source/jian_bo_gushu_v3_alignment_and_glyphs/page_xml/
Images:          stage1_ocr/input/ocr-work-source/jian_bo_gushu_v3_alignment_and_glyphs/images/
Kraken drafts:   stage1_ocr/output/ocr-work-source/kraken_batch/*.chat.xml
```

## Run eScriptorium locally

The eScriptorium source is checked out at `~/projects/escriptorium`. Its containers have not been configured or started yet. Docker Desktop is installed on Windows, and the user reports that its WSL integration is now working after resolving an application glitch. The Ubuntu account is in the `docker` group. Check Docker from the regular Ubuntu WSL terminal before starting eScriptorium:

```bash
docker info
docker compose version
```

`docker info` must show a **Server** section before continuing; the Compose version alone only confirms that the CLI plugin is installed. This managed Codex command session can find the Linux Docker CLI, but its connection to `/var/run/docker.sock` is denied, so server access has not been verified from this session. If Docker is unavailable in a regular Ubuntu terminal, check that the exact distro is enabled under **Docker Desktop → Settings → Resources → WSL Integration**. If socket access is denied there, confirm `id -nG` includes `docker` and restart the distro so the group membership is active. Membership in the `docker` group gives broad control over the Docker daemon; do not change the socket to world-writable permissions.

Then configure and start eScriptorium:

```bash
cd ~/projects/escriptorium
cp variables.env_example variables.env
```

Edit `variables.env`: replace the default `SECRET_KEY` and the default administrator username/password with private values. Then run:

```bash
docker compose pull
docker compose up -d
```

Open <http://localhost:8080/>. Stop eScriptorium from `~/projects/escriptorium` with `docker compose down`; this keeps its database and media. Do not add `-v`, which removes those data volumes. See the [official Docker installation guide](https://gitlab.com/scripta/escriptorium/-/wikis/docker-install) for current requirements and settings.

## Bring the pages into eScriptorium

Use the consolidated scans and its prepared import ZIP as the starting point. Do not import the `.chat.xml` draft files as authoritative transcription.

1. In eScriptorium, create a project and a document. On the document's **Images** tab, upload the PNGs in `stage1_ocr/input/ocr-work-source/Jian_Bo_Gushu_All_Models/images/`. Keep their filenames and page order intact; the PAGE XML maps pages to images by filename.
2. Import the prepared `stage2_htr/export/escriptorium_import/jian_bo_gushu_fields_and_lines.zip` through **Images → Import → Transcriptions (XML)**. Give it a clear name such as `Fields and lines - review required`. Start with a new document so its segmentation is empty. The import supplies rectangles, line geometry, reading order, and the four requested region labels; it deliberately contains no transcription text. eScriptorium can import layout from PAGE XML with or without transcription, and matches XML to images by filename. If importing into a document you have already edited, preserve its work and do not enable **Override** unless you intend to replace its segmentation.
3. Open **Edit** and show the **Segmentation** panel (`Ctrl+3`). Inspect the imported rectangles and lines against the scans. The baseline source has a caption and two paragraph columns on all 20 pages; it has a title region only on page 1. Add a title box only on pages where one actually appears. The boxes are ordinary four-corner rectangles, not irregular polygons.
4. The imported region types should appear in the document's **Ontology** tab as `Caption`, `Title`, `Paragraph 1`, and `Paragraph 2`. Check each line's region association and reading order. If any lines are unlinked, select them and press `Y` over the intended region. Correct region types or geometry in the Segmentation panel as needed.
5. For a transcription workflow, import the separate files from `models/01_Text_Recognition/` only after reviewing the existing lines and choosing whether to use their provisional text. Otherwise transcribe manually in eScriptorium. The text set contains literal `IMAGE_XXXX` placeholders for rare glyphs; do not treat those tokens as character labels. Review `original_transcription.docx` and the dataset README for normalization notes.
6. Export the reviewed annotations as PAGE XML from the Images tab. Keep the export separate from the original archive, its three annotation sets, and Kraken draft files.

### What “regions” and “lines” mean here

In eScriptorium, a **region** (also called a zone) is a larger block such as a caption, title, or paragraph. Regions are optional for transcription but make the document's logical structure clear. A **line segment** is the baseline and mask for an individual line of text; it is required before eScriptorium can transcribe that line. For this project, use the supplied rectangular regions and line segmentation as a starting point, then correct them against the scans. The prepared ZIP combines the baseline regions and lines in one import to avoid duplicate zones. Do not make every line its own region.

For official details, see eScriptorium's [manual segmentation guide](https://escriptorium.readthedocs.io/en/latest/segment/), [import guide](https://escriptorium.readthedocs.io/en/latest/import/), and [export guide](https://escriptorium.readthedocs.io/en/latest/export/). The CHAT model description and license are in `stage1_ocr/models/CHAT_models/README.md` and `LICENCE`.

## Other practical stages

The workspace retains the original practical folders for other class exercises:

- `stage2_htr/` — handwritten HTR material and exports.
- `stage3_training/ground_truth/` — prepared training data for the separate Transkribus class exercise, if still required.
- `stage4_evaluation/` — evaluation inputs and outputs.

Those stages are separate from the Chinese historical print workflow above. eScriptorium is the intended workspace for this project's segmentation and transcription review.
