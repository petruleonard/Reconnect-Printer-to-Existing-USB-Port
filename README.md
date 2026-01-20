# Reconnect Printer to Existing USB Port (PowerShell)

![PowerShell](https://img.shields.io/badge/PowerShell-5.1-blue?logo=powershell)
![Windows](https://img.shields.io/badge/Windows-10/11-green)

## Overview

This PowerShell script allows you to **reassign a newly connected USB printer to an existing USB virtual port** (e.g., `USB003`) on Windows 10 / Windows 11.

It is designed for scenarios where:

- Applications are hard‑coded to a specific printer port
- A printer is replaced with a new one
- Windows assigns a new USB port automatically
- Applications stop working because the port has changed

Instead of reconfiguring applications, this script lets you **move the new printer back to the original port**.

---

## Features

- Automatically runs with **Administrator privileges**
- Lists:
  - All installed printers
  - Their current USB ports
  - Online / Offline status
- Lists available USB virtual ports (`USB001`, `USB002`, etc.)
- Allows interactive selection of:
  - Printer
  - Target USB port
- Validates user input
- Handles errors safely (`try/catch`)
- Displays final verification after reassignment
- Keeps the PowerShell window open at the end
- Fully compatible with **network shares (UNC paths)**
- Supports UTF-8 encoding for international characters

---

## Typical Use Case

1. Printer **A** is connected to `USB003`
2. Applications are configured to use `USB003`
3. Printer **A** is disconnected
4. Printer **B** is connected
5. Windows assigns `USB005`
6. Applications fail to print
7. Run this script
8. Select Printer **B**
9. Assign it to `USB003`
10. Applications work again without reconfiguration

---

## Requirements

- Windows 10 or Windows 11
- PowerShell 5.1 (default on Windows) or newer
- Administrator rights
- Print Spooler service running
- Read access to the script location (local or network)

---

## Quick Start

### Running Locally

Open PowerShell as Administrator and run:

```powershell
powershell -ExecutionPolicy Bypass -File "C:\Path\Reconnect-PrinterPort.ps1"
Running from a Network Share (Recommended)
If your script is hosted on a network share, run it directly using the UNC path:

%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe ^
  -NoProfile ^
  -ExecutionPolicy Bypass ^
  -File "\\SERVER\Scripts\Reconnect-PrinterPort.ps1"
You can also create a shortcut with the same command and enable Run as administrator for easier access.

Notes:

Scripts from network locations may be blocked. Unblock if necessary:

Unblock-File "\\SERVER\Scripts\Reconnect-PrinterPort.ps1"
Using -ExecutionPolicy Bypass ensures the script will run regardless of system policy.

UTF‑8 / International Characters
The script sets UTF-8 encoding to correctly display special characters (e.g., Romanian diacritics). Ensure:

The script file is saved as UTF-8 with BOM

PowerShell console font supports Unicode (e.g., Consolas, Cascadia Mono)

At the start of the script, these lines are included:

chcp 65001 > $null
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new()
Security Notes
The script does not create or delete ports

The script does not install drivers

It only reassigns an existing printer to an existing port

All operations use standard Windows printer APIs

Administrative privileges are required for reassignment

Network share access requires read permissions

Limitations
Does not auto-detect printers by VID/PID (manual selection required)

Requires administrative privileges

Subject to domain Group Policies in corporate environments

Script does not create new ports or install drivers

Tested On
Windows 11 Pro

Windows 10 Pro

Local admin accounts

Standard users with admin credential elevation

Network share execution (UNC paths)

License
MIT License
Use, modify, and distribute freely.

Disclaimer
Use at your own risk.
Always verify printer configuration in production environments.

