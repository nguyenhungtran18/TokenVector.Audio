# ⚡ TokenVector.Audio: Kỷ Nguyên Mới Của Xử Lý m Thanh Bằng Ngôn Ngữ TokenVector

<div align="center">

![Language](https://img.shields.io/badge/Language-100%25%20Pure%20TokenVector%20(.tkv)-6C5CE7?style=for-the-badge)
![Compiler](https://img.shields.io/badge/Compiler-tkvc.exe%20(Native%20CIL%20AOT)-00B894?style=for-the-badge)
![Architecture](https://img.shields.io/badge/Architecture-Kh%C3%B4ng%20Ph%E1%BB%A5%20Thu%E1%BB%99c%20Th%C6%B0%20Vi%E1%BB%87n%20Ngo%C3%A0i-0984E3?style=for-the-badge)
![Verification](https://img.shields.io/badge/Tests-16%2F16%20PASSED%20(100%25)-E17055?style=for-the-badge)

**Đột phá công nghệ âm thanh Studio, Neural Codec và Xử lý Tín hiệu Số (DSP) được xây dựng 100% thuần túy bằng Ngôn ngữ Lập trình TokenVector (`.tkv`).**

[Tuyên Ngôn Công Nghệ](#-tuyên-ngôn-công-nghệ-tokenvector) • [Bộ 16 Module Hạt Nhân](#-bộ-16-module-hạt-nhân-thuần-tokenvector) • [4 Trụ Cột Đột Phá](#-4-trụ-cột-công-nghệ-đột-phá) • [Kiểm Thử Toàn Diện](#-chứng-minh-thực-thi-1616-tests-passed)

</div>

---

## 💎 Tuyên Ngôn Công Nghệ TokenVector

Trước đây, ngành xử lý tín hiệu âm thanh cao cấp (DSP) và Neural Audio luôn bị thống trị bởi các ngôn ngữ truyền thống như C/C++ hoặc sự cồng kềnh của các Framework ngoại lai. **TokenVector.Audio ra đời để định nghĩa lại tiêu chuẩn:**

* **🔥 100% Native TokenVector (`.tkv`):** Toàn bộ 16 module—từ các phép biến đổi Fourier số phức, đa thức Chebyshev, ma trận lượng tử hóa vector RVQ đến mô hình đầu cầu 3D HRTF—đều được viết bằng cú pháp tinh gọn và thanh lịch của ngôn ngữ **TokenVector**.
* **⚡ Không Phụ Thuộc Thư Viện Ngoài:** Trình biên dịch **`tkvc.exe`** phân tích cú pháp `.tkv` và phát sinh trực tiếp mã trung gian CIL Bytecode chuẩn quốc tế (ECMA-335), lắp ráp thành các tệp thực thi siêu nhẹ, độc lập và chạy ở tốc độ phần cứng tối đa.
* **🛡️ Hiệu Năng Thời Gian Thực Tuyệt Đối:** Loại bỏ hoàn toàn chi phí ảo hóa, không rác bộ nhớ (Zero-GC Churn), cho phép giải mã và xử lý âm thanh thời gian thực ngay trên chip yếu, thiết bị IoT và các hệ điều hành máy tính hiện đại.

---

## 🏛️ Bộ 16 Module Hạt Nhân Thuần TokenVector (`.tkv`)

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

| STT | Module `.tkv` | Phân Lớp Kỹ Thuật | Nhiệm Vụ & Thuật Toán Chuyên Sâu Bằng TokenVector |
| :---: | :--- | :--- | :--- |
| **1** | **`audio_buffer.tkv`** | Memory & I/O Engine | Quản lý bộ đệm PCM đa kênh, chuẩn hóa biên độ mẫu; Tự động nhận diện nhị phân đa định dạng: **WAV, AIFF, RAW, TKVA, MP3, FLAC, OGG, AAC**. |
| **2** | **`dsp_core.tkv`** | Toán Học & Biến Đổi | Thuật toán **Cooley-Tukey Radix-2 Complex FFT/IFFT** với hoán vị đảo bit; Ma trận **80 Mel Filterbank**; Bộ đổi tần số lấy mẫu **Polyphase Sinc Resampler**. |
| **3** | **`dsp_engine.tkv`** | Bộ Lọc Tín Hiệu Số | Động cơ lọc số Direct-Form IIR **Biquad Filters** (Low-Pass, High-Pass, Band-Pass, Notch). |
| **4** | **`dsp_lib.tkv`** | Tiện Ích m Học | Tính toán năng lượng tín hiệu **RMS**, chuyển đổi thang đo Decibel chuẩn hóa ($20 \log_{10}$), và nội suy mẫu mượt mà. |
| **5** | **`codec_rvq.tkv`** | Neural Codec 3–8 kbps | Mô hình Tâm lý Âm học **24 Bark Critical Bands** & Ngưỡng nghe tuyệt đối **ATH**; Lượng tử hóa vector dư **RVQ 4–8 stages** nén âm thanh Studio siêu nhẹ. |
| **6** | **`tkva_container.tkv`** | Container Độc Quyền | Chuẩn container âm thanh riêng biệt của TokenVector (`.tkva`), đóng gói Header Metadata và payload chuỗi token RVQ nén. |
| **7** | **`enhancement.tkv`** | Phục Chế Phòng Thu | Tái tạo dải cao 24kHz bằng **Đa thức Chebyshev ($T_2 - T_5$)**; **Psychoacoustic Virtual Bass** ($2f_0, 3f_0$); Mở rộng Stereo; Tách Beat Karaoke; Bộ lọc triệt tiêu tiếng vọng **NLMS AEC**. |
| **8** | **`multiband_mastering.tkv`**| Dynamic Mastering | Crossover 3 dải tần (Linkwitz-Riley), **Dynamic Range Compressor** độc lập từng dải (Attack/Release/Threshold/Ratio) và **Studio Brickwall Limiter**. |
| **9** | **`equalizer_10band.tkv`** | 10-Band Studio EQ | Bộ cân bằng âm thanh 10 dải tần chuẩn ISO (31Hz đến 16kHz) với 7 Presets phòng thu: **Flat, BassBoost, VocalBoost, Rock, Pop, Electronic, Jazz**. |
| **10** | **`spatial.tkv`** | m Thanh Không Gian 3D | Định vị âm thanh 360° theo mô hình đầu cầu **Woodworth ITD**, suy giảm **IID**, bộ lọc góc nâng **Pinna** và mạng phản xạ trễ **FDN Reverb**. |
| **11** | **`streaming_plc.tkv`** | Truyền Tải & Vá Lỗi | Đóng gói micro-frame $2.5\text{ms} - 5\text{ms}$ truyền phát siêu tốc; Thuật toán tự hồi quy **LPC-16 Levinson-Durbin** tự vá gói tin bị mất khi mạng lag (Packet Loss). |
| **12** | **`speech_vad.tkv`** | Voice AI & Pitch Tracking | Nhận diện tiếng người nói **VAD (Short-time Energy + ZCR)** ngắt truyền khi im lặng; Dò tìm cao độ nốt nhạc và tần số cơ bản ($f_0$) bằng thuật toán **YIN**. |
| **13** | **`speech_denoise.tkv`** | Khử Nhiễu Tiếng Nói | Bộ khử ồn môi trường nền tĩnh (tiếng quạt, gió, tạp âm máy móc) bằng phương pháp **Trừ phổ (Spectral Subtraction)** thời gian thực. |
| **14** | **`visualizer_spectrum.tkv`**| Trực Quan Hóa m Thanh | **2D Waterfall Spectrogram** bản đồ nhiệt phổ cuộn thời gian thực; **Stereo Vectorscope (Lissajous Radar)** đo tương quan pha; Bộ vẽ thanh phổ động. |
| **15** | **`evaluation.tkv`** | Chuẩn Hóa Chuẩn Studio | Đo độ lớn âm thanh tích hợp chuẩn quốc tế **EBU R128 (-14 LUFS)** và bộ giới hạn đỉnh an toàn **True Peak Limiter**. |
| **16** | **`tv_audio_engine.tkv`** | Master Orchestrator | Hạt nhân hợp nhất toàn bộ 15 thư viện vào một API duy nhất, điều phối toàn bộ vòng đời xử lý âm thanh của TokenVector. |

---

## 🚀 4 Trụ Cột Đột Phá Công Nghệ

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                     4 ĐỘT PHÁ CÔNG NGHỆ ÂM THANH CỐT LÕI BẰNG TOKENVECTOR                       │
├─────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 1. Hybrid Neural Codec (codec_rvq.tkv)       : Nén Studio 48kHz xuống 3-8 kbps bằng RVQ & ATH   │
│ 2. Harmonic Super-Resolution (enhancement.tkv): Bù dải cao 24kHz qua Đa thức Chebyshev T2-T5    │
│ 3. Psychoacoustic Virtual Bass (enhancement) : Tái hiện Sub-bass cho loa nhỏ qua sóng hài phi tuyến│
│ 4. Zero-Latency PLC (streaming_plc.tkv)      : Đóng gói 2.5ms & Tự vá mất gói bằng LPC-16       │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🧪 Chứng Minh Thực Thi (16/16 Tests PASSED)

Toàn bộ hệ thống được biên dịch và kiểm chứng trực tiếp bằng trình biên dịch TokenVector:

```powershell
tkvc.exe build test_audio_engine.tkv --entry run --out test_audio_engine.exe
.\test_audio_engine.exe
```

```
================================================================================
TOKENVECTOR.AUDIO - COMPLETE 100% SUITE VERIFICATION (16/16 TESTS)
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
================================================================================
TEST SUMMARY: 16/16 PASSED (100% PURE TOKENVECTOR .TKV)
================================================================================
```

---

## 👤 Tác Giả & Bản Quyền

- **Tác giả & Kiến trúc sư:** Trần Nguyên Hùng ([nguyen.hung.tran.18@gmail.com](mailto:nguyen.hung.tran.18@gmail.com))
- **Hệ sinh thái:** TokenVector Language Platform (.tkv)
- **Giấy phép:** [MIT License](LICENSE)

<div align="center">
<i>Được chế tác với niềm kiêu hãnh bằng 100% Sức mạnh của Ngôn ngữ Lập trình TokenVector.</i>
</div>
