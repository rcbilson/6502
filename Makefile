CC65:=cc65/bin-$(shell uname -m)
AS=$(CC65)/ca65
ASFLAGS=-l $@.lst -I $(shell pwd)

rom.bin: main.o ramtest.o maze/maze.o spislave.o librt.a 
	$(CC65)/ld65 --config eater.cfg -m rom.map -o $@ $^

librt.a: reg.o via.o led.o lcd.o lfsr.o
	$(CC65)/ar65 r $@ $^

.PHONY: test
test: rom.bin
	make -C test

.PHONY: netprogram
netprogram: rom.bin
	ssh bokonon minipro -p AT28C256 -w /n/user/richard/src/6502/rom.bin -u

.PHONY: program
program: rom.bin
	minipro -p AT28C256 -w rom.bin -u

.PHONY: hexdump
hexdump: rom.bin
	hexdump -C $<

.PHONY: cc65
cc65:
	rm -rf $(CC65) cc65/bin cc65/wrk
	make -C cc65
	mv cc65/bin $(CC65)

.PHONY: tags
tags:
	find . -name '*.s' | xargs awk '/^.proc/{ OFS="\t"; print $$2, FILENAME, "/" $$0 "/" }' | LC_ALL=C sort > tags

.PHONY: clean
clean:
	rm -f rom.bin librt.a *.o
	make -C test clean
