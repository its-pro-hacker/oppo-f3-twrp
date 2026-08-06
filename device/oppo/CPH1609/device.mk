# Device Makefile for OPPO F3 (CPH1609)
# MediaTek MT6750 Platform - TWRP Recovery Build

LOCAL_PATH := device/oppo/CPH1609

# Inherit from common device configuration
$(call inherit-product, $(LOCAL_PATH)/AndroidProducts.mk)

# Device overlays
DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay

# Required packages for TWRP
PRODUCT_PACKAGES += \
    charger_res_images \
    charger \
    libz \
    e2fsck \
    mke2fs \
    tune2fs \
    resize2fs \
    mkntfs \
    ntfs-3g \
    ntfsfix \
    libntfs-3g \
    libntfs-3g_fsck \
    libntfs-3g_mkfs \
    libntfs-3g_ioctl \
    libntfs-3g_mount \
    libntfs-3g_umount \
    ntfs-3g.probe \
    ntfsresize \
    ntfslabel \
    ntfsinfo \
    ntfscluster \
    ntfscat \
    ntfsls \
    ntfssecaudit \
    ntfstruncate \
    ntfswipe \
    ntfsfix \
    libfuse \
    libntfs-3g-gpu \
    libntfs-3g-gpu-dev \
    libntfs-3g-gpu-static

# Recovery specific configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery.fstab:recovery.fstab \
    $(LOCAL_PATH)/recovery/res/images/charger/battery_charge.png:recovery/res/images/charger/battery_charge.png \
    $(LOCAL_PATH)/recovery/res/images/charger/battery_error.png:recovery/res/images/charger/battery_error.png \
    $(LOCAL_PATH)/recovery/res/images/charger/battery_low.png:recovery/res/images/charger/battery_low.png \
    $(LOCAL_PATH)/recovery/res/images/charger/battery_unchargeable.png:recovery/res/images/charger/battery_unchargeable.png

# TWRP Specific Configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/twrp.prop:recovery/root/etc/twrp.prop \
    $(LOCAL_PATH)/twrp.fstab:recovery/root/etc/twrp.fstab

# Init files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/init.recovery.mt6750.rc:root/init.recovery.mt6750.rc \
    $(LOCAL_PATH)/rootdir/init.recovery.mt6750.usb.rc:root/init.recovery.mt6750.usb.rc \
    $(LOCAL_PATH)/rootdir/ueventd.mt6750.rc:root/ueventd.mt6750.rc

# SELinux
BOARD_SEPOLICY_DIRS += $(LOCAL_PATH)/sepolicy

# Boot animation
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := false

# Disable USB storage (handled by TWRP)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/init.mt6750.rc:root/init.mt6750.rc

# Kernel
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/kernel:kernel

# DTB (Device Tree Blob)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/dtb.img:dtb.img

# Scatter file for MTK Flash Tool
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/scatter/MT6750_Android_scatter.txt:scatter/MT6750_Android_scatter.txt

# Prebuilt vendor blobs (if available)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/vendor/etc/vold.conf:system/etc/vold.conf \
    $(LOCAL_PATH)/vendor/etc/init/mediatek perms:system/etc/init/mediatek \
    $(LOCAL_PATH)/vendor/etc/init.mt6750.rc:system/etc/init.mt6750.rc

