---
author: 
  - Brian Knackstedt
Date: 2024-06-30
---
<div style="text-align: right"> last updated: {{ git_revision_date_localized }} </div>

# Windows 11 ARM on OPi5

This guide describes how to install the latest Windows 11 ARM image on an Orange Pi 5. Keep in mind this is still in development and individual results may vary.

<center>
<iframe width="560" height="315" src="https://www.youtube.com/embed/qpqhxOXO4D4?si=tOYdRPV1eDemUZvB" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</center>

## **Hardware Requirements**

<center><img src="../assets/hardware.png" alt="hardware" width="750" /></center>


- [Orange Pi 5 (OPi5)](http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/details/Orange-Pi-5.html)

	!!!note
		OPi5 supports ARMv8.2. Windows 11 requires ARMv8.1

		As of June 2024, Orange Pi 5 Pro is not supported by this project.

- [RGB fan and low-profile CPU radiator for Orange Pi 5](https://www.aliexpress.us/item/3256805285062643.html)

- [Black ball bearing fan - DC 5V sleeve dupont 40x40x10mm](https://www.aliexpress.us/item/3256807362230220.html)

- USB hub ([uni USB C to USB Hub 4 Ports](https://www.amazon.com/gp/product/B08P3GDLVP))

	!!!note  
		USB hub is requires as only the vertical USB-A ports will work for keyboard and mouse. Any USB hub may work, this is just want I had. 

- USB-C to USB-A adapter for hub

- NVMe drive (such as a [SABRENT 1TB Rocket NVMe PCIe M.2 2242](https://www.amazon.com/gp/product/B07XVTRFF8/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&th=1))

	!!!note
		Must be a NVMe M.2 drive. You may find some NVMe drives do not have driver support. I have found SABENT brand is supported.	

		There is no driver support for All M.2 SATA drives.

- [M.2 SSD screw set](https://www.amazon.com/gp/product/B086T2KXGQ)
- [Enclosure for M.2 PCIe NVMe](https://www.amazon.com/gp/product/B08RVC6F9Y)
- USB keyboard and mouse

## **Install UEFI firmware to SPI NOR flash**

[Reference Guide](https://wiki.radxa.com/Rock5/install/spi) (see Flash with Windows PC in section 4, option 2)

**Download**

- Download and extract v2.96 or later release of [RKDevTool](https://wiki.radxa.com/Rock5/install/rockchip-flash-tools)

- Download, extract, and install latest version of [Rockchip USB driver (RKDriverAssitant)](https://wiki.radxa.com/Rock5/install/rockchip-flash-tools)

- Download and extract v0.11.2 or later release image of [EDK2 UEFI firmware](https://github.com/edk2-porting/edk2-rk3588/releases) for orangepi-5_UEFI_Release_v#.##.#.img

	!!!note
		0.9.1 does not support built-in GMAC ethernet, use a newer build.

- Download v1.15.113 or later release of [SPL loader BIN file](https://dl.radxa.com/rock5/sw/images/loader/rock-5b/release)

**Write firmware**

- Open RKDevTool as an Administrator

- Right-click in a blank space and select Load Config

    - Select rock-5b-spinor.cfg
    - Click empty box under … to select file

		!!! note
			- Rk3588_spl_loader_v#.##.###.bin for Loader
    		- orangepi-5_UEFI_Release_v#.##.#.img for Image
    
    - Check Write by Address
    - Connect OPi5 from USB-C port to PC

- Hold down MARKROM button and connect USB-C power, wait a few seconds and release button

	![MaskKey](assets/OPi5-MaskKey.png)

- Status in RKDevTool should change from "No Devices Found" to "Found One MASKROM Device"

- Click Run

- Process is done when "Download image OK" is displayed in the logging pane. 

	!!! note
		OPi5 will restarts by itself and exits MASKROM mode

- Disconnect from PC

## **Download Drivers**

Driver download posts are pinned in the #development discord channel

- Download and extract RK3588 signed drivers
	- [Current build (Downloads expire after 90 days)](https://github.com/worproject/Rockchip-Windows-Drivers/actions/workflows/build.yml?query=branch%3Amaster)
	- [Stable build](https://discord.com/channels/1082772881735438346/1082848823233216532/1236925998696763392)
- Download updated storage driver (pdb, inf, and sys)
	- [Current build](https://github.com/worproject/Rockchip-Windows-Drivers/tree/storportDriver/drivers/storage)
- Remove _ncc from file names (example rename stornvme_ncc.sys to stornvme.sys)
- Add updated drivers to rk3588_drivers-v2.zip file

## **Download Windows 11 arm64 release package**

- Open [uupdump](https://uupdump.net)

- Imager method: From the menu, select Windows 11 > 23H2 > latest arm64 build.
- WinPE method: Click arm64 button, I typically choose the latest public release build
	
	![uupdump-arch](assets/uupdump-arch.png)	

- Select latest Windows 11 update

	![uupdump-update](assets/uupdump-update.png)

- Choose language and click Next

- Uncheck Windows Home and click Next

- Select Download and convert to ISO

- Click Create download package

- Extract package to a folder that does not contain spaces in the path. Example: C:\ISO

## **Generate Windows ISO**

- Run `uup_download_windows.cmd`
- Wait for files to be downloaded, processed, and ISO generated. Takes ~60-minutes.

## **Install Windows onto NVMe Drive using Imager**

- Download and extract v2.3.1 or later of the [imager](https://worproject.com/downloads#windows-on-raspberry-imager)

	!!!note
		Ignore that it says Raspberry. This was originally built for Raspberry Pi devices, but development has been extended to support Orange Pi devices)

- Plug the NVMe drive into your PC
- Run `WoR.exe` as an Administrator
	- Set wizard mode = Select show all options
	- Select storage device and device type = Raspberry Pi 2/3
	- Select ISO image and Windows Pro build
	- For drivers, select the downloaded rk3588_drivers-v2.zip file
	- For UEFI firmware, leave use the latest firmware. This doesn't really apply to OPi5.
	- Leave defaults for configuration
	- Click Install
	- Wait for the Windows offline install to complete. Takes ~5 minutes
	- Click Finish 

### **Windows Setup**

- Install NVMe drive into the bottom of your OPi5
- Power-on OPi5
- Wait for Windows to finish setup. Takes 30+ minutes.

	!!!note
		System may be slow while .NET Optimization runs 

- Complete the OOBE process

## **Install Windows using WinPE**

- Download and extract v1.1.0 or later of the [PE-based installer](https://worproject.com/downloads#windows-on-raspberry-pe-based-installer)
	!!!note
		Ignore that it says Raspberry. This was originally built for Raspberry Pi devices, but development has been extended to support Orange Pi devices)

- Plug a separate 8+ GB USB drive into your PC (This is for the installation media and not the NVMe drive)
- Use DiskPart to prepare the partitions. Where `<disk number>` is the listed number of the external USB hard drive.
	``` text
	diskpart
	list disk
	select <disk number>
	clean
	rem === Create the Windows PE partition. ===
	create partition primary size=1024
	format quick fs=fat32 label="Windows PE"
	assign letter=P
	active
	rem === Create a partition for images ===
	create partition primary
	format fs=ntfs quick label="Images"
	assign letter=I
	list vol
	exit
	```

	![usb-partition-scheme](assets/usb-partition-scheme.png)

- 

## **Known Issues**

- When booting the loading circle locks up and Windows never loads. After a few power cycles it clears. 
- BSOD when booting. This could be a sign that the storage driver (stornvme.sys) has been overwritten by Windows\Windows Update.

## **Thank you**

This guide wouldn't have been possible without Mario Bălănică, the developers, and the community that supports the Windows on R project.

- [Windows on R Project](https://worproject.com/)
- [Windows on R Community Discord](https://discord.gg/vjHwptUCa3)