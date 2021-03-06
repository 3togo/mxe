# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencv
$(PKG)_WEBSITE  := https://opencv.org/
$(PKG)_DESCR    := OpenCV
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.5.2
$(PKG)_CHECKSUM := be976b9ef14f1deaa282fb6e30d75aa8016a2d5c1f08e85795c235148940d753
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := opencv-$($(PKG)_VERSION).zip
$(PKG)_CONTRIB_SUBDIR   := opencv-contrib-$($(PKG)_VERSION)
$(PKG)_CONTRIB_FILE := $($(PKG)_CONTRIB_SUBDIR).zip
$(PKG)_URL      := https://github.com/opencv/opencv/archive/refs/tags/$($(PKG)_VERSION).zip
#$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)library/$(PKG)-unix/$($(PKG)_VERSION)/$($(PKG)_FILE)
#$(PKG)_URL_2    := https://distfiles.macports.org/opencv/$($(PKG)_FILE)
#$(PKG)_DEPS     := cc eigen ffmpeg jasper jpeg libpng libwebp \
                   openblas openexr protobuf tiff xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

# -DCMAKE_CXX_STANDARD=98 required for non-posix gcc7 build

define $(PKG)_BUILD
	#[ -f $(BUILD_DIR)/$($(PKG)_CONTRIB_FILE) ] || \
	#wget https://github.com/opencv/opencv_contrib/archive/refs/tags/$($(PKG)_VERSION).zip -o $(BUILD_DIR)/$($(PKG)_CONTRIB_FILE)
	unzip pkg/$($(PKG)_CONTRIB_FILE) -d $(SOURCE_DIR)/..
    # build
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
      -DCMAKE_VERBOSE=ON \
      -DWITH_GSTREAMER=OFF \
      -DCMAKE_CXX_STANDARD=11 \
      -DOPENCV_GENERATE_PKGCONFIG=YES \
      -DOPENCV_EXTRA_MODULES_PATH=../$($(PKG)_CONTRIB_SUBDIR)
      #-DCMAKE_CXX_FLAGS='-D_WIN32_WINNT=0x0500'

    # install
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    # fixup and install pkg-config file
    # openexr isn't available on x86_64-w64-mingw32
    # opencv builds it's own libIlmImf.a
    $(if $(findstring x86_64-w64-mingw32,$(TARGET)),\
        $(SED) -i 's/OpenEXR//' '$(BUILD_DIR)/unix-install/opencv4.pc')

    $(SED) -i 's,share/OpenCV/3rdparty/,,g' '$(BUILD_DIR)/unix-install/opencv4.pc'

    $(INSTALL) -m755 '$(BUILD_DIR)/unix-install/opencv4.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi \
        '$(SOURCE_DIR)/samples/cpp/fback.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-opencv.exe' \
        `'$(TARGET)-pkg-config' opencv4 --cflags --libs`
endef
