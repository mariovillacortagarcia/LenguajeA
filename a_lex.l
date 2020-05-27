%{
	#include<stdio.h>
	#include"y.tab.h"
	int pos = 0;
%}
%%
[0-9]+(\.[0-9]+)? {
			pos++;
			yylval.real = atof(yytext);
			return (DIGIT);
			}

("+"|"-"|"*"|"/"|"^"|"("|")"|"\n") {
	return yytext[0];
}
%%