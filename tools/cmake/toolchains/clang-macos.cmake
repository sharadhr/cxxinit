set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_OSX_ARCHITECTURES}) # may need to rethink when moving to universal builds

set(COMPILER_ARGS
  "-g"
  "-ferror-limit=0"
)

set(CMAKE_C_COMPILER
  "clang"
  ${COMPILER_ARGS}
  CACHE STRING "" FORCE
)
set(CMAKE_CXX_COMPILER
  "clang++"
  ${COMPILER_ARGS}
  CACHE STRING "" FORCE
)
set(CMAKE_ASM_COMPILER
  "clang"
  ${COMPILER_ARGS}
  CACHE STRING "" FORCE
)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Some useful flags
if(NOT DEFINED _VCPKG_ROOT_DIR)
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
		"-Wframe-larger-than=${DEBUG_MIN_FRAME_SIZE}"
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
		"-Wundef"
		"-Wuninitialized"
		"-Wunused"
		"-Wvla"
		"-Wvolatile"
		"-Wwrite-strings"
  )
endif()
string(JOIN " " ASAN_FLAGS
  "-fsanitize=address,undefined"
  "-fno-omit-frame-pointer"
)
set(TSAN_FLAGS "-fsanitize=thread,undefined")

# different possible flag types
set(FLAG_TYPES "C" "CXX" "EXE_LINKER" "SHARED_LINKER" "MODULE_LINKER")

# Add a new build type: LTO, equal to Release but with LTO
if($ENV{BUILD_WITH_LTO})
  foreach(FLAG_TYPE "C" "CXX")
    set(CMAKE_${FLAG_TYPE}_FLAGS_LTO "-O3" CACHE STRING "Flags used by the ${FLAG_TYPE} compiler during LTO builds." FORCE)
  endforeach()

  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
  set(CMAKE_MAP_IMPORTED_CONFIG_LTO "Release" "RelWithDebInfo" "MinSizeRel")
endif()

# Add `ASan` and `TSan` build types
foreach(SAN_TYPE "ASAN" "TSAN")
  foreach(FLAG_TYPE "C" "CXX")
    set(CMAKE_${FLAG_TYPE}_FLAGS_${SAN_TYPE} "${${SAN_TYPE}_FLAGS} ${WARNING_FLAGS}" CACHE STRING "Flags used by the ${FLAG_TYPE} compiler during ${SAN_TYPE} builds." FORCE)
  endforeach()
endforeach()

# Set the default flags
set(CMAKE_C_FLAGS_INIT ${WARNING_FLAGS})
set(CMAKE_CXX_FLAGS_INIT ${WARNING_FLAGS})
set(CMAKE_EXE_LINKER_FLAGS_INIT ${LINKER_FLAGS})
set(CMAKE_SHARED_LINKER_FLAGS_INIT ${LINKER_FLAGS})
