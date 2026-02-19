#!/usr/bin/env python3
"""Transcribe a WAV file using faster-whisper (base model, CPU, int8)."""

import os
import sys
from faster_whisper import WhisperModel


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <wav_file>", file=sys.stderr)
        sys.exit(1)

    wav_file = sys.argv[1]

    # Validate input file exists and is readable
    if not os.path.isfile(wav_file):
        print(f"Error: File not found: {wav_file}", file=sys.stderr)
        sys.exit(1)

    model = WhisperModel("base", device="cpu", compute_type="int8")
    segments, _ = model.transcribe(wav_file, beam_size=5)
    text = " ".join(seg.text.strip() for seg in segments)
    print(text)


if __name__ == "__main__":
    main()
