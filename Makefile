PREFIX    ?= $(HOME)/.local
BIN_DIR    = $(PREFIX)/bin
DATA_DIR   = $(PREFIX)/share/wayland-stt
VENV_DIR   = $(DATA_DIR)/venv
PYTHON    ?= python3

.PHONY: install uninstall check-deps

check-deps:
	@command -v ffmpeg   >/dev/null || { echo "Missing: ffmpeg (sudo pacman -S ffmpeg)"; exit 1; }
	@command -v wtype    >/dev/null || { echo "Missing: wtype (sudo pacman -S wtype)"; exit 1; }
	@command -v wl-copy  >/dev/null || { echo "Missing: wl-clipboard (sudo pacman -S wl-clipboard)"; exit 1; }
	@command -v pactl    >/dev/null || { echo "Missing: pulseaudio/pipewire-pulse"; exit 1; }
	@command -v notify-send >/dev/null || { echo "Missing: libnotify (sudo pacman -S libnotify)"; exit 1; }

install: check-deps
	@echo "Creating venv at $(VENV_DIR)..."
	mkdir -p $(DATA_DIR) $(BIN_DIR)
	$(PYTHON) -m venv $(VENV_DIR)
	$(VENV_DIR)/bin/pip install --quiet faster-whisper
	@echo "Installing scripts..."
	install -m 755 voice-to-text $(BIN_DIR)/voice-to-text
	install -m 755 transcribe.py $(DATA_DIR)/transcribe.py
	@echo ""
	@echo "Installed! Add a keybinding in your Hyprland config:"
	@echo ""
	@echo "  bind = \$$mainMod, R, exec, voice-to-text"
	@echo "  bind = \$$mainMod SHIFT, R, exec, voice-to-text --copy"
	@echo ""
	@echo "Optional: add to mako config for persistent recording notification:"
	@echo ""
	@echo "  [app-name=\"Voice Recorder\"]"
	@echo "  default-timeout=3000"
	@echo "  border-color=#f38ba8"
	@echo "  ignore-timeout=0"
	@echo ""
	@echo "Then: hyprctl reload && makoctl reload"

uninstall:
	rm -f $(BIN_DIR)/voice-to-text
	rm -rf $(DATA_DIR)
	@echo "Uninstalled."
