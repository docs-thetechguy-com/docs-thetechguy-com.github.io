# FileBot + Radarr Complete Step‑by‑Step Guide

## What You'll End Up With

After following this guide:

- All movies will be named like:
  `Inception (2010) [1080p] [BluRay] [x264] [DTS].mkv`
- Each movie will live in its own folder:
  `Inception (2010)\\Inception (2010) [1080p] [BluRay] [x264] [DTS].mkv`
- CD1/CD2 multi‑part movies will be treated as a single movie
- FileBot will be used to rename/move files according to the format

---

## Prerequisites

- Windows 10 or later
- **FileBot 5.2.0 or later**
- Radarr available (optional)

---

## 1. Install and Open FileBot

### Step 1.1 – Download FileBot

1. Open your web browser.
2. Go to the official FileBot website: **https://www.filebot.net/**
3. Click **Download** and select the **Windows** installer.
4. Save the `.exe` file to your Downloads folder.

### Step 1.2 – Install FileBot

1. Open **File Explorer** and navigate to **Downloads**.
2. Double-click the FileBot installer (e.g., `FileBot-5.2.0-x64.exe`).
3. Follow the installation wizard:
   - Accept the license agreement.
   - Choose your installation location (default is fine: `C:\Program Files\FileBot`).
   - Select **Create Desktop shortcut** (optional but helpful).
4. Click **Finish** to complete the installation.

### Step 1.3 – Licensing and Activation

FileBot requires a valid license to operate.

**Purchase a License**

1. After installation, launch FileBot and click rename.
2. You'll see a licensing dialog. Click **Register** or **Buy**.
3. Follow the online payment process and receive your license key.
4. Paste your key into FileBot's licensing dialog and activate.

---

## 2. Configure FileBot Naming Format

We'll set up the Radarr‑style naming with spaces and brackets.

**Step 2.1 – Access the Preset Editor**

1. In the **Rename** panel on the left side, look for the **Preset** dropdown and **Edit Preset** button.
2. Click the **New Preset** button—this opens the editor where you can create or modify format expressions.
3. When prompted, name it: `Radarr Movies`

**Step 2.2 – Paste the Format Expression**

1. Paste this **Expression**:

```groovy
{n.colon('-')} ({y})/{n.colon('-')} ({y}){edition-3D ? ' ['+edition-3D+']' : ''}{vf ? ' [' + vf + ']' : ''}{source ? ' [' + source + ']' : ''}{vc ? ' [' + vc + ']' : ''}{ac ? ' [' + ac + ']' : ''}{pi > 0 ? ' - Part ' + pi : ''}.{ext}
```

This tells FileBot to:

- Create a **folder** named: `Title (Year)` (with colons replaced by hyphens)
- Create a **file** inside it named: `Title (Year) [Edition-3D] [Resolution] [Source] [VideoCodec] [AudioCodec].ext`
- For 3D movies: automatically includes 3D info in the edition tag (e.g., `[Director's Cut-3D SBS]`), which Plex properly recognizes
- For multi-part files: append ` - Part 1`, ` - Part 2` etc., so Plex recognizes them as parts of the same movie
- The `/` in the expression creates the folder structure
- The `.colon('-')` method replaces colons with hyphens (Windows requirement)
- The `{edition-3D}` binding automatically combines edition and 3D information when present
- The `{pi > 0 ? ' - Part ' + pi : ''}` adds part numbers for **all** multi-part movies in Plex format

**How it works:** In FileBot 5.2.0+, folder structure is defined within the naming expression using `/`. The `.colon('-')` method sanitizes filenames. The `{edition-3D}` binding is a special FileBot binding that automatically combines edition info with 3D tags when 3D content is detected, making it perfect for Plex. The `pi` (part index) binding identifies multi-part files and names them in Plex format (Part 1, Part 2, etc.).

2. Set **Datasource** to **TheMovieDB**, episode order will gray out
3. Set **Match Mode** to **Opportunistic**
4. In the Preset Editor, click the **Save Preset** button to save this format.
5. Your new preset **Radarr Movies** will now appear in the **Preset** dropdown for future use.

---

## 3. About FileBot's Actions

FileBot 5.2.0 provides several action options for organizing files:

- **Rename** - Renames files in place (no folder creation)
- **Copy** - Copies files to destination folder with new organization (keeps originals)
- **Keeplink** - Copies and creates symbolic links in original location
- **Symlink** - Creates symbolic links only (no extra disk space)
- **Hardlink** - Creates hard links (most efficient, no extra disk space)

For this guide, we use **Copy** to organize movies while keeping originals safe. Once verified, you can delete originals or switch to **Symlink** to save disk space.

---

## 4. Test FileBot Manually (Before Automation)

We'll test both of your scenarios manually to make sure the format and matching are correct.

### 4.1 Scenario A – Movies Already in Folders (No Year)

Example structure:

```
D:\Movies\Inception\Inception.mkv
D:\Movies\Avatar\Avatar.avi
```

**Step 4.1.1 – Load and Match Movies**

1. Open FileBot.
2. Drag the **top‑level folder** (e.g., `D:\Movies`) into the **Original Files** pane.
3. **Select your preset:** Click the preset icon and choose your **Radarr Movies** preset (created in Step 2).
4. FileBot will match each file to a movie using your selected preset.

**Step 4.1.2 – Preview New Names**

1. Look at the **New Names** pane.
2. You should see the full path with folders:

```
Inception - The Game (2010)\Inception - The Game (2010) [1080p] [BluRay] [x264] [DTS].mkv
Avatar (2009)\Avatar (2009) [1080p] [BluRay] [x264] [DTS].mkv
```

**Step 4.1.3 – Apply Rename**

1. If everything looks correct, click **Rename**.
2. Confirm the operation.

