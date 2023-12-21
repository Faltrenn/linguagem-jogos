all: language

language.tab.c language.tab.h: language.y
	bison -t -v -d language.y

lex.yy.c: language.lex language.tab.h
	flex language.lex

language: lex.yy.c language.tab.c language.tab.h
	cc -Wall -ggdb -o compiler language.tab.c lex.yy.c

clean:
	rm -f compiler language.tab.c lex.yy.c language.tab.h language.output

code:
	gcc -c code.c basic.c && gcc -o main.out *.o && rm *.o