# Build properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.version.sdk=23 \
    ro.build.version.release=6.0.1 \
    ro.build.version.security_patch=2017-08-05 \
    ro.build.display.id=CPH1609EX_11_A.24_180805 \
    ro.build.description=CPH1609-user 6.0.1 MMB29M 1526073414 release-keys \
    ro.build.version.incremental=1526073414 \
    ro.build.version.codename=REL \
    ro.product.board=mt6750 \
    ro.product.brand=OPPO \
    ro.product.device=CPH1609 \
    ro.product.first_api_level=23 \
    ro.product.locale=en-US \
    ro.product.manufacturer=OPPO \
    ro.product.model=CPH1609 \
    ro.product.name=CPH1609 \
    ro.build.characteristics=default \
    ro.build.display.id=CPH1609EX_11_A.24_180805 \
    ro.build.display.version=CPH1609EX_11_A.24_180805 \
    ro.build.flavor=CPH1609-user \
    ro.build.type=user \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dialer_type=google \
    ro.com.android.dialer_suggestions=true \
    ro.com.android.incallui=true \
    ro.com.android.proccesor=arm \
    ro.com.android.sdk.version=23 \
    ro.com.google.gmsversion=9_8_19 \
    ro.com.google.clientidbase=android-oppo \
    ro.com.google.clientidbase.ms=android-oplus \
    ro.com.google.clientidbase.am=android-oplus \
    ro.com.google.clientidbase.gms=android-oplus \
    ro.com.google.cta=1 \
    ro.com.google.duolingo.preinstall=true \
    ro.com.google.locationfeatures=true \
    ro.com.google.rlzbranding_value=OPN6 \
    ro.com.google.rlz.ap_whitelist=0 \
    ro.com.google.rlz.ap_gwhitelist=0 \
    ro.com.google.rlz.ap_kwhitelist=0 \
    ro.com.google.rlz.ap_twhitelist=0 \
    ro.com.google.rlz.ap_xwhitelist=0 \
    ro.com.google.rlz.ap_ywhitelist=0 \
    ro.com.google.rlz.ap_zwhitelist=0 \
    ro.com.google.rlz.ap_vwhitelist=0 \
    ro.com.google.rlz.ap_uwhitelist=0 \
    ro.com.google.rlz.ap_swhitelist=0 \
    ro.com.google.rlz.ap_rwhitelist=0 \
    ro.com.google.rlz.ap_qwhitelist=0 \
    ro.com.google.rlz.ap_pwhitelist=0 \
    ro.com.google.rlz.ap_owhitelist=0 \
    ro.com.google.rlz.ap_nwhitelist=0 \
    ro.com.google.rlz.ap_mwhitelist=0 \
    ro.com.google.rlz.ap_lwhitelist=0 \
    ro.com.google.rlz.ap_kwhitelist=0 \
    ro.com.google.rlz.ap_jwhitelist=0 \
    ro.com.google.rlz.ap_iwhitelist=0 \
    ro.com.google.rlz.ap_hwhitelist=0 \
    ro.com.google.rlz.ap_gwhitelist=0 \
    ro.com.google.rlz.ap_fwhitelist=0 \
    ro.com.google.rlz.ap_ewhitelist=0 \
    ro.com.google.rlz.ap_dwhitelist=0 \
    ro.com.google.rlz.ap_cwhitelist=0 \
    ro.com.google.rlz.ap_bwhitelist=0 \
    ro.com.google.rlz.ap_awhitelist=0

# TWRP Touchpanel Configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/init.recovery.mt6750.rc:root/init.recovery.mt6750.rc

# MTK Features
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/vendor/etc/media_codecs.xml:system/etc/media_codecs.xml \
    $(LOCAL_PATH)/vendor/etc/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_PATH)/vendor/etc/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/vendor/etc/audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/vendor/etc/audio_policy_configuration_bluetooth_legacy.xml:system/etc/audio_policy_configuration_bluetooth_legacy.xml \
    $(LOCAL_PATH)/vendor/etc/audio_policy_configuration_bluetooth.xml:system/etc/audio_policy_configuration_bluetooth.xml \
    $(LOCAL_PATH)/vendor/etc/audio_policy_configuration_usb.xml:system/etc/audio_policy_configuration_usb.xml \
    $(LOCAL_PATH)/vendor/etc/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    $(LOCAL_PATH)/vendor/etc/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    $(LOCAL_PATH)/vendor/etc/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    $(LOCAL_PATH)/vendor/etc/media_codecs_google_video_le.xml:system/etc/media_codecs_google_video_le.xml \
    $(LOCAL_PATH)/vendor/etc/media_codecs_google_video_vp9.xml:system/etc/media_codecs_google_video_vp9.xml

# Device specific configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/vendor/etc/vold.conf:system/etc/vold.conf

# TWRP Theme
TW_THEME := portrait_hdpi
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 128
TW_NO_SCREEN_TIMEOUT := true
TW_NO_BATT_PERCENT := false
TW_EXCLUDE_DEFAULT_CRYPTO := true
TW_INCLUDE_NTFS_3G := true
TW_USE_TOOLBOX := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_FBE := false
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_SCREEN_BLANK_ON_BOOT := true
TW_NO_USB_STORAGE := false
