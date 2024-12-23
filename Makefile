TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CanvasSync

CanvasSync_FILES = $(shell find Sources/CanvasSync -name '*.swift') $(shell find Sources/CanvasSyncC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
CanvasSync_SWIFTFLAGS = -ISources/CanvasSyncC/include
CanvasSync_CFLAGS = -fobjc-arc -ISources/CanvasSyncC/include
CanvasSync_EXTRA_FRAMEWORKS = SpringBoard MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += CanvasSyncSpotify
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
