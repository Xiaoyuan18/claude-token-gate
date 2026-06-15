---
name: data-leak-blocker
description: Prevents Claude from accidentally reading large data files (CSV, XLSX, DTA, Parquet, Pickle, JSONL, etc.) into context. Blocks Read calls via PreToolUse hook and redirects to Python script-based inspection — keeps raw data out of context, only summaries enter.
version: 1.0.0
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Data Leak Blocker

> "Data files stay on disk. Only summaries reach context."

## Overview

This skill intercepts Claude's `Read` tool calls targeting data file extensions and **physically blocks** them at the hook level (exit code 2), redirecting Claude to write and execute Python inspection scripts instead. This prevents accidental token flood from large datasets and enforces a strict "Python-first" data access pattern.

## How It Works

```
Claude calls Read("giant.csv")
        ↓
PreToolUse Hook fires
        ↓
Extension .csv  matched  blocked list
        ↓
exit 2 → tool call REJECTED
        ↓
stderr message: "Write a Python script instead"
        ↓
Claude writes _inspect.py → executes via Python → only summary returns
```

## Blocked Extensions

~25 data-related extensions (case-insensitive):

| Category | Extensions |
|----------|------------|
| Tabular | `.csv` `.xlsx` `.xls` `.dta` `.parquet` `.feather` `.pq` `.sas7bdat` `.sav` `.rds` `.stata` |
| ML/Model | `.pkl` `.pickle` `.joblib` `.h5` `.hdf5` `.pb` `.onnx` |
| Archive | `.gz` `.zip` `.tar` `.tar.gz` |
| Geo/JSON | `.geojson` `.jsonl` `.json` |

## Requirements

- Windows: PowerShell 5.1+
- Linux/macOS: bash + python3
- Python environment with pandas (for data inspection)

## Installation

1. Copy the entire `data-leak-blocker/` folder to `.claude/skills/` in the target project
2. Register the PreToolUse hook in `.claude/settings.local.json`
3. The skill auto-loads on next session

See [README.md](README.md) for detailed installation steps.

## When This Activates

**Automatic:** Every time Claude calls the `Read` tool, the PreToolUse hook checks the file extension.

**Manual:** User may say "data leak blocker", "block data files", "数据文件拦截" to discuss configuration.

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | This file — skill definition and reference |
| `README.md` | Installation guide for new users |
| `hooks/block-read-dataleak.ps1` | PowerShell hook (Windows) |
| `hooks/block-read-dataleak.sh` | Bash hook (Linux/macOS) |

## Configuration

Edit the hook script to customize:

- `$blockedPattern` (ps1) / `EXT` grep (sh): add or remove blocked extensions
- Python path: replace `D:/dev/envs/py314/python.exe` with your own
- Debug log path: set to a writable location

## Best Practices

### DO
- Write small `_inspect.py` scripts for ALL data file access
- Print only summaries: `df.head(10)`, `df.columns`, `df.describe()`, `df.shape`
- Use the same script file (`_inspect.py`) and overwrite it each time

### DON'T
- Don't retry Read after a block — go straight to Python
- Don't try to bypass with `cat` or `head` — those waste tokens on giant single-line files
- Don't assume "this CSV is small enough" — uniform rule = no judgment calls
