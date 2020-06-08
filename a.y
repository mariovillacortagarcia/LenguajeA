%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<math.h>

#define NUM_VARIABLES 100

typedef struct Par{
	char *clave;
	double numerico;
	char caracter;
	char cadena[1000];
	int logico;
};
void declara(char*);
void setNumerico(char,double);
void setCaracter(char,char);
void setCadena(char,char*);
void setLogico(char,int);
double getNumerico(char*);
char getCaracter(char*);
char* getCadena(char*);
int getLogico(char*);
int yyerror(char const *);
int yylex(void);

extern int pos;
Par variables[NUM_VARIABLES];
int num_variable = 0;
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
%token<cadenaReservada> NOMBRE

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
				declaracion ';'
			|	asignacion ';'
			|	condicional ';'
			|	bucle ';'
			|	metodo ';'
			;
metodo:
				PRINTF '(' expresionCadena ')'		{printf("%s",$3) ; }
			|	SCANF '(' expresionCadena ')'		{scanf("%s", $3) ; }
			;
sentenciaBloque:
				sentenciaSimple  sentenciaBloque
		 	|	sentenciaSimple 
			;
declaracion: 
			VAR expresionCadena	{declara($2);}
					; 
asignacion:
			variable '=' expresionLogica	{setLogico($1,$3);}
		|	variable '=' expresionNumerica	{setNumerico($1,$3);}
		|	variable '=' expresionCaracter	{setCara($1,$3);}
		|	variable '=' expresionCadena	{setCadena($1, $3);}
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
			funcionNumerica								{$$ = $1 ;}
		|	'-' expresionNumerica						{$$ = (-1)*$2; }
		|	expresionNumerica '+' expresionNumerica     {$$ = $1 + $3 ; }
		| 	expresionNumerica '-' expresionNumerica	  	{$$ = $1 - $3 ; }
		| 	expresionNumerica '*' expresionNumerica     {$$ = $1 * $3 ; }
		| 	expresionNumerica '/' expresionNumerica     {$$ = $1 / $3 ; }
		| 	expresionNumerica '^' expresionNumerica     {$$ = pow($1,$3) ; } 
    	| 	'(' expresionNumerica ')'					{$$ = $2 ;}
    	| 	DIGITO      								{$$ = $1 ;}	
		| 	variable									{$$ = getNumerico($1);}		
		;
expresionLogica:	
			'!'expresionLogica						{$$ = !$2;}
		|	expresionLogica '|' expresionLogica     {$$ = $1 | $3 ; }
		| 	expresionLogica '&' expresionLogica	  	{$$ = $1 & $3 ; }
		| 	expresionNumerica '<' expresionNumerica     {$$ = $1 < $3 ; }
		| 	expresionCaracter '<' expresionCaracter     {$$ = $1 < $3 ; }
		| 	expresionNumerica '<''=' expresionNumerica    {$$ = $1 <= $4 ; }
		| 	expresionCaracter '<''=' expresionCaracter    {$$ = $1 <= $4 ; }
		| 	expresionNumerica '>''=' expresionNumerica    {$$ = $1 >= $4 ; }
		| 	expresionCaracter '>''=' expresionCaracter    {$$ = $1 >= $4 ; }
		| 	expresionNumerica '>' expresionNumerica    {$$ = $1 > $3 ; }
		| 	expresionCaracter '>' expresionCaracter    {$$ = $1 > $3 ; }
		| 	expresionLogica '=''=' expresionLogica    {$$ = $1 == $4 ; }
		| 	expresionNumerica '=''=' expresionNumerica    {$$ = $1 == $4 ; }
		| 	expresionCaracter '=''=' expresionCaracter    {$$ = $1 == $4 ; }
		| 	expresionLogica '!''=' expresionLogica    {$$ = $1 != $4 ; }
		| 	expresionNumerica '!''=' expresionNumerica    {$$ = $1 != $4 ; }
		| 	expresionCaracter '!''=' expresionCaracter    {$$ = $1 != $4 ; }
		| 	'(' expresionLogica ')'					{$$ = $2 ;} 
    	| 	BOOLEANO      							{$$ = $1 ;}
		| 	variable									{$$ = getLogico($1);}

		;
expresionCaracter:	
			expresionCaracter '+' expresionCaracter     {$$ = $1 + $3 ; }
		| 	expresionCaracter '-' expresionCaracter	  	{$$ = $1 - $3 ; }
		| 	expresionCaracter '*' expresionCaracter     {$$ = $1 * $3 ; }
		| 	expresionCaracter '/' expresionCaracter     {$$ = $1 / $3 ; }
    	| 	'(' expresionCaracter ')'					{$$ = $2 ;}
    	| 	CARACTER      								{$$ = $1 ;}
		| 	variable									{$$ = getCaracter($1);}

		;
expresionCadena:
			expresionCaracter expresionCadena			{$$ = $1 + $2}
		| 	""											{$$ = $1}
		| 	variable									{$$ = getCadena($1);}
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
variable:
			NOMBRE		{$$ = $1;}
		;

%%


// Funcion que permite declarar variables
void declara(char *clave){
	int i;
	for (i = 0; i < num_variable; i++){
		if(strcmp(variables[i].clave,clave) == 0){
			return
		}
	}
	variables[num_variable].clave = clave;
	num_variable++;
}

// Dar el valor numerico a la variable numerica
void setNumerico(char *clave, double valor){
	int i;
	for (i = 0; i < num_variable; i++){
		if(strcmp(variables[i].clave,clave) == 0){
			variable.numerico = valor;
		}
	}
}

// Dar el valor caracter a la variable caracter
void setCaracter(char *clave, double valor){
	int i;
	for (i = 0; i < num_variable; i++){
		if(strcmp(variables[i].clave,clave) == 0){
			variable.caracter = valor;
		}
	}
}

// Dar el valor cadena a la variable cadena
void setCadena(char *clave, char *valor){
	int i;
	for (i = 0; i < num_variable; i++){
		if(strcmp(variables[i].clave,clave) == 0){
			variable.cadena = *valor;
		}
	}
}

// Dar el valor logico a la variable logica
void setLogico(char *clave, int valor){
	int i;
	for (i = 0; i < num_variable; i++){
		if(strcmp(variables[i].clave,clave) == 0){
			variable.logico = logico;
		}
	}
}

double getNumerico(char *clave){
	int i;
	for(i = 0; i<num_variable;i++){
		if(strcmp(variables.clave,clave) == 0){
			return variables.numerico;
		}
	}
	return NULL;
}
}
char getCaracter(char *clave){
	int i;
	for(i = 0; i<num_variable;i++){
		if(strcmp(variables.clave,clave) == 0){
			return variables.caracter;
		}
	}
	return NULL;
}
char *getCadena(char *clave){
	int i;
	for(i = 0; i<num_variable;i++){
		if(strcmp(variables.clave,clave) == 0){
			return variables.cadena;
		}
	}
	return NULL;
}
int getLogico(char *clave){
	int i;
	for(i = 0; i<num_variable;i++){
		if(strcmp(variables.clave,clave) == 0){
			return variables.logico;
		}
	}
	return NULL;
}

/*void poper(char c){
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
}*/

int yyerror(char const *s)
{
    printf("yyerror %s",s);
}

int main(int na, char *av[])
{
	yyparse();
	return 1;
}
