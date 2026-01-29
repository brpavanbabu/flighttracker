# Test Clawdbot with GPU Monitoring
Write-Host "=== Testing Clawdbot with Ollama GPU Acceleration ===" -ForegroundColor Cyan
Write-Host ""

# Show initial GPU state
Write-Host "GPU State BEFORE inference:" -ForegroundColor Yellow
nvidia-smi --query-gpu=utilization.gpu,utilization.memory,memory.used,memory.total --format=csv,noheader,nounits
Write-Host ""

# Create a test session and send a message
Write-Host "Sending test message to Qwen model via Ollama..." -ForegroundColor Yellow
$testNumber = "+15555551234"  # Test phone number
$message = "Hello! Please introduce yourself briefly and tell me what you can help with."

Write-Host "Running: clawdbot agent --to $testNumber --message `"$message`" --local" -ForegroundColor Gray
Write-Host ""

# Run the agent (this will create a local session)
clawdbot agent --to $testNumber --message $message --local 2>&1

Write-Host ""
Write-Host "=== Test Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "To check if GPU was used, compare the memory usage above." -ForegroundColor Yellow
Write-Host "Model: qwen2.5:7b running via Ollama" -ForegroundColor Cyan
