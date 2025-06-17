%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lenguaje.tab.h"
%}

DIGITO     [0-9]+
ESPACIO    [ \t\r\n]+

%%
{DIGITO}+(.{DIGITO}+)?   { yylval.decimal = atof(yytext); return NUM; }
\+              { return SUMA; }
\-              { return RESTA; }
\*              { return MULT; }
\/              { return DIV; }
\^              { return POT; }
\;              { return PUNTOYCOMA; }
\(              { return PAREN_IZQ; }
\)              { return PAREN_DER; }
{ESPACIO}       { /* ignorar */ }
"=="     { return IGUAL; }
"!="     { return DIFERENTE; }
"<="     { return MENORIGUAL; }
">="     { return MAYORIGUAL; }
"<"      { return MENOR; }
">"      { return MAYOR; }
if        { return IF; }
else      { return ELSE; }
while     { return WHILE; }
"vi" {return TIPO_INT;}
"vd" {return TIPO_FLOAT;}
"vs" {return TIPO_STRING;}
"vb" {return TIPO_BOOL;}
[a-zA-Z_][a-zA-Z0-9_]* {yylval.str = strdup(yytext); return ID;}
.               { printf("Caracter no reconocido: %s\n", yytext); }
%%

int yywrap(){
    return 1;
}
