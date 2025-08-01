set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR AMD64)
if (CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
	set(CMAKE_CROSSCOMPILING OFF CACHE BOOL "")
	set(EXECUTABLE_SUFFIX ".exe")
endif ()

set(CMAKE_C_COMPILER_TARGET "x86_64-pc-windows-msvc")
set(CMAKE_CXX_COMPILER_TARGET "x86_64-pc-windows-msvc")

set(CMAKE_C_COMPILER "cl.exe")
set(CMAKE_CXX_COMPILER "cl.exe")
set(CMAKE_ASM_COMPILER "cl.exe")
set(CMAKE_RC_COMPILER "rc.exe")

set(CMAKE_LINKER_TYPE LLD)
set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "ProgramDatabase")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Some useful flags
if (NOT DEFINED _VCPKG_ROOT_DIR)
    string(JOIN " " WARNING_FLAGS
        "/sdl"
        "/guard:cf"
        "/utf-8"
        "/diagnostics:caret"
        "/w14165"
        "/w44242"
        "/w44254"
        "/w44263"
        "/w34265"
        "/w34287"
        "/w44296"
        "/w44365"
        "/w44388"
        "/w44464"
        "/w14545"
        "/w14546"
        "/w14547"
        "/w14549"
        "/w14555"
        "/w34619"
        "/w34640"
        "/w24826"
        "/w14905"
        "/w14906"
        "/w14928"
        "/w45038"
        "/W4"
        "/permissive-"
        "/volatile:iso"
        "/Zc:inline"
        "/Zc:preprocessor"
        "/Zc:enumTypes"
        "/Zc:lambda"
        "/Zc:__cplusplus"
        "/Zc:externConstexpr"
        "/Zc:throwingNew"
        "/Zf"
        "/EHsc"
    )
endif ()
string(JOIN " " LINKER_FLAGS
    "/DEBUG"
    "/guard:cf"
)

string(JOIN " " ASAN_FLAGS "/fsanitize=address")
string(JOIN " " RTC_FLAGS "/RTC1")

set(FLAG_TYPES "C" "CXX")

# Add a new build type: LTO, equal to Release but with LTO
if ($ENV{BUILD_WITH_LTO})
	foreach (FLAG_TYPE ${FLAG_TYPES})
		set(CMAKE_${FLAG_TYPE}_FLAGS_LTO "/O2" CACHE STRING "" FORCE)
	endforeach ()

	set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
	set(CMAKE_MAP_IMPORTED_CONFIG_LTO "Release" "RelWithDebInfo" "MinSizeRel")
endif ()


foreach(CONFIG "ASAN" "RTC")
    foreach(FLAG_TYPE ${FLAG_TYPES})
        set(CMAKE_${FLAG_TYPE}_FLAGS_${CONFIG} "${${CONFIG}_FLAGS} ${WARNING_FLAGS}" CACHE STRING "" FORCE)
    endforeach()
endforeach()



# Set the default flags
set(CMAKE_C_FLAGS_INIT ${WARNING_FLAGS})
set(CMAKE_CXX_FLAGS_INIT ${WARNING_FLAGS})
set(CMAKE_EXE_LINKER_FLAGS_INIT ${LINKER_FLAGS})
set(CMAKE_SHARED_LINKER_FLAGS_INIT ${LINKER_FLAGS})
