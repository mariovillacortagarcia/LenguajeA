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
%token IF
%token ELSE
%token DO
%token WHILE
%token SCANF
%token PRINTF
%token VAR
%token SIN
%token COS
%token TAN
%token ARCSIN
%token ARCCOS
%token ARCTG
%token MCM
%token MCD
%token LOG
%token CADENACARAC


%type<real> expresionNumerica
%type<logico> expresionLogica
%type<caracter> expresionCaracter
%type<cadenaReservada> expresionCadena


%left '+' '-'
%left '*' '/'
%right '^'

%start	start
%%

start: sentencia
      ;

sentencia:
			sentenciaSimple
		|	sentenciaBloque
		;
sentenciaSimple:
				declaracion
			|	asignacion
			|	condicional
			|	bucle
			|	metodo
			;
sentenciaBloque:
				sentenciaSimple ';' sentenciaBloque
		 	|	sentenciaSimple ';'
			;
declaracion: 
			VAR CADENA	{
				int $2_bool;
				double $2_num;
				char $2_car;
				char $2_cad[1000];
					}
					;
asignacion:
			variable '=' expresionLogica	{$1_bool = $3;}
		|	variable '=' expresionNumerica	{$1_num = $3;}
		|	variable '=' expresionCaracter	{$1_car = $3;}
		|	variable '=' expresionCadena	{strcpy($1_cad, $3);}
		;
condicional:
			condicionalSimple
		|	condicionalDoble
		;
condicionalSimple:
			IF '(' expresionLogica ')' sentencia	{if($3)$5}
		;
condicionalDoble: 
			condicionalSimple ELSE sentencia	{$1 else $3}
		;
bucle:
		bucleMientras
	|	bucleHazMientras
	;		
bucleMientras:
			WHILE '(' expresionLogica ')' sentencia		{while($3) $5} 
		;
bucleHazMientras:
			DO sentencia WHILE '(' expresionLogica ')'	{do $2 while($5)}
		;
expresionNumerica:	
			funcionNumerica								{$$ = $1}
		|	'-'expresionNumerica						{$$ = (-1)*$2; }
		|	expresionNumerica '+' expresionNumerica     {$$ = $1 + $3 ; }
		| 	expresionNumerica '-' expresionNumerica	  	{$$ = $1 - $3 ; }
		| 	expresionNumerica '*' expresionNumerica     {$$ = $1 * $3 ; }
		| 	expresionNumerica '/' expresionNumerica     {$$ = $1 / $3 ; }
		| 	expresionNumerica '^' expresionNumerica     {$$ = pow($1,$3) ; }
    	| 	'(' expresionNumerica ')'					{$$ = $2 ;}
    	| 	DIGITO      								{$$ = $1 ;}
		;
expresionLogica:	
			'!'expresionLogica						{$$ = !$2;}
		|	expresionLogica '|' expresionLogica     {$$ = $1 | $3 ; }
		| 	expresionLogica '&' expresionLogica	  	{$$ = $1 & $3 ; }
		| 	expresionLogica '>' expresionLogica     {$$ = $1 > $3 ; }
		| 	expresionLogica '>=' expresionLogica    {$$ = $1 >= $3 ; }
		| 	expresionNumerica '<' expresionNumerica     {$$ = $1 < $3 ; }
		| 	expresionNumerica '<=' expresionNumerica    {$$ = $1 <= $3 ; }
		| 	expresionCaracter '<' expresionCaracter     {$$ = $1 < $3 ; }
		| 	expresionCaracter '<=' expresionCaracter    {$$ = $1 <= $3 ; }
		| 	expresion '==' expresion    {$$ = $1 == $3 ; }
		| 	expresion '!=' expresion    {$$ = $1 != $3 ; }
		| 	'(' expresionLogica ')'					{$$ = $2 ;} 
    	| 	BOOLEANO      							{$$ = $1 ;}
		;
expresionCaracter:	
			expresionCaracter '+' expresionCaracter     {$$ = $1 + $3 ; }
		| 	expresionCaracter '-' expresionCaracter	  	{$$ = $1 - $3 ; }
		| 	expresionCaracter '*' expresionCaracter     {$$ = $1 * $3 ; }
		| 	expresionCaracter '/' expresionCaracter     {$$ = $1 / $3 ; }
    	| 	'(' expresionCaracter ')'					{$$ = $2 ;}
    	| 	CARACTER      								{$$ = $1 ;}
		;
funcionNumerica:
			SIN '(' expresionNumerica ')'							{$$ = sin($3) ; }
		|	COS	'(' expresionNumerica ')' 							{$$ = cos($3) ; }
		|	TAN '(' expresionNumerica ')'							{$$ = tan($3) ; }
		|	ARCCOS '(' expresionNumerica ')' 						{$$ = acos($3); }
		|	ARCSIN '(' expresionNumerica ')' 						{$$ = asin($3); }
		|	ARCTG '(' expresionNumerica ')' 						{$$ = atan($3); }
		|	LOG '('expresionNumerica ',' expresionNumerica  ')'		{$$ = log10($5) / log10($3); }
		;


cadena:
			'"' CADENACARAC '"'	{$$ = "$2"}
		|	'"' CADENACARAC '"' ',' 
		|	
imprimir:
			PRINTF '(' cadena ')'
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
