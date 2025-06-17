#include <stdio.h>

int yylex(void);
int yyparse(void);

FILE *yyin;

int main() {
    printf("Iniciando compilador personalizado...\n");
    printf("> ");

    yyin = stdin; 

    yyparse();

    return 0;
}