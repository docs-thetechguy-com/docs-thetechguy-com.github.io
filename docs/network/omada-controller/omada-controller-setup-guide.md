---
title: Omada Controller Setup Guide
author: 
  - Brian Knackstedt
Date: 2025-02-01
---
<div style="text-align: right"> last updated: {{ git_revision_date_localized }} </div>

# tp-link Omada Controller for Windows Setup Guide

This guide will walk you through installing and configuring tp-link's Omada Software Controller for Windows.

<insert vide>

## Some Benefits of Omada Software Controller

- Enable Mesh technology for access points
- Centralized Management for configuration and firmware updates
- Real-Time Network Topology
- Free

## Prerequisites

- Virtual machine running Windows 11 23H2 or Windows Server 2022 or later
- Connect [tp-link Omada Access Points](https://www.omadanetworks.com/us/business-networking/omada/wifi/) to the network
- Download ZIP file for [Omada Software Controller for Windows](https://support.omadanetworks.com/us/product/omada-software-controller/?resourceType=download)
- Download MSI file for [Microsoft OpenJDK 21 LTS for Windows x64](https://learn.microsoft.com/en-us/java/openjdk/download#openjdk-21)
- Download [Sysinternals Autologon](https://learn.microsoft.com/en-us/sysinternals/downloads/autologon)
- Create a [tp-link cloud access account]([Omada Cloud Management Platform](https://omada.tplinkcloud.com/#signUp))

## Installation

**OpenJDK**

- Open microsoft-jdk-<version>-windows-x64.msi
- Select install for all users of this machine
- Complete wizard, accepting defaults

**Omada Software Controller**

- Create installation directory, example C:\Omada Controller
- Unzip Omada_Controller_Windows_<version>.zip file
- Run Omada Controller.exe
  Note: If SmartScreen is displayed, click Run anyway
- When prompted to open Java 8 webpage, click Yes
  Note: Web browser can be closed, download is not needed
- Change install folder to C:\Omada Controller
- Complete installation and start Omada Controller
- Copy C:\Users\Public\Desktop\Omada Controller.lnk to C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup

## Initial Configuration

**Get Started**

- Wait for Omada Controller to load, this typically several minutes
- Browser should automatically open to https://localhost:8043
- Select Advanced and continue to localhost
- Click Let's Get Started
- Enter Administrator Name, example admin
- Enter email address for password recovery
- Enter strong password - [Strong Password Generator](https://bitwarden.com/password-generator)
- Enable Cloud Access 
- Enter tp-link ID, password, and login
- Accept terms and click agree
- Click Next

**New Setup**

- Click Config New Setup
- Set controller name
- Set controller region and time zone
- Click Next

**Create Site**

- Enter first site name
- Set site region and time zone
- Enter device credentials
- Select Application Scenario
- Click Next

**Configure Devices**

- Click Next

**Configure WAN Settings Overrides**

- Click Next

**Configure Wi-FI**

- Enter SSID
- Enter Password
- Click Next

**Summary**

- Click Finish and wait for controller

## Configuration

**Controller**

- Login to controller
- Review tutorial
- Open Settings > Systems Settings and review settings

**Site**

- Select Dashboard
- Click site name
- Select Devices
- Click Add Devices
- Select Settings > Site Settings and review settings
- Select Settings > WLAN and review settings

**Auto-start Controller**

- Right-click Start button and select Computer Management

- Navigate to Local Users and Groups > Users

- Right-click Users and select New User

  - username = tp-link
  - password = Enter strong password - [Strong Password Generator](https://bitwarden.com/password-generator)
  - Uncheck User must change password at next login
  - Check Password never expires
  - Click Create and then Close

- Open properties of Groups > Administrators

  - Add local tp-link account

- Extract AutoLogon.zip

- Open Autologon.exe

- Agree to EULA

- Enter tp-link account information

  Note: Leave domain blank

- Click Enable

- Close Omada Controller

- Restart device and verify Windows signed in and Omada Controller launches

  Note: If you are using Hyper-V make sure you are in a basic session



This completes the basic setup of a tp-link software controller on Windows.
