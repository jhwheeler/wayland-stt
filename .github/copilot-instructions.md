# Copilot Instructions

## Project Overview

`wayland-stt` is a push-to-talk voice-to-text tool for Wayland compositors (e.g. Hyprland, Sway). It records audio with `ffmpeg`/`pactl`, transcribes it locally using [faster-whisper](https://github.com/SYSTRAN/faster-whisper) (base model, CPU, int8 quantization), and types the result into the focused window via `wtype`. No cloud dependencies.

### Key files

| File | Purpose |
|------|---------|
| `voice-to-text` | Main shell script — handles recording lifecycle, locking, notifications, and optional clipboard copy |
| `transcribe.py` | Python script — loads the Whisper model and transcribes a WAV file given as an argument |
| `Makefile` | `make install` / `make uninstall` targets; creates a virtualenv under `~/.local/share/wayland-stt/venv` |

## Environment & Dependencies

- **OS**: Arch Linux with a Wayland compositor
- **System tools required**: `ffmpeg`, `wtype`, `wl-clipboard` (`wl-copy`), `libnotify` (`notify-send`), `pulseaudio` or `pipewire-pulse` (`pactl`)
- **Python**: 3.10+, with `faster-whisper` installed in the project virtualenv

## Building & Installing

```bash
make install    # checks deps, creates venv, installs faster-whisper, copies scripts
make uninstall  # removes installed files
```

There is no compiled artifact — the project is pure shell + Python.

## Testing

There is no automated test suite. When making changes:

1. Verify `transcribe.py` with a real WAV file if modifying transcription logic:
   ```bash
   ~/.local/share/wayland-stt/venv/bin/python transcribe.py /path/to/test.wav
   ```
2. Exercise `voice-to-text` end-to-end on a Wayland session to confirm recording, transcription, and text-typing work correctly.
3. Run `make install` in a clean environment to confirm the install target still succeeds.

## Coding Conventions

- **Shell script** (`voice-to-text`): POSIX-compatible where possible; use `#!/usr/bin/env bash` shebangs; keep error handling explicit (`set -e` or explicit checks).
- **Python** (`transcribe.py`): Follow PEP 8; keep the script self-contained with no imports beyond the standard library and `faster-whisper`; validate inputs early and exit with a non-zero status on error.
- **No new runtime dependencies** should be added without updating the `Makefile` install target and the README requirements section.

## Common Patterns

- The lock file (`/tmp/voice-to-text.lock`) is used to toggle recording on/off between invocations — preserve this mechanism when modifying the script flow.
- Notifications use `notify-send` with a fixed app-name (`"Voice Recorder"`) so users can configure their notification daemon (e.g. mako) to style them distinctively.
- The Whisper model is loaded fresh on every invocation (no persistent daemon) to keep the implementation simple.
