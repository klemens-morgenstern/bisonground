
// Copyright (c) 2021 Klemens D. Morgenstern
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef BISONGROUND_LEXER_HPP
#define BISONGROUND_LEXER_HPP

#include <boost/asio/experimental/channel.hpp>
#include <boost/asio/spawn.hpp>
#include <boost/asio/readable_pipe.hpp>
#include <boost/asio/redirect_error.hpp>

#if ! defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif

namespace bison::stackful
{

struct token
{
    std::string text;
    enum type
    {
        lower,
        upper,
        word,
        newline,
        char_
    };
    type tp;
};

struct lexer : yyFlexLexer
{

    using executor_type = boost::asio::any_io_executor;
    boost::asio::readable_pipe source;
    boost::asio::experimental::channel<void(boost::system::error_code, token)> channel{source.get_executor()};

    template<typename ... Args>
    lexer(Args && ... args) : source(std::forward<Args>(args)...) {}


    executor_type get_executor() {return source.get_executor();}

    boost::asio::yield_context *yield_ctx = nullptr;

    void lex_impl(boost::asio::yield_context yield_);

};


}

#endif //BISONGROUND_LEXER_HPP
