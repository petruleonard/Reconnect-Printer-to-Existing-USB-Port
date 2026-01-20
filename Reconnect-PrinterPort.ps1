# ==============================
# Auto-elevare Administrator
# ==============================
$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

if (-not $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    Write-Host "Repornire script cu drepturi de Administrator..."
    Start-Process powershell.exe `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
        -Verb RunAs
    exit
}


Clear-Host
Write-Host "=== Manager Porturi USB pentru Imprimante ===`n"

# ==============================
# Preluare porturi USB
# ==============================
$usbPorts = Get-PrinterPort | Where-Object {
    $_.Name -match "^USB\d+"
}

if (!$usbPorts) {
    Write-Error "Nu au fost găsite porturi USB."
    Read-Host "`nApasă Enter pentru ieșire"
    exit
}

# ==============================
# Preluare imprimante
# ==============================
$printers = Get-Printer | Sort-Object Name

if (!$printers) {
    Write-Error "Nu au fost găsite imprimante."
    Read-Host "`nApasă Enter pentru ieșire"
    exit
}

# ==============================
# Afișare imprimante
# ==============================
$printerTable = for ($i = 0; $i -lt $printers.Count; $i++) {
    [PSCustomObject]@{
        Index  = $i
        Name   = $printers[$i].Name
        Port   = $printers[$i].PortName
        Status = $printers[$i].PrinterStatus
    }
}

$printerTable | Format-Table -AutoSize

# ==============================
# Selectare imprimantă
# ==============================
do {
    $printerIndex = Read-Host "`nIntrodu indexul imprimantei"
} until ($printerIndex -match '^\d+$' -and $printerIndex -lt $printers.Count)

$selectedPrinter = $printers[$printerIndex]

Write-Host "`nSelectată: $($selectedPrinter.Name)"

# ==============================
# Afișare porturi
# ==============================
Write-Host "`nPorturi USB disponibile:"
$usbPorts | Sort-Object Name | ForEach-Object {
    Write-Host " - $($_.Name)"
}

# ==============================
# Selectare port
# ==============================
do {
    $targetPort = Read-Host "`nIntrodu numele portului (ex: USB003)"
    $portExists = $usbPorts.Name -contains $targetPort
    if (-not $portExists) {
        Write-Warning "Portul nu există. Încearcă din nou."
    }
} until ($portExists)

# ==============================
# Reasociere cu tratare erori
# ==============================
try {
    Write-Host "`nMut imprimanta pe portul $targetPort..."
    Set-Printer -Name $selectedPrinter.Name -PortName $targetPort -ErrorAction Stop
    Write-Host "✔ Reasociere efectuată."
}
catch {
    Write-Error "Eroare la reasocierea imprimantei:"
    Write-Error $_.Exception.Message
    Read-Host "`nApasă Enter pentru ieșire"
    exit
}

# ==============================
# Reverificare finală
# ==============================
Write-Host "`n=== Stare finală imprimante ===`n"

Get-Printer | Sort-Object Name |
    Select-Object Name, PortName, PrinterStatus |
    Format-Table -AutoSize

# ==============================
# Pauză finală
# ==============================
Read-Host "`nApasă Enter pentru a închide scriptul"
