%{c
	#include<stdio.h>
	#include"y.tab.h"
	int pos = 0;
%}
%%
[0-9]+(\.[0-9]+)?   {
			pos++;
			yylval.real = atof(yytext);
			return (DIGITO);
}
([a-z]|[A-Z]|"_")+ {
			strcpy(yyval.cadenaReservada,yytext);
			return (NOMBRE);
}
true    {
			pos++;
			yylval.logico = 1;
			return (BOOLEANO);
}
false   {
			pos++;
			yylval.logico = 0;
			return (BOOLEANO);
}
. {
			pos++;
			yylval.caracter = yytext;
			return (CARACTER);
}
"if" {
			pos++;
			return (IF)
}
"else" {
			pos++;
			return (ELSE)
}
"do" {
			pos++;
			return (DO)
}
"while" {
			pos++;
			return (WHILE)
}
"printf" {
			pos++;
			return (PRINTF);
}
"scanf" {
			pos++;
			return (SCANF));
}
"var" {
			pos++;
			return (VAR);
}
"sin" {
			pos++;
			return (SIN);
}
"cos" {
			pos++;
			return (COS);
}
"tan" {
			pos++;
			return (TAN);
}
"arcsin" {
			pos++;
			return (ARCSIN);
}
"arccos" {
			pos++;
			return (ARCCOS);
}
"arctg" {
			pos++;
			return (ARCTG);
}
"mcm" {
			pos++;
			return (MCM);
}
"mcd" {
			pos++;
			return (MCD);
}
"log" {
			pos++;
			return (LOG);
}
("+"|"-"|"*"|"/"|"^"|"("|")"|";"|"|"|"&"|"!"|">"|">="|"<"|"<="|"=="|"!=") {
	return yytext[0];
}
%%