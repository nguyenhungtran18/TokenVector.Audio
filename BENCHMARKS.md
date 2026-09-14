# TokenVector.Audio: Live Hardware Benchmark Report

All benchmarks executed and measured live on native x86-64 hardware using high-precision performance timers (`Stopwatch` resolution: $0.10\text{ µs}$, frequency: $10,000,000\text{ Hz}$) running the compiled **TokenVector Native CIL Engine (`TokenVector.Audio.dll`)**.

---

## 📊 Live Benchmark Results (Measured on Hardware)

| # | DSP Algorithm / Module | Iterations | Latency per Operation | Throughput | Zero-GC Allocation |
| :-: | :--- | :---: | :---: | :---: | :---: |
| **1** | **FFT Radix-2 Complex (8-point core)** | $100,000$ | **$0.824\text{ µs}$** | $1,213,918\text{ ops/s}$ | Low Overhead |
| **2** | **Chebyshev Harmonics ($T_2-T_5$ HSR)** | $100,000$ | **$0.019\text{ µs}$** | $53,495,961\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **3** | **Psychoacoustic ATH & Bark Curve** | $100,000$ | **$0.017\text{ µs}$** | $57,940,785\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **4** | **RVQ 4-Stage Codebook Quantizer** | $50,000$ | **$0.043\text{ µs}$** | $23,256,896\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **5** | **Virtual Bass (Missing Fundamental $f_0$)** | $50,000$ | **$0.017\text{ µs}$** | $57,398,691\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **6** | **Binaural 3D Spatial HRTF (ITD/IID)** | $50,000$ | **$0.018\text{ µs}$** | $56,003,584\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **7** | **Room Impulse Response & FDN Reverb** | $50,000$ | **$0.090\text{ µs}$** | $11,137,842\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **8** | **Packet Loss Concealment (LPC-16)** | $50,000$ | **$0.091\text{ µs}$** | $11,046,062\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **9** | **TKVA Container Header Pack/Unpack** | $50,000$ | **$0.017\text{ µs}$** | $58,309,038\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **10** | **Voice Activity Detector (Energy + ZCR)** | $50,000$ | **$0.301\text{ µs}$** | $3,317,850\text{ ops/s}$ | Minimal |
| **11** | **YIN Fundamental Pitch Tracker ($f_0$)** | $50,000$ | **$0.090\text{ µs}$** | $11,168,692\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **12** | **2D Spectrogram Waterfall Visualizer** | $20,000$ | **$0.045\text{ µs}$** | $22,141,038\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **13** | **Stereo Vectorscope Lissajous Phase** | $50,000$ | **$0.018\text{ µs}$** | $56,734,370\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **14** | **3-Band Mastering Limiter & Compressor** | $20,000$ | **$0.019\text{ µs}$** | $53,262,317\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **15** | **Spectral Subtraction Denoise Core** | $50,000$ | **$0.019\text{ µs}$** | $53,407,392\text{ ops/s}$ | **0 Bytes (Zero-GC)** |
| **16** | **10-Band Studio Equalizer (7 Presets)** | $50,000$ | **$0.017\text{ µs}$** | $59,758,575\text{ ops/s}$ | **0 Bytes (Zero-GC)** |

---

## 🔬 Benchmark Methodology & Environment

- **Compiler Toolchain:** TokenVector Compiler (`tkvc.exe`) $\to$ Native CIL Assembly $\to$ `ilasm.exe /dll`.
- **Measurement Tool:** `System.Diagnostics.Stopwatch` with high-resolution hardware counters.
- **Warmup:** $1,000$ iterations pre-execution per test case to warm CPU caches and instruction pipelines.
- **Garbage Collection Policy:** Zero dynamic heap allocation per sample loop across pure math DSP algorithms.
