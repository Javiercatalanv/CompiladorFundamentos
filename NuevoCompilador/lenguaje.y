/* Aqui van los include del archivo*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
%}

/* Aqui se unen los tipos posibles de datos */
%union {
    int num;
    float decimal;
    char* str;
}

/* Aqui se declaran los tokens */
%token <decimal> NUM
%token SUMA RESTA MULT DIV POT
%token PUNTOYCOMA PAREN_IZQ PAREN_DER
%token IGUAL DIFERENTE MENOR MAYOR MENORIGUAL MAYORIGUAL
%token IF ELSE WHILE
%token TIPO_INT TIPO_FLOAT TIPO_STRING TIPO_BOOL
%token FUNCION RETURN MOSTRAR
%token <str> ID

/* Aqui se declaran los tipos no terminales */
%type <decimal> programa expresion potencia
%type <num> comparacion sentencia
%start programa
%%

/* Aqui se declara la regla Programa */
programa:
      expresion PUNTOYCOMA     { printf("Resultado: %.2f\n", $1); }
    | potencia PUNTOYCOMA      { printf("Resultado: %.2f\n", $1); }
    | programa expresion PUNTOYCOMA { printf("Resultado: %.2f\n", $2); }
    | programa potencia PUNTOYCOMA { printf("Resultado: %.2f\n", $2); }
    | comparacion PUNTOYCOMA      { printf("Resultado comparación: %s\n", $1 ? "true" : "false"); }
    | sentencia programa
    | sentencia
    | if_statement
    | while_statement
;

/* Aqui se declara la regla Sentencia */
sentencia:
    expresion PUNTOYCOMA
  | comparacion PUNTOYCOMA
  | IF PAREN_IZQ comparacion PAREN_DER bloque
      {
        if ($3) {
            printf("Condición IF verdadera\n");
        } else {
            printf("Condición IF falsa (no hay else)\n");
        }
      }
  | IF PAREN_IZQ comparacion PAREN_DER bloque ELSE bloque
      {
        if ($3) {
            printf("Condición IF verdadera (ejecutando bloque if)\n");
        } else {
            printf("Condición IF falsa (ejecutando bloque else)\n");
        }
      }
  | WHILE PAREN_IZQ expresion PAREN_DER bloque
      {
        printf("Inicio de WHILE\n");
        while ($3) {
            printf("Iteración del WHILE\n");
            break; 
        }
      }
;

/* Aqui se declara la regla Bloque */
bloque:
    PAREN_IZQ sentencia PAREN_DER
    | PAREN_IZQ programa PAREN_DER
;

/* Aqui se declara la regla Expresion */
expresion:
      NUM SUMA NUM   { $$ = $1 + $3; }
    | NUM RESTA NUM  { $$ = $1 - $3; }
    | NUM MULT NUM   { $$ = $1 * $3; }
    | NUM DIV NUM    {
                        if ($3 == 0) {
                            yyerror("División por cero");
                            exit(1);
                        }
                        $$ = $1 / $3;
                    }
;

/* Aqui se declara la regla Potencia */
potencia:
      NUM POT NUM {
          int resultado = 1;
          for (int i = 0 ; i < $3 ; i++){
            resultado *= $1;
          }
          $$ = resultado;
      }
;

/* Aqui se declara la regla Comparacion */
comparacion:
      NUM IGUAL NUM        { $$ = $1 == $3; }
    | NUM DIFERENTE NUM    { $$ = $1 != $3; }
    | NUM MENOR NUM        { $$ = $1 < $3; }
    | NUM MAYOR NUM        { $$ = $1 > $3; }
    | NUM MENORIGUAL NUM   { $$ = $1 <= $3; }
    | NUM MAYORIGUAL NUM   { $$ = $1 >= $3; }
;

/* Aqui se declara la regla If_Statement */
if_statement:
    IF PAREN_IZQ comparacion PAREN_DER bloque
  | IF PAREN_IZQ comparacion PAREN_DER bloque ELSE bloque
;

/* Aqui se declara la regla While_Statement */
while_statement:
    WHILE PAREN_IZQ comparacion PAREN_DER bloque
;

/* Aqui se declara la regla Declaracion */
declaracion:
    TIPO_INT ID '=' expresion PUNTOYCOMA
    | TIPO_FLOAT ID '=' expresion PUNTOYCOMA
    | TIPO_BOOL ID '=' comparacion PUNTOYCOMA
;

%%

/* Estas son las funciones auxiliares */
int resolver_suma(int a, int b) {
    int resultado = a + b;
    printf("Resultado de la suma: %d\n", resultado);
    return resultado;
}

int resolver_resta(int a, int b) {
    int resultado = a - b;
    printf("Resultado de la resta: %d\n", resultado);
    return resultado;
}

int resolver_multiplicacion(int a, int b) {
    int resultado = a * b;
    printf("Resultado de la multiplicación: %d\n", resultado);
    return resultado;
}

int resolver_division(int a, int b) {
    if (b == 0) {
        printf("Error: División por cero.\n");
        return 0;
    }
    int resultado = a / b;
    printf("Resultado de la división: %d\n", resultado);
    return resultado;
}

int resolver_potencia(int base, int exponente) {
    int resultado = 1;
    while (exponente > 0) {
        resultado *= base;
        exponente--;
    }
    printf("Resultado de la potencia: %d\n", resultado);
    return resultado;
}


