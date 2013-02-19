TOP    := $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
PREFIX := ${TOP}/install


build: build_guacd-all

build_guacd-all: build_guacd build_libguac-client-vnc build_libguac-client-rdp

build_guacd: build_libguac

build_libguac-client-vnc: build_libguac

build_libguac-client-rdp: build_libguac

build_libguac:
	cd ${TOP}/libguac; \
		aclocal; \
		autoreconf -i; \
		CFLAGS=-Wno-error ${TOP}/libguac/configure --prefix=${PREFIX}; \
		make
