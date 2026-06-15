# PreToolUse Hook: Block Read on data files, redirect to Python
# PowerShell version — replaces the .sh hook on Windows
# Reads tool call JSON from stdin, checks if Read targets a blocked extension

# Read ALL stdin lines into a single string (robust across pipe/redirect)
$stdinLines = @($input)
$rawInput = $stdinLines -join "`n"
if ([string]::IsNullOrWhiteSpace($rawInput)) {
    exit 0
}

try {
    $obj = $rawInput | ConvertFrom-Json
} catch {
    exit 0
}

$toolName = $obj.tool_name
if ($toolName -ne "Read") {
    exit 0
}

$filePath = $obj.tool_input.file_path
if ([string]::IsNullOrWhiteSpace($filePath)) {
    exit 0
}

# DEBUG: Log every Read call to confirm harness invokes this script (comment out to disable)
# $triggerTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
# "$triggerTime | Read | $filePath | stdin_len=$($rawInput.Length)" | Out-File -Append -Encoding UTF8 "$env:TEMP\dataleak-hook-debug.log"

# Blocked extensions — add or remove as needed
$blockedPattern = '\.(csv|dta|xlsx|xls|parquet|feather|sas7bdat|sav|rds|h5|hdf5|pkl|pickle|joblib|pb|onnx|pq|stata|gz|zip|tar|tar\.gz|geojson|jsonl|json)$'

if ($filePath -notmatch $blockedPattern) {
    exit 0
}

# Blocked! Print redirection to stderr
$msg = @'
[SYSTEM BLOCK -- PreToolUse Hook] Read was called on a data file. This tool call has been REJECTED to prevent token overflow.

CORRECT NEXT STEP: Write a Python inspection script and execute it via Python.
Use your project's Python (python3 / venv python / py314 / whatever the project uses).

Example pattern:
  Write a script to <project>/_inspect.py containing:
    import pandas as pd
    df = pd.read_csv("FILE_PATH")
    print(df.head(10))
    print(df.columns.tolist())
    print(df.describe())
  Then execute: python _inspect.py

Only the SUMMARY output returns to context — raw data stays out.
'@

[Console]::Error.WriteLine($msg)
exit 2
