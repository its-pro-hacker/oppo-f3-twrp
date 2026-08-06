#!/bin/bash
# build_twrp.sh - Build TWRP Recovery for OPPO F3 (CPH1609)
# MediaTek MT6750 - Android 6.0.1 Marshmallow

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DEVICE_DIR="$PROJECT_DIR/device/oppo/CPH1609"
OUTPUT_DIR="$PROJECT_DIR/output"
LOGS_DIR="$PROJECT_DIR/logics"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "[$timestamp] [$level] $message" | tee -a "$LOGS_DIR/build_$(date +%Y%m%d).log"
}

# Error handling
error_exit() {
    log "ERROR" "$1"
    exit 1
}

# Check dependencies
check_dependencies() {
    log "INFO" "Checking build dependencies..."
    
    local required_tools=(
        "git"
        "repo"
        "java"
        "javac"
        "python3"
        "make"
        "gcc"
        "g++"
        "flex"
        "bison"
        "libssl-dev"
        "libncurses5-dev"
        "libxml2-utils"
        "unzip"
        "curl"
        "wget"
    )
    
    local missing_tools=()
    
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
            log "WARNING" "Missing tool: $tool"
        fi
    done
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        log "WARNING" "Missing tools: ${missing_tools[*]}"
        log "INFO" "Please install missing tools before continuing."
        
        # Attempt to install on Ubuntu/Debian
        if command -v apt-get &> /dev/null; then
            log "INFO" "Attempting to install missing tools..."
            sudo apt-get update
            sudo apt-get install -y "${missing_tools[@]}"
        fi
    fi
    
    log "INFO" "Dependency check completed"
}

# Setup build environment
setup_environment() {
    log "INFO" "Setting up build environment..."
    
    # Set environment variables
    export LC_ALL=C
    export USE_CCACHE=1
    export CCACHE_DIR="$HOME/.ccache"
    export CCACHE_EXEC="$(which ccache)"
    
    # Create ccache directory
    mkdir -p "$CCACHE_DIR"
    
    # Check if TWRP source exists
    local twrp_source="$HOME/twrp"
    if [ ! -d "$twrp_source" ]; then
        log "INFO" "Downloading TWRP source..."
        mkdir -p "$twrp_source"
        cd "$twrp_source"
        
        # Initialize repo
        repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-7.1
        repo sync -c --force-sync --no-tags -j$(nproc)
        
        cd "$PROJECT_DIR"
    fi
    
    log "INFO" "Environment setup completed"
}

# Clone device tree
clone_device_tree() {
    log "INFO" "Cloning device tree..."
    
    local twrp_source="$HOME/twrp"
    local device_path="$twrp_source/device/oppo/CPH1609"
    
    # Create device directory if it doesn't exist
    mkdir -p "$(dirname "$device_path")"
    
    # Clone device tree
    if [ ! -d "$device_path" ]; then
        git clone https://github.com/yoda24/device-tree-cph1609_android_7.1.1_for_twrp_omni_7.1.git "$device_path"
    else
        log "INFO" "Device tree already exists"
    fi
    
    log "INFO" "Device tree cloned successfully"
}

# Apply patches
apply_patches() {
    log "INFO" "Applying patches..."
    
    local twrp_source="$HOME/twrp"
    local device_path="$twrp_source/device/oppo/CPH1609"
    local patches_dir="$DEVICE_DIR/patches"
    
    # Check if patches directory exists
    if [ -d "$patches_dir" ]; then
        local patch_files=$(find "$patches_dir" -name "*.patch" -type f)
        
        for patch_file in $patch_files; do
            log "INFO" "Applying patch: $patch_file"
            cd "$device_path"
            git apply "$patch_file" 2>/dev/null || log "WARNING" "Failed to apply patch: $patch_file"
            cd "$PROJECT_DIR"
        done
    fi
    
    log "INFO" "Patches applied"
}

# Build TWRP
build_twrp() {
    log "INFO" "Building TWRP..."
    
    local twrp_source="$HOME/twrp"
    
    cd "$twrp_source"
    
    # Set build environment
    export LC_ALL=C
    source build/envsetup.sh
    
    # Lunch for device
    lunch omni_CPH1609-eng
    
    # Build recovery image
    log "INFO" "Starting build..."
    mka recoveryimage -j$(nproc) 2>&1 | tee -a "$LOGS_DIR/build_$(date +%Y%m%d).log"
    
    # Check if build was successful
    if [ $? -eq 0 ]; then
        log "INFO" "Build completed successfully!"
        
        # Copy output
        local recovery_img="$twrp_source/out/target/product/CPH1609/recovery.img"
        if [ -f "$recovery_img" ]; then
            cp "$recovery_img" "$OUTPUT_DIR/twrp_CPH1609.img"
            log "INFO" "Recovery image copied to: $OUTPUT_DIR/twrp_CPH1609.img"
        else
            error_exit "Recovery image not found"
        fi
    else
        error_exit "Build failed"
    fi
    
    cd "$PROJECT_DIR"
}

# Validate build
validate_build() {
    log "INFO" "Validating build..."
    
    local recovery_img="$OUTPUT_DIR/twrp_CPH1609.img"
    
    if [ ! -f "$recovery_img" ]; then
        error_exit "Recovery image not found for validation"
    fi
    
    # Check file size
    local file_size=$(stat -f%z "$recovery_img" 2>/dev/null || stat -c%s "$recovery_img" 2>/dev/null)
    log "INFO" "Recovery image size: $file_size bytes"
    
    # Check if file is valid
    if [ "$file_size" -lt 1048576 ]; then
        error_exit "Recovery image is too small (< 1MB)"
    fi
    
    # Try to unpack and validate
    if command -v unpack_bootimg &> /dev/null; then
        local validate_dir="$OUTPUT_DIR/validation"
        mkdir -p "$validate_dir"
        
        unpack_bootimg --boot_img "$recovery_img" --out "$validate_dir" 2>&1 | tee -a "$LOGS_DIR/build_$(date +%Y%m%d).log"
        
        if [ -f "$validate_dir/kernel" ] && [ -f "$validate_dir/ramdisk" ]; then
            log "INFO" "Build validation passed"
        else
            log "WARNING" "Build validation incomplete"
        fi
    fi
    
    log "INFO" "Build validation completed"
}

# Main function
main() {
    log "INFO" "=========================================="
    log "INFO" "OPPO F3 (CPH1609) TWRP Build System"
    log "INFO" "MediaTek MT6750 - Android 6.0.1"
    log "INFO" "=========================================="
    
    # Check if running on Linux
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        error_exit "This build system is designed for Linux only"
    fi
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        log "WARNING" "Running as root is not recommended"
    fi
    
    # Check dependencies
    check_dependencies
    
    # Setup environment
    setup_environment
    
    # Clone device tree
    clone_device_tree
    
    # Apply patches
    apply_patches
    
    # Build TWRP
    build_twrp
    
    # Validate build
    validate_build
    
    log "INFO" "=========================================="
    log "INFO" "Build Summary:"
    log "INFO" "=========================================="
    log "INFO" "Output: $OUTPUT_DIR/twrp_CPH1609.img"
    log "INFO" "Build completed successfully!"
    log "INFO" "=========================================="
}

# Run main function
main "$@"
