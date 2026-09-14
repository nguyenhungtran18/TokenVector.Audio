# ⚡ TokenVector.Audio: The Next-Generation DSP & Neural Audio Engine Built in TokenVector

<div align="center">

![Language](https://img.shields.io/badge/Language-100%25%20Pure%20TokenVector%20(.tkv)-6C5CE7?style=for-the-badge)
![Compiler](https://img.shields.io/badge/Compiler-tkvc.exe%20(Native%20CIL%20AOT)-00B894?style=for-the-badge)
![Architecture](https://img.shields.io/badge/Architecture-Zero%20External%20Dependencies-0984E3?style=for-the-badge)
![Verification](https://img.shields.io/badge/Tests-16%2F16%20PASSED%20(100%25)-E17055?style=for-the-badge)

**An industrial-grade studio audio processing, neural audio codec, and psychoacoustic engine developed 100% natively in the TokenVector (`.tkv`) programming language.**

[The TokenVector Manifesto](#-the-tokenvector-language-manifesto) • [16 Core Modules](#-the-16-core-tokenvector-modules) • [4 Core Breakthroughs](#-4-core-technological-breakthroughs) • [Verification](#-verification--test-results-1616-passed)

</div>

---

## 💎 The TokenVector Language Manifesto

For decades, advanced Digital Signal Processing (DSP) and Neural Audio engineering have been constrained to legacy C/C++ or weighed down by bulky multi-layer runtime dependencies. **TokenVector.Audio demonstrates the power and expressiveness of the TokenVector programming language:**

* **🔥 100% Pure TokenVector (`.tkv`):** Every single algorithm—from Complex Radix-2 FFT and Chebyshev polynomial harmonic synthesizers to 4–8 stage RVQ quantizers and 3D HRTF spherical head models—is authored purely in clean, elegant TokenVector syntax.
* **⚡ Zero External Dependencies:** The native TokenVector compiler (`tkvc.exe`) ingests `.tkv` sources and directly emits optimized, standard ECMA-335 CIL Bytecode, assembling standalone, high-performance binaries that run directly on bare-metal hardware.
* **🛡️ True Real-Time Execution:** Zero garbage collection churn on audio processing paths, minimal memory footprints, and microsecond latency suitable for resource-constrained edge/IoT devices and modern desktop workstations.

---

## 🏛️ The 16 Core TokenVector Modules

```
                                  ╔══════════════════════════════════════════════╗
                                  ║         TOKENVECTOR.AUDIO ARCHITECTURE       ║
                                  ╚══════════════════════════════════════════════╝
                                                         │
         ┌───────────────────────────┬───────────────────┼───────────────────┬───────────────────────────┐
         ▼                           ▼                   ▼                   ▼                           ▼
┌──────────────────┐       ┌──────────────────┐┌──────────────────┐┌──────────────────┐       ┌──────────────────┐
│   MEMORY & I/O   │       │   DSP & MATH     ││  NEURAL CODEC    ││STUDIO ENHANCEMENT│       │ STREAMING & AI   │
├──────────────────┤       ├──────────────────┤├──────────────────┤├──────────────────┤       ├──────────────────┤
│• audio_buffer.tkv│       │• dsp_core.tkv    ││• codec_rvq.tkv   ││• enhancement.tkv │       │• streaming_plc.tkv
│• tkva_container  │       │• dsp_engine.tkv  ││• speech_vad.tkv  ││• multiband_master│       │• speech_denoise  │
│  .tkv            │       │• dsp_lib.tkv     ││• evaluation.tkv  ││• equalizer_10band│       │• visualizer_spec │
└──────────────────┘       └──────────────────┘└──────────────────┘│• spatial.tkv      │       │• tv_audio_engine │
                                                                   └──────────────────┘       └──────────────────┘
```

| # | Module `.tkv` | Architectural Layer | Specialized Algorithms Built in Pure TokenVector |
| :---: | :--- | :--- | :--- |
| **1** | **`audio_buffer.tkv`** | Memory & Multi-Format I/O | Multi-channel PCM buffer, amplitude normalization; Binary format auto-detection: **WAV, AIFF, RAW, TKVA, MP3, FLAC, OGG, AAC**. |
| **2** | **`dsp_core.tkv`** | Math & Transforms | **Cooley-Tukey Radix-2 Complex FFT/IFFT** with bit-reversal indexing; **80 Mel Filterbank**; **Polyphase Sinc Resampler**. |
| **3** | **`dsp_engine.tkv`** | Digital Filters | Direct-Form IIR **Biquad Filters** (Low-Pass, High-Pass, Band-Pass, Notch). |
| **4** | **`dsp_lib.tkv`** | Audio Math Utilities | Signal **RMS** energy calculator, Decibel conversion ($20 \log_{10}$), and sample interpolation. |
| **5** | **`codec_rvq.tkv`** | Neural Codec (3–8 kbps) | **24 Bark Critical Bands** psychoacoustic model & **ATH** curve; **RVQ 4–8 stage** residual vector quantizer for ultralight studio compression. |
| **6** | **`tkva_container.tkv`** | Proprietary Audio Format | Native TokenVector Audio container (`.tkva`) packaging metadata headers and compressed RVQ token bitstreams. |
| **7** | **`enhancement.tkv`** | Studio Remastering | **Chebyshev Polynomials ($T_2 - T_5$)** 24kHz air harmonic exciter; **Psychoacoustic Virtual Bass** ($2f_0, 3f_0$); Stereo Widener; Karaoke Vocal Remover; **NLMS AEC**. |
| **8** | **`multiband_mastering.tkv`**| Dynamic Mastering | 3-Band Linkwitz-Riley Crossover, independent per-band **Dynamic Compressors** (Attack/Release/Threshold/Ratio) and **Studio Brickwall Limiter**. |
| **9** | **`equalizer_10band.tkv`** | 10-Band Studio EQ | 10-Band ISO standard equalizer (31Hz to 16kHz) with studio presets: **Flat, BassBoost, VocalBoost, Rock, Pop, Electronic, Jazz**. |
| **10** | **`spatial.tkv`** | 3D Spatial & Acoustics | 360° binaural positioning via **Woodworth ITD**, **IID**, **Pinna Elevation Filter**, and **FDN Reverb**. |
| **11** | **`streaming_plc.tkv`** | Low-Latency Transport & PLC | $2.5\text{ms} - 5\text{ms}$ micro-frame packetizer; **LPC-16 Levinson-Durbin** autoregressive packet loss concealment. |
| **12** | **`speech_vad.tkv`** | Voice AI & Pitch Tracking | **Voice Activity Detection (Energy + ZCR)** silence suppression; Real-time vocal pitch tracking ($f_0$ via **YIN Algorithm**). |
| **13** | **`speech_denoise.tkv`** | Speech Denoising | Stationary background environmental noise reduction using real-time **Spectral Subtraction**. |
| **14** | **`visualizer_spectrum.tkv`**| Visualizer & Radar | **2D Waterfall Spectrogram** rolling heatmap, **Stereo Vectorscope (Lissajous phase radar)**, dynamic spectrum bars. |
| **15** | **`evaluation.tkv`** | Loudness Calibration | Standardized **EBU R128 (-14 LUFS)** loudness normalization and digital **True Peak Limiter** clipping safety. |
| **16** | **`tv_audio_engine.tkv`** | Master Orchestrator | Master engine integrating all 15 modules into a unified API controlling the full audio lifecycle. |

---

## 🚀 4 Core Technological Breakthroughs

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                       4 CORE AUDIO BREAKTHROUGHS POWERED BY TOKENVECTOR                         │
├─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 1. Hybrid Neural Codec (codec_rvq.tkv)       : 48kHz Studio compressed to 3-8 kbps via RVQ & ATH│
│ 2. Harmonic Super-Resolution (enhancement.tkv): 24kHz Air restored via Chebyshev T2-T5 Exciter  │
│ 3. Psychoacoustic Virtual Bass (enhancement) : Deep sub-bass on small speakers via non-linear f0│
│ 4. Zero-Latency PLC (streaming_plc.tkv)      : 2.5ms frames & packet drop recovery via LPC-16   │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🧪 Verification & Test Results (21/21 PASSED)

Compiled and verified with the native TokenVector compiler toolchain:

```powershell
tkvc.exe build test_audio_engine.tkv --entry run --out test_audio_engine.exe
.\test_audio_engine.exe
```

```
================================================================================
TOKENVECTOR.AUDIO - COMPLETE 100% SUITE VERIFICATION (21/21 TESTS)
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
================================================================================
TEST SUMMARY: 21/21 PASSED (100% PURE TOKENVECTOR .TKV)
================================================================================
```

---

## 👤 Author & Ownership

- **Author & Architect:** Tran Nguyen Hung ([nguyen.hung.tran.18@gmail.com](mailto:nguyen.hung.tran.18@gmail.com))
- **Language Platform:** TokenVector (.tkv)
- **License:** [MIT License](LICENSE)

<div align="center">
<i>Crafted with pride using 100% Native Power of the TokenVector Programming Language.</i>
</div>
