LUAJIT_OS=$(shell luajit -e "print(require('ffi').os)")
LUAJIT_ARCH=$(shell luajit -e "print(require('ffi').arch)")
TARGET_DIR=$(LUAJIT_OS)-$(LUAJIT_ARCH)/

ifeq ($(LUAJIT_OS), OSX)
HOEDOWN_LIB=libhoedown.dylib
else
HOEDOWN_LIB=libhoedown.so
endif

libs: build
	cmake --build build --config Release
	mkdir -p $(TARGET_DIR)
	cp build/$(HOEDOWN_LIB) $(TARGET_DIR)

hoedown/src:
	git submodule update --init hoedown

build: hoedown/src
	cmake -Bbuild -H. -GNinja

hoedown-sample/main.lua:
	git submodule update --init hoedown-sample

hoedown-sample/deps: hoedown-sample/main.lua
	cd hoedown-sample && lit install
	rm -rf hoedown-sample/deps/hoedown
	ln -s ../.. hoedown-sample/deps/hoedown

test: libs hoedown-sample/deps
	luvi hoedown-sample

clean:
	rm -rf build hoedown-sample/deps
