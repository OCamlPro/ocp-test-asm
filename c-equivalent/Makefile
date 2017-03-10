
all: Imulh.o

clean:
	rm -f *.s *.o *.i *~

Imulh.o: Imulh.c
	ocamlopt -verbose -ccopt -save-temps -c Imulh.c

