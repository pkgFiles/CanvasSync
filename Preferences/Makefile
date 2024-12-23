TARGET := iphone:clang:latest:14.5

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CanvasSyncPrefs

CanvasSyncPrefs_FILES = $(shell find Sources/CanvasSyncPrefs -name '*.swift') $(shell find Sources/CanvasSyncPrefsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
CanvasSyncPrefs_SWIFTFLAGS = -ISources/CanvasSyncPrefsC/include
CanvasSyncPrefs_INSTALL_PATH = /Library/PreferenceBundles
CanvasSyncPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
