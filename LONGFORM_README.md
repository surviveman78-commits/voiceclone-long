# My VoxCPM Long-Form Voiceover Fork

This fork adds automatic long-form synthesis to the upstream VoxCPM Gradio app.
Paste a long script into **Target Text**. The app splits it at sentence boundaries, generates each chunk with the same reference voice, inserts a short pause, and returns one WAV file.

## What changed

- `app.py` now splits long text before inference.
- Burmese and common Latin/CJK punctuation are supported.
- Each chunk reuses the same reference audio and cloning prompt.
- All generated chunks are concatenated into one output waveform.
- A deterministic seed is offset per chunk when a seed is supplied.
- Chunk size and pause can be configured without editing code.

## Install

Use Python 3.10–3.12, PyTorch compatible with your GPU, and CUDA 12+ for the normal CUDA path.

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
python -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -e .
```

If the app reports missing FFmpeg/torchcodec while loading reference audio, install FFmpeg using your operating system package manager.

## Run

```bash
python app.py --model-id openbmb/VoxCPM2 --server-port 7860
```

Open `http://localhost:7860`, upload a clean 5–15 second reference clip, paste the complete script, and click **Generate Speech**.

## Long-form settings

Defaults are suitable for a first test:

```bash
export VOXCPM_MAX_CHARS=220
export VOXCPM_CHUNK_PAUSE_MS=120
```

For Burmese voiceover, start with smaller chunks if words are skipped:

```bash
VOXCPM_MAX_CHARS=160 VOXCPM_CHUNK_PAUSE_MS=100 \
  python app.py --model-id openbmb/VoxCPM2 --server-port 7860
```

`VOXCPM_MAX_CHARS` controls the approximate maximum characters per inference chunk. `VOXCPM_CHUNK_PAUSE_MS` controls the silence inserted between chunks. The final result remains one WAV file.

Recommended UI settings for long-form cloning:

- CFG: `1.5–1.7`
- LocDiT steps: `10`
- Reference audio: clean speech, normally `5–15` seconds
- Ultimate Cloning: use only when the reference transcript is exact

## Important limitation

This is an inference-time long-form workaround, not retraining. Since each chunk is a separate generation, very small changes in rhythm or pitch can occur at chunk boundaries. Sentence-boundary splitting and a clean reference clip minimize this effect.

The model weights are not included in this repository. They are downloaded from Hugging Face on first run unless a local model path is supplied.

## Updating the fork

```bash
git pull --ff-only origin main
```

When copying upstream changes into this fork, review conflicts in `app.py`; the long-form logic is inside `VoxCPMDemo.generate_tts_audio()` and `_split_long_text()`.

## License

The upstream VoxCPM code and model weights remain under their respective upstream licenses. Keep the upstream `LICENSE` file and review the model card before redistribution or commercial use.

Use voice cloning only with permission and do not impersonate people or mislead listeners.
      
      
