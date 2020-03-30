LOCAL_PATH := device/sprd/pike2/common
include $(LOCAL_PATH)/features/base/TelephonyFeatures.mk

FEATURES.PRODUCT_PACKAGES += \
    ShakePhoneToStartRecording \
    SpeakerToHeadset \
    FlipToMute \
    FadeDownRingtoneToVibrate \
    PickUpToAnswerIncomingCall \
    MaxRingingVolumeAndVibrate

# Additional settings used in all AOSP builds
ADDITIONAL_BUILD_PROPERTIES += \
    ro.config.ringtone=Ring_Synth_04.ogg \
    ro.config.ringtone1=Ring_Synth_02.ogg \
    ro.config.default_message=Argon.ogg \
    ro.config.default_message0=Argon.ogg \
    ro.config.default_message1=Highwire.ogg \
    ro.config.notification_sound=pixiedust.ogg \
    ro.config.alarm_alert=Alarm_Classic.ogg

##powercontroller-ultrasaving start##
TARGET_PWCTL_ULTRASAVING ?= true
ifeq (true,$(strip $(TARGET_PWCTL_ULTRASAVING)))
# ultrasaving mode
ADDITIONAL_BUILD_PROPERTIES += \
    ro.sys.pwctl.ultrasaving=1
else
ADDITIONAL_BUILD_PROPERTIES += \
    ro.sys.pwctl.ultrasaving=0
endif

ifeq ($(strip $(TARGET_BUILD_VERSION)),gms)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.sprd.pwctl.ultra.message=1
endif
##powercontroller-ultrasaving end##

# Location configs
$(warning "SUPPORT_LOCATION = $(SUPPORT_LOCATION), SUPPORT_LOCATION_GNSS = $(SUPPORT_LOCATION_GNSS)")

ifeq ($(strip $(SUPPORT_GNSS_HARDWARE)),true)
    SUPPORT_LOCATION_GNSS := enabled
    else
    SUPPORT_LOCATION_GNSS := disabled
endif

# No WCN
ifeq ($(strip $(PRODUCT_SUPPORT_WCN)),false)
    SUPPORT_LOCATION_GNSS := disabled
endif

ifneq ($(strip $(SUPPORT_LOCATION)), disabled)
ifneq ($(strip $(SUPPORT_LOCATION_GNSS)), disabled)
    FEATURES.PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:vendor/etc/permissions/android.hardware.location.gps.xml
    else
    FEATURES.PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.xml:vendor/etc/permissions/android.hardware.location.xml
endif
endif

ifeq ($(strip $(SUPPORT_LOCATION)), disabled)
    FEATURES.PRODUCT_PACKAGE_OVERLAYS += vendor/sprd/feature_configs/location/overlay
endif

#ifaa
ifeq ($(strip $(BOARD_IFAA_TRUSTY)), true)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.ifaa.support=true
endif
#soter
ifeq ($(strip $(BOARD_SOTER_TRUSTY)), true)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.soter.support=true
endif

$(warning "BOARD_HAVE_SPRD_WCN_COMBO = $(BOARD_HAVE_SPRD_WCN_COMBO)")
include $(wildcard vendor/sprd/modules/wlan/wlanconfig/device-sprd-wlan-property.mk)
