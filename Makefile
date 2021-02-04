export ARCHS = arm64 arm64e
export TARGET = iphone:clang::13.1.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Protein

Protein_FILES = $(wildcard *.x *.xm *.m *.mm *.h)
Protein_CFLAGS = -fobjc-arc -Wno-unused-variable

Protein_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += proteinprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "sbreload"
