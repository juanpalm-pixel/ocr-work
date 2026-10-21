# OCR workflow: Tongjia dictionary, pages 1–20

This folder contains the source material and working notes for transcribing pages 1–20 of the Tongjia dictionary. The ZIP archive contains 20 page images (`p1`–`p20`) and Word files; the notes describe an earlier OCR workflow and character normalization decisions.

## What Kraken and eScriptorium do

[Kraken](https://kraken.re/) is an open-source OCR/HTR engine. It can find text lines (segmentation) and recognize text from those lines (transcription). Recognition quality depends on the script and print style, and results need proofreading.

[eScriptorium](https://escriptorium.eu/) is a browser-based workspace for organizing document images, running Kraken models, correcting layout and text, and exporting annotations. It uses Kraken as its segmentation and recognition engine. eScriptorium is useful here because you can review page images alongside the segmentation and text, correct errors, and export structured results.

## Installed software

Kraken 7.1.1 is installed in the Conda environment `session04-ocr`. In a WSL terminal, run:

```bash
conda activate session04-ocr
kraken --version
```

Expected version: `kraken, version 7.1.1`.

## Set up local eScriptorium

A local instance is recommended for this project: the images, annotations, and models stay on your machine, and you control the workspace and its backups. It is a good fit for a small individual project. It does require Docker and some setup; training models locally may need substantial memory and benefits from a supported GPU.

The eScriptorium source has been downloaded to `~/projects/escriptorium`. Docker Desktop is installed on Windows, but Docker is not currently available from this WSL distribution. Before running the commands below:

1. Open Docker Desktop on Windows and enable **Settings → Resources → WSL Integration** for the WSL distribution you use.
2. Apply the change and restart the WSL terminal. Confirm `docker compose version` works there.
3. Ensure Git is available in WSL.
4. In WSL, enter the downloaded checkout and create its local configuration file:

   ```bash
   cd ~/projects/escriptorium
   cp variables.env_example variables.env
   ```

5. Edit `variables.env` before starting the instance. Replace the default Django superuser password and secret key with private values. Keep the service bound to your own machine; do not expose it publicly without configuring it securely.
6. Start the services and open the local site:

   ```bash
   docker compose pull
   docker compose up -d
   ```

   Visit <http://localhost:8080/> and log in with the superuser credentials configured in `variables.env`.

To stop the services while keeping their data, run `docker compose down` from the eScriptorium checkout. Avoid `docker compose down -v`: that also removes the application’s stored data volumes.

For the current official instructions and configuration details, see [eScriptorium's Docker installation guide](https://gitlab.com/scripta/escriptorium/-/wikis/docker-install). On a first installation, eScriptorium downloads several container images and initializes its database; allow time for this to complete.

## Process these pages

1. Extract the ZIP archive (or use the existing page images if already extracted). Check the order and make sure the image filenames remain associated with the correct pages. The notes mention exporting images from a PDF and saving PNGs; the ZIP already includes 20 PNG page images.
2. In eScriptorium, create a project and a document, then import the PNG images. You can also import a PDF directly; eScriptorium imports its page images, not an embedded text layer.
3. Select the document pages and run a segmentation model to locate text regions and lines. Review and correct the line order, boundaries, and any missed or extra lines before transcription.
4. Run a recognition model suited to the printed Chinese script and period. If no suitable model is available, transcribe manually or prepare reviewed ground truth before considering model training. Treat model output as a draft.
5. Proofread page by page against the images. Preserve the project notes' conventions: normalize the noted variants as specified (`㬎` and `兹`), use IDS for unsupported characters when appropriate, and retain image references for unidentified characters. Record any project-specific transcription policy changes.
6. Export the reviewed transcription and segmentation as PAGE XML, optionally including images. Also export plain text if you need a reading copy. Keep the original images and a separate backup of the eScriptorium project data.

The Word documents in this folder contain prior OCR/transcription work and notes. Use them as reference material, and compare their text with the page images before importing or adopting it as ground truth.

## Using the results in Transkribus

Segmentation exported from eScriptorium can generally be exchanged with Transkribus using **PAGE XML**. eScriptorium exports PAGE XML as a ZIP archive containing XML files for the document parts (and optionally the images); Transkribus supports PAGE XML transcripts. Import the pages and PAGE XML together, preserving matching image/page names where possible, then inspect the imported regions, lines, reading order, and text. Compatibility is format-level rather than a guarantee that every region type, metadata field, or version-specific detail transfers exactly.

See [eScriptorium's import guide](https://escriptorium.readthedocs.io/en/latest/import/) and [export guide](https://escriptorium.readthedocs.io/en/latest/export/). Transkribus' current help center has guidance on [uploading files](https://help.transkribus.org/uploading-files-to-transkribus); older Transkribus eXpert documentation describes importing local PAGE XML transcripts.

## Official guides

- [eScriptorium quick start](https://escriptorium-tutorial.readthedocs.io/en/latest/quick-start/)
- [eScriptorium automatic prediction](https://escriptorium.readthedocs.io/en/latest/predict/)
- [Kraken documentation](https://kraken.re/)
- [eScriptorium Docker installation](https://gitlab.com/scripta/escriptorium/-/wikis/docker-install)
