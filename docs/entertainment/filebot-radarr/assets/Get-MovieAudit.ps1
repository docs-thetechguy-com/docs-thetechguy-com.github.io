<#
.SYNOPSIS
    Audits a movie share for common FileBot/Plex issues.

.DESCRIPTION
    Scans a movie directory structure to identify and fix common issues:
    - Duplicate file extensions (e.g., movie.mkv.mkv)
    - Folders containing multiple movie files
    - Unsupported/problematic video formats for Plex

    The script automatically fixes duplicate extensions and reports on other issues
    that require manual intervention.

.PARAMETER MoviePath
    The path to the movie library folder to audit. Defaults to the script's directory
    if not specified.

.PARAMETER ExportCSV
    When specified, exports the audit results to a timestamped CSV file in the
    script's directory.

.EXAMPLE
    .\Get-MovieAudit.ps1 -MoviePath "D:\Movies"
    Audits the D:\Movies folder and displays results to the console.

.EXAMPLE
    .\Get-MovieAudit.ps1 -MoviePath "\\server\media\movies" -ExportCSV
    Audits the network share and exports results to a CSV file.

.NOTES
    Name:        Get-MovieAudit.ps1
    Author:      TheTechGuy
    Version:     1.0.0
    DateCreated: 2026-01-20
    Requires:    PowerShell 5.1 or later

.LINK
    https://docs.thetechguy.com/entertainment/filebot-radarr/
#>

param(
    [string]$MoviePath,
    [switch]$ExportCSV
)

# Default to script location if no path provided
if (-not $MoviePath) {
    $MoviePath = Split-Path -Parent $MyInvocation.MyCommand.Path
}

