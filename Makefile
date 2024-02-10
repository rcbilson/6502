CC65=cc65/bin
AS=$(CC65)/ca65
ASFLAGS=--target sim65c02

rom.bin: main.o ramtest.o
	$(CC65)/ld65 --config eater.cfg -m rom.map -o $@ $^

.PHONY: hexdump
hexdump: rom.bin
	hexdump -C $<

.PHONY: cc65
cc65:
	make -C cc65

.PHONY: clean
clean:
	rm -f rom.bin *.o
