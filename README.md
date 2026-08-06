# TWRP Recovery for OPPO F3 (CPH1609)

A complete build system for generating a bootable TWRP recovery image for the OPPO F3 (CPH1609) smartphone.

## Device Specifications

| Component | Details |
|-----------|---------|
| Device | OPPO F3 (CPH1609) |
| Chipset | MediaTek MT6750 |
| CPU | Octa-core 1.5 GHz Cortex-A53 |
| GPU | Mali-T860 MP2 |
| Display | 5.5" Full HD (1080x1920) |
| RAM | 4 GB |
| Storage | 64 GB |
| Android | 6.0.1 Marshmallow |
| TWRP Version | 3.5.2-0 (Unofficial) |

## Repository Structure

```
oppo-f3-twrp/
├── .github/workflows/      # GitHub Actions CI/CD
├── device/oppo/CPH1609/    # Device tree configuration
│   ├── BoardConfig.mk      # Board configuration
│   ├── AndroidProducts.mk  # Product definitions
│   ├── device.mk           # Device makefile
│   ├── recovery.fstab      # Recovery fstab
│   ├── twrp.fstab          # TWRP fstab
│   ├── twrp.prop           # TWRP properties
│   ├── scatter/            # MTK scatter files
│   ├── rootdir/            # Init scripts
│   └── patches/            # Custom patches
├── scripts/                # Build and utility scripts
├── extract/                # Firmware extraction tools
├── build/                  # Build system
├── tools/                  # Additional tools
├── firmware/               # Firmware files (user-provided)
├── output/                 # Build output
├── docs/                   # Documentation
└── logics/                 # Build logs
```

## Quick Start

### Prerequisites

- Linux (Ubuntu 18.04/20.04/22.04) or WSL
- 16GB+ RAM recommended
- 100GB+ free disk space
- Stable internet connection

### Build from Source

```bash
# Clone repository
git clone https://github.com/your-username/oppo-f3-twrp.git
cd oppo-f3-twrp

# Make scripts executable
chmod +x scripts/*.sh

# Build TWRP
./scripts/build_twrp.sh
```

### Build with GitHub Actions

1. Push to repository
2. GitHub Actions will automatically build TWRP
3. Download from releases

## Extraction Tools

### Automatic Firmware Extraction

```bash
# Extract from firmware ZIP
./scripts/extract_firmware.sh /path/to/firmware.zip

# Extract from extracted directory
./scripts/extract_firmware.sh /path/to/extracted/firmware/
```

The extraction tool will automatically extract:
- boot.img
- recovery.img
- Kernel
- Ramdisk
- fstab
- Partition layout (scatter file)
- Default properties
- Vendor information
- Security patch level
- Page size
- Kernel command line

### Manual Extraction

```bash
# Extract boot.img using MTKClient
python3 mtk r boot boot.img

# Extract recovery.img
python3 mtk r recovery recovery.img

# Extract all partitions
python3 mtk r
```

## Build System

### Local Build

```bash
# Setup environment
./scripts/setup_environment.sh

# Build TWRP
./scripts/build_twrp.sh

# Validate build
./scripts/validate_recovery.sh output/twrp_CPH1609.img
```

### GitHub Actions Build

The repository includes a complete GitHub Actions workflow that:
1. Sets up build environment
2. Downloads TWRP source
3. Clones device tree
4. Applies patches
5. Builds TWRP
6. Validates output
7. Creates release

## Installation

### Using Fastboot

```bash
# Reboot to bootloader
adb reboot bootloader

# Flash TWRP
fastboot flash recovery twrp_CPH1609.img

# Boot to TWRP
fastboot boot twrp_CPH1609.img
```

### Using MTKClient

```bash
# Boot to BROM mode
# Power off device, hold Volume Up + Volume Down, connect USB

# Flash recovery
python3 mtk w recovery twrp_CPH1609.img
```

### Using SP Flash Tool

1. Open SP Flash Tool
2. Load scatter file from `scatter/MT6750_Android_scatter.txt`
3. Select recovery partition
4. Choose `twrp_CPH1609.img`
5. Click Download
6. Power off device, connect USB

## Features

### TWRP Features
- Full touch-based interface
- Backup and restore
- Flash ZIP files
- ADB and MTP support
- USB OTG support
- Decryption support
- File manager
- Terminal emulator

### Device-Specific Features
- MediaTek MT6750 support
- EMMC partition support
- Proper fstab configuration
- Init scripts for recovery
- USB configuration
- Touchpanel support

## Partition Layout

Based on MT6750 scatter file analysis:

| Partition | Start Address | Size | Description |
|-----------|---------------|------|-------------|
| preloader | 0x0 | 0x40000 | Preloader |
| pgpt | 0x0 | 0x8000 | Primary GPT |
| recovery | 0x8000 | 0x1000000 | Recovery |
| md1rom | 0x1008000 | 0x4000000 | Modem |
| md1dsp | 0x5008000 | 0x200000 | Modem DSP |
| md1arm7 | 0x5208000 | 0x200000 | Modem ARM7 |
| md3rom | 0x5408000 | 0x200000 | Modem3 |
| lk | 0x5608000 | 0x100000 | Little Kernel |
| boot | 0x5708000 | 0x1000000 | Boot |
| logo | 0x6708000 | 0x800000 | Logo |
| nvram | 0x7008000 | 0x800000 | NVRAM |
| seccfg | 0x7808000 | 0x20000 | Secure Config |
| nvdata | 0x8A28000 | 0x2000000 | NVRAM Data |
| proinfo | 0xBA28000 | 0x300000 | Product Info |
| para | 0xBD28000 | 0x80000 | Parameters |
| expdb | 0xBDA8000 | 0x100000 | Exception DB |
| frp | 0xBEA8000 | 0x100000 | Factory Reset |
| system | 0x1BFA8000 | 0x70800000 | System |
| cache | 0x8C7A8000 | 0x10000000 | Cache |
| userdata | 0x9C7A8000 | 0x3A3858000 | User Data |

## Troubleshooting

### Build Issues

1. **Flex error**: Run `export LC_ALL=C` before build
2. **Missing dependencies**: Run `./scripts/setup_environment.sh`
3. **Permission denied**: Run `chmod +x scripts/*.sh`

### Boot Issues

1. **Device doesn't boot to TWRP**:
   - Verify bootloader is unlocked
   - Try booting TWRP temporarily: `fastboot boot twrp.img`
   - Check if TWRP image is valid

2. **Touchscreen not working**:
   - Check touchpanel configuration
   - Verify device tree settings

3. **Decryption fails**:
   - Format data in TWRP: Wipe → Format Data
   - This will erase all data

### Recovery Issues

1. **Bootloop after flashing**:
   - Boot to stock recovery
   - Factory reset
   - Reflash TWRP

2. **ADB not working**:
   - Enable USB debugging in TWRP
   - Try different USB cable/port
   - Reinstall ADB drivers

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## Credits

- **TWRP Team** - Team Win Recovery Project
- **yoda24** - OPPO F3 device tree
- **OPPO Community** - Device information
- **MediaTek** - Platform support

## License

This project is licensed under the GPL v2 License.

## Disclaimer

- Flashing custom recovery may void your warranty
- Backup your data before flashing
- Use at your own risk
- The authors are not responsible for any damage

## Support

For issues and questions:
- Create GitHub Issue
- Check XDA Forums
- Join OPPO Community
