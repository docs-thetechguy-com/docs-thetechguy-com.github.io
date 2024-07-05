---
author: 
  - Brian Knackstedt
Date: 2024-06-30
---
<div style="text-align: right"> last updated: {{ git_revision_date_localized }} </div>

# Windows 11 ARM on OPi5

This guide describes how to install the latest Windows 11 ARM image on an Orange Pi 5.

## **Hardware Requirements**

- [Orange Pi 5 (OPi5)](http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/details/Orange-Pi-5.html)
	
	!!! note
		OPi5 supports ARMv8.2. Windows 11 requires ARMv8.1
  
    	As of June 2024, Orange Pi 5 Pro is not supported by this project.

- USB hub ([uni USB C to USB Hub 4 Ports](https://www.amazon.com/gp/product/B08P3GDLVP))
	
	!!! note  
		USB hub is requires as only the vertical USB-A ports will work for keyboard and mouse. Any USB hub may work, this is just want I had. 
  
- USB-C to USB-A adapter for hub

- NVMe drive (such as a [SABRENT 1TB Rocket NVMe PCIe M.2 2242](https://www.amazon.com/gp/product/B07XVTRFF8/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&th=1))

	!!! note
		Must be a NVMe M.2 drive. You may find some NVMe drives do not have driver support. I have found SABENT brand is supported.	
			
	
  	There is no driver support for All M.2 SATA drives.
  
- [M.2 SSD screw set](https://www.amazon.com/gp/product/B086T2KXGQ)
- USB keyboard and mouse

## **Install UEFI firmware to SPI NOR flash**

[Reference Guide](https://wiki.radxa.com/Rock5/install/spi) (see Flash with Windows PC in section 4, option 2)

**Download**

- Download and install [rkdevtools](https://wiki.radxa.com/Rock5/install/rockchip-flash-tools)

- Download and extract latest successful build of [EDK2 UEFI firmware](https://github.com/edk2-porting/edk2-rk3588/actions/workflows/build.yml) for orangepi-5 UEFI Debug image

	!!!note
		0.9.1 does not support built-in GMAC ethernet, use a newer build.

**Write firmware**

- Open RKDevTool as an Administrator

- Right-click and select Load Config

    - Select rock-5b-spinor.cfg
    - Click empty box under … to select file

		!!! note
			- Rk3588_spl_loader.bin for Loader
    		- Orangepi-5_UEFI.img for Image
    
    - Check Write by Address
    - Connect OPi5 from USB-C port to PC

- Hold down MARKROM button and connect USB-C power, wait a few seconds and release button

	![MaskKey](assets/OPi5-MaskKey.png)

- Status in RKDevTool should change from No Devices Found to Found One MASKROM Device

- Click Run

- Process is done when "Download image OK" is displayed in the logging pane. 

	!!! note
		OPi5 will restarts by itself and exits MASKROM mode

- Disconnect from PC

## **Download Drivers**

Driver download posts are pinned in the #development discord channel

- Download and extract [RK3588 signed drivers](https://discord.com/channels/1082772881735438346/1082848823233216532/1236925998696763392)
- Download updated [storage driver (pdb, inf, and sys)](https://github.com/worproject/Rockchip-Windows-Drivers/tree/storportDriver/drivers/storage)
- Download updated [USB driver (inf and sys)](https://github.com/worproject/Rockchip-Windows-Drivers/tree/master/drivers/usb/usbehci_nointerlocked)
- Add updated drivers to rk3588_drivers ZIP file

## **Download Windows 11 arm64 release package**

- Open [uupdump](https://uupdump.net)

- Select arm64 build, I typically choose the latest public release build
	
	![uupdump-arch](assets/uupdump-arch.png)	

- Select update

	![uupdump-update](assets/uupdump-update.png)

- Choose language and click Next

- Uncheck Windows Home and click Next

- Select Download and convert to ISO

- Click Create download package

- Extract package to a folder that does not contain spaces in the path. Example: C:\ISO

## **Generate Windows ISO**

- Run `uup_download_windows.cmd`
- Wait for files to be downloaded, processed, and ISO generated. Typically 60-minutes.

## **Install Windows onto NVMe Drive**

- Download and extract [imager](https://worproject.com/downloads#windows-on-raspberry-imager)

	!!!note
		Ignore that it says Raspberry. This was original built for Raspberry Pi devices, but developer has been extended support to Orange Pi devices)

- Plug the NVMe drive into your PC
- Run `WoR.exe` as an Administrator
	- Set wizard mode = Select show all options
	- Select storage device and device type = Raspberry Pi 2/3
	- Select ISO image and Windows Pro build
	- For drivers, select the downloaded rk3588_drivers-v2.zip file
	- For UEFI firmware, leave use the latest firmware. This doesn't really apply to OPi5.
	- Leave defaults for configuration
	- Click Install
	- Wait for the Windows offline install to complete
	- Click Finish 

## **Windows Setup**

- Install NVMe drive into the bottom of your OPi5
- Power-on OPi5
- Wait for Windows to finish setup. Typically 30+ minutes.

	!!!note
		System may be slow while .NET optimization runs 

- Disable Windows Search service
- Disable Print Spooler service
- Uninstall all unused apps
- Open Microsoft Store and update all. Might need to be run multiple times
- Configure and run Windows Updates
- Rename device 

## **Installing and Configuring Hyper-V**

- Create `C:\Hyper-V` folder
- Open Control Panel > Uninstall a program > Turn Windows features on or off
	- Check Hyper-V
	- Uncheck Windows PowerShell 2.0
	- Uncheck Work Folder Client
	- Click OK
- Configure Hyper-V Settings
- Configure Hyper-V external virtual switch

## **Thank you**

This guide wouldn't have been possible without Mario Bălănică, the developers, and the community that supports the Windows on R project.

- [Windows on R Project](https://worproject.com/)
- [Windows on R Community Discord](https://discord.gg/vjHwptUCa3)