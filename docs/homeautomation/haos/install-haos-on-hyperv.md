---
author: 
  - Brian Knackstedt
Date: 2024-07-24
---
<div style="text-align: right"> last updated: {{ git_revision_date_localized }} </div>

# Install Home Assistant OS on Hyper-V

This guide describes how to install the latest Home Assistant OS on Hyper-V.

## **Download HAOS**
- Open [HAOS release](https://github.com/home-assistant/operating-system/releases)
- Scroll-down and download `haos_generic-aarch64-<version>.vmdk.zip`
- Extract ZIP file

## **Convert VMDK to VHDX**
- Download and install [Microsoft Virtual Machine Converter](http://download.microsoft.com/download/9/1/E/91E9F42C-3F1F-4AD9-92B7-8DD65DA3B0C2/mvmc_setup.msi)
- Open Powershell as an Administrator

	``` powershell
	Import-Module 'C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1'
	
	ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath 'C:\Temp\haos_generic-aarch64-12.3.vmdk' -Destination 'C:\Temp' -VhdType DynamicHardDisk -VhdFormat vhdx
	```

- Wait several minutes for the conversion to complete

## **Create virtual machine**
**Recommended Hardware**

- 2 CPUs
- 2048 MB memory
- Disk: Move `haos_generic-aarch64.vhdx` under `Virtual Hard Disks` folder and select existing

## **Launch Home Assistant**
- Start Virtual Machine
- Open `http://homeassistant.local:8123`

## **Install HACS (Home Assistant Community Store)**
[Reference](https://hacs.xyz/docs/setup/download)

- Install SSH add-on
- Set password
- Start SSH service
- Run `wget -O - https://get.hacs.xyz | bash -`
- Navigate to Settings > Devices & Services > Integrations
- Clear browser cache
- Hard reload browser using Shift-Refresh
- Click on + Add Integration
- Search for HACS and install
- Follow on-screen instructions

## **Add Integration**
- [LG ThinQ Devices integration](https://github.com/ollo69/ha-smartthinq-sensors)

	!!!note
		Go to the Integration tab and search the "SmartThinQ LGE Sensors" component
