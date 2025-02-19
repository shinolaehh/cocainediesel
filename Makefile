all: debug
.PHONY: debug asan tsan bench release clean

LUA = ggbuild/lua.linux
NINJA = ggbuild/ninja.linux

WSLENV ?= notwsl
ifndef WSLENV
	LUA = ggbuild/lua.exe
	NINJA = ggbuild/ninja.exe
endif

debug:
	@$(LUA) make.lua > build.ninja
	@$(NINJA) -k 0

asan:
	@$(LUA) make.lua asan > build.ninja
	@$(NINJA) -k 0

tsan:
	@$(LUA) make.lua tsan > build.ninja
	@$(NINJA) -k 0

bench:
	@$(LUA) make.lua bench > build.ninja
	@$(NINJA) -k 0

release:
	@$(LUA) make.lua release > build.ninja
	@$(NINJA) -k 0

clean:
	@$(LUA) make.lua debug > build.ninja
	@$(NINJA) -t clean || true
	@$(LUA) make.lua asan > build.ninja || true
	@$(NINJA) -t clean || true
	@$(LUA) make.lua tsan > build.ninja || true
	@$(NINJA) -t clean || true
	@$(LUA) make.lua bench > build.ninja || true
	@$(NINJA) -t clean || true
	@rm -f source/qcommon/gitversion.h
	@rm -rf build release
	@rm -f -- *.exp *.ilk *.ilp *.lib *.pdb
	@rm -f build.ninja
