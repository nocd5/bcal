%{
#include <stdio.h>
#include <string.h>
#include <windows.h>
#include "y.tab.h"

extern void colorPrintf(WORD attr, const char *fmt, ...);
int
yywrap(void)
{
    return 1;
}
%}
%%
"@" return PREV;
"(" return LRB;
")" return RRB;
"[" return LAB;
"]" return RAB;
"," return COMMA;
"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"~" return INV;
".inv" return INV;
"&" return AND;
"|" return OR;
"^"  return XOR;
"<<" return LS;
">>" return RS;
".hex" return HEX;
".bin" return BIN;
"\n" return CR;
" " {
}
0x[A-Fa-f0-9]* {
    int temp;
    sscanf(yytext, "%x", &temp);
    yylval.int_value = temp;
    return INT_LITERAL;
}
0b[0-1]* {
    int result = 0;
    char temp[33];
    sscanf(yytext, "0b%s", temp);
    int bits = strlen(temp);
    int w = 1;
    while (bits--) {
      result += temp[bits] == '1' ? w : 0;
      w <<= 1;
    }
    yylval.int_value = result;
    return INT_LITERAL;
}
[0-9]* {
    int temp;
    sscanf(yytext, "%ld", &temp);
    yylval.int_value = temp;
    return INT_LITERAL;
}
"exit" {
  exit(0);
}

%%
