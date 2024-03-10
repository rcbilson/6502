CC65:=../cc65/bin-$(shell uname -m)
AS=$(CC65)/ca65
ASFLAGS=-l $@.lst -I ..

$(APP): $(OBJECTS) ../librt.a 
	$(CC65)/ld65 --config ../app.cfg -m $@.map -o $@ $^

.PHONY: upload
upload: $(APP)
	../spipy/upload $<

.PHONY: clean
clean:
	rm -f $(APP) *.lst *.map *.o
