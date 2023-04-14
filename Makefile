COMPILER = gcc

main: main.c
	bison -d parser.y
	flex scanner.l
	$(COMPILER) main.c iloc_generator.c free.c data_type.c symbol_table.c print.c lexical_value.c generic_tree.c parser.tab.c lex.yy.c -c # gera main.o
	$(COMPILER) main.o iloc_generator.o free.o data_type.o symbol_table.o print.o lexical_value.o generic_tree.o parser.tab.o lex.yy.o -o etapa7

debug: main.c
	bison -d parser.y --report-file parser.output -Wcounterexamples
	flex scanner.l
	$(COMPILER) main.c iloc_generator.c free.c data_type.c symbol_table.c print.c lexical_value.c generic_tree.c parser.tab.c lex.yy.c -c # gera main.o
	$(COMPILER) main.o iloc_generator.o free.o data_type.o symbol_table.o print.o lexical_value.o generic_tree.o parser.tab.o lex.yy.o -o etapa7

scanner: scanner.l
	flex scanner.l
	$(COMPILER) lex.yy.c -c #gera lex.yy.o

all: main scanner
	$(COMPILER) lex.yy.o main.o -o etapa7

example1: main
	./etapa7 -O < example1.c > program_optimized.s && gcc-12 program_optimized.s -o program_optimized
	./etapa7 < example1.c > program_default.s && gcc-12 program_default.s -o program_default
	python3 analise.py

example2: main
	./etapa7 -O < example2.c > program_optimized.s && gcc-12 program_optimized.s -o program_optimized
	./etapa7 < example2.c > program_default.s && gcc-12 program_default.s -o program_default
	python3 analise.py