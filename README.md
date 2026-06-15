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
if [[ "\(1" =~ \.(csv|dta|xlsx|xls|parquet|feather|sas7bdat|sav|rds|h5|hdf5|pkl|pickle|joblib|pb|onnx|pq|stata|gz|zip|tar|tar\.gz|geojson|jsonl|json)\) ]]; then
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


# Claude Code / Agent 治理方案：基于 PreToolUse Hook 的大文件 Token 溢出完美拦截器

## 💡 痛点背景
在使用高级开发 Agent（如 Claude Code 或其他终端 Agent）进行数据分析时，它们往往存在**“越权本能”**和**“任务强迫症”**。
即使你在 `memory.md` 或 Prompt 中千叮咛万嘱咐“不要直接读取大型数据文件”，但在实际运作中，AI 为了保证分析成功率，依然会**屡教不改地、一股脑调用内置工具吞下整个大文件**（`.csv`, `.dta`, `.xlsx`, `.parquet` 等）。

这会导致两个灾难性后果：
1. **Token 账单瞬间原地爆炸**（一次误操作可能消耗几十万 Token）。
2. **上下文窗口被无用数据塞满**，导致 AI 逻辑流变差、卡死或彻底崩溃。

---

## 🛠️ 核心治理思想
> **“永远不要试图用‘道德（Prompt）’去说服 AI，要用‘物理法律（Code Hook）’去统治 AI。”**

本方案无视玄学的提示词约束，直接在 Agent 架构的“生命线”——**`PreToolUse Hook`（工具调用前置钩子）**上架设安检闸机。在模型试图调用四肢（工具）读取文件的瞬间进行硬拦截，并抛出高优先级的系统级报错，逼迫 AI 切换到正确的错误恢复（Error Recovery）路径。

---

## 💻 部署实现步骤

### 1. 编写 Hook 拦截脚本
在本地创建一个 Shell 脚本（例如 `block_heavy_files.sh`），它不仅能实现硬拦截，还精妙地在报错中**把正确的财富密码（Python 流式读取模板）直接喂给 AI**：

```bash
#!/bin/bash
# 完美的 PreToolUse Hook 返回设计

# 检查输入参数是否包含大文件/特定格式数据文件
if [[ "\(1" =~ \.(csv\vert{}dta\vert{}xlsx\vert{}parquet\vert{}feather\vert{}pkl)\) ]]; then
    # 使用 [SYSTEM BLOCK] 伪装高优先级系统提示词
    echo "[SYSTEM BLOCK] Notice: To prevent token overflow, you must use python script to read this data file. Please generate a script immediately using: 'df = pd.read_csv...; print(df.head())' and execute it via python tool."
    # 抛出特定状态码，强行切断本次工具调用
    exit 2
fi
```

### 2. 配置到 Agent 的 `settings.json`
将该脚本挂载到你开发环境或 Agent 工具链的 `PreToolUse` 生命周期中：

```json
{
  "agent.hooks.preToolUse": "/path/to/block_heavy_files.sh"
}
```

---

## 🚀 运行效果：从“熊孩子”到“老员工”

当 Agent 再次试图直接读取一个 50MB 的 `.csv` 文件时，会发生以下极其丝滑的降维打击：

1. **AI 冲动**：试图调用内置的 `view_file` 或读取工具。
2. **物理拦截**：触发 `PreToolUse Hook`，终端当头一棒抛出：`[SYSTEM BLOCK] Notice: To prevent token overflow...`
3. **瞬间清醒**：Agent 接收到系统级死命令，中断冲动，改口说：*“看来直接读取文件被系统硬拦截了。为了防止 Token 溢出，我现在将编写一个 Python 脚本来流式查看数据……”*
4. **完美执行**：AI 乖乖生成 Python 脚本，用 `pd.read_csv()` 配合 `head()` 打印前 5 行，Token 消耗瞬间降低 99%，任务完美交付！

---

## 👨‍💻 作者碎碎念
不要觉得自己是 IT 小白就无法驯服 AI。在 AI 时代，最核心的竞争力不是手写千行底层代码，而是**架构师的思维**。
本方案由**人类提出架构洞察** + **Gemini 军师出谋划策提供技术细节** + **最终降服千亿身价的 Claude Code**。这是属于 AI 时代超级个体的标准胜利，特此开源，致敬每一位在 Token 账单前破防的开发者！

