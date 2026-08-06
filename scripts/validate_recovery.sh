#!/bin/bash
# validate_recovery.sh - Validate TWRP Recovery Image
# OPPO F3 (CPH1609) - MediaTek MT6750

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
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
    echo -e "[$timestamp] [$level] $message" | tee -a "$LOGS_DIR/validate_$(date +%Y%m%d).log"
}

# Error handling
error_exit() {
    log "ERROR" "$1"
    exit 1
}

# Check if file exists
check_file() {
    if [ ! -f "$1" ]; then
        error_exit "File not found: $1"
    fi
}

# Validate recovery image
validate_recovery() {
    local recovery_img="$1"
    
    log "INFO" "Validating recovery image: $recovery_img"
    
    check_file "$recovery_img"
    
    # Check file size
    local file_size=$(stat -f%z "$recovery_img" 2>/dev/null || stat -c%s "$recovery_img" 2>/dev/null)
    log "INFO" "File size: $file_size bytes"
    
    # Check if file is too small
    if [ "$file_size" -lt 1048576 ]; then
        error_exit "Recovery image is too small (< 1MB)"
    fi
    
    # Check if file is too large
    if [ "$file_size" -gt 33554432 ]; then
        log "WARNING" "Recovery image is large (> 32MB)"
    fi
    
    # Check file magic bytes
    local magic=$(xxd -l 4 -p "$recovery_img")
    log "INFO" "Magic bytes: $magic"
    
    # Check for Android boot image header
    if [[ "$magic" == "414e4452" ]]; then
        log "INFO" "Valid Android boot image header detected"
    else
        log "WARNING" "Non-standard boot image header"
    fi
    
    # Try to unpack
    if command -v unpack_bootimg &> /dev/null; then
        local validate_dir="$OUTPUT_DIR/validation"
        mkdir -p "$validate_dir"
        
        log "INFO" "Unpacking recovery image..."
        unpack_bootimg --boot_img "$recovery_img" --out "$validate_dir" 2>&1 | tee -a "$LOGS_DIR/validate_$(date +%Y%m%d).log"
        
        # Check kernel
        if [ -f "$validate_dir/kernel" ]; then
            local kernel_size=$(stat -f%z "$validate_dir/kernel" 2>/dev/null || stat -c%s "$validate_dir/kernel" 2>/dev/null)
            log "INFO" "Kernel size: $kernel_size bytes"
            
            # Check if kernel is compressed
            local kernel_magic=$(xxd -l 4 -p "$validate_dir/kernel")
            if [[ "$kernel_magic" == "1f8b08" ]]; then
                log "INFO" "Kernel is gzip compressed"
            elif [[ "$kernel_magic" == "8b000000" ]]; then
                log "INFO" "Kernel is LZ4 compressed"
            fi
        else
            error_exit "Kernel not found in recovery image"
        fi
        
        # Check ramdisk
        if [ -f "$validate_dir/ramdisk" ]; then
            local ramdisk_size=$(stat -f%z "$validate_dir/ramdisk" 2>/dev/null || stat -c%s "$validate_dir/ramdisk" 2>/dev/null)
            log "INFO" "Ramdisk size: $ramdisk_size bytes"
            
            # Check ramdisk compression
            local ramdisk_magic=$(xxd -l 4 -p "$validate_dir/ramdisk")
            if [[ "$ramdisk_magic" == "1f8b08" ]]; then
                log "INFO" "Ramdisk is gzip compressed"
            elif [[ "$ramdisk_magic" == "8b000000" ]]; then
                log "INFO" "Ramdisk is LZ4 compressed"
            fi
        else
            error_exit "Ramdisk not found in recovery image"
        fi
        
        # Check fstab in ramdisk
        local fstab_files=$(find "$validate_dir" -name "fstab*" -type f 2>/dev/null)
        if [ -n "$fstab_files" ]; then
            log "INFO" "fstab files found:"
            for fstab in $fstab_files; do
                log "INFO" "  - $fstab"
            done
        else
            log "WARNING" "No fstab files found in ramdisk"
        fi
        
        # Check default.prop
        if [ -f "$validate_dir/default.prop" ]; then
            log "INFO" "default.prop found"
            
            # Check for important properties
            if grep -q "ro.build.version.sdk" "$validate_dir/default.prop" 2>/dev/null; then
                local sdk_version=$(grep "ro.build.version.sdk" "$validate_dir/default.prop" | cut -d= -f2)
                log "INFO" "Android SDK version: $sdk_version"
            fi
        else
            log "WARNING" "default.prop not found"
        fi
        
        # Clean up
        rm -rf "$validate_dir"
    else
        log "WARNING" "unpack_bootimg not found, skipping detailed validation"
    fi
    
    log "INFO" "Recovery image validation completed"
}

# Compare with stock recovery
compare_with_stock() {
    local twrp_img="$1"
    local stock_img="$2"
    
    log "INFO" "Comparing TWRP with stock recovery..."
    
    check_file "$twrp_img"
    check_file "$stock_img"
    
    # Compare file sizes
    local twrp_size=$(stat -f%z "$twrp_img" 2>/dev/null || stat -c%s "$twrp_img" 2>/dev/null)
    local stock_size=$(stat -f%z "$stock_img" 2>/dev/null || stat -c%s "$stock_img" 2>/dev/null)
    
    log "INFO" "TWRP size: $twrp_size bytes"
    log "INFO" "Stock size: $stock_size bytes"
    
    if [ "$twrp_size" -gt "$stock_size" ]; then
        log "WARNING" "TWRP image is larger than stock"
    fi
    
    # Compare magic bytes
    local twrp_magic=$(xxd -l 4 -p "$twrp_img")
    local stock_magic=$(xxd -l 4 -p "$stock_img")
    
    if [ "$twrp_magic" == "$stock_magic" ]; then
        log "INFO" "Boot image headers match"
    else
        log "WARNING" "Boot image headers differ"
    fi
    
    log "INFO" "Comparison completed"
}

# Main function
main() {
    log "INFO" "=========================================="
    log "INFO" "OPPO F3 (CPH1609) Recovery Validation Tool"
    log "INFO" "MediaTek MT6750 - Android 6.0.1"
    log "INFO" "=========================================="
    
    # Check arguments
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <recovery.img> [stock_recovery.img]"
        echo "  recovery.img: TWRP recovery image to validate"
        echo "  stock_recovery.img: Optional stock recovery for comparison"
        exit 1
    fi
    
    local recovery_img="$1"
    local stock_img="$2"
    
    # Validate TWRP recovery
    validate_recovery "$recovery_img"
    
    # Compare with stock if provided
    if [ -n "$stock_img" ]; then
        compare_with_stock "$recovery_img" "$stock_img"
    fi
    
    log "INFO" "=========================================="
    log "INFO" "Validation Summary:"
    log "INFO" "=========================================="
    log "INFO" "Recovery image validated: $recovery_img"
    log "INFO" "=========================================="
}

# Run main function
main "$@"
