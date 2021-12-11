
FLEX_TARGET(StackfulScanner lexer.l  ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

add_executable(stackful_lexer lexer.hpp lexer_main.cpp ${FLEX_StackfulScanner_OUTPUTS})
target_link_libraries(stackful_lexer Boost::system Boost::context Boost::coroutine ${FLEX_LIBRARIES})
