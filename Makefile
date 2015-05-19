BIN = bcal.exe

OBJ = y.tab.o lex.yy.o

CC = gcc
CFLAGS = -O2
LDFLAGS =

YACC = bison.exe
YACCFLAGS = --yacc -dv

LEX = flex.exe
LEXFLAGS =

RM = rm -rf

all : $(BIN)

clean :
	$(RM) $(BIN) $(OBJ) $(OBJ:o=c) $(OBJ:o=h) y.output

$(BIN) : $(OBJ)
	$(CC) $(LDFLAGS) $^ -o $@

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

y.tab.c : bcal.y
	$(YACC) $(YACCFLAGS) $<

lex.yy.c : bcal.l
	$(LEX) $(LEXFLAGS) $<
