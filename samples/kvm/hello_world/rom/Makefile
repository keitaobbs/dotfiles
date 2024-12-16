CFLAGS  = -Wall -Wextra -nostdinc -nostdlib -fno-builtin
LDFLAGS = -s -x -T rom.ld

all: rom.h

%.h: %.bin
	xxd -i $^ > $@

%.bin: %.o
	ld $(LDFLAGS) -o $@ $+

%.o: %.S
	gcc $(CFLAGS) -c -o $@ $+

clean:
	rm -f *.h

.PHONY: clean
