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
	float real;
}

%token<real> DIGIT
%type<real> expr

%left '+' '-'
%left '*' '/'
%right '^'

%start	start


%%

start : expr'\n' 		{printf("Resultado: %f\n", $1); exit(1);}
      ;

expr:	'-'expr			{$$ = (-1)*$2; poper('S');}
	| expr '+' expr     {$$ = $1 + $3 ; poper('+');}
	| expr '-' expr		{$$ = $1 - $3 ; poper('-');}		
    | expr '*' expr     {$$ = $1 * $3 ; poper('*');}
	| expr '/' expr     {$$ = $1 / $3 ; poper('/');}
	| expr '^' expr     {
						$$ = pow($1,$3);
						poper('^');
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