# efficiencyTool

自用效率工具集合，包含多个实用脚本，旨在提高日常开发和测试工作的效率。

## 目录

- [adb_tool](#adb_tool)
- [monitor_adb](#monitor_adb)

## adb_tool

### 功能

`adb_tool.ps1` 是一个 PowerShell 脚本，用于简化与 Android 设备的 ADB 操作。它可以执行常见的 ADB 命令，如推送文件到设备。

### 使用方法

1. **指定设备名称**

   ```powershell
   .\adb_tool.ps1 -DeviceName "thwood"```
- DeviceName: 指定目标设备的名称或序列号。例如，thwood。

2. **推送文件**

   ```powershell
   D:\adb_tool\test.txt
   ```

- DeviceName: 脚本会将指定的文件推送到设备的默认目录（通常是 /sdcard/）。

### 示例

```powershell
    .\adb_tool.ps1 -DeviceName "thwood"
    D:\adb_tool\test.txt
```

## monitor_adb

### 功能

`monitor_adb.ps1` 是一个 `PowerShell` 脚本，用于启动一个 `ADB` 服务端口，以监听指定设备的特定端口。这在开发 `React Native` 应用时非常有用。

### 使用方法

1. **指定设备名称**

   ```powershell
   .\monitor_adb.ps1 -DeviceName "thwood" -Port 8082
   ```

- DeviceName: 指定目标设备的名称或序列号。例如，thwood。
- Port: 指定要监听的端口号。例如，8082。


### 示例

```powershell
# 启动 ADB 服务并监听 8082 端口
.\monitor_adb.ps1 -DeviceName "smatek" -Port 8082
```
