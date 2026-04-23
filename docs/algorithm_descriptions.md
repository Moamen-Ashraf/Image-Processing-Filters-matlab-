# Algorithm Descriptions — Mathematical Detail

This document supplements the README with deeper mathematical background for each algorithm.

---

## Spatial Filters

### Convolution Fundamentals

All spatial filters apply 2-D discrete convolution:

```
(f * h)[i,j] = Σ_m Σ_n  f[m,n] · h[i-m, j-n]
```

where `f` is the image and `h` is the kernel. In MATLAB, `imfilter` implements correlation (not convolution), which is equivalent for symmetric kernels like Gaussian and averaging kernels.

### Averaging Filter
- **Kernel size:** k×k, all entries = 1/k²
- **Effect:** Blurs image; equivalent to low-pass filtering in frequency domain.
- **Noise model suited for:** Gaussian noise (reduces variance by factor 1/k²).

### Weighted Average (Gaussian Approximation)
- **Kernel:** [1 2 1; 2 4 2; 1 2 1] / 16
- This is the 2-D binomial kernel of order 2, a discrete approximation to a Gaussian with σ ≈ 0.85.

### Gaussian Filter
- **Kernel:** G(x,y) = exp(-(x²+y²) / (2σ²)) / (2πσ²)
- Frequency response is also Gaussian → no ringing artefacts.
- FWHM = 2√(2ln2)·σ ≈ 2.355·σ

### Sharpening Filter (Laplacian)
- **Laplacian of an image:** ∇²f = ∂²f/∂x² + ∂²f/∂y²
- 4-connected discrete approximation: [0 1 0; 1 -4 1; 0 1 0]
- Sharpening kernel = Identity - Laplacian = [0 -1 0; -1 5 -1; 0 -1 0]

### Unsharp Masking
- `mask = f - Gaussian(f)`   (high-frequency content)
- `sharpened = f + mask = 2f - Gaussian(f)`
- Amount of sharpening controlled by σ of the Gaussian blur.

### Median Filter
- Non-linear filter — selects the median of neighbourhood values.
- Optimal for **impulse noise** (salt-and-pepper).
- Does NOT blur edges (unlike linear smoothing filters).

---

## Frequency Domain Filters

### DFT Basis

The 2-D Discrete Fourier Transform:
```
F(u,v) = Σ_x Σ_y  f(x,y) · exp(-j2π(ux/M + vy/N))
```

After `fftshift`, the DC component (u=0,v=0) is at the centre. Distance from centre:
```
D(u,v) = sqrt((u - M/2)² + (v - N/2)²)
```

### Ideal Filters

```
LPF:  H(u,v) = 1 if D ≤ D0,  else 0
HPF:  H(u,v) = 0 if D ≤ D0,  else 1
```
Sharp cutoff in frequency domain ↔ ringing (Gibbs phenomenon) in spatial domain.

### Butterworth Filters

```
LPF:  H(u,v) = 1 / (1 + (D/D0)^(2n))
HPF:  H(u,v) = 1 / (1 + (D0/D)^(2n))
```
- At D = D0: H = 0.5 (3 dB point)
- n→∞: approaches ideal filter
- Smooth falloff → little ringing

### Gaussian Filters

```
LPF:  H(u,v) = exp(-D² / (2·D0²))
HPF:  H(u,v) = 1 - exp(-D² / (2·D0²))
```
- No ringing — FT of Gaussian is Gaussian
- D0 = σ of the Gaussian in frequency domain

---

## Intensity Transforms

All point transforms apply a mapping `s = T(r)` independently to each pixel.

### Power Law (Gamma Correction)
```
s = c · r^γ    where c = L / L^γ = L^(1-γ),  L = 255
```
- Monitors typically have γ ≈ 2.2 (CRT) or γ ≈ 1.8–2.4 (LCD)
- Correction: apply γ_correction = 1 / γ_display

### Contrast Stretching
Linear map from [r_min, r_max] → [0, 255]:
```
s = (r - r_min) · (255 / (r_max - r_min))
```

### Image Negative
```
s = (L-1) - r = 255 - r
```
Useful for displaying medical images (e.g. X-rays).

---

## Histogram Processing

### Histogram Equalization

Given CDF(r) = Σ_{i=0}^{r} p(i):
```
s = round((L-1) · CDF(r))
```
Result: output histogram approximates uniform distribution, maximising entropy.

### Histogram Matching (Specification)

Given source CDF `Cs` and target CDF `Cr`:
For each source level r, find s such that `Cr(s) ≈ Cs(r)`.
```
s = Cr⁻¹(Cs(r))
```

---

## Edge Detection

### Laplacian
Second-order derivative → detects edges as zero crossings.
Sensitive to noise — often applied after Gaussian smoothing (LoG filter).

### Sobel Operator
First-order derivative in x and y:
```
Gx = [-1 0 1; -2 0 2; -1 0 1]
Gy = Gx'
|G| = sqrt(Gx² + Gy²)
θ   = atan2(Gy, Gx)
```
`|G|` gives edge magnitude; `θ` gives edge orientation.

---

## Grayscale Conversion

| Method | Formula | Notes |
|---|---|---|
| Single Channel | Gray = R | Ignores G and B entirely |
| Averaging | Gray = (R+G+B)/3 | Equal weight; not perceptually uniform |
| Luminance | Gray = 0.299R + 0.587G + 0.114B | ITU-R BT.601; matches human perception |
| Decomposition | Gray = max(R,G,B) | Brightest channel dominates |
| Desaturation | Gray = (max+min)/2 | Average of extremes |

The **luminance** method is standard for photography and video because human vision is most sensitive to green (0.587 weight) and least sensitive to blue (0.114 weight).
