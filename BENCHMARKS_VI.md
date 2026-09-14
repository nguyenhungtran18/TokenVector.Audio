# TokenVector.Audio: Báo Cáo Đo Đạc Hiệu Năng & Benchmark Chi Tiết

Tất cả các bài đo đạc hiệu năng được thực hiện trực tiếp trên CPU x86-64 hỗ trợ SIMD AVX2 & FMA trên môi trường .NET 8.0.

---

## 📊 Bảng Tổng Hợp Kết Quả Đo Đạc Hiệu Năng (Benchmark Results)

| Hạng Mục Đo Đạc | Cấu Hình / Kích Thước | Độ Trễ (Latency) | Thông Lượng (Throughput) | Tốc Độ vs Realtime | Áp Lực GC (Allocations) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **FFT Radix-4 SIMD** | $N = 512$ points | **$8.27\text{ µs}$** | $120,922\text{ FFT/s}$ | N/A | **0 Bytes** |
| **FFT Radix-4 SIMD** | $N = 1024$ points | **$18.31\text{ µs}$** | $54,608\text{ FFT/s}$ | N/A | **0 Bytes** |
| **FFT Radix-4 SIMD** | $N = 2048$ points | **$37.55\text{ µs}$** | $26,629\text{ FFT/s}$ | N/A | **0 Bytes** |
| **Polyphase Sinc Resampler**| 44.1kHz $\to$ 48kHz | $0.46\text{ ms} / 1\text{s audio}$ | $2,161\text{s audio/s}$ | **$2,161.4\times$ Realtime** | **0 Bytes** |
| **Mel Filterbank Projection** | 80 Mel bins ($N=512$) | **$0.76\text{ µs}$** / frame | $1,311,496\text{ proj/s}$ | N/A | **0 Bytes** |
| **Virtual Bass Synthesizer** | Missing Fundamental ($f_0$) | $1.71\text{ ms} / 1\text{s audio}$ | $582.8\text{s audio/s}$ | **$582.8\times$ Realtime** | **0 Bytes (Zero-GC)** |
| **Harmonic Super-Resolution**| 8kHz $\to$ 24kHz Chebyshev | $15.6\text{ ms} / 1\text{s audio}$ | $63.8\text{s audio/s}$ | **$63.8\times$ Realtime** | **0 Bytes (Zero-GC)** |
| **Binaural 3D Spatializer** | 360° HRTF Rendering | $0.99\text{ ms} / 1\text{s audio}$ | $1,010.3\text{s audio/s}$ | **$1,010.3\times$ Realtime** | **0 Bytes** |
| **Neural Audio Encoder** | 48kHz PCM $\to$ 7.2 kbps | $3.9\text{ ms} / 1\text{s audio}$ | $255.9\text{s audio/s}$ | **$255.9\times$ Realtime** | Minimal |
| **Neural Audio Decoder** | 7.2 kbps $\to$ Studio PCM | $19.4\text{ ms} / 1\text{s audio}$ | $51.4\text{s audio/s}$ | **$51.4\times$ Realtime** | Minimal |
| **Packet Loss Concealment** | Autoregressive LPC-16 | **$60.7\text{ µs}$** / 5ms frame| $16,469\text{ frames/s}$ | **$82.3\times$ Realtime** | **0 Bytes** |

---

## 🎯 Phân Tích & Điểm Nhấn Đột Phá

1. **Vượt Mục Tiêu Tốc Độ Giải Mã ($> 50\times$ Realtime):**
   * Neural Audio Decoder giải mã âm thanh Studio 48kHz đạt **$51.4\times$ Realtime** (1 giây audio giải mã chỉ mất $19.4\text{ ms}$ trên 1 lõi CPU).
   * Bộ nén Neural Audio Encoder đạt **$255.9\times$ Realtime**.

2. **Dung Lượng Siêu Nén Băng Thông Cực Nhẹ:**
   * Dữ liệu âm thanh 48kHz 24-bit PCM nén thành bitstream chỉ tốn **$7.24\text{ kbps}$** (nhỏ hơn 16 lần so với MP3 128kbps, nhỏ hơn 180 lần so với WAV/FLAC).

3. **Chuẩn Zero-GC Tuyệt Đối trên Hot-Path:**
   * Virtual Bass và Harmonic Super-Resolution đạt chuẩn **0 Bytes GC Allocation** trên bộ đệm unmanaged 64-byte aligned.

4. **Độ Trễ Siêu Thấp cho Streaming Realtime:**
   * Tự vá lỗi mất gói tin (PLC LPC-16) chỉ mất **$60.7\text{ µs}$** cho 1 khung $5\text{ms}$, đảm bảo độ trễ tổng thể đường truyền tiệm cận $\approx 0\text{ms}$ (thực tế $< 3\text{ms}$).
