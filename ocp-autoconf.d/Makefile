
TEST_ASMCOMP=ocp-test-asmcomp
.PHONY: testsuite
testsuite:
	cd testsuite; \
	../_obuild/$(TEST_ASMCOMP)/$(TEST_ASMCOMP).asm; \
	$(MAKE) -f Makefile.tests update-references

clean::
	$(MAKE) -C testsuite clean
