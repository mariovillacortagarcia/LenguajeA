a: a.y a_lex.l
	yacc -yd a.y
	flex a_lex.l
	gcc y.tab.c lex.yy.c -lfl -lm -o a 
clean:
	rm *c *h a