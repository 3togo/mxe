# This file is part of MXE.
# See index.html for further information.
# patched by FreeToGo@gmail.com

PKG             := tesseract
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.03
$(PKG)_CHECKSUM := 5bd12482a69f0a1fdf3c9e0d652de08db763ee93
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-rc1.tar.gz
$(PKG)_URL      := https://bitbucket.org/3togo/python-tesseract/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    $(SED) -i 's/vs2008/vs2010/g' $(1)/ccutil/Makefile.am
    $(SED) -i 's/Windows\.h/windows\.h/g' $(1)/opencl/openclwrapper.cpp
    $(SED) -i 's/unsigned long int>(dawg_/uintptr_t>(dawg_/g' $(1)/cube/tess_lang_mod_edge.h 
    cd '$(1)' && $(SED) -i 's/AC_CHECK_LIB(lept,pixCreate/#AC_CHECK_LIB(lept,pixCreate/g' configure.ac
 
    cd '$(1)' && ./autogen.sh
    
    cd '$(1)' &&./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

endef

