# 🦞 Moltbot Agent Guide - Control Your Laptop

**Congratulations!** You now have Moltbot connected to Ollama with GPU acceleration!

---

## 🎯 What You Can Do With Moltbot

Moltbot is a **personal AI agent** that can:
- ✅ Execute commands on your laptop
- ✅ Read and write files
- ✅ Run code and scripts
- ✅ Automate workflows
- ✅ Control your system
- ✅ All running **locally** with your GPU!

---

## 🚀 Basic Usage

### Talk to Moltbot Locally:

```powershell
# General format
moltbot agent --to +15555551234 --message "Your request" --local

# Or shorter with any phone number
moltbot agent --to +1234567890 --message "Your request" --local
```

The phone number is just a session identifier for local use.

---

## 💻 What Moltbot Can Do For You

### 1. **File Operations**

```powershell
# List files
moltbot agent --to +1234567890 --message "List all markdown files in my Maltbot folder" --local

# Read a file
moltbot agent --to +1234567890 --message "Read the contents of README.md" --local

# Create a file
moltbot agent --to +1234567890 --message "Create a file called notes.txt with today's date" --local

# Edit files
moltbot agent --to +1234567890 --message "Add a section about GPU usage to my README.md" --local
```

### 2. **System Information**

```powershell
# Check system
moltbot agent --to +1234567890 --message "What's my CPU and memory usage?" --local

# Monitor GPU
moltbot agent --to +1234567890 --message "Check my NVIDIA GPU status" --local

# Disk space
moltbot agent --to +1234567890 --message "How much disk space do I have?" --local
```

### 3. **Coding & Development**

```powershell
# Write code
moltbot agent --to +1234567890 --message "Write a Python script to backup my files" --local

# Debug
moltbot agent --to +1234567890 --message "Fix the syntax error in script.py" --local

# Git operations
moltbot agent --to +1234567890 --message "Commit my changes with a descriptive message" --local
```

### 4. **Automation**

```powershell
# Backup
moltbot agent --to +1234567890 --message "Create a backup of my Documents folder" --local

# Organize files
moltbot agent --to +1234567890 --message "Organize my Downloads folder by file type" --local

# Schedule tasks
moltbot agent --to +1234567890 --message "Set up a daily backup script" --local
```

---

## 🔧 Configuration

### Your Current Setup:

**Workspace**: `C:\Users\brpav\clawd`  
**Model**: `ollama/qwen2.5:7b` (GPU-accelerated)  
**Commands**: Enabled (auto mode)

### Security Settings:

```json
{
  "commands": {
    "native": "auto",      // Allows system commands
    "nativeSkills": "auto" // Allows built-in skills
  }
}
```

**Auto mode** means Moltbot can execute commands but may ask for approval for sensitive operations.

---

## 🛡️ Safety & Permissions

### Sandbox Mode (Optional)

To restrict Moltbot to specific directories:

```powershell
moltbot config set agents.defaults.sandbox.enabled true
moltbot config set agents.defaults.sandbox.allowedPaths '["C:\\Users\\brpav\\clawd","C:\\Users\\brpav\\Maltbot"]'
```

### Approval Mode

For sensitive operations, you can enable approvals:

```powershell
moltbot config set commands.native "approval"
```

This will ask you to approve commands before execution.

---

## 📱 Connect to Messaging Apps

You can control Moltbot through:
- **Telegram** - Most popular
- **WhatsApp** - Personal messages
- **Discord** - Server integration
- **Slack** - Team workspace
- **Signal** - Privacy-focused

### Setup Telegram (Recommended):

```powershell
# Enable Telegram plugin
moltbot channels login telegram

# Follow the prompts to connect your bot
```

Then message your bot from Telegram to control your laptop remotely!

---

## 🎮 Advanced Features

### 1. **Skills System**

Moltbot has built-in "skills" for common tasks:

```powershell
# Check available skills
moltbot doctor | Select-String "Skills"

# Enable specific skills via config
```

### 2. **Browser Control**

Moltbot can control a browser instance:

```powershell
moltbot config set browser.enabled true
```

### 3. **Voice Integration** (macOS)

Wake word support for hands-free control.

### 4. **Memory System**

Moltbot remembers context across conversations:

```powershell
moltbot memory search "GPU settings"
```

---

## 🔥 Real-World Examples

### Example 1: Daily Backup

```powershell
moltbot agent --to +1234567890 --message "Create a PowerShell script that backs up my Maltbot folder to D:\Backups with today's date in the filename" --local
```

### Example 2: System Monitoring

```powershell
moltbot agent --to +1234567890 --message "Check if any programs are using more than 50% CPU and list them" --local
```

### Example 3: Code Generation

```powershell
moltbot agent --to +1234567890 --message "Write a Python script that monitors my GPU temperature and sends an alert if it goes above 80C" --local
```

### Example 4: File Organization

```powershell
moltbot agent --to +1234567890 --message "Find all PDF files in my Downloads and move them to Documents/PDFs" --local
```

---

## 🚨 Troubleshooting

### Gateway Not Running:

```powershell
moltbot gateway start
# Or in background:
Start-Process powershell -ArgumentList "-NoExit", "-Command", "moltbot gateway" -WindowStyle Minimized
```

### Check Status:

```powershell
moltbot health
moltbot doctor
```

### Session Locked Error:

```powershell
# Delete lock files
Remove-Item "C:\Users\brpav\.moltbot\agents\main\sessions\*.lock" -Force
# Restart gateway
moltbot gateway stop
moltbot gateway start
```

### View Logs:

```powershell
moltbot logs
```

---

## 📊 Monitor GPU Usage

While Moltbot is processing:

```powershell
# Real-time monitoring
nvidia-smi -l 1

# Single check
nvidia-smi
```

You should see GPU and memory usage increase when Moltbot is thinking!

---

## 🎯 Quick Commands

```powershell
# Check configuration
moltbot config get

# List models
moltbot models list

# Health check
moltbot health

# View sessions
moltbot sessions list

# Stop gateway
moltbot gateway stop

# Start gateway
moltbot gateway
```

---

## 🔗 Useful Resources

- **Documentation**: https://docs.molt.bot
- **GitHub**: https://github.com/moltbot/moltbot
- **Providers**: https://docs.molt.bot/providers/ollama
- **Your Config**: `C:\Users\brpav\.moltbot\moltbot.json`
- **Workspace**: `C:\Users\brpav\clawd`

---

## 💡 Pro Tips

1. **Use descriptive messages** - The more specific, the better results
2. **Check workspace** - Moltbot works best within its workspace directory
3. **Enable channels** - Control from your phone via Telegram/WhatsApp
4. **Monitor GPU** - Watch `nvidia-smi` to see your GPU in action
5. **Read logs** - Use `moltbot logs` to debug issues

---

## ✅ Your Setup Summary

- ✅ **Moltbot**: 2026.1.27-beta.1
- ✅ **Ollama**: 0.13.5 with GPU
- ✅ **Model**: qwen2.5:7b (4.7 GB)
- ✅ **GPU**: NVIDIA RTX 5070 Ti (12GB VRAM)
- ✅ **CUDA**: 12.9
- ✅ **Status**: Fully operational! 🦞

---

**You now have a fully local, GPU-powered AI agent that can control your laptop!**

Try it out and let it help you with your daily tasks! 🚀
