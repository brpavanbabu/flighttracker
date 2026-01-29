# Clawdbot Setup Verification
Write-Host '=== Clawdbot Setup - GPU Enabled with Ollama ===' -ForegroundColor Cyan
Write-Host ''
Write-Host 'Checking Ollama...' -ForegroundColor Yellow
ollama --version
Write-Host ''
Write-Host 'Checking GPU...' -ForegroundColor Yellow
nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader
Write-Host ''
Write-Host 'Checking Node.js...' -ForegroundColor Yellow
node --version
npm --version
Write-Host ''
Write-Host 'Checking Clawdbot...' -ForegroundColor Yellow
clawdbot --version
Write-Host ''
Write-Host 'Available Ollama models:' -ForegroundColor Yellow
ollama list
Write-Host ''
Write-Host '=== All Prerequisites Met! ===' -ForegroundColor Green
Write-Host ''
Write-Host 'Next: Run clawdbot onboard --install-daemon' -ForegroundColor Cyan
