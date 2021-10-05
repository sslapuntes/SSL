%option yylineno 

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"

    extern FILE* yyin;

    /* Desarrollo SCANNER solamente para derivar el código de archivo_fuente.c */

%}
IDENTIFICADOR [a-zA-Z_][a-zA-Z0-9]*
SUFIJO_UNSIGNED u|U
SUFIJO_LONG     l|L
SUFIJO_ENTERO   {SUFIJO_UNSIGNED}|{SUFIJO_LONG}|{SUFIJO_UNSIGNED}{SUFIJO_LONG}|{SUFIJO_LONG}{SUFIJO_UNSIGNED}
%%
"#include<stdio.h>"   {return INCLUDE;}
"#define"[ ]+{IDENTIFICADOR}   {return DEFINE;}
"void"                         {return VOID;}
"int"                          {return INT;}
"if"                           {return IF;}
"else"                         {return ELSE;}
"while"                        {return WHILE;}
"return"                       {return RETURN;}
";"|"="|","|"{"|"}"|"("|")"|"*"       {return yytext[0];}
0[0-7]*{SUFIJO_ENTERO}?        {yylval.ival=strtol(yytext,NULL,8); return OCTAL;}
{IDENTIFICADOR}                {yylval.idval=strdup(yytext);       return ID;}
[\t\n]                         {;}
%%

int yywrap(void)
{
    return 1;
}