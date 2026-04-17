# Logs (viva proof)

Every **`lab*/run.sh`** writes a **timestamped** transcript under this folder. **`./run_demo.sh`** writes a **master** transcript that includes the full pipeline. Logs are **evidence** during evaluation: show the file path and grep for `[OK]` / `[FAIL]`.

| Filename pattern | Produced by |
| --- | --- |
| `lab1_YYYYMMDD_HHMMSS.log` | Lab 1 |
| `lab2_YYYYMMDD_HHMMSS.log` | Lab 2 |
| `lab3_YYYYMMDD_HHMMSS_open5gs.log` | Lab 3 (Open5GS) |
| `lab3_YYYYMMDD_HHMMSS_free5gc.log` | Lab 3 (Free5GC) |
| `lab4_YYYYMMDD_HHMMSS.log` | Lab 4 |
| `lab5_YYYYMMDD_HHMMSS.log` | Lab 5 |
| `demo_master_YYYYMMDD_HHMMSS.log` | **`./run_demo.sh`** |

`*.log` is **gitignored**; this **`README.md`** is committed so the directory stays self-explanatory.

**Pre-flight:** `bash setup/verify_env.sh` before `./run_demo.sh` so missing tools fail early.
