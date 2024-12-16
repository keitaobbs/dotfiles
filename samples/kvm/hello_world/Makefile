CFLAGS  = -Wall -Wextra

all: vm

vm: rom/rom.h main.c
	gcc $(CFLAGS) -o $@ $+

rom/rom.h:
	make -C rom

clean:
	rm -f vm
	make -C rom clean

.PHONY: clean
