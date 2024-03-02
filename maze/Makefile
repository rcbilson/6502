CC65=../cc65/bin
AS=$(CC65)/ca65
ASFLAGS=-l $@.lst -I ..

maze.bin: maze.o ../librt.a 
	$(CC65)/ld65 --config ../app.cfg -m maze.map -o $@ $^

.PHONY: clean
clean:
	rm -f maze.bin *.lst *.map *.o
