
# Channel Flow Turbulence Analysis

A MATLAB-based toolkit for statistical analysis of channel-flow velocity data, including mean velocity profiles, stationarity, homogeneity, turbulence statistics, and two-point spatial correlations.

---

## 1. Overview

This repository contains a collection of MATLAB scripts for the statistical analysis and post-processing of velocity data from channel-flow simulations or experiments.

The scripts are organized as independent analysis modules, allowing individual quantities to be calculated without running a single large processing script.

The analysis includes:

* Mean velocity profiles
* Streamwise mean velocity distribution
* Temporal stationarity
* Sliding-window stationarity
* Streamwise homogeneity
* Spanwise homogeneity
* RMS velocity fluctuations
* Skewness and kurtosis
* Streamwise RMS variation
* Streamwise two-point velocity correlation
* Spanwise two-point velocity correlation

The scripts are designed to work with different numbers of time samples, spatial locations, and wall-normal levels, provided the input data follow the specified format.

---

## 2. Requirements

### Software

* MATLAB
* MATLAB functions used by the scripts:

  * `readmatrix`
  * `xcorr`
  * `skewness`
  * `kurtosis`

No specialized CFD or turbulence toolbox is required for the analysis.

---

## 3. Repository Structure


channel-flow-analysis/
│
├── config.m
│
├── mean_velocity_profile.m
├── mean_velocity_streamwise.m
├── stationarity.m
├── sliding_window_stationarity.m
├── streamwise_homogeneity.m
├── spanwise_homogeneity.m
├── turbulence_statistics.m
├── rms_along_x.m
├── streamwise_autocorrelation.m
└── spanwise_autocorrelation.m

The input data should be placed inside a `data` directory:


channel-flow-analysis/
│
├── config.m
├── ...
│
└── data/
    ├── x.csv
    ├── y.csv
    ├── z.csv
    ├── u_stream_z1.csv
    ├── u_stream_z2.csv
    ├── ...
    ├── u_stream_zN.csv
    ├── u_span_z1.csv
    ├── u_span_z2.csv
    ├── ...
    └── u_span_zN.csv


---

## 4. Input Data Format

### Coordinate files

Three coordinate files are required:


x.csv
y.csv
z.csv

* `x.csv` contains the streamwise coordinates.
* `y.csv` contains the spanwise coordinates.
* `z.csv` contains the wall-normal coordinates.

The number of entries in each file determines the number of spatial locations used by the analysis.

---

### Streamwise velocity data

The streamwise velocity files should follow the naming convention:


u_stream_z1.csv
u_stream_z2.csv
...
u_stream_zN.csv


Each file should contain a matrix of size:

[
N_t \times N_x
]

where:

* (N_t) = number of time samples
* (N_x) = number of streamwise locations

The file index corresponds to the ordering of `z.csv`.

For example:

u_stream_z1.csv → z(1)
u_stream_z2.csv → z(2)
u_stream_z3.csv → z(3)
...

---

### Spanwise velocity data

For analyses involving the spanwise direction, the corresponding files should be provided as:


u_span_z1.csv
u_span_z2.csv
...
u_span_zN.csv

Each file should contain:

[
N_t \times N_y
]

where (N_y) is the number of spanwise locations.

The spanwise files are required for:

* Spanwise homogeneity
* Spanwise two-point correlation

---

## 5. Configuration

The common parameters used by the analysis scripts are defined in:

config.m

This file loads the coordinate data and determines:

* Number of streamwise locations
* Number of spanwise locations
* Number of wall-normal locations
* Channel height
* Channel half-height
* Normalized wall-normal coordinate (z/h)
* Sliding-window size

The main user-adjustable settings are:

dataDir = 'data';

and:

windowSize = 500;

If the input data are stored in a different directory, modify `dataDir` accordingly.

The sliding-window size can also be changed depending on the number of available time samples.

---

# 6. How to Run

### Step 1 — Clone or download the repository

Place the repository on your computer.

### Step 2 — Add the input data

Create a folder named:

data

and place the required CSV files inside it.

### Step 3 — Open MATLAB

Set the repository folder as the MATLAB working directory.

### Step 4 — Check `config.m`

Make sure the following points to the correct data directory:

```matlab
dataDir = 'data';
```

### Step 5 — Run the required analysis

Each analysis is independent. There is no requirement to run the scripts in a particular order.

---

# 7. Analysis Scripts

## 7.1 `config.m`

Provides the common configuration used by all analysis scripts.

It loads:


x.csv
y.csv
z.csv

and calculates the channel dimensions and normalized wall-normal coordinate.

---

## 7.2 `mean_velocity_profile.m`

Calculates the mean streamwise velocity at each wall-normal location:

[
\langle u\rangle(z)
]

and plots it against:

[
z/h
]

### Output

Mean streamwise velocity profile across the channel.

