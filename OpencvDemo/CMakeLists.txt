cmake_minimum_required(VERSION 2.8)
project(opencvtest)
find_package(OpenCV REQUIRED)
message(${OpenCV_INCLUDE_DIRS})
message(${OpenCV_LIBRARIES})
include_directories(${OpenCV_INCLUDE_DIRS})

add_executable(opencvtest test.cpp)
target_link_libraries(opencvtest ${OpenCV_LIBRARIES})