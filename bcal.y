%{
#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#define YYDEBUG 1
int prev = 0;
void colorPrintf(WORD attr, const char *fmt, ...){
    HANDLE hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_SCREEN_BUFFER_INFO ScreenInfo;
    GetConsoleScreenBufferInfo(hStdOut, &ScreenInfo);
    SetConsoleTextAttribute(hStdOut, attr);
    va_list list;
    va_start(list, fmt);
    vprintf(fmt, list);
    va_end(list);
    SetConsoleTextAttribute(hStdOut, ScreenInfo.wAttributes);
}

%}
%union {
    int          int_value;
    double       double_value;
}
%token <int_value>         INT_LITERAL
%token <double_value>      DOUBLE_LITERAL
%token PREV LRB RRB LAB RAB ADD SUB MUL DIV INV AND OR XOR LS RS HEX BIN COMMA CR
%type <int_value> expr term primary_expr

%%
line_list
    : line
    | line_list line
    ;
line
    : CR
    {
        colorPrintf(FOREGROUND_INTENSITY, "calc");
        printf("   >> ");
    }
    | expr CR
    {
        prev = $1;
        colorPrintf(FOREGROUND_GREEN | FOREGROUND_INTENSITY, "result");
        printf(" >> %ld\n", $1);
        colorPrintf(FOREGROUND_INTENSITY, "calc");
        printf("   >> ");
    }
expr
    : term
    | expr ADD term
    {
        $$ = $1 + $3;
    }
    | expr SUB term
    {
        $$ = $1 - $3;
    }
    | SUB term
    {
        $$ = $2 * -1;
    }
    ;

term
    : primary_expr
    | term MUL primary_expr 
    {
        $$ = $1 * $3;
    }
    | term DIV primary_expr
    {
        $$ = $1 / $3;
    }
    | term AND primary_expr
    {
        $$ = $1 & $3;
    }
    | AND primary_expr
    {
        int result = 1;
        int bitpos = 1;
        while (bitpos < $2) bitpos <<= 1;
        bitpos = 1 < bitpos>>1 ? bitpos>>1 : 1;
        while (bitpos) {
          result &= $2 & bitpos ? 1 : 0;
          bitpos >>= 1;
        }
        $$ = result;
    }
    | OR primary_expr
    {
        int result = 0;
        int bitpos = 1;
        while (bitpos < $2) bitpos <<= 1;
        bitpos = 1 < bitpos>>1 ? bitpos>>1 : 1;
        while (bitpos) {
          result |= $2 & bitpos ? 1 : 0;
          bitpos >>= 1;
        }
        $$ = result;
    }
    | term OR primary_expr
    {
        $$ = $1 | $3;
    }
    | XOR primary_expr
    {
        int result = 0;
        int bitpos = 1;
        while (bitpos < $2) bitpos <<= 1;
        bitpos = 1 < bitpos>>1 ? bitpos>>1 : 1;
        while (bitpos) {
          result ^= $2 & bitpos ? 1 : 0;
          bitpos >>= 1;
        }
        $$ = result;
    }
    | term XOR primary_expr
    {
        $$ = $1 ^ $3;
    }
    | INV primary_expr
    {
        int result = 0;
        int bitpos = 1;
        while (bitpos < $2) bitpos <<= 1;
        bitpos = 1 < bitpos>>1 ? bitpos>>1 : 1;
        while (bitpos) {
          result += $2 & bitpos ? 0 : bitpos;
          bitpos >>= 1;
        }
        $$ = result;
    }
    | term LS primary_expr
    {
        $$ = $1 << $3;
    }
    | term RS primary_expr
    {
        $$ = $1 >> $3;
    }
    | term AND INV primary_expr
    {
        $$ = $1 &~ $4;
    }
    | term OR INV primary_expr
    {
        $$ = $1 |~ $4;
    }
    | term XOR INV primary_expr
    {
        $$ = $1 ^~ $4;
    }
    ;
primary_expr
    : INT_LITERAL
    | PREV
    {
      $$ = prev;
    }
    | LRB expr RRB
    {
      $$ = $2;
    }
    | primary_expr HEX
    {
        colorPrintf(FOREGROUND_BLUE | FOREGROUND_INTENSITY, "hex");
        printf("    >> %d	->	0x%x\n", $1, $1);
    }
    | primary_expr HEX LRB expr RRB
    {
        int digitcount = 1;
        while (1 << (digitcount*4) < $1 + 1) digitcount++;
        digitcount = $4 < digitcount ? $4 : digitcount;

        colorPrintf(FOREGROUND_BLUE | FOREGROUND_INTENSITY, "hex");
        printf("    >> %d	->	0x", $1);
        while (digitcount < $4) {
          printf("%d", 0);
          digitcount++;
        }
        printf("%x\n", $1);
    }
    | primary_expr BIN
    {
        colorPrintf(FOREGROUND_BLUE | FOREGROUND_INTENSITY, "bin");
        printf("    >> %d	->	0b", $1);
        int bitpos = 1;
        while (bitpos < $1+1) bitpos <<= 1;
        bitpos = 1 < bitpos>>1 ? bitpos>>1 : 1;
        while (bitpos) {
          printf("%d", $1 & bitpos ? 1 : 0);
          bitpos >>= 1;
        }
        printf("\n");
    }
    | primary_expr BIN LRB expr RRB
    {
        int bitpos = 1;
        while (1 << bitpos < $1 + 1) bitpos++;
        bitpos = (1 << ($4 - 1)) < bitpos >> 1 ? bitpos >> 1 : (1 << ($4 - 1));

        colorPrintf(FOREGROUND_BLUE | FOREGROUND_INTENSITY, "bin");
        printf("    >> %d	->	0b", $1);
        while (bitpos) {
          printf("%d", $1 & bitpos ? 1 : 0);
          bitpos >>= 1;
        }
        printf("\n");
    }
    | primary_expr INV
    {
        int result = 0;
        int bitpos = 1;
        while (bitpos < $1) bitpos <<= 1;
        bitpos = 1 < bitpos>>1 ? bitpos>>1 : 1;
        while (bitpos) {
          result += $1 & bitpos ? 0 : bitpos;
          bitpos >>= 1;
        }
        $$ = result;
    }
    | primary_expr INV LRB expr RRB
    {
        int result = 0;
        int bitpos = 1;
        while (1 << bitpos < $1 + 1) bitpos++;
        bitpos = (1 << ($4 - 1)) < bitpos >> 1 ? bitpos >> 1 : (1 << ($4 - 1));

        while (bitpos) {
          result += $1 & bitpos ? 0 : bitpos;
          bitpos >>= 1;
        }
        $$ = result;
    }
    | primary_expr LAB expr  RAB
    {
        $$ = ($1 >> $3) & 1 ? 1 : 0;
    }
    | primary_expr LAB expr COMMA expr RAB
    {
        int lsb = min($3, $5);
        int msb = max($3, $5);
        int tmp = $1 >> lsb;
        int result = 0;
        int pos = 0;
        while (pos <= msb - lsb) {
            result += tmp & (1 << pos) ? (1 << pos) : 0;
            pos++;
        }
        $$ = result;
    }
%%

int
yyerror(char const *str)
{
    extern char *yytext;
    fprintf(stderr, "parser error near %s\n", yytext);
    return 0;
}

int main(void)
{
    extern int yyparse(void);
    extern FILE *yyin;

    colorPrintf(FOREGROUND_INTENSITY, "calc");
    printf("   >> ");
    yyin = stdin;
    while (1) {
      if (yyparse()) {
          fprintf(stderr, "Parse Error !\n");
      }
    }
}
