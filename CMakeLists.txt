include(GenerateExportHeader)
cmake_minimum_required (VERSION 2.6)
project (hoedown)
include_directories(hoedown/src)

set(SOURCES
    hoedown/src/autolink.c
    hoedown/src/buffer.c
    hoedown/src/document.c
    hoedown/src/escape.c
    hoedown/src/html.c
    hoedown/src/html_blocks.c
    hoedown/src/html_smartypants.c
    hoedown/src/stack.c
    hoedown/src/version.c
)
if (MSVC)
    list(APPEND SOURCES hoedown/hoedown.def)
endif()
add_library(hoedown SHARED ${SOURCES})
target_link_libraries(hoedown)
