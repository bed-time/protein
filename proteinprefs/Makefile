export ARCHS = arm64 arm64e
export TARGET = iphone:clang::13.1.3

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ProteinPrefs

ProteinPrefs_FILES = ptpRootListController.m
ProteinPrefs_FRAMEWORKS = UIKit
ProteinPrefs_LIBRARIES = colorpicker
ProteinPrefs_PRIVATE_FRAMEWORKS = Preferences
ProteinPrefs_INSTALL_PATH = /Library/PreferenceBundles
ProteinPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
