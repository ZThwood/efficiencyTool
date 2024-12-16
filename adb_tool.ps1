param (
  [string]$DeviceName
)

# 检查是否输入设备名
if (-not $DeviceName) {
  Write-Host "Please provide the device name, for example: .\adb_tool.ps1 -DeviceName smatek" -ForegroundColor Red
  exit
}

# 定义函数用于执行 ADB 命令
function Execute-AdbCommand {
  param (
    [string]$Command,
    [string]$ErrorMessage
  )

  Write-Host "`n Execute Adb Command: $Command" -ForegroundColor Cyan
  $result = Invoke-Expression -Command $Command

  # # 检查命令执行状态
  if ($LASTEXITCODE -ne 0) {
    Write-Host "$ErrorMessage" -ForegroundColor Red
    exit $LASTEXITCODE
  }
  Write-Host "Command execute success!" -ForegroundColor Green
}

# Step 1: 执行 adb root
Execute-AdbCommand -Command "adb -s $DeviceName root" -ErrorMessage "Execute 'adb root' failed!"

# Step 2: 执行 adb remount
Execute-AdbCommand -Command "adb -s $DeviceName remount" -ErrorMessage "Execute 'adb remount' failed!"

# Step 3: 让用户手动输入文件夹路径
$UserFolderPath = Read-Host "Please enter the full path of the folder you want to push"

# 检查路径是否存在
if (-Not (Test-Path -Path $UserFolderPath -PathType Container)) {
  Write-Host "The path you entered does not exist. Please check it and re-run the script" -ForegroundColor Red
  exit
}

# 执行 adb push
Execute-AdbCommand -Command "adb -s $DeviceName push `"$UserFolderPath`" /vendor/bin/" -ErrorMessage "Execute 'adb push' failed!"

# Step 4: 执行 adb reboot
Execute-AdbCommand -Command "adb -s $DeviceName reboot" -ErrorMessage "Execute 'adb reboot' failed!"

Write-Host "`n success, begin reboot device..." -ForegroundColor Green

# Step 5: 等待设备启动
Write-Host "Waiting for device to reboot and become available..." -ForegroundColor Yellow

$MaxRetry = 30   # 最大重试次数（每次等待 5 秒，总共 150 秒）
$RetryInterval = 5
$DeviceReady = $false

for ($i = 1; $i -le $MaxRetry; $i++) {
  # 检查设备是否处于 device 状态
  $adbOutput = adb devices | Select-String -Pattern "$DeviceName\s+device"

  if ($adbOutput) {
    Write-Host "Device is online!" -ForegroundColor Green
    $DeviceReady = $true
    break
  }

  # 设备未上线，等待
  Write-Host "Device not ready, retrying in $RetryInterval seconds ($i/$MaxRetry)..." -ForegroundColor Yellow
  Start-Sleep -Seconds $RetryInterval
}

# 检查是否超时
if (-not $DeviceReady) {
  Write-Host "Timeout waiting for device to become ready. Please check the device." -ForegroundColor Red
  exit 1
}

# Step 6: 设置 adb reverse
Execute-AdbCommand -Command "adb -s $DeviceName reverse tcp:8082 tcp:8082" -ErrorMessage "Failed to set reverse port forwarding!"
Write-Host "Reverse port forwarding set successfully!" -ForegroundColor Green
