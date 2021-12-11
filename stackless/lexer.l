%{
/* C++ string header, for string ops below */
#include <string>

/* Implementation of yyFlexScanner */
#include "stackless/lexer.hpp"
#undef  YY_DECL
#define YY_DECL \
template<typename Source> \
boost::asio::experimental::coro<token> lexify(Source source)

#define YY_INPUT(buf,result,max_size) \
{  \
    boost::system::error_code ec; \
    result = co_await source_.async_read_some(boost::asio::buffer(buf, max_size), \
                boost::asio::redirect_error(boost::asio::experimental::use_coro, ec)); \
}

/* #define YY_NO_INPUT */
/* using "token" to make the returns for the tokens shorter to type */
using token = bison_ex::token;

/* define yyterminate as this instead of NULL */
#define yyterminate() co_return ;


%}

%option debug
%option nodefault
%option noyywrap
%option c++

%%
%{
            std::string buffer;
            buffer.resize(4096);
            std::size_t remaining_read_size{0u};
%}

[a-z]       {
               co_yield token{yytext, token::lower };
            }

[A-Z]       {
               co_yield token{yytext, token::upper };
             }

[a-zA-Z]+   {
               /**
                * Section 10.1.5.1 of the 3.0.2 Bison Manual says the
                * following should work:
                * yylval.build( yytext );
                * but it doesn't.
                * ref: http://goo.gl/KLn0w2
                */
               co_yield token{yytext, token::word };
            }

\n          {
               /** Update line number **/
               co_yield token{yytext, token::newline };
            }

.           {
               co_yield token{yytext, token::char_ };
            }
%%