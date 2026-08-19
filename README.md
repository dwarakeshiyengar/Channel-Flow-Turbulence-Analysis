# Turbulence Statistics Toolkit (MATLAB)

A collection of MATLAB scripts for post-processing streamwise velocity data from a wall-bounded turbulent flow (e.g. an open/closed channel). The toolkit checks statistical convergence, homogeneity, stationarity, and spatial correlation of the velocity field across wall-normal (`z`), streamwise (`x`), and spanwise (`y`) directions.

All scripts share a common configuration file (`config.m`) and read pre-exported `.csv` velocity fields from a `data/` folder.

---

## Table of Contents

- [Requirements](#requirements)
- [Directory Structure](#directory-structure)
- [Data Format](#data-format)
- [Configuration](#configurationconfigm)
- [Scripts](#scripts)
  - [mean_velocity_profile_wallnormal.m](#mean_velocity_profile_wallnormalm)
  - [mean_velocity_profile_streamwise.m](#mean_velocity_profile_streamwisem)
  - [stationarity_streamwise.m](#stationarity_streamwisem)
  - [stationarity_spanwise.m](#stationarity_spanwisem)
  - [sliding_window_streamwise.m](#sliding_window_streamwisem)
  - [sliding_window_spanwise.m](#sliding_window_spanwisem)
  - [homogeneity_streamwise.m](#homogeneity_streamwisem)
  - [homogeneity_spanwise.m](#homogeneity_spanwisem)
  - [turbulence_statistics_wallnormal.m](#turbulence_statistics_wallnormalm)
  - [rms_along_x.m](#rms_along_xm)
  - [autocorrelation_streamwise.m](#autocorrelation_streamwisem)
  - [autocorrelation_spanwise.m](#autocorrelation_spanwisem)
- [Quick Start](#quick-start)

---

## Requirements

- MATLAB R2019b or later (uses `tiledlayout`, which requires R2019b+)
- Statistics and Machine Learning Toolbox (for `skewness`, `kurtosis`)
- Signal Processing Toolbox (for `xcorr`)

## Directory Structure

```
.
├── config.m
├── mean_velocity_profile_wallnormal.m
├── mean_velocity_profile_streamwise.m
├── stationarity_streamwise.m
├── stationarity_spanwise.m
├── sliding_window_streamwise.m
├── sliding_window_spanwise.m
├── homogeneity_streamwise.m
├── homogeneity_spanwise.m
├── turbulence_statistics_wallnormal.m
├── rms_along_x.m
├── autocorrelation_streamwise.m
├── autocorrelation_spanwise.m
└── data/
```

Every analysis script calls `run('config.m')` at the top, so `config.m` must remain in the same directory (or on the MATLAB path) as the other scripts.

## Data Format

All scripts expect a `data/` folder (relative to the working directory) containing:

| File | Description | Shape |
|---|---|---|
| `x.csv` | Streamwise coordinate vector | `Nx × 1` |
| `y.csv` | Spanwise coordinate vector | `Ny × 1` |
| `z.csv` | Wall-normal coordinate vector | `Nz × 1` |
| `u_stream_z<i>.csv` | Streamwise velocity time series sampled along `x`, at wall-normal index `i` | `Nt × Nx` |
| `u_span_z<i>.csv` | Streamwise velocity time series sampled along `y`, at wall-normal index `i` | `Nt × Ny` |

- `<i>` ranges from `1` to `Nz` and corresponds to the row index in `z.csv`.
- In the `u_*` matrices, **rows = time steps**, **columns = spatial position** (x or y).
- Scripts that read `u_span_z<i>.csv` skip the wall-normal plane gracefully if the file doesn't exist (`isfile` check).

## Configuration (`config.m`)

Loaded by every script via `run('config.m')`. Defines:

| Variable | Meaning |
|---|---|
| `dataDir` | Path to input data (`'data'`) |
| `x`, `y`, `z` | Coordinate vectors (column vectors) |
| `Nx`, `Ny`, `Nz` | Number of streamwise / spanwise / wall-normal points |
| `dx`, `dy` | Streamwise / spanwise grid spacing |
| `H` | Full domain height (`max(z) - min(z)`) |
| `h` | Half-height (`H/2`) |
| `z_by_h` | Wall-normal coordinate normalized as `(z - min(z)) / h`, i.e. `z/h` |
| `windowSize` | Sliding-window length (500 samples) used by the `sliding_window_*` scripts |
| `z_indices` | Representative wall-normal planes (`[near-wall, mid-height, outer edge]`), used by scripts that only analyze a subset of `z` |

Edit `dataDir`, `windowSize`, or `z_indices` here to change behavior globally.

---

## Scripts

### `mean_velocity_profile_wallnormal.m`
Plots the **mean streamwise velocity as a function of wall-normal position**, `⟨u⟩(z/h)`. Loads each `u_stream_z<i>.csv`, averages over both time and x, and plots one point per plane.

**Figure title:** *Mean Velocity Profile vs Wall-normal Position*

---

### `mean_velocity_profile_streamwise.m`
Plots the **time-averaged streamwise velocity profile along x**, `⟨u⟩(x)`, overlaid for every wall-normal plane in a single figure with a legend.

**Figure title:** *Mean Streamwise Velocity along x for All z-Levels*

---

### `stationarity_streamwise.m`
Plots **spatially-averaged velocity vs. time**, `⟨u⟩_x(t)`, for every wall-normal plane — a temporal stationarity check. One subplot per plane in a `ceil(Nz/2) × 2` tiled layout.

**Figure title:** *Stationarity Check: Streamwise Data (mean over x)*

---

### `stationarity_spanwise.m`
Same check as above but for spanwise data (`⟨u⟩_y(t)`), overlaid for the representative planes in `z_indices`. Skips a plane if its `u_span_z<i>.csv` is missing.

**Figure title:** *Stationarity Check for Spanwise Data*

---

### `sliding_window_streamwise.m`
Performs a **sliding-window stationarity check** over time for every wall-normal plane, using streamwise data.

- For each window of length `windowSize`, computes the mean of `u` over that window (`num_windows = Nt - windowSize + 1`).
- Compares each windowed mean against the full-record mean and reports the maximum percentage deviation, both in the subplot titles and printed to the console.

**Figure title:** *Sliding Window Mean vs Time (All z Levels, Streamwise)*

---

### `sliding_window_spanwise.m`
Same sliding-window check as above, applied to spanwise data at the representative planes in `z_indices`.

**Figure title:** *Stationarity Check via Sliding Window (Spanwise Data)*

---

### `homogeneity_streamwise.m`
Plots `⟨u⟩(x)` per wall-normal plane, annotated with the **maximum percentage deviation** from the plane-averaged mean — a streamwise homogeneity check, for all `z` planes.

**Figure title:** *Streamwise Homogeneity: Time-Averaged u vs x (All z Levels)*

---

### `homogeneity_spanwise.m`
Plots `⟨u⟩(y)` per wall-normal plane, annotated with maximum percentage deviation — a spanwise homogeneity check, for the representative planes in `z_indices`.

**Figure title:** *Spanwise Homogeneity: Time-Averaged u vs y*

---

### `turbulence_statistics_wallnormal.m`
Computes and plots **mean, RMS fluctuation, skewness, and kurtosis (flatness) of u** as a function of `z/h`, for every wall-normal plane, in a 2×2 tiled layout.

**Figure title:** *Turbulence Statistics vs Wall-normal Position*

---

### `rms_along_x.m`
Computes the **RMS of the streamwise velocity fluctuation along x**, at a single wall-normal plane (mid-height by default — edit `z_index` at the top of the script to inspect a different plane).

**Title:** *RMS of Streamwise Fluctuation u' vs x, z/h = \<value\>*

---

### `autocorrelation_streamwise.m`
Computes the **streamwise two-point autocorrelation** `R_uu(r_x)` at the representative planes in `z_indices`. For each plane, fluctuates every time snapshot, accumulates a biased `xcorr` across time, and normalizes by `R(0)`.

**Figure title:** *Streamwise Two-Point Correlation*

---

### `autocorrelation_spanwise.m`
Same two-point correlation procedure as above, computed along `y` using `u_span_z<i>.csv` at the representative planes in `z_indices`. Skips a plane if its file is missing.

**Figure title:** *Spanwise Two-Point Correlation*

---

## Quick Start

```matlab
% 1. Place your CSVs in a "data" folder next to the scripts:
%    data/x.csv, data/y.csv, data/z.csv,
%    data/u_stream_z1.csv ... data/u_stream_zN.csv,
%    data/u_span_z1.csv   ... data/u_span_zN.csv (optional)

% 2. Run any analysis script directly — each one loads config.m itself:
mean_velocity_profile_wallnormal
turbulence_statistics_wallnormal
sliding_window_streamwise
rms_along_x
autocorrelation_spanwise
```

To change the data location, sliding-window length, or which planes are treated as "representative," edit `dataDir`, `windowSize`, or `z_indices` in `config.m`.

---

## License

This project is licensed under the MIT License.
