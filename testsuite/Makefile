TEST_ASMCOMP=ocp-test-asmcomp

tests:
	$(MAKE) -f Makefile.tests

update-references:
	../_obuild/$(TEST_ASMCOMP)/$(TEST_ASMCOMP).asm
	$(MAKE) -f Makefile.tests update-references

clean:
	$(MAKE) -f Makefile.tests clean
	rm -f *~
