# TokenVector.Audio

<div align="center">

<img src="logo.png" alt="TokenVector.Audio Logo" width="128" height="128" />

![Language](https://img.shields.io/badge/Language-100%25%20Pure%20TokenVector%20(.tkv)-6C5CE7?style=for-the-badge)
![Compiler](https://img.shields.io/badge/Compiler-tkvc.exe%20(CIL%20AOT)-00B894?style=for-the-badge)
![Architecture](https://img.shields.io/badge/Architecture-Kh%C3%B4ng%20Ph%E1%BB%A5%20Thu%E1%BB%99c%20Th%C6%B0%20Vi%E1%BB%87n%20Ngo%C3%A0i-0984E3?style=for-the-badge)
![SIMD](https://img.shields.io/badge/SIMD-AVX2%20%7C%20FMA%20(256--bit)-FF7675?style=for-the-badge)
![Tests](https://img.shields.io/badge/Tests-23%2F23%20PASSED-E17055?style=for-the-badge)

**Thư viện DSP và neural audio codec viết hoàn toàn bằng ngôn ngữ TokenVector (`.tkv`). Không phụ thuộc runtime ngoài; biên dịch thành CIL bytecode chuẩn ECMA-335 qua toolchain `tkvc.exe`.**

</div>

---

## Tổng quan

TokenVector.Audio gồm 23 module thuần `.tkv` bao phủ pipeline xử lý âm thanh từ biến đổi tín hiệu cấp thấp, tăng tốc vector hóa phần cứng SIMD (AVX2/FMA), đến perceptual coding, binaural rendering và streaming transport. Thư viện được thiết kế như một reference implementation của các thuật toán DSP/audio trong môi trường đơn ngôn ngữ, không phụ thuộc thư viện ngoài.

Toàn bộ module biên dịch ra `.dll` qua `ilasm.exe`, tiêu thụ được từ bất kỳ host .NET 4.8 / .NET 8.0 nào mà không cần NuGet package nào khác.

---

## Kiến trúc

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
│          │  │ pitch_wsola  │  │ nmf_separation   │  │            │  │ SIMD (AVX2/FMA)    │
└──────────┘  └──────────────┘  └──────────────────┘  └────────────┘  └────────────────────┘
```

---

## Danh sách module

| STT | Module | Tầng | Thuật toán |
|:--:|:--|:--|:--|
| 1 | `audio_buffer.tkv` | PCM I/O | Bộ đệm mẫu đa kênh; chuẩn hóa biên độ; nhận diện header định dạng: WAV, AIFF, RAW, TKVA, MP3, FLAC, OGG, AAC |
| 2 | `dsp_core.tkv` | Phân tích phổ & SIMD | Cooley-Tukey Radix-2 FFT/IFFT; Mel filterbank; Polyphase Sinc resampler; **SimdHardwareVectorEngine (AVX2 256-bit unrolled complex butterflies & FMA dot product)** |
| 3 | `dsp_engine.tkv` | Bộ lọc số | Direct-Form II Biquad IIR: Low-Pass, High-Pass, Band-Pass, Notch |
| 4 | `dsp_lib.tkv` | Tiện ích tín hiệu | Short-time RMS energy; chuyển đổi dB ($20\log_{10}$); nội suy tuyến tính |
| 5 | `codec_rvq.tkv` | Perceptual Codec | 24 Bark critical-band psychoacoustic model; Absolute Threshold of Hearing (ATH); RVQ 4–8 stage |
| 6 | `tkva_container.tkv` | Container Format | Container `.tkva`: header metadata và đóng gói bitstream token RVQ |
| 7 | `tkva_streamer.tkv` | Streaming Decoder | `TkvaStreamReader` cursor theo frame; `TkvaPlaybackPump` decode on-demand vào `LockFreeRingBuffer` — không cần giải nén toàn bộ file trước khi phát |
| 8 | `enhancement.tkv` | Kích thích phổ | Chebyshev harmonic exciter ($T_2$–$T_5$, 8–24 kHz); virtual bass ($2f_0$, $3f_0$ non-linear); stereo width; NLMS AEC |
| 9 | `multiband_mastering.tkv` | Dynamic Processing | 3-band Linkwitz-Riley crossover; feed-forward compressor (Attack / Release / Threshold / Ratio); True-Peak brickwall limiter |
| 10 | `equalizer_10band.tkv` | Parametric EQ | 10-band ISO (31 Hz – 16 kHz); presets: Flat, BassBoost, VocalBoost, Rock, Pop, Electronic, Jazz |
| 11 | `spatial.tkv` | Binaural Rendering | Woodworth ITD; IID; pinna elevation filter; FDN late reverberation |
| 12 | `streaming_plc.tkv` | Transport / PLC | Micro-frame packetizer 2.5–5 ms; LPC-16 Levinson-Durbin autoregressive packet-loss concealment |
| 13 | `speech_vad.tkv` | Voice Detection | VAD bằng short-time energy + ZCR; YIN $f_0$ pitch estimator |
| 14 | `speech_denoise.tkv` | Khử nhiễu | Spectral subtraction nhiễu nền tĩnh (single-channel) |
| 15 | `visualizer_spectrum.tkv` | Visualization | 2D rolling waterfall spectrogram; Lissajous vectorscope stereo M/S |
| 16 | `evaluation.tkv` | Loudness Metering | EBU R128 integrated loudness (−14 LUFS); True-Peak limiting |
| 17 | `dsp_mdct.tkv` | Biến đổi | MDCT/IMDCT với Sine-window TDAC (50% frame overlap) |
| 18 | `pitch_shifter_wsola.tkv` | Time-Scale / Pitch | WSOLA pitch shift ±12 semitones; time stretch 0.5×–2.0× |
| 19 | `codec_flac.tkv` | Lossless Codec | Rice entropy decoding; LPC residual synthesis; stereo decorrelation (Left/Side, Mid/Side) |
| 20 | `reverb_convolution.tkv` | Convolution Reverb | Schroeder-style synthetic IR; overlap-add partitioned convolution |
| 21 | `nmf_separation.tkv` | Source Separation | Non-negative Matrix Factorization (multiplicative update); soft Wiener mask vocal / accompaniment |
| 22 | `tv_audio_engine.tkv` | Engine Facade | API thống nhất 21 sub-module; factory tạo TKVA streaming playback pump |
| 23 | `SimdHardwareVectorEngine` | Vectorization | Kernel SIMD AVX2/FMA tăng tốc phép nhân cộng vô hướng và số phức 256-bit |


---

## TKVA Streaming Playback

Từ v1.2.0, file `.tkva` có thể được decode **theo từng frame RVQ** (on-demand), đẩy PCM sample vào SPSC `LockFreeRingBuffer` để audio callback tiêu thụ — **không cần giải nén toàn bộ file ra PCM/WAV trước**.

```
.tkva bitstream
    │
    ▼
TkvaStreamReader       ← con trỏ frame tuần tự; hỗ trợ seek ngẫu nhiên
    │  read_next_frame_tokens()
    ▼
TkvaPlaybackPump       ← RVQ codec.decode_frame() mỗi lần pump
    │  pump_one_frame()
    ▼
LockFreeRingBuffer     ← SPSC; capacity do caller cấu hình
    │  read_sample()
    ▼
DAC / audio callback
```

**API (qua `TokenVectorAudioEngine`):**

```python
# Tạo pump từ token_frames (đọc từ container .tkva)
pump = engine.create_tkva_playback_pump(token_frames, ring_cap=4096)
pump.start()

# Pre-buffer trước audio callback đầu tiên
pump.prefill_buffer(target_frames=8)

# Trong audio callback (mỗi sample):
sample = pump.read_pcm_sample()

# Bơm thêm frame vào ring buffer (producer thread hoặc timer):
pump.pump_one_frame()

# Seek đến frame bất kỳ (scrubbing):
pump.reader.seek_to_frame(frame_index)

# Thống kê:
stats = pump.get_stats()   # "frames_decoded=N samples_written=M pos=T.Ts / D.Ds (P%)"
```

---

## Kết quả kiểm thử (23/23 PASSED)

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

Script tự động phát hiện `tkvc.exe` từ `PATH`, biên dịch toàn bộ `.tkv`, lắp ráp `TokenVector.Audio.dll` qua `ilasm.exe`, và đóng gói NuGet `.nupkg`.

---

## Tác giả

- **Tác giả:** Trần Nguyên Hùng ([nguyen.hung.tran.18@gmail.com](mailto:nguyen.hung.tran.18@gmail.com))
- **Ngôn ngữ:** TokenVector (.tkv)
- **Giấy phép:** [MIT](LICENSE)
