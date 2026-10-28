# Stage 2: OCR review with eScriptorium

This stage provides 20 scanned pages and provisional PAGE XML annotations for an eScriptorium exercise. eScriptorium runs Kraken for segmentation, recognition, and training. The Kraken command-line exercise is in [`stage_1`](../stage_1/); the other class exercises are in the course web document.

## Files for students

All page files are loose files in [`stage_2/pages/`](pages/): 20 `.png` scans, 20 matching `.xml` PAGE annotations, and `mets.xml`. A PNG and XML with the same stem belong to the same page. The METS file lists the page files; it is a manifest, not an eScriptorium import file. The `glyph_references/` subfolder contains 11 rare glyph images referred to by `⟦IMAGE_0001⟧` through `⟦IMAGE_0011⟧` in the XML.

The XML includes regions, lines, reading order, and provisional transcription. Some text was visually corrected, but the pages have **not** been checked line by line and the geometry has not been verified throughout. Review the annotations against the scans before treating them as ground truth. The `IMAGE_XXXX` tokens are unresolved character references, not characters to teach a recognition model.

For optional automatic recognition or segmentation, the `chat_rec.mlmodel` and `chat_seg.mlmodel` files are available from the [CHAT models GitHub repository](https://github.com/colibrisson/CHAT_models). The model files are not included here.

## Run eScriptorium locally

Install Docker Desktop, enable WSL integration for your Ubuntu distribution if you use Windows, and download the [eScriptorium source](https://gitlab.com/scripta/escriptorium). In the terminal where you will run eScriptorium, check that Docker is connected:

```bash
docker info
docker compose version
```

`docker info` must show a **Server** section. If it does not, check Docker Desktop's WSL integration settings and restart the Ubuntu terminal. From your eScriptorium checkout, create and edit its configuration:

```bash
cd /path/to/escriptorium
cp variables.env_example variables.env
```

Replace the default `SECRET_KEY` and administrator credentials in `variables.env` with private values. Then start eScriptorium:

```bash
docker compose pull
docker compose up -d
```

Open <http://localhost:8080/>. To stop it later, run `docker compose down` from the same checkout; this keeps its database and media volumes. The [official Docker installation guide](https://gitlab.com/scripta/escriptorium/-/wikis/docker-install) has setup details. If recognition training hits the Kraken version problem described in this repository, see the [optional worker instructions](docker/kraken-7.0.3/README.md).

## Work with the pages

1. Create a project and a document in eScriptorium. On the document's **Images** tab, upload the 20 PNGs from `stage_2/pages/` in filename order. Wait for every upload to finish.
2. Choose **Import → Transcriptions (XML)** and import the XML matching one uploaded image. Give the transcription a clear name such as `Provisional transcription`. Check that the regions, lines, and text appear on the correct page before continuing.
3. Repeat for the other pages you need. eScriptorium accepts a single loose PAGE XML file per import; its documented batch option is a ZIP. Keep **Override** off when adding later pages so existing segmentation is retained. The `mets.xml` file is not uploaded in this step.
4. In **Edit**, review regions, line geometry, reading order, and every transcription against the scanned image. Resolve `IMAGE_XXXX` tokens using `glyph_references/` where possible, or mark those lines uncertain. Use Kraken predictions as drafts to review.
5. Export the corrected work from eScriptorium as PAGE XML. Save the export separately from the starter files.

The [eScriptorium import guide](https://escriptorium.readthedocs.io/en/latest/import/) explains image and PAGE XML import. The [segmentation guide](https://escriptorium.readthedocs.io/en/latest/segment/) and [export guide](https://escriptorium.readthedocs.io/en/latest/export/) cover review and export.
