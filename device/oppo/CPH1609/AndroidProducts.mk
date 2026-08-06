# Android Products Makefile for OPPO F3 (CPH1609)
# This file defines the product configuration for TWRP builds

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Device is phone
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_phone_no_telephony.mk)

# Device configuration
PRODUCT_NAME := omni_CPH1609
PRODUCT_DEVICE := CPH1609
PRODUCT_BRAND := OPPO
PRODUCT_MODEL := CPH1609
PRODUCT_MANUFACTURER := OPPO
PRODUCT_MANUFACTURER_COUNTRY := India

# Device-specific overlay
DEVICE_PACKAGE_OVERLAYS := device/oppo/CPH1609/overlay

# Include common device configuration
$(call inherit-product, device/oppo/CPH1609/device.mk)

# Inherit from board configuration
$(call inherit-product, $(LOCAL_PATH)/BoardConfig.mk)