if (-not (Test-Path $MoviePath)) {
    Write-Host "ERROR: Movie path does not exist: $MoviePath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "===============================================================" -ForegroundColor Cyan
Write-Host "  MOVIE SHARE AUDIT" -ForegroundColor Cyan
Write-Host "===============================================================" -ForegroundColor Cyan
Write-Host "  Scanning: $MoviePath" -ForegroundColor White
Write-Host "===============================================================" -ForegroundColor Cyan
Write-Host ""

$duplicateExtensions = @()
$multipleFileFolders = @()
$unsupportedFormats = @()
$totalFolders = 0
$totalFiles = 0

# Formats Plex doesn't support well or has issues with
$problematicFormats = @('iso', 'wmv', 'avi', 'divx', 'flv', 'vob', 'rmvb', '3gp', 'f4v', 'ogv', 'ogm')

$folders = Get-ChildItem -Path $MoviePath -Directory
Write-Host "Found $($folders.Count) folders to scan..." -ForegroundColor Gray
Write-Host "Scanning" -NoNewline -ForegroundColor Gray

foreach ($folder in $folders) {
    $totalFolders++
    if ($totalFolders % 100 -eq 0) { Write-Host "." -NoNewline -ForegroundColor DarkGray }
    
    # Get all files in this folder
    $files = Get-ChildItem -Path $folder.FullName -File
    if ($files.Count -gt 0) { $totalFiles += $files.Count }
    
    foreach ($file in $files) {
        $filename = $file.Name
        if ($filename -imatch '\bpart\b') { continue }
        
        # Check if extension is duplicated (e.g., .mkv.mkv, .mp4.mp4)
        $actualExtension = [System.IO.Path]::GetExtension($filename).TrimStart('.')
        $nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($filename)
        $previousExtension = [System.IO.Path]::GetExtension($nameWithoutExt).TrimStart('.')
        
        # Only flag as duplicate if both extensions exist and match
        if ($previousExtension -and $actualExtension -and ($previousExtension -eq $actualExtension)) {
            $baseNameOnly = [System.IO.Path]::GetFileNameWithoutExtension($nameWithoutExt)
            $finalExtension = $actualExtension
            
            $dupItem = @{
                Folder = $folder.Name
                File = $filename
                FullPath = $file.FullName
                BaseNameOnly = $baseNameOnly
                FinalExtension = $finalExtension
                Fixed = $false
            }
            
            $newName = "$baseNameOnly.$finalExtension"
            $newPath = Join-Path $folder.FullName $newName
            
            if (-not (Test-Path -LiteralPath $file.FullName)) {
                Write-Host "  [SKIP] $filename - File no longer exists" -ForegroundColor Yellow
            }
            else {
                try {
                    Rename-Item -LiteralPath $file.FullName -NewName $newName -Force -ErrorAction Stop
                    if (Test-Path -LiteralPath $newPath) {
                        $dupItem.Fixed = $true
                        Write-Host "  [OK] $filename -> $newName" -ForegroundColor Green
                    }
                    else {
                        Write-Host "  [FAIL] $filename" -ForegroundColor Red
                    }
                }
                catch {
                    Write-Host "  [FAIL] $filename - $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            $duplicateExtensions += $dupItem
        }
        
        # Check for unsupported/problematic formats
        if ($actualExtension -and ($problematicFormats -contains $actualExtension.ToLower())) {
            $unsupportedFormats += @{
                Folder   = $folder.Name
                File     = $filename
                FullPath = $file.FullName
                Format   = $actualExtension.ToUpper()
            }
        }
    }
    
    $nonPartFiles = $files | Where-Object { $_.Name -inotmatch '\bpart\b' }
    if ($nonPartFiles.Count -gt 1) {
        $multipleFileFolders += @{
            Folder = $folder.Name
            FileCount = $nonPartFiles.Count
            Files = ($nonPartFiles | Select-Object -ExpandProperty Name)
            FullPath = $folder.FullName
        }
    }
}

# Add newline after progress dots
Write-Host ""

# Re-scan folders for multiple files if fixes were applied (file counts may have changed)
if ($duplicateExtensions.Count -gt 0) {
    $fixedCount = ($duplicateExtensions | Where-Object { $_.Fixed }).Count
    if ($fixedCount -gt 0) {
        $multipleFileFolders = @()
        foreach ($folder in $folders) {
            $files = @(Get-ChildItem -Path $folder.FullName -File)
            $nonPartFiles = $files | Where-Object { $_.Name -inotmatch '\bpart\b' }
            if ($nonPartFiles.Count -gt 1) {
                $multipleFileFolders += @{
                    Folder = $folder.Name
                    FileCount = $nonPartFiles.Count
                    Files = ($nonPartFiles | Select-Object -ExpandProperty Name)
                    FullPath = $folder.FullName
                }
            }
        }
    }
}

Write-Host ""
Write-Host "===============================================================" -ForegroundColor Yellow
Write-Host "  SUMMARY" -ForegroundColor Yellow
Write-Host "===============================================================" -ForegroundColor Yellow
Write-Host "  Total Folders: $totalFolders | Total Files: $totalFiles" -ForegroundColor White

$dupColor = if ($duplicateExtensions.Count -gt 0) { "Red" } else { "Green" }
Write-Host "  Duplicate Extensions: " -NoNewline -ForegroundColor Gray
Write-Host "$($duplicateExtensions.Count)" -ForegroundColor $dupColor

$multiColor = if ($multipleFileFolders.Count -gt 0) { "Yellow" } else { "Green" }
Write-Host "  Multiple File Folders: " -NoNewline -ForegroundColor Gray
Write-Host "$($multipleFileFolders.Count)" -ForegroundColor $multiColor

$formatColor = if ($unsupportedFormats.Count -gt 0) { "Magenta" } else { "Green" }
Write-Host "  Unsupported Formats:   " -NoNewline -ForegroundColor Gray
Write-Host "$($unsupportedFormats.Count)" -ForegroundColor $formatColor
Write-Host "===============================================================" -ForegroundColor Yellow
Write-Host ""

if ($duplicateExtensions.Count -gt 0) {
    Write-Host "DUPLICATE EXTENSIONS:" -ForegroundColor Red
    foreach ($item in $duplicateExtensions) {
        if ($item.Fixed) {
            Write-Host "  [OK] $($item.Folder): $($item.File) -> $($item.BaseNameOnly).$($item.FinalExtension)" -ForegroundColor Green
        }
        else {
            Write-Host "  [FAIL] $($item.Folder): $($item.File)" -ForegroundColor Yellow
        }
    }
    $fixedCount = ($duplicateExtensions | Where-Object { $_.Fixed }).Count
    Write-Host "  Fixed: $fixedCount / $($duplicateExtensions.Count)" -ForegroundColor White
    Write-Host ""
}
else {
    Write-Host "  [OK] No duplicate extensions found" -ForegroundColor Green
    Write-Host ""
}

if ($multipleFileFolders.Count -gt 0) {
    Write-Host "MULTIPLE FILES IN FOLDERS:" -ForegroundColor Yellow
    foreach ($item in $multipleFileFolders) {
        Write-Host "  [WARN] $($item.Folder) ($($item.FileCount) files)" -ForegroundColor Yellow
        foreach ($file in $item.Files) {
            Write-Host "         - $file" -ForegroundColor Gray
        }
    }
    Write-Host ""
}
else {
    Write-Host "  [OK] All folders contain exactly one file" -ForegroundColor Green
    Write-Host ""
}

if ($unsupportedFormats.Count -gt 0) {
    Write-Host "UNSUPPORTED/PROBLEMATIC FORMATS:" -ForegroundColor Magenta
    Write-Host "These formats may not play well in Plex and should be converted" -ForegroundColor Gray
    Write-Host ""
    foreach ($item in $unsupportedFormats) {
        Write-Host "  [WARN] $($item.Folder)" -ForegroundColor Magenta
        Write-Host "         Format: $($item.Format) - $($item.File)" -ForegroundColor Yellow
        Write-Host "         $($item.FullPath)" -ForegroundColor DarkGray
        Write-Host ""
    }
    Write-Host "  Recommendation: Convert to MKV or MP4 using FileBot or HandBrake" -ForegroundColor Cyan
    Write-Host ""
}
else {
    Write-Host "  [OK] All files are in Plex-compatible formats" -ForegroundColor Green
    Write-Host ""
}

if ($ExportCSV) {
    $csvPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "audit-report-$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    $reportData = @()
    foreach ($item in $duplicateExtensions) {
        $reportData += [PSCustomObject]@{
            Type = "Duplicate Extension"
            Folder = $item.Folder
            Details = $item.File
            Fixed = $item.Fixed
            FullPath = $item.FullPath
            Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        }
    }
    foreach ($item in $multipleFileFolders) {
        $reportData += [PSCustomObject]@{
            Type = "Multiple Files"
            Folder = $item.Folder
            Details = "$($item.FileCount) files"
            Fixed = $false
            FullPath = $item.FullPath
            Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        }
    }
    foreach ($item in $unsupportedFormats) {
        $reportData += [PSCustomObject]@{
            Type = "Unsupported Format"
            Folder = $item.Folder
            Details = "$($item.Format) - $($item.File)"
            Fixed = $false
            FullPath = $item.FullPath
            Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        }
    }
    if ($reportData.Count -gt 0) {
        $reportData | Export-Csv -Path $csvPath -NoTypeInformation
        Write-Host "Report exported to: $csvPath" -ForegroundColor Cyan
    }
    Write-Host ""
}

Write-Host "===============================================================" -ForegroundColor Cyan
Write-Host "  AUDIT COMPLETE" -ForegroundColor Cyan
Write-Host "===============================================================" -ForegroundColor Cyan
Write-Host ""

$unfixedDuplicates = ($duplicateExtensions | Where-Object { -not $_.Fixed }).Count
$issuesRemaining = $unfixedDuplicates + $multipleFileFolders.Count + $unsupportedFormats.Count

if ($issuesRemaining -gt 0) {
    Write-Host "  [WARN] Remaining issues: $issuesRemaining" -ForegroundColor Yellow
    if ($unsupportedFormats.Count -gt 0) {
        Write-Host "         ($($unsupportedFormats.Count) files need format conversion)" -ForegroundColor Magenta
    }
    exit 1
}
else {
    Write-Host "  [OK] All checks passed!" -ForegroundColor Green
    exit 0
}
