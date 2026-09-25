# TokenVector.Audio

<div align="center">

<img src="logo.png" alt="TokenVector.Audio Logo" width="128" height="128" />

![Language](https://img.shields.io/badge/Language-100%25%20Pure%20TokenVector%20(.tkv)-6C5CE7?style=for-the-badge)
![Compiler](https://img.shields.io/badge/Compiler-tkvc.exe%20(CIL%20AOT)-00B894?style=for-the-badge)
![Architecture](https://img.shields.io/badge/Architecture-Zero%20External%20Dependencies-0984E3?style=for-the-badge)
![SIMD](https://img.shields.io/badge/SIMD-AVX2%20%7C%20FMA%20(256--bit)-FF7675?style=for-the-badge)
![Tests](https://img.shields.io/badge/Tests-23%2F23%20PASSED-E17055?style=for-the-badge)

**A DSP and neural audio codec library written entirely in the TokenVector (`.tkv`) programming language. Zero external runtime dependencies; compiled to standard ECMA-335 CIL bytecode via the native `tkvc.exe` toolchain.**

</div>

---

## Overview

TokenVector.Audio is a collection of 23 pure-`.tkv` modules covering the audio processing pipeline from low-level signal transforms, SIMD hardware acceleration (AVX2/FMA) through perceptual coding, spatial rendering, and streaming transport. The library is intended as a demonstration of the TokenVector language's capability for numerically intensive DSP workloads, and as a reference implementation of the described algorithms in a single-language, dependency-free environment.

All modules compile to `.dll` via `ilasm.exe` and are consumable from any .NET 4.8 / .NET 8.0 host without third-party packages.

---

## Architecture

```
                          ╔══════════════════════════════════════╗
                          ║       TOKENVECTOR.AUDIO (v1.2.1)     ║
                          ╚══════════════════════════════════════╝

                                           │
     ┌────────────────┬────────────────────┼──────────────────┬────────────────────┐
     ▼                ▼                    ▼                  ▼                    ▼
┌──────────┐  ┌──────────────┐  ┌──────────────────┐  ┌────────────┐  ┌────────────────────┐
│ I/O      │  │ Transforms   │  │ Perceptual Codec  │  │ Enhancement│  │ Streaming / AI     │
├──────────┤  ├──────────────┤  ├──────────────────┤  ├────────────┤  ├────────────────────┤
│audio_buf │  │ dsp_core     │  │ codec_rvq        │  │enhancement │  │ streaming_plc      │
│tkva_cont │  │ dsp_engine   │  │ speech_vad       │  │multiband   │  │ speech_denoise     │
│tkva_stream│ │ dsp_lib      │  │ evaluation       │  │eq_10band   │  │ visualizer_spectrum│
│          │  │ dsp_mdct     │  │ codec_flac       │  │spatial     │  │ tv_audio_engine    │
│          │  │ pitch_wsola  │  │ nmf_separation   │  │            │  │                    │
└──────────┘  └──────────────┘  └──────────────────┘  └────────────┘  └────────────────────┘
```

---

## Modules

| # | Module | Layer | Algorithms |
|:--:|:--|:--|:--|
| 1 | `audio_buffer.tkv` | PCM I/O | Multi-channel sample buffer; amplitude normalization; format header detection: WAV, AIFF, RAW, TKVA, MP3, FLAC, OGG, AAC |
| 2 | `dsp_core.tkv` | Spectral Analysis | Cooley-Tukey Radix-2 FFT/IFFT with bit-reversal permutation; 80-band Mel filterbank; Polyphase Sinc resampler |
| 3 | `dsp_engine.tkv` | Digital Filters | Direct-Form II Biquad IIR: Low-Pass, High-Pass, Band-Pass, Notch |
| 4 | `dsp_lib.tkv` | Signal Utilities | Short-time RMS energy; dB conversion ($20\log_{10}$); linear interpolation |
| 5 | `codec_rvq.tkv` | Perceptual Codec | 24 Bark critical-band psychoacoustic model; Absolute Threshold of Hearing (ATH) curve; 4–8 stage Residual Vector Quantization (RVQ) |
| 6 | `tkva_container.tkv` | Container Format | `.tkva` proprietary container: metadata header serialization and RVQ token-frame bitstream packing |
| 7 | `tkva_streamer.tkv` | Streaming Decoder | Frame-cursor `TkvaStreamReader`; on-demand `TkvaPlaybackPump` feeding decoded PCM into `LockFreeRingBuffer` — no full-file decompression required |
| 8 | `enhancement.tkv` | Spectral Enhancement | Chebyshev polynomial harmonic exciter ($T_2$–$T_5$, 8–24 kHz); psychoacoustic virtual bass ($2f_0$, $3f_0$ non-linear synthesis); stereo width expansion; NLMS AEC |
| 9 | `multiband_mastering.tkv` | Dynamic Processing | 3-band Linkwitz-Riley crossover; per-band feed-forward dynamic compressor (Attack / Release / Threshold / Ratio); brickwall True-Peak limiter |
| 10 | `equalizer_10band.tkv` | Parametric EQ | 10-band ISO-standard EQ (31 Hz – 16 kHz); presets: Flat, BassBoost, VocalBoost, Rock, Pop, Electronic, Jazz |
| 11 | `spatial.tkv` | Binaural Rendering | Woodworth ITD head-shadow model; IID pinna elevation filter; FDN late reverberation |
| 12 | `streaming_plc.tkv` | Transport / PLC | 2.5 ms – 5 ms micro-frame packetizer; LPC-16 Levinson-Durbin autoregressive packet-loss concealment |
| 13 | `speech_vad.tkv` | Voice Detection | Short-time energy + zero-crossing-rate VAD; YIN $f_0$ pitch estimator |
| 14 | `speech_denoise.tkv` | Noise Reduction | Single-channel stationary-noise spectral subtraction |
| 15 | `visualizer_spectrum.tkv` | Visualization | 2D rolling waterfall spectrogram; stereo Lissajous vectorscope (M/S) |
| 16 | `evaluation.tkv` | Loudness Metering | EBU R128 integrated loudness (−14 LUFS); True-Peak limiting |
| 17 | `dsp_mdct.tkv` | Transform | MDCT/IMDCT with Sine-window TDAC property (50% frame overlap) |
| 18 | `pitch_shifter_wsola.tkv` | Time-Scale / Pitch | WSOLA pitch shift ±12 semitones; time stretch 0.5×–2.0× |
| 19 | `codec_flac.tkv` | Lossless Codec | Rice entropy decoding; LPC residual synthesis; stereo decorrelation (Left/Side, Mid/Side) |
| 20 | `reverb_convolution.tkv` | Convolution Reverb | Schroeder-style synthetic IR; overlap-add partitioned convolution |
| 21 | `nmf_separation.tkv` | Source Separation | Non-negative Matrix Factorization (multiplicative update); soft Wiener mask for vocal / accompaniment split |
| 22 | `tv_audio_engine.tkv` | Engine Facade | Unified API integrating all 21 sub-modules; TKVA streaming playback factory |

---

## TKVA Streaming Playback

A key design goal of v1.2.0 is to allow `.tkva` files to be decoded **incrementally** at frame granularity, feeding an SPSC ring buffer that a downstream audio callback can consume directly — without first decompressing the entire file to PCM or WAV.

```
.tkva bitstream
    │
    ▼
TkvaStreamReader          ← sequential frame cursor; supports random-access seek
    │  read_next_frame_tokens()
    ▼
TkvaPlaybackPump          ← RVQ codec.decode_frame() per pump call
    │  pump_one_frame()
    ▼
LockFreeRingBuffer        ← SPSC; capacity configured by caller
    │  read_sample()
    ▼
DAC / audio callback
```

**API (via `TokenVectorAudioEngine`):**

```python
# Create pump from token_frames list (loaded from .tkva container)
pump = engine.create_tkva_playback_pump(token_frames, ring_cap=4096)
pump.start()

# Pre-buffer before first audio callback
pump.prefill_buffer(target_frames=8)

# Inside audio callback (per-sample):
sample = pump.read_pcm_sample()

# Refill ring buffer (called from a producer thread or timer):
pump.pump_one_frame()

# Seek to a specific frame (for scrubbing):
pump.reader.seek_to_frame(frame_index)

# Diagnostics:
stats = pump.get_stats()   # "frames_decoded=N samples_written=M pos=T.Ts / D.Ds (P%)"
```

---

## Test Results (23/23 PASSED)

Build and run the verification suite:

```powershell
tkvc.exe build test_audio_engine.tkv --entry run --out test_audio_engine.exe
.\test_audio_engine.exe
```

```
================================================================================
TOKENVECTOR.AUDIO - COMPLETE 100% SUITE VERIFICATION (23/23 TESTS)
================================================================================
[PASS] BT1_Psychoacoustic_Bark_ATH_Masking
[PASS] BT1_Residual_Vector_Quantization_RVQ4
[PASS] BT2_Chebyshev_T2_T5_Harmonics_8k_24k
[PASS] BT2_Cooley_Tukey_Radix2_Complex_FFT
[PASS] BT3_Virtual_Bass_Missing_Fundamental
[PASS] BT3_Binaural_3D_Woodworth_ITD_HRTF
[PASS] BT3_Room_Impulse_Response_Diffusion
[PASS] BT4_LPC16_Levinson_Durbin_Waveform_PLC
[PASS] EXT1_TKVA_Proprietary_Container_Header
[PASS] EXT2_Voice_Activity_Detection_Energy_ZCR
[PASS] EXT2_Pitch_Tracker_YIN_F0_A440Hz
[PASS] EXT3_Spectrogram_Waterfall_2D_Rolling
[PASS] EXT3_Stereo_Vectorscope_Lissajous_MS
[PASS] EXT4_Multiband_Mastering_Peak_Limiter
[PASS] EXT4_Spectral_Subtraction_Denoising
[PASS] EXT4_Equalizer_10Band_Studio_Presets
[PASS] ADV1_MDCT_IMDCT_TDAC_Reconstruction
[PASS] ADV2_WSOLA_Waveform_Pitch_Shifting
[PASS] ADV3_FLAC_Rice_Entropy_And_LPC_Decode
[PASS] ADV4_Partitioned_Convolution_Reverb
[PASS] ADV5_NMF_Source_Separation_Vocal_Mask
[PASS] ADV6_TKVA_Frame_Streaming_Direct_Playback
[PASS] ADV7_SIMD_Hardware_Vector_AVX2_FMA
================================================================================
TEST SUMMARY: 23/23 PASSED (100% PURE TOKENVECTOR .TKV)
================================================================================
```


---

## Build

```powershell
.\build_package.ps1
```

The script detects `tkvc.exe` from `PATH`, compiles all `.tkv` sources, assembles `TokenVector.Audio.dll` via `ilasm.exe`, and packages a NuGet `.nupkg`.

---

## Author

- **Author:** Tran Nguyen Hung ([nguyen.hung.tran.18@gmail.com](mailto:nguyen.hung.tran.18@gmail.com))
- **Language:** TokenVector (.tkv)
- **License:** [MIT](LICENSE)
