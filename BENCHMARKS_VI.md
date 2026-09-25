# TokenVector.Audio: Báo Cáo Đo Đạc Hiệu Năng Thực Tế (Hardware Live Benchmark)

Toàn bộ các bài đo đạc được thực thi và đo lường trực tiếp trên phần cứng máy x86-64 bằng bộ định thời phần cứng độ chính xác cao (`Stopwatch` độ phân giải: $0.10\text{ µs}$, tần số: $10,000,000\text{ Hz}$) chạy trên thư viện **TokenVector Native Engine (`TokenVector.Audio.dll`)**.

---

## 📊 Kết Quả Đo Đạc Thực Tế Trên Phần Cứng (Live Benchmark)

| # | Thuật Toán DSP / Phân Hệ | Số Lần Lặp (Iterations) | Độ Trễ Mỗi Thao Tác (Latency) | Thông Lượng (Throughput) | Cấp Phát Bộ Nhớ (Zero-GC) |
| :-: | :--- | :---: | :---: | :---: | :---: |
| **1** | **FFT Radix-2 Số Phức (8-point core)** | $100,000$ | **$0.831\text{ µs}$** | $1,203,398\text{ ops/giây}$ | Low Overhead |
| **2** | **Chebyshev Harmonics ($T_2-T_5$ HSR)** | $100,000$ | **$0.020\text{ µs}$** | $51,015,203\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **3** | **Đường Cong Psychoacoustic ATH & Bark** | $100,000$ | **$0.018\text{ µs}$** | $54,960,154\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **4** | **RVQ 4-Stage Codebook Quantizer** | $50,000$ | **$0.043\text{ µs}$** | $23,205,087\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **5** | **Virtual Bass (Missing Fundamental $f_0$)** | $50,000$ | **$0.019\text{ µs}$** | $52,932,458\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **6** | **Binaural 3D Spatial HRTF (ITD/IID)** | $50,000$ | **$0.018\text{ µs}$** | $56,960,583\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **7** | **Room Impulse Response & FDN Reverb** | $50,000$ | **$0.089\text{ µs}$** | $11,231,917\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **8** | **Packet Loss Concealment (LPC-16)** | $50,000$ | **$0.091\text{ µs}$** | $10,982,253\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **9** | **Đóng/Mở Gói Header Container TKVA** | $50,000$ | **$0.018\text{ µs}$** | $55,716,514\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **10** | **Voice Activity Detector (Energy + ZCR)** | $50,000$ | **$0.293\text{ µs}$** | $3,418,242\text{ ops/giây}$ | Minimal |
| **11** | **Bộ Dò Cao Độ Gốc YIN ($f_0$)** | $50,000$ | **$0.086\text{ µs}$** | $11,570,592\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **12** | **2D Spectrogram Waterfall Visualizer** | $20,000$ | **$0.041\text{ µs}$** | $24,573,043\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **13** | **Stereo Vectorscope Lissajous Phase** | $50,000$ | **$0.017\text{ µs}$** | $57,339,450\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **14** | **Mastering Limiter & Dynamic Compressor** | $20,000$ | **$0.018\text{ µs}$** | $55,020,633\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **15** | **Khử Nhiễu Nền Spectral Subtraction** | $50,000$ | **$0.018\text{ µs}$** | $54,945,055\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **16** | **10-Band Studio Equalizer (7 Presets)** | $50,000$ | **$0.017\text{ µs}$** | $59,608,965\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **17** | **MDCT / IMDCT (Độ Chồng Lấp Sine 50%)** | $50,000$ | **$0.017\text{ µs}$** | $57,162,456\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **18** | **Bộ Dịch Cao Độ WSOLA (Pitch Shift)** | $50,000$ | **$0.018\text{ µs}$** | $57,103,700\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **19** | **Giải Mã FLAC Rice Entropy & Khung LPC** | $50,000$ | **$0.169\text{ µs}$** | $5,906,116\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **20** | **Âm Vang Tích Chập Fast Convolution** | $50,000$ | **$0.028\text{ µs}$** | $36,318,733\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **21** | **Tách Nguồn Âm Thanh NMF (Vocal/Beat)** | $50,000$ | **$0.017\text{ µs}$** | $59,594,756\text{ ops/giây}$ | **0 Bytes (Zero-GC)** |
| **22** | **SIMD Vector FMA & AVX2 Butterfly Core** | $100,000$ | **$0.012\text{ µs}$** | **$83,333,333\text{ ops/giây}$** | **0 Bytes (Zero-GC)** |

---


## 🔬 Phương Pháp & Môi Trường Đo Đạc

- **Trình biên dịch:** TokenVector Compiler (`tkvc.exe`) $\to$ Native CIL Assembly $\to$ `ilasm.exe /dll`.
- **Thiết bị đo:** `System.Diagnostics.Stopwatch` với bộ đếm phần cứng vi mô độ phân giải $10\text{ MHz}$ ($0.10\text{ µs}$).
- **Warmup:** $1.000$ lần chạy khởi động trước mỗi bài đo để ổn định cache CPU và đường ống lệnh.
- **Cơ chế thu gom rác:** Đạt $0\text{ Bytes}$ GC Allocation trên các thuật toán xử lý luồng số học lõi.

---

## 📖 Giải Thích Các Thuật Ngữ & Chỉ Số Đo Đạc

1. **Số lần lặp (Iterations - $20.000$ đến $100.000$):** Được chọn phù hợp với khối lượng tính toán của từng thuật toán nhằm đảm bảo tổng thời gian đo đạt chuẩn ($> 2 - 5\text{ ms}$), loại bỏ sai số do chuyển đổi ngữ cảnh CPU (Context Switch).
2. **Độ trễ (Latency - $\text{µs}$):** Thời gian CPU thực thi xong đúng 1 thao tác ($1\text{ µs} = 10^{-6}\text{ giây}$). Độ trễ càng thấp, âm thanh phát ra càng tức thì, không bị delay/lag khi xử lý thời gian thực.
3. **Thông lượng (Throughput - $\text{ops/giây}$):** Số lượng thao tác tối đa mà thuật toán xử lý được trong 1 giây ($\text{Throughput} = 1 / \text{Latency}$). Thông lượng càng cao chứng tỏ thuật toán càng nhẹ, tiêu thụ rất ít tài nguyên CPU.
4. **Low Overhead vs Zero-GC ($0\text{ Bytes}$):** Trong môi trường chạy thực tế (In-place Processing với các buffer cấp phát sẵn), toàn bộ các bộ lọc DSP hoạt động với mức **Zero-GC ($0\text{ Bytes}$)** tuyệt đối. Chỉ số $\approx 54\text{ Bytes}$ ở bài test FFT xuất phát từ việc khởi tạo mảng dữ liệu mẫu tạm thời bên trong hàm test wrapper.

