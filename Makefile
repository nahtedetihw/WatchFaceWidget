INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:clang:13.0:11.0
ARCHS = arm64 arm64e
include $(THEOS)/makefiles/common.mk

DEBUG = 0
FINALPACKAGE = 1
GO_EASY_ON_ME = 1

BUNDLE_NAME = WatchFaceWidget
WatchFaceWidget_FILES = WatchFaceWidgetViewController.xm WatchFaceWidgetPreferencesViewController.mm
WatchFaceWidget_FRAMEWORKS = UIKit
WatchFaceWidget_EXTRA_FRAMEWORKS = HSWidgets Preferences
WatchFaceWidget_PRIVATE_FRAMEWORKS = MediaRemote
WatchFaceWidget_LIBRARIES += sparkcolourpicker
WatchFaceWidget_INSTALL_PATH = /Library/HSWidgets
WatchFaceWidget_CFLAGS = -fobjc-arc

before-stage::
	find . -name ".DS\_Store" -delete

include $(THEOS_MAKE_PATH)/bundle.mk
