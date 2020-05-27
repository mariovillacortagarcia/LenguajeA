%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<math.h>

#define TAMANO_CADENA 1000

void poper(char);
int yyerror(char const *) ;
int yylex(void) ;

extern int pos;

%}

%union {
	double real;
    char caracter;
	char cadenaReservada[TAMANO_CADENA];
    int logico;
}


%token<real> DIGITO
%token<logico> BOOLEANO
%token<caracter> LETRA
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

start : expr'\n' 		{printf("Resultado: %f\n", $1); exit(1);}
      ;

expr:	'-'expr			{$$ = (-1)*$2; }
	| expr '+' expr     {$$ = $1 + $3 ; }
	| expr '-' expr		{$$ = $1 - $3 ; }		
    | expr '*' expr     {$$ = $1 * $3 ; }
	| expr '/' expr     {$$ = $1 / $3 ; }
	| expr '**' expr     {
						$$ = pow($1,$3);
						;
						}	
    | '(' expr ')'		{$$ = $2 ;}
    | DIGIT      		{$$ = $1 ; printf("NUM(%d) ",pos);}   
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