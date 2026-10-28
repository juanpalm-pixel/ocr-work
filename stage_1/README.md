# Practical walkthrough 1: OCR with Kraken

Kraken separates the steps of text recognition so you can see what each command asks the computer to do. The point is to understand the input, output, and model at each step, not to memorise commands. A wrong path, filename, or missing model will stop the workflow. See [Kraken's README](https://github.com/mittagessen/kraken#readme) and [inference guide](https://kraken.re/7.1/user_guide/inference.html) for more detail.

## The pages

`images/lsi_v3p1_p010_prose.jpg` is printed page 10, mostly prose. `images/lsi_v3p1_p482_linguistic.jpg` is printed page 482, with linguistic forms, diacritics, and a table. Both are from George A. Grierson's *Linguistic Survey of India*, Volume III, Part I (1909), in its historical “Tibeto-Burman” grouping. The files are page 37 and page 510 of the [Wikimedia Commons scan](https://commons.wikimedia.org/wiki/File:Linguistic_Survey_of_India_Vol_3_Part_1.djvu); the [Digital South Asia Library](https://dsal.uchicago.edu/books/lsi/lsi.php?pages=670&volume=3-1) also hosts the volume. We use these pages to compare ordinary prose with text where errors in names, diacritics, and example forms matter.

The historical classification in this source is material to examine, not a current or authoritative classification. [Språkbanken's digitised and annotated LSI corpus](https://spraakbanken.gu.se/en/resources/lsi) can provide an independent comparison if you locate the exact passage. Check it against the scan before treating it as ground truth.

## Set up Kraken

From the repository root, create the supplied Conda environment, activate it, and download a print recognition model:

```bash
conda env create -f stage_1/environment.yml
conda activate kraken-practical
kraken --version
kraken get 10.5281/zenodo.10592716
cd stage_1
```

The model is [CATMuS-Print Large](https://zenodo.org/records/10592716), a print model covering several Western European languages including English. Kraken stores the downloaded `catmus-print-fondue-large.mlmodel` in its model directory. It is a starting model, not a guarantee of accurate transcription for these pages.

## Run the prose page

Run each command from inside `stage_1/`:

```bash
kraken -i images/lsi_v3p1_p010_prose.jpg output/prose_binary.png binarize
kraken -x -i "$PWD/images/lsi_v3p1_p010_prose.jpg" output/prose_layout.xml segment -bl
kraken -f page -i output/prose_layout.xml output/prose_ocr.txt ocr -m catmus-print-fondue-large.mlmodel
```

The first command creates a black-and-white image so you can inspect what binarization does. The neural baseline segmenter in the second command reads the original scan and writes line positions as PAGE XML. The third reads those lines and applies the recognition model to produce text. `$PWD` supplies the absolute image path so the PAGE XML in `output/` can find its scan in `images/`.

Open `output/prose_binary.png` and `output/prose_layout.xml`; then compare `output/prose_ocr.txt` with the scan. For a quick look at the text in a terminal:

```bash
sed -n '1,35p' output/prose_ocr.txt
```

Find one correctly read line, one character error, and one layout or reading-order error. Keep in mind that plausible English sentences can still contain wrong names or diacritics.

## Try the harder page

Use the same three steps on printed page 482:

```bash
kraken -i images/lsi_v3p1_p482_linguistic.jpg output/linguistic_binary.png binarize
kraken -x -i "$PWD/images/lsi_v3p1_p482_linguistic.jpg" output/linguistic_layout.xml segment -bl
kraken -f page -i output/linguistic_layout.xml output/linguistic_ocr.txt ocr -m catmus-print-fondue-large.mlmodel
```

Compare `output/linguistic_ocr.txt` with the image, especially the transcribed forms and the table. Record where Kraken misreads a diacritic or puts table cells in the wrong order. Discuss why a smooth-looking transcription can still misrepresent linguistic evidence.

Generated files stay in `output/` and are ignored by Git. The two source scans and their filenames are unchanged.
