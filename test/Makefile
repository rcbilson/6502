VPATH=..

CC65=../cc65/bin
AS=$(CC65)/ca65
ASFLAGS=--target sim65c02

TESTS=test_lfsr test_ramtest

.PHONY: test
test: $(TESTS)
	set -ex; for i in $^; do $(CC65)/sim65 $$i; done

%: %.o
	$(CC65)/cl65 --target sim65c02 -m $@.map -o $@ $^

ramtest.o: ramtest.s
	$(AS) $(ASFLAGS) -D RAMTEST_START='$$6000' $<

test_ramtest: test_ramtest.o ramtest.o
test_lfsr: test_lfsr.o lfsr.o

.PHONY: clean
clean:
	rm -f $(TESTS) *.o *.map *.lst
