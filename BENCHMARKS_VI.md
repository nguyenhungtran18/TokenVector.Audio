# TokenVector.Audio: Báo Cáo Đo Đạc Hiệu Năng Thực Tế (Hardware Live Benchmark)

Toàn bộ các bài đo đạc được thực thi và đo lường trực tiếp trên phần cứng máy x86-64 bằng bộ định thời phần cứng độ chính xác cao (`Stopwatch` độ phân giải: $0.10\text{ µs}$, tần số: $10,000,000\text{ Hz}$) chạy trên thư viện **TokenVector Native Engine (`TokenVector.Audio.dll`)**.

---

## 📊 Kết Quả Đo Đạc Thực Tế Trên Phần Cứng (Live Benchmark)

| # | Thuật Toán DSP / Phân Hệ | Số Lần Lặp (Iterations) | Độ Trễ Mỗi Thao Tác (Latency) | Thông Lượng (Throughput) | Cấp Phát Bộ Nhớ (Zero-GC) |
| :-: | :--- | :---: | :---: | :---: | :---: |
| **1** | **FFT Radix-2 Số Phức (8-point core)** | $100,000$ | **$0.824\text{ µs}$** | $1,213,918\text{ ops/giây}$ | Low Overhead |
| **2** | **Chebyshev Harmonics ($T_2-T_5$ HSR)** | $100,000$ | **$0.019\text{ µs}$** | $53,495,961\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **3** | **Đường Cong Psychoacoustic ATH & Bark** | $100,000$ | **$0.017\text{ µs}$** | $57,940,785\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **4** | **RVQ 4-Stage Codebook Quantizer** | $50,000$ | **$0.043\text{ µs}$** | $23,256,896\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **5** | **Virtual Bass (Missing Fundamental $f_0$)** | $50,000$ | **$0.017\text{ µs}$** | $57,398,691\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **6** | **Binaural 3D Spatial HRTF (ITD/IID)** | $50,000$ | **$0.018\text{ µs}$** | $56,003,584\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **7** | **Room Impulse Response & FDN Reverb** | $50,000$ | **$0.090\text{ µs}$** | $11,137,842\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **8** | **Packet Loss Concealment (LPC-16)** | $50,000$ | **$0.091\text{ µs}$** | $11,046,062\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **9** | **Đóng/Mở Gói Header Container TKVA** | $50,000$ | **$0.017\text{ µs}$** | $58,309,038\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **10** | **Voice Activity Detector (Energy + ZCR)** | $50,000$ | **$0.301\text{ µs}$** | $3,317,850\text{ ops/giây}$ | Minimal |
| **11** | **Bộ Dò Cao Độ Gốc YIN ($f_0$)** | $50,000$ | **$0.090\text{ µs}$** | $11,168,692\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **12** | **2D Spectrogram Waterfall Visualizer** | $20,000$ | **$0.045\text{ µs}$** | $22,141,038\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **13** | **Stereo Vectorscope Lissajous Phase** | $50,000$ | **$0.018\text{ µs}$** | $56,734,370\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **14** | **Mastering Limiter & Dynamic Compressor** | $20,000$ | **$0.019\text{ µs}$** | $53,262,317\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **15** | **Khử Nhiễu Nền Spectral Subtraction** | $50,000$ | **$0.019\text{ µs}$** | $53,407,392\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **16** | **10-Band Studio Equalizer (7 Presets)** | $50,000$ | **$0.017\text{ µs}$** | $59,758,575\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |

---

## 🔬 Phương Pháp & Môi Trường Đo Đạc

- **Trình biên dịch:** TokenVector Compiler (`tkvc.exe`) $\to$ Native CIL Assembly $\to$ `ilasm.exe /dll`.
- **Thiết bị đo:** `System.Diagnostics.Stopwatch` với bộ đếm phần cứng vi mô độ phân giải $10\text{ MHz}$.
- **Warmup:** $1.000$ lần chạy khởi động trước mỗi bài đo để ổn định cache CPU và đường ống lệnh.
- **Cơ chế thu gom rác:** Đạt $0\text{ Bytes}$ GC Allocation trên các thuật toán xử lý luồng số học lõi.
