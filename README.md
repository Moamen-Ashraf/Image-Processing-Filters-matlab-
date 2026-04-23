# 📷 MATLAB Image Processing Algorithms

A clean, well-documented collection of classical image processing algorithms implemented from scratch in MATLAB — no external toolboxes required beyond the core Image Processing Toolbox.

---

## 📋 Table of Contents

- [Project Structure](#project-structure)
- [Setup & Requirements](#setup--requirements)
- [Quick Start](#quick-start)
- [Algorithm Reference](#algorithm-reference)
  - [Spatial Filters](#-spatial-filters)
  - [Frequency Domain Filters](#-frequency-domain-filters)
  - [Intensity Transforms](#-intensity-transforms)
  - [Histogram Processing](#-histogram-processing)
  - [Edge Detection](#-edge-detection)
  - [Color Utilities](#-color-utilities)
  - [Image Arithmetic](#-image-arithmetic)
- [Contributing](#contributing)

---

## Project Structure

```
matlab-image-processing/
│
├── spatial_filters/
│   ├── averaging_filter.m          Mean (box) filter
│   ├── weighted_average_filter.m   Gaussian-like 3×3 weighted filter
│   ├── gaussian_filter.m           2-D Gaussian blur (manual convolution)
│   ├── sharpening_filter.m         Laplacian-based sharpening
│   ├── unsharp_mask_filter.m       Unsharp masking
│   └── median_filter.m             Salt-and-pepper noise removal
│
├── frequency_filters/
│   ├── ideal_lpf.m                 Ideal Low-Pass Filter
│   ├── ideal_hpf.m                 Ideal High-Pass Filter
│   ├── butterworth_lpf.m           Butterworth Low-Pass Filter
│   ├── butterworth_hpf.m           Butterworth High-Pass Filter
│   ├── gaussian_lpf.m              Gaussian Low-Pass Filter
│   └── gaussian_hpf.m              Gaussian High-Pass Filter
│
├── intensity_transforms/
│   ├── brightness_shift.m          Additive brightness / darkening
│   ├── contrast_stretch.m          Linear contrast stretching
│   ├── power_law_transform.m       Gamma correction
│   ├── image_negative.m            Photographic negative
│   └── quantization.m              Bit-depth (grey-level) reduction
│
├── histogram_processing/
│   ├── draw_histogram.m            Plot intensity histogram
│   ├── histogram_equalization.m    Histogram equalisation
│   └── histogram_matching.m        Histogram specification / matching
│
├── edge_detection/
│   ├── laplacian_edge_filter.m     Laplacian edge detector
│   └── sobel_edge_detection.m      Sobel gradient edge detector
│
├── color_utils/
│   ├── rgb_to_gray.m               Five grayscale conversion methods
│   └── image_upscale.m             Nearest-neighbour / bilinear upscaling
│
├── image_arithmetic/
│   └── image_arithmetic.m          Pixel-wise addition and subtraction
│
├── images/                         Sample test images
└── docs/
    └── algorithm_descriptions.md   Extended mathematical descriptions
```

---

## Setup & Requirements

### Requirements

| Requirement | Version |
|---|---|
| MATLAB | R2018b or later |
| Image Processing Toolbox | Any version compatible with MATLAB above |

> **Note:** The frequency-domain filters and basic spatial filters only use `fft2`, `ifft2`, `fftshift`, `imshow`, and `imfilter` — all included in the standard Image Processing Toolbox.

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/matlab-image-processing.git
   ```

2. **Open MATLAB** and navigate to the repository folder:
   ```matlab
   cd('path/to/matlab-image-processing')
   ```

3. **Add all subfolders to the MATLAB path:**
   ```matlab
   addpath(genpath(pwd))
   ```
   To make this permanent, run `savepath` afterwards.

4. **Verify setup** by running a quick test:
   ```matlab
   img = imread('images/image.jpg');
   averaging_filter(img, 5);
   ```

---

## Quick Start

```matlab
% Load a sample image
img      = imread('images/image.jpg');
gray_img = rgb2gray(img);

% --- Spatial Filters ---
averaging_filter(img, 5);
weighted_average_filter(img);
gaussian_filter(img, 5, 1.5);
sharpening_filter(img);
unsharp_mask_filter(img, 2);
median_filter(img);

% --- Frequency Filters (require grayscale input) ---
ideal_lpf(gray_img, 30);
ideal_hpf(gray_img, 30);
butterworth_lpf(gray_img, 30, 2);
butterworth_hpf(gray_img, 30, 2);
gaussian_lpf(gray_img, 30);
gaussian_hpf(gray_img, 30);

% --- Intensity Transforms ---
brightness_shift(img,  80);       % brighten
brightness_shift(img, -80);       % darken
contrast_stretch(img);
power_law_transform(img, 0.5);    % gamma < 1 brightens
image_negative(img);
quantization(img, 3);             % 8 grey levels

% --- Histogram ---
draw_histogram(gray_img);
histogram_equalization(gray_img);
ref = imread('images/image1.jpg');
histogram_matching(img, ref);

% --- Edge Detection ---
laplacian_edge_filter(img);
sobel_edge_detection(img);

% --- Color Utilities ---
rgb_to_gray(img);
image_upscale(img, 2, 'nearest');
image_upscale(img, 2, 'bilinear');

% --- Arithmetic ---
img2 = imread('images/image1.jpg');
image_arithmetic(img, img2);
```

---

## Algorithm Reference

### 🟦 Spatial Filters

Spatial filters operate directly on image pixel values using a convolution kernel.

#### `averaging_filter(img, window_size)`
Replaces each pixel with the average of its neighbourhood.

**Kernel** (k×k):
```
H = ones(k, k) / k²
```
- Blurs the image and reduces Gaussian noise.
- Larger `window_size` → stronger blur.

---

#### `weighted_average_filter(img)`
Applies a 3×3 binomial kernel — a smooth approximation to a Gaussian.

**Kernel:**
```
     [1 2 1]
H =  [2 4 2] / 16
     [1 2 1]
```
- Less blurring than a uniform average; preserves edges slightly better.

---

#### `gaussian_filter(image, filter_size, sigma)`
Convolves the image with a proper 2-D Gaussian kernel (manual convolution loop).

**Kernel:** generated by `fspecial('gaussian', filter_size, sigma)`

**Formula:** `G(x,y) = exp(-(x²+y²) / (2σ²)) / (2πσ²)`

- `sigma` controls the spread: larger σ → more blur.
- No ringing artefacts.

---

#### `sharpening_filter(img)`
Enhances edges by subtracting the Laplacian from the original image.

**Kernel:**
```
     [0 -1  0]
H =  [-1  5 -1]
     [0 -1  0]
```
Equivalent to: `output = original + Laplacian`

---

#### `unsharp_mask_filter(img, sigma)`
Classic photographic unsharp masking.

**Algorithm:**
```
mask   = original - Gaussian_blur(original, sigma)
output = original + mask
```

---

#### `median_filter(img)`
Replaces each pixel with the **median** of its 3×3 neighbourhood.

- Excellent for **salt-and-pepper noise**.
- Preserves edges better than averaging.

---

### 🟩 Frequency Domain Filters

Frequency filters operate on the Fourier transform of the image. All filters follow the same pipeline:

```
F  = fft2(image)          % forward FFT
FS = fftshift(F)          % centre the spectrum
G  = H .* FS              % apply filter H(u,v)
output = real(ifft2(ifftshift(G)))   % inverse FFT
```

where `D(u,v) = sqrt((u - M/2)² + (v - N/2)²)` is the distance from the spectral centre.

---

#### `ideal_lpf(img, D0)` / `ideal_hpf(img, D0)`

| Filter | Transfer Function H(u,v) |
|---|---|
| Ideal LPF | `1` if `D ≤ D0`, else `0` |
| Ideal HPF | `0` if `D ≤ D0`, else `1` |

⚠️ Sharp cutoff causes **Gibbs ringing** artefacts.

---

#### `butterworth_lpf(img, D0, n)` / `butterworth_hpf(img, D0, n)`

| Filter | Transfer Function H(u,v) |
|---|---|
| Butterworth LPF | `1 / (1 + (D/D0)^(2n))` |
| Butterworth HPF | `1 / (1 + (D0/D)^(2n))` |

- Smooth transition band — no ringing.
- `n` (order): higher = sharper cutoff.

---

#### `gaussian_lpf(img, D0)` / `gaussian_hpf(img, D0)`

| Filter | Transfer Function H(u,v) |
|---|---|
| Gaussian LPF | `exp(-D² / (2·D0²))` |
| Gaussian HPF | `1 - exp(-D² / (2·D0²))` |

- Smoothest transition of all three families.
- No ringing because the Fourier transform of a Gaussian is a Gaussian.

---

### 🟨 Intensity Transforms

Point operations that map each input pixel intensity `r` to an output intensity `s = T(r)`.

#### `brightness_shift(img, offset)`
`s = clamp(r + offset, 0, 255)`

#### `contrast_stretch(img)`
`s = (r - r_min) / (r_max - r_min) × 255`

#### `power_law_transform(img, gamma)`
`s = c · r^γ` where `c = 255 / 255^γ`
- `γ < 1` → brightens (expands dark tones)
- `γ > 1` → darkens (compresses dark tones)

#### `image_negative(img)`
`s = 255 - r`

#### `quantization(img, bits)`
Reduces the image to `2^bits` grey levels.

---

### 🟧 Histogram Processing

#### `draw_histogram(img)`
Plots the pixel frequency distribution across 256 intensity levels.

#### `histogram_equalization(img)`
Redistributes intensities so the output histogram is approximately uniform.

**Algorithm:**
1. Compute PDF: `p(r) = count(r) / total_pixels`
2. Compute CDF: `CDF(r) = Σ p(i)` for i = 0..r
3. Map: `s = round(CDF(r) × 255)`

#### `histogram_matching(source, reference)`
Transforms source image intensities so its histogram matches the reference.

---

### 🟥 Edge Detection

#### `laplacian_edge_filter(img)`
Uses the 8-connected Laplacian kernel to detect edges in all directions:
```
[-1 -1 -1]
[-1  8 -1]
[-1 -1 -1]
```

#### `sobel_edge_detection(img)`
Computes the gradient magnitude using Sobel operators:
```
Gx = [-1 0 1; -2 0 2; -1 0 1]
Gy = Gx'
magnitude = sqrt(Gx² + Gy²)
```

---

### 🟪 Color Utilities

#### `rgb_to_gray(img)`
Demonstrates five grayscale conversion methods:
| Method | Formula |
|---|---|
| Single Channel | `Gray = R` |
| Averaging | `Gray = (R+G+B)/3` |
| Luminance | `Gray = 0.299R + 0.587G + 0.114B` (ITU-R BT.601) |
| Decomposition | `Gray = max(R,G,B)` |
| Desaturation | `Gray = (max(R,G,B) + min(R,G,B)) / 2` |

#### `image_upscale(img, factor, method)`
Upscales an image by an integer factor using:
- `'nearest'` — pixel replication (blocky but fast)
- `'bilinear'` — smooth interpolation

---

### ⬜ Image Arithmetic

#### `image_arithmetic(img1, img2)`
Computes pixel-wise addition and subtraction between two images.
- Images are automatically resized to match.
- Output is clamped to `[0, 255]`.

---

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/new-algorithm`
3. Follow the existing docstring format (see any `.m` file).
4. Test your function with at least one image from the `images/` folder.
5. Submit a pull request with a clear description.

---

## Author

**Momen Ashraf**  
[linkedin.com/in/momen-ashraf-](https://linkedin.com/in/momen-ashraf-)
