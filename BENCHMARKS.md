# TokenVector.Audio: Performance Benchmark Report

All benchmarks executed on x86-64 with AVX2 and FMA SIMD acceleration on .NET 8.0 Runtime.

---

## 📊 Benchmark Summary Table

| Benchmark Category | Configuration / Size | Latency | Throughput | Realtime Speed Factor | GC Allocation |
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
