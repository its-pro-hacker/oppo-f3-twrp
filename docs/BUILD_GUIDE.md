# Documentation for OPPO F3 (CPH1609) TWRP Build System

## Overview

This document provides comprehensive information about the TWRP build system for the OPPO F3 (CPH1609) smartphone with MediaTek MT6750 chipset.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Build Instructions](#build-instructions)
3. [Extraction Tools](#extraction-tools)
4. [Device Configuration](#device-configuration)
5. [Troubleshooting](#troubleshooting)
6. [Advanced Usage](#advanced-usage)

## Getting Started

### Prerequisites

#### Hardware Requirements
- Modern multi-core processor (Intel/AMD)
- 16GB RAM minimum (32GB recommended)
- 100GB+ free disk space
- Stable internet connection

#### Software Requirements
- Ubuntu 18.04/20.04/22.04 LTS (or WSL2 on Windows)
- Git
- Python 3.6+
- Java 8 (OpenJDK)
- Android SDK Platform Tools

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/oppo-f3-twrp.git
cd oppo-f3-twrp

# Make scripts executable
chmod +x scripts/*.sh

# Run setup
./scripts/setup_environment.sh
```

## Build Instructions

### Automatic Build

```bash
# Build TWRP
./scripts/build_twrp.sh
```

### Manual Build

```bash
# Setup environment
export LC_ALL=C
mkdir -p ~/twrp && cd ~/twrp
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-7.1
repo sync -c --force-sync --no-tags -j$(nproc)

# Clone device tree
git clone https://github.com/yoda24/device-tree-cph1609_android_7.1.1_for_twrp_omni_7.1.git device/oppo/CPH1609

# Build
source build/envsetup.sh
lunch omni_CPH1609-eng
mka recoveryimage -j$(nproc)
```

## Extraction Tools

### Automatic Extraction

```bash
# Extract from firmware
./scripts/extract_firmware.sh /path/to/firmware.zip

# Extract from directory
./scripts/extract_firmware.sh /path/to/extracted/firmware/
```

### What Gets Extracted

- `boot.img` - Boot image
- `recovery.img` - Stock recovery
- `kernel` - Linux kernel
- `ramdisk` - Initial ramdisk
- `fstab` - File system table
- `scatter.txt` - Partition layout
- `default.prop` - Build properties
- `vendor_info.txt` - Vendor information
- `page_size.txt` - Boot image page size
- `kernel_cmdline.txt` - Kernel command line
- `security_patch.txt` - Security patch level
- `header_version.txt` - Boot image header version

## Device Configuration

### BoardConfig.mk

Key configuration options:

```makefile
# Platform
TARGET_BOARD_PLATFORM := mt6750

# Kernel
BOARD_KERNEL_CMDLINE := console=ttyMT0,115200n1 androidboot.console=ttyMT0
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_PAGESIZE := 2048

# Partitions
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1887436800
```

### Recovery FSTAB

```
/dev/block/platform/mtk-msdc.0/by-name/system    /system      ext4    ro,barrier=1
/dev/block/platform/mtk-msdc.0/by-name/cache     /cache       ext4    noatime,nodiratime,nosuid,nodev
/dev/block/platform/mtk-msdc.0/by-name/userdata  /data        ext4    noatime,nodiratime,nosuid,nodev
```

### TWRP Properties

```
tw_device_info_max_brightness=255
tw_device_info_default_brightness=128
tw_device_info_screen_timeout_secs=0
tw_device_info_has_battery_percentage=true
```

## Troubleshooting

### Build Issues

#### Flex Error
```bash
export LC_ALL=C
```

#### Missing Dependencies
```bash
sudo apt-get install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev
```

#### Permission Denied
```bash
chmod +x scripts/*.sh
```

### Boot Issues

#### Device Doesn't Boot to TWRP
1. Verify bootloader is unlocked
2. Try temporary boot: `fastboot boot twrp.img`
3. Check TWRP image validity

#### Touchscreen Not Working
1. Check touchpanel configuration in device tree
2. Verify kernel config includes touch drivers

#### Decryption Fails
1. Format data in TWRP: Wipe → Format Data
2. This will erase all data

### Recovery Issues

#### Bootloop After Flashing
1. Boot to stock recovery
2. Factory reset
3. Reflash TWRP

#### ADB Not Working
1. Enable USB debugging in TWRP
2. Try different USB cable/port
3. Reinstall ADB drivers

## Advanced Usage

### Custom Patches

Place patch files in `device/oppo/CPH1609/patches/`:

```bash
# Create patch
git diff > my_patch.patch

# Apply patch
git apply my_patch.patch
```

### Custom Kernel

1. Extract kernel from firmware
2. Modify kernel configuration
3. Rebuild kernel
4. Update device tree

### Multi-Device Support

To add support for other MT6750 devices:

1. Create new device directory
2. Copy and modify configuration files
3. Update build scripts
4. Test on actual hardware

## Performance Tips

### Build Optimization

```bash
# Use ccache
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache

# Limit jobs
mka recoveryimage -j8

# Use tmpfs for build
export TMPDIR=/dev/shm
```

### Disk Space Management

```bash
# Clean build
make clean

# Remove old artifacts
rm -rf out/target/product/CPH1609/*
```

## Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## Support

- GitHub Issues: Report bugs and request features
- XDA Forums: Community support
- OPPO Community: Device-specific help
