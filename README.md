# claude-token-gate
Stop Pleading with Prompts! Fix Claude's Stubborn Large-File Gulping via PreToolUse Hook  _ 别再用Prompt劝AI了！用Hook彻底治好Claude狂吞大文件的“屡教不改”

When using advanced developer Agents (such as Claude Code or other terminal-based agents) for data analysis, they often exhibit an **"Autonomy Overdrive"** and a compulsive need to complete tasks perfectly. 

Even if you explicitly instruct them in `memory.md` or system prompts to "never directly read large data files," they will often **repeatedly ignore your instructions**. Driven by the urge to ensure an accurate analysis, the AI will blindly invoke its built-in viewing tools to swallow massive files wholesale (`.csv`, `.dta`, `.xlsx`, `.parquet`, etc.).

This results in two disastrous consequences:
1. **Your token bill explodes instantly** (a single accidental file gulp can burn hundreds of thousands of tokens).
2. **The context window gets flooded with junk data**, severely degrading the AI's reasoning, causing lag, or crashing it entirely.

---

## 🛠️ Core Governance Philosophy
> **"Never try to govern AI with morality (Prompts). Rule AI with physics (Code Hooks)."**

This solution completely bypasses the unpredictable nature of prompt-based constraints. Instead, it deploys a security gate directly at the agent architecture's neural center: the **`PreToolUse Hook`** (Pre-Tool Execution Lifecycle). 

The moment the model attempts to trigger its "limbs" (tools) to read a file, the `PreToolUse Hook` intercepts the command at the system level. By throwing a high-priority system error, it forces the AI to instantly pivot to a proper Error Recovery path.

---

## 💻 Deployment Steps

### 1. Write the Intercepting Hook Script
Create a local Shell script (e.g., `block_heavy_files.sh`). This script does not just dumbly block the AI; it brilliantly **feeds the correct alternative solution (a Python stream-reading template) right into the AI's error log**:

```bash
#!/bin/bash
# The Perfect PreToolUse Hook Return Design

# Check if the input argument matches massive or specialized data file extensions
if [[ "\(1" =~ \.(csv\vert{}dta\vert{}xlsx\vert{}parquet\vert{}feather\vert{}pkl)\) ]]; then
    # Use [SYSTEM BLOCK] to mimic a high-priority system prompt
    echo "[SYSTEM BLOCK] Notice: To prevent token overflow, you must use python script to read this data file. Please generate a script immediately using: 'df = pd.read_csv...; print(df.head())' and execute it via python tool."
    # Exit with a specific status code to violently kill the current tool invocation
    exit 2
fi
```

### 2. Configure it in your Agent's `settings.json`
Mount the script into the `PreToolUse` lifecycle of your development environment or Agent toolchain:

```json
{
  "agent.hooks.preToolUse": "/path/to/block_heavy_files.sh"
}
```

---

## 🚀 The Result: From "Rebellious Child" to "Compliant Expert"

The next time the Agent impulsively tries to view a 50MB `.csv` file directly, the following seamless workflow takes place:

1. **AI Impulse**: The Agent attempts to call its built-in `view_file` or file-reading tool.
2. **Physical Interception**: The `PreToolUse Hook` fires, slamming the terminal shut with the error: `[SYSTEM BLOCK] Notice: To prevent token overflow...`
3. **Instant Realization**: The Agent receives a hard system-level restriction, breaks its compulsive loop, and adapts: *"It appears that directly reading files is strictly blocked by the system. To prevent token overflow, I will now write a Python script to stream and inspect the data..."*
4. **Flawless Execution**: The AI obediently generates a Python script, uses `pd.read_csv()` combined with `head()` to print just the first 5 lines, instantly **slashing token consumption by 99%** while successfully delivering the task!

---

## 👨‍💻 Author's Musings
You don't need to be an IT veteran to tame AI. In the age of AI, the ultimate competitive edge isn't hand-writing thousands of lines of boilerplate code—it's **architectural thinking**. 

This project represents a textbook victory for the modern "Super-Individual": **Human intuition defines the architecture** + **Gemini acts as the strategist to supply technical scripts** = **Successfully taming the multi-billion-dollar Claude Code Agent**. 

This repository is open-sourced to save developers worldwide from breaking down over exploding token bills. If this saved your wallet, give it a ⭐!
