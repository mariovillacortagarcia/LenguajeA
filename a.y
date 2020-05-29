%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<math.h>

void poper(char);
int yyerror(char const *) ;
int yylex(void) ;

extern int pos;

%}

%union {
	double real;
    char caracter;
	char cadenaReservada[1000];
    int logico;
}


%token<real> DIGITO
%token<logico> BOOLEANO
%token<caracter> CARACTER
%token<cadenaReservada> CADENA
%token<cadenaReservada> PALABRACLAVE

%type<real> exprNumerica
%type<logico> exprLogica
%type<caracter> exprCaracter
%type<cadenaReservada> exprCadena


%left '+' '-'
%left '*' '/'
%right '^'

%start	start


%%

start : sentencia
      ;

sentencia : sentenciaSimple
					| sentenciaBloque
					;
sentenciaSimple :	declaracion
								| asignacion
								| condicional
								| bucle
								;
declaracion : 'var' VARIABLE
						;
sentenciaBloque : sentenciaSimple ';' sentenciaBloque
								| sentenciaSimple ';'
asignacion : variable '=' expresion
					 ;
condicional : condicionalSimple
						| condicionalDoble
						;
condicionalSimple : 'if' '('expresionLogica ')' sentencia
									;
condicionalDoble : condicionalSimple 'else' sentencia


exprNumerica:	'-'exprNumerica			{$$ = (-1)*$2; }
	| exprNumerica '+' exprNumerica     {$$ = $1 + $3 ; }
	| exprNumerica '-' exprNumerica		{$$ = $1 - $3 ; }
    | exprNumerica '*' exprNumerica     {$$ = $1 * $3 ; }
	| exprNumerica '/' exprNumerica     {$$ = $1 / $3 ; }
	| exprNumerica '^' exprNumerica     {
						$$ = pow($1,$3);
						;
						}
    | '(' exprNumerica ')'		{$$ = $2 ;}
    | DIGITO      		{$$ = $1 ; printf("NUM(%d) ",pos);}
	;

%%

void poper(char c){
    switch(c){
        case '+'  : printf("<+> ");
                    break;
		case '-'  : printf("<-> ");
					break;
        case '*'  : printf("<*> ");
                    break;
		case '^'  : printf("<^> ");
                    break;
		case 'S'  : printf("CHS ");
					break;
	}
    return;
}

int yyerror(char const *s)
{
    printf("yyerror %s",s);
}

int main(int na, char *av[])
{
	yyparse();
	return 1;
}
