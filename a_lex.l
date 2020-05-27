%{
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
\'.\' {
			pos++;
			yylval.caracter = yytext;
			return (CARACTER);
}
\".+\" {
			pos++;
			strcpy(yylval.cadenaReservada, yytext);
			return (CADENA);
}

("+"|"-"|"*"|"/"|"^"|"("|")"|"\n") {
	return yytext[0];
}
%%