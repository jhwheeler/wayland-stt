# wayland-stt

Push-to-talk voice-to-text for Wayland. Press a key to start recording, press again to stop — your speech is transcribed locally and typed into the focused window.

Uses [faster-whisper](https://github.com/SYSTRAN/faster-whisper) (base model, CPU, int8 quantization) for fast local transcription with no cloud dependencies.

## Requirements

- Arch Linux / Wayland compositor (Hyprland, Sway, etc.)
- `ffmpeg`, `wtype`, `wl-clipboard`, `libnotify`, `pulseaudio` or `pipewire-pulse`
- Python 3.10+

## Install

```bash
# Install system dependencies (Arch)
sudo pacman -S ffmpeg wtype wl-clipboard libnotify

# Install wayland-stt
git clone https://github.com/jhwheeler/wayland-stt.git
cd wayland-stt
make install
```

The first transcription will download the Whisper base model (~150MB, cached in `~/.cache/huggingface/`).

## Keybindings

This tool works with any Wayland compositor. Below are configuration examples for popular compositors.

### Hyprland

Add to `~/.config/hypr/hyprland.conf`:

```
bind = $mainMod, R, exec, voice-to-text
bind = $mainMod SHIFT, R, exec, voice-to-text --copy
```

### Sway

Add to `~/.config/sway/config`:

```
bindsym $mod+r exec voice-to-text
bindsym $mod+Shift+r exec voice-to-text --copy
```

### Other Wayland Compositors

For other compositors (e.g., river, wayfire, labwc), add keybindings that execute:

- `voice-to-text` — Start/stop recording and type transcription
- `voice-to-text --copy` — Copy last transcription to clipboard

Consult your compositor's documentation for the keybinding syntax.

## Usage

| Action | Effect |
|--------|--------|
| `ALT+R` | Start recording (notification persists) |
| `ALT+R` again | Stop, transcribe, type text into focused window |
| `ALT+SHIFT+R` | Copy last transcription to clipboard |

## Mako notification config (optional)

For a persistent "Recording..." notification that stays until you stop:

```ini
[app-name="Voice Recorder"]
default-timeout=3000
border-color=#f38ba8
ignore-timeout=0
```

## Uninstall

```bash
make uninstall
```
