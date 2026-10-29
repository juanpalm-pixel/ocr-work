# eScriptorium recognition training worker

`compose.cpu.yml` runs training on the CPU; `compose.gpu.yml` requests an NVIDIA GPU. The service is named `celery-gpu` in both cases because that is the name of eScriptorium's training queue.

## CPU training (default)

Set `OCR_WORK_REPO_DIR` to your local copy of this repository, as well as changing `PATH_TO_ESCRIPTORIUM` to your eScriptorium directory. From the eScriptorium checkout, run:

```bash
cd ~/PATH_TO_ESCRIPTORIUM # Go to the eScriptorium folder. Docker Compose reads its files here.
export OCR_WORK_REPO_DIR=~/PATH_TO_OCR-WORK # Tell the terminal where you saved the OCR project. This is saved for the following commands
cp "$OCR_WORK_REPO_DIR/stage_2/docker/kraken-7.0.3/compose.cpu.yml" docker-compose.override.yml # Set eScriptorium to use the CPU configuration.
docker compose build celery-gpu # Build the eScriptorium training worker image.
docker compose up -d --no-deps celery-gpu # Start the worker in the background without restarting its dependencies.
docker compose exec -T celery-gpu python -m pip show kraken | grep '^Version:' # Check the Kraken version inside the running worker -- it should say 7.0.3; -T disables a pseudo-terminal inside docker. To see more information, remove the | `grep '^Version:'`
```

To know if the path was saved, use the following command
```bash
echo $OCR_WORK_REPO_DIR
```

Afterward, start a new recognition training attempt in eScriptorium using the imported transcription version. Use a new model name because the failed attempt may have left an incomplete model entry. If training still fails, inspect the recent `celery-gpu` logs again.

## Optional NVIDIA GPU training

Docker Desktop on Windows supports NVIDIA GPUs through WSL 2. First test the built worker image without changing the running service:

```bash
# Test whether this image can see your GPU; the temporary container is removed afterward.
docker run --rm --gpus all --entrypoint python local/escriptorium-celery-gpu:kraken-7.0.3 -c 'import torch; print("CUDA build:", torch.version.cuda, "GPU available:",torch.cuda.is_available())'
```

If this prints `GPU available: True`, wait for any active training to finish, then run:

```bash
cp "$OCR_WORK_REPO_DIR/stage_2/docker/kraken-7.0.3/compose.gpu.yml" docker-compose.override.yml # Replace the CPU template with the GPU template in the eScriptorium checkout.
docker compose up -d --no-deps celery-gpu # Recreate the training worker with GPU access; leave other services running.
docker compose exec -T celery-gpu python -c 'import torch; print("GPU available:", torch.cuda.is_available())' # Confirm that PyTorch can see the GPU from inside the worker.
```

The GPU override requests one NVIDIA GPU and sets `KRAKEN_TRAINING_DEVICE=cuda:0`.

## Return to CPU training

Wait for any active training to finish. From the eScriptorium checkout, replace the GPU override with the CPU override and recreate the worker:

```bash
cd /path/to/escriptorium # Return to the eScriptorium checkout.
export OCR_WORK_REPO_DIR=/path/to/ocr-work # Point this terminal to the OCR project again if it is a new terminal session.
cp "$OCR_WORK_REPO_DIR/stage_2/docker/kraken-7.0.3/compose.cpu.yml" docker-compose.override.yml # Restore the CPU template as Docker Compose's active override.
docker compose up -d --no-deps --force-recreate celery-gpu # Recreate only the training worker so it uses the CPU settings.
docker compose exec -T celery-gpu printenv KRAKEN_TRAINING_DEVICE # Confirm that training is now configured for the CPU.
```

The last command should print `cpu`. The CPU template sets that value and does not request a GPU. The same Kraken 7.0.3 image is used, so there is no need to rebuild it.
