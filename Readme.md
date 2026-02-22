# Adobe Firewall Blocker - Enhanced Version

![Version](https://img.shields.io/badge/version-2.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)

A powerful Windows batch script to block Adobe applications from accessing the internet via Windows Firewall and reset application data.

---

## 🎯 Features

- ✅ **Block All Adobe Applications** - Automatically finds and blocks all Adobe executables
- ✅ **Inbound + Outbound Blocking** - Comprehensive network blocking in both directions
- ✅ **Critical Services Blocking** - Specifically targets Adobe background services
- ✅ **Smart Exclusions** - Option to skip helpers and updaters
- ✅ **Data Reset** - Clear all Adobe application data for fresh install state
- ✅ **Custom Directory Scan** - Scan any directory for Adobe executables
- ✅ **Rule Management** - Easy removal of existing firewall rules
- ✅ **Detailed Logging** - Complete operation logs with timestamps
- ✅ **No Terminal Crashes** - Stable operation with proper error handling

---

## 📋 Prerequisites

- Windows 7/8/10/11
- Administrator privileges
- Windows Firewall enabled

---

## 🚀 Quick Start

### 1. Download
Download the `.bat` file from this repository.

### 2. Run as Administrator
- Right-click on the `.bat` file
- Select **"Run as administrator"**
- Click **Yes** on the UAC prompt

### 3. Choose Your Option
Select from the menu (1-8) based on your needs.

---

## 📖 Menu Options

### **Option 1: Block All Adobe Applications** ⭐ Recommended
- Scans all Adobe installation directories
- Blocks every Adobe executable found
- Creates inbound + outbound firewall rules
- Automatically blocks critical background services

**Use Case:** Complete network isolation for all Adobe products

---

### **Option 2: Remove Existing Firewall Rules**
- Searches for all Adobe firewall rules
- Safely removes them from Windows Firewall
- Shows count of removed rules

**Use Case:** Unblocking Adobe applications, troubleshooting

---

### **Option 3: Block Adobe (Exclude Helpers/Updaters)**
- Blocks main Adobe applications only
- Skips files containing:
  - `uninstall`
  - `helper`
  - `crash`
  - `reporter`
  - `installer`
  - `update`

**Use Case:** Block apps but allow update mechanisms to work

---

### **Option 4: Custom Directory Scan**
- Enter any directory path
- Scans for all `.exe` files
- Blocks found executables

**Use Case:** Block Adobe apps in non-standard installation locations

---

### **Option 5: Block Critical Adobe Services** 🎯
Specifically targets known Adobe background processes:

| Service | Executable |
|---------|------------|
| Adobe Desktop Service | `AdobeDesktopService.exe` |
| Adobe CEF HTML Engine | `CEPHtmlEngine.exe` / `cephtmlengine.exe` |
| Adobe Genuine Software Monitor | `AGMService.exe` |
| Adobe Genuine Launcher | `AdobeGenuineLauncher.exe` |
| Adobe GC Invoker Utility | `AGCInvokerUtility.exe` |
| Creative Cloud Process | `CCXProcess.exe` |
| Adobe IPC Broker | `AdobeIPCBroker.exe` |
| Creative Cloud | `Creative Cloud.exe` |
| CC Library | `CCLibrary.exe` |
| Core Sync | `CoreSync.exe` |

**Use Case:** Target specific Adobe services without full scan

---

### **Option 6: Clear Adobe Application Data** 🔄
Resets Adobe applications to fresh install state by removing:

- ✅ User preferences and settings
- ✅ Cache files
- ✅ Recent files history
- ✅ Workspaces and custom configurations
- ✅ License activation data (may require re-activation)
- ✅ Registry entries

**Locations Cleared:**
```
%APPDATA%\Adobe
%LOCALAPPDATA%\Adobe
%ProgramData%\Adobe\SLCache
%ProgramData%\Adobe\SLStore
%TEMP%\Adobe
HKCU\Software\Adobe
```

**⚠️ Warning:** You may need to sign in and re-activate your Adobe products after this operation.

**Use Case:** Fix corrupted settings, start fresh, troubleshooting

---

### **Option 7: View Log File**
- Displays complete operation log
- Shows all blocked applications
- Lists errors and warnings

**Use Case:** Verify operations, troubleshooting

---

### **Option 8: Exit**
Safely closes the program.

---

## 📂 Scanned Directories

The script automatically scans these locations:

```
C:\Program Files\Adobe
C:\Program Files (x86)\Adobe
C:\Program Files\Common Files\Adobe
C:\Program Files (x86)\Common Files\Adobe
%APPDATA%\Adobe
%LOCALAPPDATA%\Adobe
%ProgramData%\Adobe
```

---

## 📊 Flowchart

<img width="2816" height="1536" alt="Gemini_Generated_Image_wschwdwschwdwsch" src="https://github.com/user-attachments/assets/77164396-ed44-4f06-b12a-b8e387c741da" />


## 📝 Log Files

Log files are automatically created in the same directory as the script:

**Format:** `firewall_block_YYYYMMDD_HHMMSS.log`

**Example:** `firewall_block_20240215_143022.log`

**Contents:**
- Timestamp of operations
- Scanned directories
- Blocked applications with full paths
- Skipped applications
- Errors and warnings
- Operation summaries

---

## ⚠️ Important Notes

### Firewall Rules
- Each application gets TWO rules: one inbound, one outbound
- Rule naming format: `Block_Adobe_[AppName]_In` / `Block_Adobe_[AppName]_Out`
- Rules work across all network profiles (Domain, Private, Public)

### Data Clearing
- **Always creates a backup** of important work before clearing data
- Some Adobe apps may require re-activation after data clearing
- Creative Cloud login credentials will need to be re-entered

### Administrator Rights
- Script **MUST** be run as Administrator
- Without admin rights, firewall rules cannot be created
- UAC prompt will appear - click "Yes"

---

## 🔧 Troubleshooting

### Script Won't Run
- Ensure you're running as Administrator
- Check if execution policies allow batch scripts
- Verify Windows Firewall service is running

### Applications Still Connect
- Verify rules were created: `Windows Defender Firewall → Advanced Settings → Outbound Rules`
- Check if VPN or proxy is bypassing firewall
- Some Adobe services may use system processes - use Option 5

### Terminal Closes Unexpectedly
- This issue has been fixed in the current version
- All operations now return to menu properly
- If still occurring, check the log file for errors

### Can't Remove Rules
- Ensure running as Administrator
- Manually check Windows Firewall if automated removal fails
- Use Windows Firewall GUI: `wf.msc`

---

## 🛡️ Security & Privacy

This script:
- ✅ Only modifies Windows Firewall rules
- ✅ Does not modify system files
- ✅ Does not send data anywhere
- ✅ Creates detailed logs locally
- ✅ Can be fully reversed (Option 2)

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request


---

## 🌟 Support

If this tool helped you, please:
- ⭐ Star this repository
- 🐛 Report bugs via Issues
- 💡 Suggest features via Issues
- 📢 Share with others

---

## ⚖️ Disclaimer

This tool is provided "as is" without warranty of any kind. Use at your own risk. The author is not responsible for any damage or data loss. Always backup important data before using system modification tools.

This tool is intended for legitimate use cases such as:
- Network testing
- Privacy protection
- Bandwidth management
- Offline work environments

---

## 📅 Version History

### Version 2.0 (Current)
- ✅ Fixed terminal closing issue
- ✅ Added critical services blocking
- ✅ Enhanced inbound + outbound blocking
- ✅ Added data clearing feature
- ✅ Improved error handling
- ✅ Better logging with full paths


Made with ❤️ by [WKVDewantha](https://github.com/WKVDewantha)