FileBot will rename files and organize them into their respective folders.

---

### 4.2 Scenario B – Loose Movie Files (No Folders)

Example structure:

```
D:\Downloads\Inception.2010.1080p.BluRay.x264.mkv
D:\Downloads\Avatar.2009.720p.BluRay.x264.avi
```

**Step 4.2.1 – Load and Match Movies**

1. Drag the folder containing the loose files (e.g., `D:\Downloads`) into FileBot.
2. **Select your preset:** Click the preset icon and choose your **Radarr Movies** preset.
3. FileBot will match each file to a movie using your selected preset.

**Step 4.2.2 – Preview New Names**

You should see the full path with folders:

```
Inception - The Game (2010)\Inception - The Game (2010) [1080p] [BluRay] [x264] [DTS].mkv
Avatar (2009)\Avatar (2009) [720p] [BluRay] [x264] [DTS].avi
```

**Step 4.2.4 – Apply Rename**

1. If everything looks correct, click **Rename**.
2. Confirm the operation.

FileBot will rename files and organize them into their respective folders.

---

### 4.3 Scenario C – Multi‑File Movies (CD1/CD2)

FileBot **does not merge** video files. Instead, it renames multi-part files so Plex recognizes them as parts of the same movie.

Example structure:

```
D:\Movies\Avatar CD1.avi
D:\Movies\Avatar CD2.avi
```

**Step 4.3.1 – Load Both Parts**

1. Drag the folder containing both `CD1` and `CD2` into FileBot.

**Step 4.3.2 – Match as Movies**

1. Click **Match → Movie Mode**.
2. **Select your preset:** Click the preset icon and choose your **Radarr Movies** preset.
3. Ensure both files are matched to the **same movie** (Avatar).

**Step 4.3.3 – Preview New Names**

You should see both parts renamed with part indicators:

```
Avatar (2009)\Avatar (2009) [1080p] [BluRay] [x264] [DTS] - Part 1.avi
Avatar (2009)\Avatar (2009) [1080p] [BluRay] [x264] [DTS] - Part 2.avi
```

Plex will recognize these as two parts of the same movie.

**Step 4.3.5 – Apply Rename**

1. If everything looks correct, click **Rename**.
2. Confirm the operation.

FileBot will rename files and organize them into their respective folders.

---

## 5. Scripts and Logging (Repository-only)

All scripts and logs for this project live in the repository `Scripts` folder:

Files included:

- [Get-MovieAudit.ps1](assets/Get-MovieAudit.ps1) — PowerShell audit script that scans your movie library for issues: duplicate file extensions (e.g., `movie.mkv.mkv`) and folders containing multiple files.

---

## 6. Manual Invocation (preferred)

### 6.1 Audit Your Movie Library

Run the audit script to check for issues:

```powershell
# Basic audit (displays results in console)
& '.\Get-MovieAudit.ps1' -MoviePath 'D:\Movies'

# Audit with CSV export
& '.\Get-MovieAudit.ps1' -MoviePath 'D:\Movies' -ExportCSV
```

**What it checks:**
1. **Duplicate file extensions** — Detects files like `movie.mkv.mkv` (FileBot rename errors)
2. **Multiple files per folder** — Detects folders with more than one file (unexpected)

**Output:**
- Summary of issues found
- Detailed list of problematic files and folders
- Optional CSV report for tracking

---

### 3D Movie Detection Issues

**Problem:** FileBot doesn't detect 3D movies (SBS, TAB) and they're named without the `[3D]` tag.

**Why:** FileBot's 3D detection relies on file metadata. Some 3D files may not have the proper metadata tags, so FileBot can't automatically detect them.

**Solution:**
1. **Manual rename:** Edit the filename to add the 3D tag: `Movie (Year) [3D] [2160p] [x265] [EAC3].mkv`
2. **Use filename hints:** If your original filename includes "3D", "SBS", or "TAB", FileBot may detect it from the filename during the rename process
3. **Check file properties:** Open the file in a media player or tool like MediaInfo to verify it's actually 3D before renaming

---

## 7. Converting Unsupported Formats to MKV

Some video formats don't play well in Plex (ISO, WMV, AVI, DIVX, VOB, etc.). You should convert these to MKV for better compatibility.

### Option 1: HandBrake (Easiest - GUI)

**Download & Install:**
1. Download from https://handbrake.fr/
2. Install and open HandBrake

**Convert Files:**
1. Click **Open Source** and select your video file
2. Click **Browse** to choose output location
3. Set **Format** to **MKV**
4. Choose a preset like **"Fast 1080p30"** or **"H.265 MKV 1080p30"**
5. Click **Start Encode**

**Batch Convert:**
- Use **Queue** → **Add to Queue** for multiple files
- Process them all at once

### Option 2: FFmpeg (Command Line - Fast & Powerful)

**Install FFmpeg:**
```powershell
winget install FFmpeg
```

**Simple Re-container (no re-encode - very fast):**
```powershell
ffmpeg -i "input.avi" -c copy "output.mkv"
```

**Re-encode with H.264 (better compatibility):**
```powershell
ffmpeg -i "input.avi" -c:v libx264 -crf 20 -c:a aac -b:a 192k "output.mkv"
```

**Batch convert all AVI files in a folder:**
```powershell
Get-ChildItem -Filter *.avi | ForEach-Object {
    $output = $_.BaseName + ".mkv"
    ffmpeg -i $_.FullName -c:v libx264 -crf 20 -c:a aac -b:a 192k $output
}
```

### Recommendation

- Use **HandBrake** for one-off conversions (easy GUI)
- Use **FFmpeg** for batch operations (faster, more control)
- Run the **Get-MovieAudit.ps1** script to identify files that need conversion
