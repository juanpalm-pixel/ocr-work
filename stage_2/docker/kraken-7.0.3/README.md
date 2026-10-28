# eScriptorium recognition training worker

The downloaded eScriptorium image currently contains Kraken 7.0.1. That release's text direction code rejects some modern text during recognition training, so eScriptorium can compile the lines but then report `No training data in dataset`. Kraken 7.0.3 replaces that code. This override upgrades only the `celery-gpu` worker, which runs recognition training.

Set `OCR_WORK_REPO_DIR` to your local copy of this repository. From the eScriptorium checkout, run:

```bash
cd /path/to/escriptorium
export OCR_WORK_REPO_DIR=/path/to/ocr-work
cp "$OCR_WORK_REPO_DIR/stage_2/docker/kraken-7.0.3/compose.override.yml" docker-compose.override.yml
docker compose build celery-gpu
docker compose up -d --no-deps celery-gpu
docker compose exec -T celery-gpu python -m pip show kraken | grep '^Version:'
```

The last command should print `Version: 7.0.3`. The override keeps the worker's original command, environment and media volume. It does not replace the database or media volumes.

Afterward, start a new recognition training attempt in eScriptorium using the imported transcription version. Use a new model name because the failed attempt may have left an incomplete model entry. If training still fails, inspect the recent `celery-gpu` logs again.

## Optional NVIDIA GPU training

Docker Desktop on Windows supports NVIDIA GPUs through WSL 2. First test the built worker image without changing the running service:

```bash
docker run --rm --gpus all --entrypoint python local/escriptorium-celery-gpu:kraken-7.0.3 -c 'import torch; print("CUDA build:", torch.version.cuda, "GPU available:", torch.cuda.is_available())'
```

If this prints `GPU available: True`, wait for any active training to finish, then run:

```bash
cp "$OCR_WORK_REPO_DIR/stage_2/docker/kraken-7.0.3/compose.gpu.yml" docker-compose.override.yml
docker compose up -d --no-deps celery-gpu
docker compose exec -T celery-gpu python -c 'import torch; print("GPU available:", torch.cuda.is_available())'
```

The GPU override requests one NVIDIA GPU and sets `KRAKEN_TRAINING_DEVICE=cuda:0`. To return to CPU training, copy `compose.override.yml` from this directory over the checkout's `docker-compose.override.yml` and restart `celery-gpu`.