---

## 7.3 `mean_velocity_streamwise.m`

Calculates the time-averaged velocity at every streamwise location:

[
\langle u\rangle(x)
]

for each wall-normal level.

### Output

A set of profiles showing the variation of mean velocity along the streamwise direction.

---

## 7.4 `stationarity.m`

Checks the temporal behavior of the velocity data.

The velocity is averaged over the streamwise direction at every time step:

[
\langle u\rangle_x(t)
]

### Output

Time histories for the different wall-normal locations.

These plots can be used to assess whether the dataset is statistically stationary.

---

## 7.5 `sliding_window_stationarity.m`

Performs a quantitative stationarity check using a moving time window.

For each window, the mean velocity is calculated and compared with the mean of the complete dataset.

The maximum deviation is reported as a percentage of the overall mean.

### Output

Sliding-window mean plots and maximum percentage deviations.

---

## 7.6 `streamwise_homogeneity.m`

Examines the variation of time-averaged velocity along the streamwise direction.

The maximum deviation from the overall streamwise mean is calculated.

### Output

Mean velocity profiles along (x) and their maximum percentage deviations.

---

## 7.7 `spanwise_homogeneity.m`

Performs the equivalent homogeneity analysis in the spanwise direction.

The analysis uses:


u_span_z*.csv

### Output

Mean velocity profiles along (y) and maximum percentage deviations.

If spanwise velocity files are not available, this analysis cannot be performed.

---

## 7.8 `turbulence_statistics.m`

Calculates basic statistical properties of the streamwise velocity at each wall-normal location.

The quantities are:

### Mean

[
\overline{u}=\langle u\rangle
]

### Velocity fluctuation

[
u'=u-\overline{u}
]

### RMS fluctuation

[
u'_{\mathrm{rms}}
=================

\sqrt{\langle u'^2\rangle}
]

### Skewness

Measures the asymmetry of the velocity distribution.

### Kurtosis

Describes the shape and tails of the velocity distribution.

### Output

A four-panel figure showing the statistical quantities as functions of (z/h).

---

## 7.9 `rms_along_x.m`

Calculates the RMS of the velocity fluctuations at each streamwise location for the middle wall-normal level.

[
u'_{\mathrm{rms}}(x)
====================

\sqrt{\langle u'^2\rangle}
]

### Output

RMS velocity fluctuation as a function of (x).

---

## 7.10 `streamwise_autocorrelation.m`

Calculates the two-point spatial autocorrelation of velocity fluctuations in the streamwise direction.

The correlation is normalized such that:

[
R_{uu}(0)=1
]

### Output

[
R_{uu}(r_x)
]

for selected wall-normal locations.

The default locations are the first, middle, and last wall-normal levels.

---

## 7.11 `spanwise_autocorrelation.m`

Calculates the two-point spatial autocorrelation of velocity fluctuations in the spanwise direction.

The correlation is normalized such that:

[
R_{uu}(0)=1
]

### Output

[
R_{uu}(r_y)
]

for selected wall-normal locations.

---

# 8. Summary of Outputs

| Script                          | Primary Output                 |
| ------------------------------- | ------------------------------ |
| `mean_velocity_profile.m`       | (\langle u\rangle) vs. (z/h)   |
| `mean_velocity_streamwise.m`    | (\langle u\rangle) vs. (x)     |
| `stationarity.m`                | Mean velocity vs. time         |
| `sliding_window_stationarity.m` | Sliding mean and deviation     |
| `streamwise_homogeneity.m`      | Mean velocity variation in (x) |
| `spanwise_homogeneity.m`        | Mean velocity variation in (y) |
| `turbulence_statistics.m`       | Mean, RMS, skewness, kurtosis  |
| `rms_along_x.m`                 | (u'_{\mathrm{rms}}) vs. (x)    |
| `streamwise_autocorrelation.m`  | (R_{uu}(r_x))                  |
| `spanwise_autocorrelation.m`    | (R_{uu}(r_y))                  |

---

# 9. Notes

* The number of spatial locations and time samples is determined directly from the input files.
* The ordering of the `u_stream_z*.csv` and `u_span_z*.csv` files should match the ordering of `z.csv`.
* Spanwise analyses require the corresponding `u_span_z*.csv` files.
* The default sliding-window size is defined in `config.m` and can be modified as required.
* The scripts currently focus on streamwise velocity statistics.

---

# 10. Possible Extensions

The framework can be extended to include additional channel-flow analyses such as:

* Reynolds stresses
* Turbulence intensity
* Velocity probability density functions
* Energy spectra
* Integral length scales
* Taylor microscale
* Additional velocity components
* Higher-order velocity statistics
* Comparison between different Reynolds numbers or datasets

# LICENSE
Distributed under MIT Licesnce. Refer `LICENSE.md` for further details. 

