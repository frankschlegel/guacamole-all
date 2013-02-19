TOP    := $(shell cd "$( dirname "$(BASH_SOURCE)0]}" )" && pwd)
PREFIX := $(TOP)/install

UNAME := $(shell uname)
SO := so
ifeq ($(UNAME),Darwin)
	SO := dylib
endif


build: build_guacd-all
install: install_guacd-all
clean: clean_guacd-all
uninstall:
	rm -rf $(PREFIX)


LIBGUAC_DIR := $(TOP)/libguac
BUILD_LIBGUAC := $(LIBGUAC_DIR)/src/libguac.la

build_guacd-all: build_guacd build_libguac-client-vnc build_libguac-client-rdp

build_guacd: $(BUILD_LIBGUAC)

build_libguac-client-vnc: $(BUILD_LIBGUAC)

build_libguac-client-rdp: $(BUILD_LIBGUAC)

$(BUILD_LIBGUAC):
	cd $(LIBGUAC_DIR); \
		aclocal; \
		autoreconf -i; \
		CFLAGS=-Wno-error $(LIBGUAC_DIR)/configure --prefix=$(PREFIX); \
		make


clean_guacd-all: clean_guacd clean_libguac clean_libguac-client-vnc clean_libguac-client-rdp

clean_guacd:

clean_libguac:
	-cd $(LIBGUAC_DIR); \
		make distclean

clean_libguac-client-vnc:

clean_libguac-client-rdp:


INSTALL_LIBGUAC := $(PREFIX)/lib/libguac.$(SO)

install_guacd-all: install_guacd install_libguac-client-vnc install_libguac-client-rdp

install_guacd: $(INSTALL_LIBGUAC)

install_libguac-client-vnc: $(INSTALL_LIBGUAC)

install_libguac-client-rdp: $(INSTALL_LIBGUAC)

$(INSTALL_LIBGUAC): $(BUILD_LIBGUAC)
	cd $(LIBGUAC_DIR); \
		make install


.PHONY: clean* uninstall
