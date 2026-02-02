---
author: 
  - Brian Knackstedt
Date: 2024-07-24
---
<div style="text-align: right"> last updated: {{ git_revision_date_localized }} </div>

![ome Assistant OS on Hyper-V Banner](assets/haos-banner.png)

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
- Open [`http://homeassistant.local:8123`](http://homeassistant.local:8123)

## **Install HACS (Home Assistant Community Store)**
[Reference Documentation](https://hacs.xyz/docs/setup/download)

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
- [Emporia Vue](https://github.com/magico13/ha-emporia-vue)
- [HomeKit Bridge](https://www.home-assistant.io/integrations/homekit)
- [LG ThinQ Devices integration](https://github.com/ollo69/ha-smartthinq-sensors)

	!!!note
		Go to the Integration tab and search the "SmartThinQ LGE Sensors" component

- [Google Nest](https://www.home-assistant.io/integrations/nest)
- [Reolink IP NVR/camera](https://www.home-assistant.io/integrations/reolink)
- [Zigbee2MQTT](https://github.com/zigbee2mqtt/hassio-zigbee2mqtt#installation)

## Add Automation Hardware
- [Google Nest Learning Thermostat 4th Gen](https://amzn.to/4iggz70)
- [Emporia Smart Home Energy Monitor](https://amzn.to/4fnHD2K)
- [EMPORIA Smart Plug with Energy Monitoring](https://amzn.to/3LJFiBT)
- [ratgdo](https://paulwieland.github.io/ratgdo/) - Chamberlain or Liftmaster Opener
- [meross Smart Light Switch 4 pack](https://amzn.to/4cVTNP2)
- [meross Smart Ceiling Fan Control and Dimmer Light Switch](https://amzn.to/3WC5hkO)

## Zigbee Hardware
- [CC2652P2 or CC2652P7 Based Zigbee to PoE Coordinator](https://tubeszb.com)
- [Tuya Zigbee 3.0 Signal Repeater USB](https://www.aliexpress.us/item/3256804809754261.html)
- [Amico 6.0A USB 3-Port 30W Wall Outlets](https://amzn.to/3VfvfJQ)
- [Aqara Temperature and Humidity Sensor](https://www.aliexpress.us/item/3256806607779727.html)
- [Aqara Water Leakage Sensor](https://www.aliexpress.us/item/3256806421735716.html)
- [Tuya Soil Temperature and Humidity Sensor](https://www.aliexpress.us/item/3256807143183397.html)

## Add Security Hardware
- [REOLINK 4K 8CH Network Video Recorder](https://amzn.to/3WCNYjM)
- [REOLINK RLC-1240A 12MP POE 145° wide-angle Camera](https://amzn.to/3Spbazx)
- [REOLINK RLC-820A 8MP POE 87° Camera](https://amzn.to/46rfvbg)
- [REOLINK E1 Zoom 5MP 360° Indoor Camera](https://amzn.to/4cV8TEn)
- [Cudy 8 Port Gigabit PoE Switch](https://amzn.to/4cXgRgh)
