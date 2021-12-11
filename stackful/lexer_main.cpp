// Copyright (c) 2021 Klemens D. Morgenstern
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include "lexer.hpp"

int main()
{
    boost::asio::io_context ctx;

    bison::stackful::lexer lx{ctx, STDIN_FILENO};

    boost::asio::spawn(ctx, [&](auto ctx) { lx.lex_impl(std::move(ctx)); });
    boost::asio::spawn(ctx,
                       [&](boost::asio::yield_context yctx)
            {
                while (true)
                {
                    std::cerr << "Receiving" << std::endl;
                    auto tk = lx.channel.async_receive(yctx);
                    std::cout << "Received token: " << tk.tp << " : '" << tk.text << "'" << std::endl;
                }
            });
    try {
        ctx.run();
    }
    catch (std::exception & ex)
    {
        std::cerr << "Exception " << ex.what() << std::endl;
    }


}

// I got no idea why I need to define this.

int yyFlexLexer::yylex()
{
    throw std::logic_error("Not supposed to be called");
}

extern "C" int yylex()
{
    throw std::logic_error("Not supposed to be called");
}