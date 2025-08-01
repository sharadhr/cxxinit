set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR AMD64)
if (CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
	set(CMAKE_CROSSCOMPILING OFF CACHE BOOL "")
	set(EXECUTABLE_SUFFIX ".exe")
endif ()
set(CMAKE_SYSROOT "C:/Program Files/LLVM")

set(CMAKE_C_COMPILER_TARGET "x86_64-pc-windows-msvc")
set(CMAKE_CXX_COMPILER_TARGET "x86_64-pc-windows-msvc")

set(COMPILER_ARGS
	"-g"
	"-ferror-limit=0"
	"-fms-extensions"
	"-fms-hotpatch"
)

set(CMAKE_C_COMPILER
	"clang${EXECUTABLE_SUFFIX}"
	${COMPILER_ARGS}
)
set(CMAKE_CXX_COMPILER
	"clang++${EXECUTABLE_SUFFIX}"
	${COMPILER_ARGS}
)
set(CMAKE_ASM_COMPILER
	"clang++${EXECUTABLE_SUFFIX}"
	${COMPILER_ARGS}
)
set(CMAKE_RC_COMPILER
	"llvm-rc${EXECUTABLE_SUFFIX}"
)

set(CMAKE_LINKER_TYPE LLD)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Some useful flags
if (NOT DEFINED _VCPKG_ROOT_DIR)
	string(JOIN " " WARNING_FLAGS
		"-Wall"
		"-Walloca"
		"-Wcast-align"
		"-Wcast-qual"
		"-Wcomma-subscript"
		"-Wconversion"
		"-Wctor-dtor-privacy"
		"-Wdeprecated-copy-dtor"
		"-Wdouble-promotion"
		"-Wduplicated-branches"
		"-Wduplicated-cond"
		"-Wenum-conversion"
		"-Wextra"
		"-Wextra-semi"
		"-Wfloat-equal"
		"-Wformat-overflow=2"
		"-Wformat-signedness"
		"-Wformat=2"
		"-Wframe-larger-than=1048576"
		"-Wimplicit-fallthrough"
		"-Wjump-misses-init"
		"-Wlogical-op"
		"-Wmismatched-tags"
		"-Wmissing-braces"
		"-Wmultichar"
		"-Wno-unused-parameter"
		"-Wnoexcept"
		"-Wnon-virtual-dtor"
		"-Wnull-dereference"
		"-Wold-style-cast"
		"-Woverloaded-virtual"
		"-Wpedantic"
		"-Wpointer-arith"
		"-Wrange-loop-construct"
		"-Wrestrict"
		"-Wshadow"
		"-Wsign-conversion"
		"-Wstrict-null-sentinel"
		"-Wsuggest-attribute=format"
		"-Wsuggest-attribute=malloc"
		"-Wundeclared-selector"
		"-Wundef"
		"-Wuninitialized"
		"-Wunreachable-code"
		"-Wunused"
		"-Wvla"
		"-Wvolatile"
		"-Wwrite-strings"
	)
endif ()
string(JOIN " " LINKER_FLAGS
	"--start-no-unused-arguments"
	"--rtlib=compiler-rt"
	"--unwindlib=libunwind"
	"-static-libgcc"
	"--end-no-unused-arguments"
)
string(JOIN " " ASAN_FLAGS
	"-fsanitize=address,undefined"
	"-fno-omit-frame-pointer"
)
set(TSAN_FLAGS "-fsanitize=thread,undefined")

# different possible flag types
set(FLAG_TYPES "C" "CXX" "EXE_LINKER" "SHARED_LINKER" "MODULE_LINKER")

# Add a new build type: LTO, equal to Release but with LTO
if ($ENV{BUILD_WITH_LTO})
	foreach (FLAG_TYPE ${FLAG_TYPES})
		set(CMAKE_${FLAG_TYPE}_FLAGS_LTO "-O3" CACHE STRING "" FORCE)
	endforeach ()

	set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
	set(CMAKE_MAP_IMPORTED_CONFIG_LTO "Release" "RelWithDebInfo" "MinSizeRel")
endif ()

# Add `ASan` and `TSan` build types
foreach (CONFIG "ASAN" "TSAN")
	foreach (FLAG_TYPE ${FLAG_TYPES})
		set(CMAKE_${FLAG_TYPE}_FLAGS_${CONFIG} "${${CONFIG}_FLAGS}" CACHE STRING "" FORCE)
	endforeach ()
endforeach ()

# Set the default flags
set(CMAKE_C_FLAGS_INIT ${WARNING_FLAGS})
set(CMAKE_CXX_FLAGS_INIT ${WARNING_FLAGS})
set(CMAKE_EXE_LINKER_FLAGS_INIT ${LINKER_FLAGS})
set(CMAKE_SHARED_LINKER_FLAGS_INIT ${LINKER_FLAGS})
