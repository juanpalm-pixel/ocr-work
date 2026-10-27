FROM registry.gitlab.com/scripta/escriptorium:latest

# Kraken 7.0.3 replaces the older text direction implementation that fails
# on some historical Chinese transcription characters.
RUN python -m pip install --no-cache-dir 'kraken==7.0.3'
