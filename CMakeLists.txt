cmake_minimum_required(VERSION 4.0)

project(cxxinit LANGUAGES CXX)

add_executable(cxxinit)

target_sources(cxxinit PRIVATE
	"source/main.cpp"
)
