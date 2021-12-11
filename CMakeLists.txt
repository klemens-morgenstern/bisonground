cmake_minimum_required(VERSION 3.21)
project(bisonground)

set(CMAKE_CXX_STANDARD 20)

find_package(Boost COMPONENTS system context unit_test_framework prg_exec_monitor coroutine)
find_package(BISON)
find_package(FLEX)
include_directories(.)

add_subdirectory(stackful)
add_subdirectory(stackless)
