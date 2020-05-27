intopost: a.y a_lex.l
	yacc -yd a.y
	flex a_.l
	gcc y.tab.c lex.yy.c -lfl -lm -o a 
clean:
	rm *c *h a