
all: Imulh.o

clean:
	rm -f *.s *.o *.i *~

Imulh.o: Imulh.c
	ocamlopt -verbose -ccopt -save-temps -c Imulh.c

siteox:
	rm -f *.cm? *.asm *.o *.log *~ *.s
	rsync -auv --rsync-path=/usr/local/bin/rsync \
		. siteox:opt/ocaml-4.03.0/ocp-c-equiv

