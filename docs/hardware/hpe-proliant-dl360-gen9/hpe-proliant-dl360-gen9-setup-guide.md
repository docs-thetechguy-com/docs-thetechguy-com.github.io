---
title: HPE DL360 Gen9 Setup Guide
author: 
  - Brian Knackstedt
Date: 2025-01-31
---
<div style="text-align: right"> last updated: {{ git_revision_date_localized }} </div>

![HPE ProLiant DL360 Gen9 Banner](assets/hpe-proliant-dl360-gen9-banner.png)

# HPE ProLiant DL360 Gen9 Setup Guide

**Hardware**

- HPE ProLiant DL360 Gen9 Server (2 x Intel XEON E5-2690 v4 2.60GHz)

	[The Server Store](https://www.theserverstore.com/hp-1u-servers-gen-9)

	[Newegg](https://www.newegg.com/p/pl?N=101714326%204131%20600561141)

- HPE SmartMemory 128 GB (16 x 8GB DDR4 2133MHz ECC)

- HPE ProLiant DL360 Gen9 2SFF SAS/SATA Universal Media Bay Kit (775428-001)

	Connect to onboard SATA port 1 and install 2 SSD drives. This will be used for the OS.

- HPE P440ar or H240AR SAS Embedded Controller

- 10 x HPE Gen 9 SFF drive caddy with screws (651687-001)

- 2 x Samsung EVO 870 SSD 500GB SSD (https://amzn.to/4jcVhrr)

- 4 x Samsung EVO 870 SSD 500GB SSD (https://amzn.to/4jcVhrr)

- 4 x Western Digital WD20NPVZ 2TB SATA (https://amzn.to/4jcVfjj)

- 1 x Samsung EVO 980 Pro 1TB M.2 NVMe (https://amzn.to/4jbjAGk)

- 1 x M.2 to PCIe Adpater (https://amzn.to/4fUBBWs)

- 1 x Nvidia ConnectX-4 InfiniBand PCIe Adapter (MCX414A-BCAT)

!!! Info ""
	This is the network adapter I'm using, but you could also use a 10GbE adapter. I would recommend it support [SRV-IO](https://learn.microsoft.com/en-us/windows-hardware/drivers/network/overview-of-single-root-i-o-virtualization--sr-iov-).

!!! Info IMPORTANT
    On top of the server case is a sticker with the default iLO information. Make note of this information.

**Reset HPE Integrated Lights-Out (iLO)**

- Connect iLO port to the network
- Power on server
- When available, Press F9 for System Utilities
- Select System Configuration > iLO 4 Configuration Utility
- Change Set to factory defaults to Yes
- Press ESC and Y to save change
- Press ESC several times and Enter to restart server
- Make note of the iLO IP address that is displayed on the boot screen

**Configure HPE Integrated Lights-Out (iLO)**

- From your workstation, open a web browser
- Enter iLO IP address
- Enter credentials from the sticker

- Navigate to Administration > Firmware

- Verify iLO and BIOS firmware are the latest versions

	Latest firmware can be downloaded from [HPE Integrated Lights-Out 4 (iLO 4)](https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=5219994&tab=driversAndSoftware)

	Google P89_3.40_08_29_2024 for the latest system firmware [Biesma.net](https://wp.biesma.net)


- Navigate to Administration > User Administration
- Check Administrator and click Edit
- Set a new long complex password
- Navigate to Administration > Access Settings
- Disable all services that are not being used (SSH, SNMP, IPMI/DCMI, Serial CLI, Virtual Serial Port)
- Enable Require Login for iLO RBSU
- Increase Minimum Password Length to 15
- Update Server Name
- Navigate to Administration > Security
- Enable login security banner

**Configure System BIOS**

- Open iLO Overview page
- Under Integrated Remote Console, click HTML5
- Power on server
- When available, Press F9 for System Utilities
- Select System Configuration > BIOS/Platform Configuration
- System Options > SATA Controller Options > Enable Dynamic Smart Array RAID Support
- System Options > Virtualization Options > All Enabled
- Boot Mode > Boot Mode > UEFI Mode
- Power Management > Power Profile > Balanced Power and Performance
- Power Management > Advanced Power Options > Redundant Power Supply Mode > High Efficiency Mode (Auto)
- Advanced Options > Fan and Thermal Options > Thermal Configuration > Optimal Cooling
- Press F10 and Y to save configuration
- Press ESC several times to return to System Configuration menu
- Reboot system

**Create RAID Array and Enable HBA Mode**

- When available, Press F9 for System Utilities
- Select System Configuration > Embedded Storage
- Select Exit and launch Smart Storage Administrator
- Create RAID 1 array

- From the drop-down menu, select Smart HBA controller > Configure
- Enable HBA mode
- Exit Smart Storage Administrator
- Reboot server

**Create Media**

- Download Windows Server 2025 Datacenter
- Use Rufus to write ISO to USB drive
- Download [HPE B140i Controller Drivers](https://support.hpe.com/connect/s/softwaredetails?collectionId=MTX-78fc77876f754f93)
- Open download and extract to a folder named Drivers on the USB drive
- Insert USB drive into server

**Install Operating System**

- Open iLO Overview page
- Under Integrated Remote Console, click HTML5
- Power on server
- When available, Press F11 for Boot menu
- Select USB drive
- When prompted, press any key to boot Windows Server setup
- Select Load drivers
- Select USB > Drivers folder
- Wait for installation to complete
- Apply Windows product key
- Enable Receive updates for other Microsoft products
- Install all Windows Updates
- Install all optional (driver) updates

**Install HPE Drivers**

- [H240ar Smart HBA Driver for Windows (x64)](https://support.hpe.com/connect/s/softwaredetails?language=en_US&collectionId=MTX-32cb58a13b764af9&tab=revisionHistory)

- [HPE Smart HBA Firmware](https://support.hpe.com/connect/s/softwaredetails?language=en_US&collectionId=MTX-b57ffa2f7fe942a8&tab=revisionHistory)

- [HPE Smart Storage Administrator (HPE SSA) for Windows (x64)](https://support.hpe.com/connect/s/softwaredetails?language=en_US&collectionId=MTX-a1953c549aa145b2&tab=revisionHistory)

- [iLO 4 Channel Interface Driver for Windows (x64)](https://support.hpe.com/connect/s/softwaredetails?language=en_US&collectionId=MTX-cef186d7aeff4c8e&tab=revisionHistory)

- [iLO 4 Management Controller Driver Package for Windows (x64)](https://support.hpe.com/connect/s/softwaredetails?language=en_US&collectionId=MTX-0304d65ecdff4ea5&tab=revisionHistory)

- [Matrox G200eH Video Controller Driver for Windows (x64)](https://support.hpe.com/connect/s/softwaredetails?language=en_US&collectionId=MTX-c64a84fd2c1c48b6&tab=revisionHistory)

	This may cause you to lose video and you will need to force a server restart.

**Install Nvidia InfiniBand Drivers**

- [Nvidia WinOF-2 Driver for Windows (x64) 3.0.50000](https://www.mellanox.com/downloads/WinOF/MLNX_WinOF2-3_0_50000_All_x64.exe)

- [Nvidia ConnectX-4 (MCX414A-BCAT) Firmware 12.28.2302](https://www.mellanox.com/downloads/firmware/fw-ConnectX4-rel-12_28_2302-MCX414A-BCA_Ax-UEFI-14.21.17-FlexBoot-3.6.102.bin.zip)

- At this point Device Manager should show clean

**Switch Controller to HBA Mode**

- Open HPE Smart Storage Administrator
- Select Smart Array P440ar or H240ar controller
- Select Configure
- Select Enable HBA Mode
- Select Manage Power Settings > Min Power
- Select Physical Devices and verify all eight drives display
- Restart system to apply settings
