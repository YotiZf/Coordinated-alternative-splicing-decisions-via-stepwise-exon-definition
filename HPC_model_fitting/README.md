# Model fitting code

This repository provides the code used to perform multi-start parameter estimation for ODE-based models using the Data2Dynamics (d2d) framework in MATLAB. The fitting was performed on an HPC cluster(bwHPC) using SLURM, and the saved results are included as `.mat` files.

## Repository structure

| File / Folder | Description |
|---|---|
| `Setup.m` | Main MATLAB script: loads model and data, defines parameter bounds, runs multi-start fitting, and saves results |
| `submit_jobarray_d2d.sh` | SLURM submission script for running the MATLAB job on an HPC cluster |
| `Models/` | Model definition files (d2d `.def` format) |
| `Data/` | Experimental data files used for fitting |
| `data2d/` | Data2Dynamics toolbox files |
| `HEKd2dcomitarerror_1_1000.mat` | Saved fitting results for model 1 (1000 starts) |
| `HEKd2dcomitarerror_2_1000.mat` | Saved fitting results for model 2 (1000 starts) |

## Usage

### `Setup.m`

The main entry point of the pipeline. It initializes d2d, loads the selected model, loads the experimental datasets (including mutation-specific datasets), compiles the model, defines parameter bounds, and runs Latin Hypercube Sampling (LHS)-based multi-start optimization. Results are saved automatically as `.mat` files upon completion.

The function takes two arguments:

```matlab
Setup(moo, fit)
```

- `moo` — integer selecting the model to load depending on the model's step(`1` or `2`)
- `fit` — number of multi-start fitting runs

Example:

```matlab
Setup(2, 1000)
```

### HPC submission

The `submit_jobarray_d2d.sh` script is configured for a SLURM-based cluster. It loads MATLAB R2024b, sets the model index and number of fitting starts, and executes `Setup.m` in non-interactive mode.

Default configuration: 1 node, 20 tasks, 100 GB RAM, 40-hour wall time.

```bash
sbatch submit_jobarray_d2d.sh
```

## Dependencies

- MATLAB R2024b
- [Data2Dynamics (d2d)](https://github.com/Data2Dynamics/d2d)
- SLURM (for HPC job submission)


