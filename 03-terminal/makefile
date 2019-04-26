.PRECIOUS: binary/%.o binary/library/%.o binary/%.bin

LIBRARY_SRC = $(wildcard library/*.s)
LIBRARY_OBJ = $(patsubst library/%.s, binary/library/%.o, $(LIBRARY_SRC))

binary/%.o: %.s $(wildcard include/*.s)
	@mkdir -p binary
	avr-as -m atmega32a $< -o $@

binary/library/%.o: library/%.s
	@mkdir -p binary/library
	avr-as -m atmega32a $< -o $@

binary/%.bin: binary/%.o $(LIBRARY_OBJ)
	avr-ld -T script.ld $^ -o $@

%.hex: binary/%.bin
	avr-objcopy -j .text -j .data -O ihex $< $@

%: %.hex
	avrdude -p m32 -c usbasp -P usb -U flash:w:$<:i -F

clean:
	rm -rf binary *.hex
