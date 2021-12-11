%{
/* C++ string header, for string ops below */
#include <string>

/* Implementation of yyFlexScanner */
#include "stackful/lexer.hpp"
#undef  YY_DECL
#define YY_DECL \
void bison::stackful::lexer::lex_impl(boost::asio::yield_context yield_)

#define YY_INPUT(buf,result,max_size) \
{  \
    boost::system::error_code ec; \
    auto this_ = static_cast<bison::stackful::lexer*>(this); \
    assert(this_->yield_ctx) ; \
    result = this_->source.async_read_some(boost::asio::buffer(buf, max_size), \
                boost::asio::redirect_error(*this_->yield_ctx, ec)); \
}

/* using "token" to make the returns for the tokens shorter to type */
using token = bison::stackful::token;

/* define yyterminate as this instead of NULL */
#define yyterminate() \
channel.async_send(boost::asio::error::eof, {}, yield_); \
return ;

#define YY_USER_INIT this->yield_ctx = &yield_

%}


%option debug
%option nodefault
%option noyywrap
%option c++

%%
%{
%}

[a-z]       {
                channel.async_send(boost::system::error_code{}, token{yytext, token::lower }, yield_);
            }

[A-Z]       {
                channel.async_send(boost::system::error_code{}, token{yytext, token::upper }, yield_);
            }

[a-zA-Z]+   {
               /**
                * Section 10.1.5.1 of the 3.0.2 Bison Manual says the
                * following should work:
                * yylval.build( yytext );
                * but it doesn't.
                * ref: http://goo.gl/KLn0w2
                */
              channel.async_send(boost::system::error_code{}, token{yytext, token::word }, yield_);
            }

\n          {
               /** Update line number **/
               channel.async_send(boost::system::error_code{}, token{yytext, token::newline }, yield_);
            }

.           {
               channel.async_send(boost::system::error_code{}, token{yytext, token::char_ }, yield_);
            }
%%
