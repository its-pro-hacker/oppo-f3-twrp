# OPPO F3 (CPH1609) TWRP Project - Research Analysis
## Date: 2026-08-06

## Device Information

### OPPO F3 (CPH1609)
- **Chipset:** MediaTek MT6750 (MT6755 variant)
- **CPU:** Octa-core 1.5 GHz Cortex-A53
- **GPU:** Mali-T860 MP2
- **Display:** 5.5" Full HD (1080x1920)
- **RAM:** 4 GB
- **Storage:** 64 GB
- **Android:** 6.0.1 Marshmallow (ColorOS 3)
- **Board ID:** full_oppo6750_16391

## Research Findings

### 1. Existing TWRP Ports

#### GitHub Device Tree (yoda24)
- **Repository:** https://github.com/yoda24/device-tree-cph1609_android_7.1.1_for_twrp_omni_7.1
- **Status:** TWRP boots normally
- **Features Working:**
  - Touchscreen
  - Mount system, cache, data
  - Backup & restore
  - Flash zip files
  - ADB working
  - MTP working
- **Known Issues:**
  - Data partition may not mount due to FDE
  - Solution: Format data in TWRP
  - Boot.img provided for preventing encryption

#### Unofficial TWRP 3.5.2-0
- **Source:** yayvomark.com
- **Status:** Available for download
- **Version:** 3.5.2-0 (Unofficial)

### 2. XDA Forum Information

#### Porting Thread
- **Thread:** https://xdaforums.com/t/help-in-porting-twrp-recovery-oppo-f3.3656902/
- **Date:** August 2017
- **Issues Reported:**
  - "corrupted image (boot/recovery) prevents the system from booting manually"
  - Porting using Carliv Kitchen
  - Multiple base recoveries tried (OPPO F1S, Quetel K10000 Pro)

#### Successful Root Methods
- **MTK-SU + Magisk:** Works on Nougat 7.1.1
- **Boot.img Patching:** Can be used without TWRP

### 3. Firmware Analysis

#### Scatter File Details
- **Platform:** MT6750
- **Project:** rlk6750_65_n
- **Storage:** EMMC
- **Block Size:** 0x20000 (131072 bytes)

#### Partition Layout
| Partition | Start Address | Size | Description |
|-----------|---------------|------|-------------|
| preloader | 0x0 | 0x40000 | Preloader |
| pgpt | 0x0 | 0x8000 | Primary GPT |
| recovery | 0x8000 | 0x1000000 | Recovery (16MB) |
| md1rom | 0x1008000 | 0x4000000 | Modem (64MB) |
| md1dsp | 0x5008000 | 0x200000 | Modem DSP (2MB) |
| md1arm7 | 0x5208000 | 0x200000 | Modem ARM7 (2MB) |
| md3rom | 0x5408000 | 0x200000 | Modem3 (2MB) |
| lk | 0x5608000 | 0x100000 | Little Kernel (1MB) |
| boot | 0x5708000 | 0x1000000 | Boot (16MB) |
| logo | 0x6708000 | 0x800000 | Logo (8MB) |
| nvram | 0x7008000 | 0x800000 | NVRAM (8MB) |
| seccfg | 0x7808000 | 0x20000 | Secure Config (128KB) |
| nvdata | 0x8A28000 | 0x2000000 | NVRAM Data (32MB) |
| proinfo | 0xBA28000 | 0x300000 | Product Info (3MB) |
| para | 0xBD28000 | 0x80000 | Parameters (512KB) |
| expdb | 0xBDA8000 | 0x100000 | Exception DB (1MB) |
| frp | 0xBEA8000 | 0x100000 | Factory Reset (1MB) |
| system | 0x1BFA8000 | 0x70800000 | System (~1.8GB) |
| cache | 0x8C7A8000 | 0x10000000 | Cache (256MB) |
| userdata | 0x9C7A8000 | 0x3A3858000 | User Data (~25GB) |

### 4. Boot Image Analysis

#### Header Information
- **Page Size:** 2048 bytes (typical for MTK)
- **Kernel Offset:** 0x00008000
- **Ramdisk Offset:** 0x04000000
- **Tags Offset:** 0xE000000
- **Base Address:** 0x40000000
- **Compression:** Gzip (kernel), LZ4 (ramdisk)

#### Kernel Command Line
```
console=ttyMT0,115200n1 androidboot.console=ttyMT0 androidboot.hardware=mt6750
```

### 5. Security Considerations

#### SafetyNet Detection
- **Issue:** Banking apps detect root
- **Solution:** Magisk + Shamiko module + SafetyNet Fix
- **Method:** Systemless root with Zygisk

#### Bootloader Unlock
- **Method:** `fastboot oem unlock-go`
- **Alternative:** `fastboot flashing unlock`
- **Deep Testing App:** May be required for newer firmware

### 6. Build System Analysis

#### TWRP Source
- **Manifest:** https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git
- **Branch:** twrp-7.1
- **Compatible:** Android 6.0.1/7.1.1

#### Build Dependencies
- Ubuntu 18.04/20.04/22.04
- Python 3.6+
- Java 8
- repo tool
- Standard build tools (flex, bison, gcc, etc.)

### 7. Alternative Methods

#### Magisk Without TWRP
- **Method:** Patch boot.img using Magisk Manager
- **Steps:**
  1. Extract boot.img from firmware
  2. Patch with Magisk Manager
  3. Flash patched boot.img via fastboot

#### MTKClient Method
- **Tool:** https://github.com/bkerler/mtkclient
- **Advantage:** Can flash without unlocking bootloader
- **Usage:** `python3 mtk w recovery recovery.img`

### 8. Known Issues

#### Data Encryption
- **Issue:** Full Disk Encryption (FDE) may prevent TWRP from mounting /data
- **Solution 1:** Format data in TWRP (erases all data)
- **Solution 2:** Flash boot.img that disables encryption

#### Boot Issues
- **Issue:** "Corrupted image" error after flashing
- **Cause:** Incorrect partition offsets or page size
- **Solution:** Use correct scatter file values

#### Touch Panel
- **Issue:** Touchscreen may not work in TWRP
- **Solution:** Verify touchpanel configuration in device tree

## Recommendations

### For Building TWRP
1. Use existing device tree from yoda24
2. Apply patches for Android 6.0.1 compatibility
3. Use correct partition offsets from scatter file
4. Test with temporary boot before permanent flash

### For Rooting
1. **Recommended:** Magisk without TWRP (simplest method)
2. **Advanced:** TWRP + Magisk (more features)
3. **SafetyNet:** Use Shamiko + SafetyNet Fix modules

### For Banking Apps
1. Enable Zygisk in Magisk
2. Configure DenyList
3. Install Shamiko module
4. Install Universal SafetyNet Fix
5. Test with SafetyNet checker

## References

1. [yoda24 Device Tree](https://github.com/yoda24/device-tree-cph1609_android_7.1.1_for_twrp_omni_7.1)
2. [XDA Porting Thread](https://xdaforums.com/t/help-in-porting-twrp-recovery-oppo-f3.3656902/)
3. [TWRP for OPPO F3](https://yayvomark.com/twrp/oppo-f3-cph1609)
4. [OPPO F3 Firmware](https://oppostockrom.com/oppo-f3-cph1609)
5. [Magisk Guide](https://topjohnwu.github.io/Magisk/)
6. [Shamiko Module](https://github.com/nicehash/Shamiko)
7. [SafetyNet Fix](https://github.com/kdrag0n/safetynet-fix)
