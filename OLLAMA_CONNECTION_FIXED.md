# Moltbot/Clawdbot Ollama Connection - Solution Guide

## Problem Identified

**Issue**: Clawdbot (version 2026.1.24-3) configuration schema doesn't accept custom Ollama connection parameters in the config file, even though documentation mentions Ollama support.

**Root Cause**: The current npm version of Clawdbot has strict config validation that rejects keys like `baseURL`, `model`, and `authProfile` at the model configuration level.

---

## ✅ WORKING SOLUTION: Ollama Direct Access

Your Ollama installation is **fully functional with GPU** and ready to use!

### Verified Working:
- ✅ **Ollama 0.13.5** running
- ✅ **GPU detected and available** (RTX 5070 Ti, 12GB VRAM, CUDA 12.9)
- ✅ **Models installed**: qwen2.5:7b, llava:latest, qwen3-coder:30b
- ✅ **OpenAI-compatible API** working at `http://127.0.0.1:11434/v1`

---

## Option 1: Use Ollama Directly (Recommended for Now)

### Interactive Chat with GPU
```powershell
# Start interactive chat - GPU is used automatically
ollama run qwen2.5:7b
```

**GPU Usage**: Ollama automatically detects and uses your NVIDIA GPU - no configuration needed!

### Programmatic Usage via API

```powershell
# Simple chat completion
$body = @{
    model = "qwen2.5:7b"
    messages = @(
        @{
            role = "user"
            content = "Your question here"
        }
    )
    stream = $false
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri "http://127.0.0.1:11434/v1/chat/completions" `
    -Method POST `
    -Body $body `
    -ContentType "application/json" `
    -UseBasicParsing

$response.Content | ConvertFrom-Json
```

**Test Result**: ✅ Successfully tested and working!
```json
{
  "id": "chatcmpl-511",
  "object": "chat.completion",
  "model": "qwen2.5:7b",
  "choices": [{
    "message": {
      "role": "assistant",
      "content": "Hello there, friend!"
    }
  }]
}
```

---

## Option 2: Alternative Local AI Tools

Since Clawdbot-Ollama integration isn't working in this version, consider these GPU-enabled alternatives:

### 1. **Open WebUI** (Recommended)
- Beautiful web interface for Ollama
- Chat history, model management
- Multi-user support
- Install: `docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main`

### 2. **LM Studio**
- GUI application for local LLMs
- Download: https://lmstudio.ai/
- Works with Ollama models
- GPU acceleration built-in

### 3. **Continue (VS Code Extension)**
- Code assistant powered by local models
- Integrates with Ollama
- Install from VS Code marketplace

### 4. **Ollama + Python**
```python
import requests

def chat_with_ollama(prompt):
    response = requests.post('http://127.0.0.1:11434/v1/chat/completions',
        json={
            "model": "qwen2.5:7b",
            "messages": [{"role": "user", "content": prompt}]
        })
    return response.json()['choices'][0]['message']['content']

print(chat_with_ollama("Hello!"))
```

---

## Option 3: Wait for Moltbot Update

The rebranding from Clawdbot to Moltbot is ongoing. According to documentation:
- Ollama integration exists: https://docs.clawd.bot/providers/ollama
- May require different installation method
- Official installer: `curl -fsSL https://molt.bot/install | bash` (Linux/WSL)

### Potential Solution for Windows:
Try installing via WSL2 which might have better Ollama integration:
```bash
# In WSL2:
curl -fsSL https://molt.bot/install | bash
moltbot onboard
```

---

## GPU Monitoring

### Check GPU Usage While Running Ollama:
```powershell
# Real-time GPU monitoring
nvidia-smi -l 1

# Or single check:
nvidia-smi --query-gpu=utilization.gpu,utilization.memory,memory.used,memory.total --format=csv
```

**Expected behavior**: When Ollama processes requests, you'll see:
- GPU Utilization increase (10-100%)
- Memory Used increase (4-6GB for qwen2.5:7b)

---

## What We Configured (For Future Reference)

### Clawdbot Config
**Location**: `C:\Users\brpav\.clawdbot\clawdbot.json`

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai/qwen2.5:7b"
      },
      "models": {
        "openai/qwen2.5:7b": {}
      },
      "workspace": "C:\\Users\\brpav\\clawd"
    }
  },
  "gateway": {
    "mode": "local"
  }
}
```

### Auth Profile (Attempted)
**Location**: `C:\Users\brpav\.clawdbot\auth-profiles.json`

```json
{
  "profiles": [{
    "id": "ollama-local",
    "provider": "openai",
    "baseURL": "http://127.0.0.1:11434/v1",
    "apiKey": "ollama"
  }]
}
```

**Status**: ⚠️ Configuration accepted but model not recognized by Clawdbot gateway

---

## Available Ollama Models & GPU Usage

| Model | Size | VRAM Usage | Speed | Best For |
|-------|------|------------|-------|----------|
| **qwen2.5:7b** | 4.7 GB | ~5-6 GB | Fast | General chat, coding |
| **llava:latest** | 4.7 GB | ~5-6 GB | Fast | Image understanding |
| **qwen3-coder:30b** | 18 GB | ~12GB+ (overflow to RAM) | Slower | Advanced coding |

**Your GPU**: RTX 5070 Ti (12GB VRAM) - Perfect for 7B models, can handle 30B with system RAM overflow

---

## Quick Start Commands

### Start Ollama (if not running):
```powershell
Start-Process "ollama" -ArgumentList "serve" -WindowStyle Hidden
```

### List Models:
```powershell
ollama list
```

### Pull New Models:
```powershell
# Coding specialist
ollama pull qwen2.5-coder:7b

# Fast general model
ollama pull mistral:latest

# Very capable larger model
ollama pull llama3.3:70b
```

### Test GPU Usage:
```powershell
# In one terminal:
ollama run qwen2.5:7b

# In another terminal while model is responding:
nvidia-smi
```

---

## Summary

### ✅ What Works:
- Ollama with GPU acceleration
- OpenAI-compatible API endpoint
- All your models ready to use
- Direct command-line interaction

### ❌ What Doesn't Work (Yet):
- Clawdbot → Ollama integration
- Using local models through Clawdbot gateway
- Messaging platform automation with local models

### 🎯 Best Path Forward:

**Immediate (Today)**:
- Use `ollama run qwen2.5:7b` for interactive chat
- Use Ollama API for programmatic access
- Consider Open WebUI for better interface

**Short Term (This Week)**:
- Try Moltbot installation via WSL2
- Monitor official documentation for updates
- Explore LM Studio or Continue extension

**Long Term**:
- Wait for Moltbot/Clawdbot to mature Ollama support
- Community might develop plugins
- Official integration may improve in future versions

---

## Support & Resources

- **Ollama Docs**: https://docs.ollama.com/
- **Moltbot Docs**: https://docs.clawd.bot/
- **Your Setup Status**: `.\setup-check.ps1`
- **GPU Monitor**: `nvidia-smi`

---

**Created**: January 29, 2026  
**GPU**: NVIDIA RTX 5070 Ti (12GB) with CUDA 12.9  
**Status**: Ollama fully operational with GPU | Clawdbot integration pending  
**Recommendation**: Use Ollama directly for now
