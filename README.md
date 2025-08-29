# Quad-Swarm-RL — Reproduction & Robustness Extensions

**Forked and adapted from:** [https://github.com/Zhehui-Huang/quad-swarm-rl](https://github.com/Zhehui-Huang/quad-swarm-rl)

**Course context:** AER 1820 Directed Reading Course  
This repository reproduces the ICRA’24 work *Collision Avoidance and Navigation for a Quadrotor Swarm Using End-to-End Deep Reinforcement Learning* and **extends it** with systematic robustness studies:

- Scaling robots `N`, neighbor cap `K`, obstacle density `ρ`, obstacle diameter `d_obs`
- Stress tests up to `N=48`, `K=47` in cluttered rooms
- Same policy class: IPPO + multi-head attention + SDF obstacle encoding; **low-level thrust control**, fully decentralized (no inter-agent comms)

> **Scope:** outcome of the **AER 1820 Directed Reading Course** — emphasis on **reproducibility, stress testing, and analysis**, not proposing a new algorithm.

---

## Repository Layout

```
.
├─ gym_art/                  # quadrotor dynamics, collisions, obstacles
├─ swarm_rl/                 # training entry points, models, wrappers
├─ paper/                    # plotting helpers and final figures
├─ scripts/                  # runners I added (baseline, ablations, scaling)
│  ├─ fig3_baseline.sh
│  ├─ fig3_ours_full.sh
│  ├─ fig3_no_replay.sh
│  ├─ fig3_no_attention.sh
│  ├─ scale_agents_X.sh      # N ∈ {8,16,32}
│  ├─ scale_neighbor_K.sh    # K ∈ {1,2,6,16,31}
│  ├─ scale_density_D.sh     # ρ ∈ {20,40,60,80}%
│  └─ scale_size_S.sh        # d_obs ∈ {0.6,0.7,0.8,0.85} m
└─ scripts/train_dir/        # training outputs (checkpoints, logs) — git-ignored
```

---

## Environment & Installation

* Python ≥ 3.10 (tested with 3.11)
* PyTorch, NumPy, Numba, Matplotlib, etc.

```bash
pip install -e .
# If PyTorch is missing, install a wheel from https://pytorch.org
```

> **Note:** `scripts/train_dir/` and `*.pth` are excluded by `.gitignore` to avoid pushing large artifacts.
> macOS/Apple Silicon: CPU/MPS supported; throughput is lower than discrete GPUs.

---

## Quick Start

### Baseline & Ablations

```bash
bash scripts/fig3_baseline.sh
bash scripts/fig3_ours_full.sh
bash scripts/fig3_no_replay.sh
bash scripts/fig3_no_attention.sh
```

### Robustness Sweeps

```bash
bash scripts/scale_agents_X.sh
bash scripts/scale_neighbor_K.sh
bash scripts/scale_density_D.sh
bash scripts/scale_size_S.sh
```

**Outputs**

```
scripts/train_dir/<run_name>/
  ├── checkpoint_p0/*.pth
  ├── config.json
  └── sf_log.txt
```

---

## Plots

* Ready-made figures: `paper/final_plots/`
* To regenerate: use helpers under `paper/` (e.g., `mean_std_plots_quad_*.py`, `attn_heatmap.py`).

---

## Notes vs Upstream

* Preserves IPPO + attention + SDF design; extends evaluation with **N/K/ρ/d\_obs** sweeps and **N=48, K=47** stress tests.
* Absolute numbers may differ from upstream due to **random seeds, map realizations, and default hyperparameters**; trends match qualitatively.

---

## Acknowledgments

Original environment and baseline code: **Zhehui Huang et al., quad-swarm-rl**
Repository: [https://github.com/Zhehui-Huang/quad-swarm-rl](https://github.com/Zhehui-Huang/quad-swarm-rl)
Please cite their paper when using this repository.

---

## License

Follows the original repository’s license. Retain the original `LICENSE` and attribution when redistributing.
