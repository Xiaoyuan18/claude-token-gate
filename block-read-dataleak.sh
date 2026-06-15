#!/usr/bin/env bash
# PreToolUse Hook: Block Read on data files, redirect to Python
# Reads tool call JSON from stdin, checks if Read targets a blocked extension

set -euo pipefail

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | python -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | python -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null)

# Only intercept Read calls
if [ "$TOOL_NAME" != "Read" ]; then
    exit 0
fi

# Extract extension (case-insensitive)
EXT=$(echo "$FILE_PATH" | grep -oEi '\.(csv|dta|xlsx|xls|parquet|feather|sas7bdat|sav|rds|h5|hdf5|pkl|pickle|joblib|pb|onnx|pq|stata|gz|zip|tar|tar\.gz|geojson|jsonl|json)$' | tr '[:upper:]' '[:lower:]')

if [ -z "$EXT" ]; then
    # Not a blocked extension — allow
    exit 0
fi

# Blocked: print redirection to stderr, exit 2
cat >&2 << 'HEREDOC_END'
[SYSTEM BLOCK -- PreToolUse Hook] Read was called on a data file. This tool call has been REJECTED to prevent token overflow.

CORRECT NEXT STEP: Write a Python inspection script and execute it via Python.
Use your project's Python (python3 / venv python / whatever the project uses).

Example pattern:
  Write a script to _inspect.py containing:
    import pandas as pd
    df = pd.read_csv("FILE_PATH")
    print(df.head(10))
    print(df.columns.tolist())
    print(df.describe())
  Then execute: python _inspect.py

Only the SUMMARY output returns to context — raw data stays out.
HEREDOC_END

exit 2
