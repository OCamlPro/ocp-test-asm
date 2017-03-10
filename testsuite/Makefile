TEST_ASMCOMP=ocp-test-asm

MAKEREC=$(MAKE) -f Makefile.tests --no-print-directory

tests:
	$(MAKEREC)

update-references:
	../_obuild/$(TEST_ASMCOMP)/$(TEST_ASMCOMP).asm
	$(MAKEREC) update-references

clean:
	$(MAKEREC) clean
	rm -f *~

siteox:
	rm -f *.cm? *.asm *.o *.log *~ *.s
	rsync -auv --rsync-path=/usr/local/bin/rsync \
		. siteox:opt/ocaml-4.03.0/ocp-testsuite

.SUFFIXES: .ml .cmm .log

.ml.cmm:
	$(MAKEREC) $*.cmm
.ml.log:
	$(MAKEREC) $*.log
