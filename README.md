# Reconnect Printer to Existing USB Port (PowerShell)

## Overview

This PowerShell script allows you to **reassign a newly connected USB printer to an existing USB virtual port** (e.g. `USB003`) on Windows 10 / Windows 11.

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

## Running the Script (Local)

```cmd
powershell -ExecutionPolicy Bypass -File "C:\Path\Reconnect-PrinterPort.ps1"

%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe ^
  -NoProfile ^
  -ExecutionPolicy Bypass ^
  -File "\\SERVER\Scripts\Reconnect-PrinterPort.ps1"

