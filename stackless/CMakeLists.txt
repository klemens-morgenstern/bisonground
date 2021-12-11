
FLEX_TARGET(StacklessScanner lexer.l  ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

add_executable(stackless_lexer lexer.hpp lexer_main.cpp ${FLEX_StacklessScanner_OUTPUTS})
target_link_libraries(stackless_lexer Boost::system Boost::context Boost::coroutine ${FLEX_LIBRARIES})
