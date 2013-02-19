TOP := $(shell cd "$( dirname "$(BASH_SOURCE)0]}" )" && pwd)
INSTALL_DIR := $(TOP)/install
LIB_DIR := $(INSTALL_DIR)/lib
INCLUDE_DIR := $(INSTALL_DIR)/include

CFLAGS  := -I"$(INCLUDE_DIR)"
LDFLAGS := -L"$(LIB_DIR)"


UNAME := $(shell uname)
SO := so
ifeq ($(UNAME),Darwin)
	SO := dylib
endif


build: build_guacd-all
install: install_guacd-all
clean: clean_guacd-all
uninstall:
	rm -rf $(INSTALL_DIR)


GUACD_DIR := $(TOP)/guacd
BUILD_GUACD := $(GUACD_DIR)/guacd
INSTALL_GUACD := $(INSTALL_DIR)/sbin/guacd

LIBGUAC_DIR := $(TOP)/libguac
BUILD_LIBGUAC := $(LIBGUAC_DIR)/src/libguac.la
INSTALL_LIBGUAC := $(LIB_DIR)/libguac.$(SO)

LIBGUAC_CLIENT_VNC_DIR := $(TOP)/libguac-client-vnc
BUILD_LIBGUAC_CLIENT_VNC := $(LIBGUAC_CLIENT_VNC_DIR)/libguac-client-vnc.la
INSTALL_LIBGUAC_CLIENT_VNC := $(LIB_DIR)/libguac-client-vnc.$(SO)


build_guacd-all: $(BUILD_GUACD) $(BUILD_LIBGUAC_CLIENT_VNC) build_libguac-client-rdp

$(BUILD_GUACD): $(BUILD_LIBGUAC) $(INSTALL_LIBGUAC)
	cd $(GUACD_DIR) && \
		aclocal && \
		autoreconf -i && \
		CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) \
			$(GUACD_DIR)/configure --prefix=$(INSTALL_DIR) && \
		make

$(BUILD_LIBGUAC_CLIENT_VNC): $(BUILD_LIBGUAC) $(INSTALL_LIBGUAC)
	cd $(LIBGUAC_CLIENT_VNC_DIR) && \
		aclocal && \
		autoreconf -i && \
		CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) \
			$(LIBGUAC_CLIENT_VNC_DIR)/configure --prefix=$(INSTALL_DIR) && \
		make

build_libguac-client-rdp: $(BUILD_LIBGUAC)

$(BUILD_LIBGUAC):
	cd $(LIBGUAC_DIR) && \
		aclocal && \
		autoreconf -i && \
		CFLAGS='$(CFLAGS) -Wno-error' LDFLAGS=$(LDFLAGS) \
			$(LIBGUAC_DIR)/configure --prefix=$(INSTALL_DIR) && \
		make


clean_guacd-all: clean_guacd clean_libguac clean_libguac-client-vnc clean_libguac-client-rdp

clean_guacd:
	-cd $(GUACD_DIR) && make clean

clean_libguac:
	-cd $(LIBGUAC_DIR) && make clean

clean_libguac-client-vnc:
	-cd $(LIBGUAC_CLIENT_VNC_DIR) && make clean

clean_libguac-client-rdp:


install_guacd-all: $(INSTALL_GUACD) $(INSTALL_LIBGUAC_CLIENT_VNC) install_libguac-client-rdp

$(INSTALL_GUACD): $(BUILD_GUACD) $(INSTALL_LIBGUAC)
	cd $(GUACD_DIR) && make install

$(INSTALL_LIBGUAC_CLIENT_VNC): $(BUILD_LIBGUAC_CLIENT_VNC) $(INSTALL_LIBGUAC)
	cd $(LIBGUAC_CLIENT_VNC_DIR) && make install

install_libguac-client-rdp: $(INSTALL_LIBGUAC)

$(INSTALL_LIBGUAC): $(BUILD_LIBGUAC)
	cd $(LIBGUAC_DIR) && make install


.PHONY: clean* uninstall
