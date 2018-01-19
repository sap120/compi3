cmake_minimum_required(VERSION 3.9)
project(compi3)

set(CMAKE_CXX_STANDARD 11)

add_executable(compi3 SymbolTables.cpp SymbolTables.h TableEntry.cpp TableEntry.h part3_helpers.hpp part3_helpers.cpp)