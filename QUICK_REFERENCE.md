# Quick Reference - Ollama with GPU on Your System

## 🚀 Start Using Ollama RIGHT NOW

```powershell
# Interactive chat with qwen2.5:7b (uses GPU automatically!)
ollama run qwen2.5:7b

# Or try the vision model
ollama run llava

# Or the powerful coding model
ollama run qwen3-coder:30b
```

**Your GPU is automatically used** - no configuration needed!

---

## 📊 Monitor GPU Usage

```powershell
# Watch GPU in real-time
nvidia-smi -l 1

# Quick check
nvidia-smi
```

---

## 🔧 Common Commands

### Model Management
```powershell
# List installed models
ollama list

# Pull a new model
ollama pull mistral:latest

# Remove a model
ollama rm <model-name>
```

### API Usage (OpenAI-compatible)
```powershell
# Test API
Invoke-WebRequest -Uri "http://127.0.0.1:11434/v1/chat/completions" `
  -Method POST `
  -Body '{"model":"qwen2.5:7b","messages":[{"role":"user","content":"Hello!"}]}' `
  -ContentType "application/json"
```

---

## ⚙️ Your System Specs

- **GPU**: NVIDIA RTX 5070 Ti Laptop (12GB VRAM)
- **CUDA**: 12.9
- **Driver**: 577.05
- **Ollama**: 0.13.5 ✅
- **Node.js**: v24.12.0 ✅
- **Clawdbot**: 2026.1.24-3 ✅

---

## 📦 Your Models

| Model | Size | Speed | Best For |
|-------|------|-------|----------|
| `qwen2.5:7b` | 4.7 GB | ⚡ Fast | Chat, general tasks |
| `llava:latest` | 4.7 GB | ⚡ Fast | Images + vision |
| `qwen3-coder:30b` | 18 GB | 🐢 Slower | Advanced coding |

---

## 🎯 Why Clawdbot Integration Isn't Working

The current npm version (2026.1.24-3) doesn't support Ollama configuration properly:
- Config validation rejects Ollama connection parameters
- Documentation mentions support, but it's not functional in this version
- May need WSL installation or wait for updates

**Workaround**: Use Ollama directly - it works perfectly with GPU!

---

## 📄 Documentation Files

- `README.md` - Complete setup guide
- `SETUP_COMPLETE.md` - Full status report
- `OLLAMA_CONNECTION_FIXED.md` - Detailed connection troubleshooting
- `setup-check.ps1` - Verify all prerequisites
- `test-gpu-agent.ps1` - GPU testing script

---

## 🆘 Troubleshooting

### Ollama not responding?
```powershell
# Check if running
Get-Process ollama

# Start if needed
Start-Process "ollama" -ArgumentList "serve" -WindowStyle Hidden
```

### Want better UI?
Try **Open WebUI**: https://github.com/open-webui/open-webui  
Or **LM Studio**: https://lmstudio.ai/

### Need coding assistant?
Install **Continue** extension for VS Code - works with Ollama!

---

## ✅ Bottom Line

**Your Ollama setup is PERFECT and GPU-ready!**

Just use: `ollama run qwen2.5:7b`

Clawdbot integration will need to wait for updates, but you can use your models with full GPU acceleration right now through Ollama directly.
