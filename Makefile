TOP := $(shell cd "$( dirname "$(BASH_SOURCE)0]}" )" && pwd)
PREFIX := /usr/local
INIT_DIR := /etc/init.d
LIB_DIR := $(PREFIX)/lib
INCLUDE_DIR := $(PREFIX)/include

CFLAGS  := -I"$(INCLUDE_DIR)"
LDFLAGS := -L"$(LIB_DIR)"


UNAME := $(shell uname)
SO := so
ifeq ($(UNAME),Darwin)
	SO := dylib
endif


default: install

build: build_guacd-all
install: install_guacd-all
clean: clean_guacd-all


GUACD_DIR := $(TOP)/guacd
BUILD_GUACD := $(GUACD_DIR)/guacd
INSTALL_GUACD := $(PREFIX)/sbin/guacd

LIBGUAC_DIR := $(TOP)/libguac
BUILD_LIBGUAC := $(LIBGUAC_DIR)/src/libguac.la
INSTALL_LIBGUAC := $(LIB_DIR)/libguac.$(SO)

LIBGUAC_CLIENT_VNC_DIR := $(TOP)/libguac-client-vnc
BUILD_LIBGUAC_CLIENT_VNC := $(LIBGUAC_CLIENT_VNC_DIR)/libguac-client-vnc.la
INSTALL_LIBGUAC_CLIENT_VNC := $(LIB_DIR)/libguac-client-vnc.$(SO)

LIBGUAC_CLIENT_RDP_DIR := $(TOP)/libguac-client-rdp
BUILD_LIBGUAC_CLIENT_RDP := $(LIBGUAC_CLIENT_RDP_DIR)/libguac-client-rdp.la
INSTALL_LIBGUAC_CLIENT_RDP := $(LIB_DIR)/libguac-client-rdp.$(SO)

GUACAMOLE_DIR := $(TOP)/guacamole
# get the guacamole version
# run command mute the first time to make sure that the maven help plugin is installed
GUACAMOLE_VERSION := $(shell cd $(GUACAMOLE_DIR) && mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version -B -q && mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version -B | grep -e "^[0-9]" | head -n1)
BUILD_GUACAMOLE := $(GUACAMOLE_DIR)/target/guacamole-$(GUACAMOLE_VERSION).war
INSTALL_GUACAMOLE := $(TOP)/guacamole-$(GUACAMOLE_VERSION).war

build_guacd-all: $(BUILD_GUACD) $(BUILD_LIBGUAC_CLIENT_VNC) $(BUILD_LIBGUAC_CLIENT_RDP) $(BUILD_LIBGUACAMOLE)

$(BUILD_GUACD): $(INSTALL_LIBGUAC)
	cd $(GUACD_DIR) && \
		aclocal && \
		autoreconf -i && \
		CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) \
			$(GUACD_DIR)/configure --with-init-dir=$(INIT_DIR) --prefix=$(PREFIX) && \
		make

$(BUILD_LIBGUAC_CLIENT_VNC): $(INSTALL_LIBGUAC)
	cd $(LIBGUAC_CLIENT_VNC_DIR) && \
		aclocal && \
		autoreconf -i && \
		CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS) \
			$(LIBGUAC_CLIENT_VNC_DIR)/configure --prefix=$(PREFIX) && \
		make

$(BUILD_LIBGUAC_CLIENT_RDP): $(INSTALL_LIBGUAC)
	cd $(LIBGUAC_CLIENT_RDP_DIR) && \
		aclocal && \
		autoreconf -i && \
		CFLAGS='$(CFLAGS) -Wno-error' LDFLAGS=$(LDFLAGS) \
			$(LIBGUAC_CLIENT_RDP_DIR)/configure --prefix=$(PREFIX) && \
		make

$(BUILD_LIBGUAC):
	cd $(LIBGUAC_DIR) && \
		aclocal && \
		autoreconf -i && \
		CFLAGS='$(CFLAGS) -Wno-error' LDFLAGS=$(LDFLAGS) \
			$(LIBGUAC_DIR)/configure --prefix=$(PREFIX) && \
		make

$(BUILD_GUACAMOLE):
	cd $(GUACAMOLE_DIR) && \
		mvn package

clean_guacd-all: clean_guacd clean_libguac clean_libguac-client-vnc clean_libguac-client-rdp clean_guacamole

clean_guacd:
	-cd $(GUACD_DIR) && make clean

clean_libguac:
	-cd $(LIBGUAC_DIR) && make clean

clean_libguac-client-vnc:
	-cd $(LIBGUAC_CLIENT_VNC_DIR) && make clean

clean_libguac-client-rdp:
	-cd $(LIBGUAC_CLIENT_RDP_DIR) && make clean

clean_guacamole:
	-cd $(GUACAMOLE_DIR) && mvn clean


install_guacd-all: $(INSTALL_GUACD) $(INSTALL_LIBGUAC_CLIENT_VNC) $(INSTALL_LIBGUAC_CLIENT_RDP) $(INSTALL_GUACAMOLE)

$(INSTALL_GUACD): $(BUILD_GUACD) $(INSTALL_LIBGUAC)
	cd $(GUACD_DIR) && make install

$(INSTALL_LIBGUAC_CLIENT_VNC): $(BUILD_LIBGUAC_CLIENT_VNC) $(INSTALL_LIBGUAC)
	cd $(LIBGUAC_CLIENT_VNC_DIR) && make install

$(INSTALL_LIBGUAC_CLIENT_RDP): $(BUILD_LIBGUAC_CLIENT_RDP) $(INSTALL_LIBGUAC)
	cd $(LIBGUAC_CLIENT_RDP_DIR) && make install

$(INSTALL_LIBGUAC): $(BUILD_LIBGUAC)
	cd $(LIBGUAC_DIR) && make install

$(INSTALL_GUACAMOLE): $(BUILD_GUACAMOLE)
	cp $(BUILD_GUACAMOLE) $(TOP)


.PHONY: clean* uninstall
