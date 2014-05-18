# This file is part of MXE.
# See index.html for further information.

PKG             := leptonica
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.70
$(PKG)_CHECKSUM := 476edd5cc3f627f5ad988fcca6b62721188fce13
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.leptonica.com/source/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.leptonica.com/download.html' | \
    $(SED) 's/.*:\W//'|$(SED) 's/\s.*//'|$(SED) 's/\s*//'

endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

endef
