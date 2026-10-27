cmake_minimum_required(VERSION 3.16)
project(TransformersPC C)

set(CMAKE_C_STANDARD 99)

add_executable(TransformersPC
    src/main.c
)

# Put the executable in bin\ for every build configuration.
set_target_properties(TransformersPC PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY         ${CMAKE_SOURCE_DIR}/bin
    RUNTIME_OUTPUT_DIRECTORY_DEBUG   ${CMAKE_SOURCE_DIR}/bin
    RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin
)
