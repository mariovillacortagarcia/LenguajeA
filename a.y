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

%type<real> expresionNumerica
%type<logico> expresionLogica
%type<caracter> expresionCaracter
%type<cadenaReservada> expresionCadena


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
								| metodo
								;
sentenciaBloque : sentenciaSimple ';' sentenciaBloque
		 						| sentenciaSimple ';'
								;
declaracion : 'var' CADENA	{
													double $2_num;
													char $2_car;
													char $2_cad[1000];
													}
						;
asignacion : variable '=' expresionLogica	{$1_num = $3;}
 					 | variable '=' expresionNumerica	{$1_num = $3;}
					 | variable '=' expresionCaracter	{$1_car = $3;}
					 | variable '=' expresionCadena	{strcpy($1_cad, $3);}
				 	 ;
condicional : condicionalSimple
						| condicionalDoble
						;
condicionalSimple : 'if' '('expresionLogica ')' sentencia
									;
condicionalDoble : condicionalSimple 'else' sentencia
								 ;
expresionNumerica:	'-'expresionNumerica			{$$ = (-1)*$2; }
	| expresionNumerica '+' expresionNumerica     {$$ = $1 + $3 ; }
	| expresionNumerica '-' expresionNumerica		{$$ = $1 - $3 ; }
  | expresionNumerica '*' expresionNumerica     {$$ = $1 * $3 ; }
	| expresionNumerica '/' expresionNumerica     {$$ = $1 / $3 ; }
	| expresionNumerica '^' expresionNumerica     {
						$$ = pow($1,$3);
						;
						}
    | '(' expresionNumerica ')'		{$$ = $2 ;}
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
