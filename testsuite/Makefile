TEST_ASMCOMP=ocp-test-asm

MAKEREC=$(MAKE) --no-print-directory

tests: all

generate-references:
	../_obuild/$(TEST_ASMCOMP)/$(TEST_ASMCOMP).asm
	$(MAKEREC) update-references -j 5

siteox:
	rm -f *.cm? *.asm *.o *.log *~ *.s
	rsync -auv --rsync-path=/usr/local/bin/rsync \
		. siteox:opt/ocp-testsuite

include Makefile.tests
