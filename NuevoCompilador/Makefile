compilador: lex.yy.c lenguaje.tab.c
	gcc lex.yy.c lenguaje.tab.c main.c -o compilador -ll

lex.yy.c: lenguaje.l
	flex lenguaje.l

lenguaje.tab.c lenguaje.tab.h: lenguaje.y
	bison -d lenguaje.y

clean:
	rm -f compilador lex.yy.c lenguaje.tab.c lenguaje.tab.h
