all: clean


downd: all_compile
	sudo cp kernel.bin /media/colby/
	sudo sync
	sudo umount /media/colby


all_compile: system
	objcopy -I elf64-x86-64 -S -R ".eh_frame" -R ".comment" -O binary system kernel.bin

system:	head.o main.o font.o 
	ld -b elf64-x86-64 -o system head.o main.o -T Kernel.lds 

main.o:	main.c
	gcc  -mcmodel=large -fno-builtin -m64 -c main.c

head.o:	head.S
	gcc -E  head.S > head.s
	as --64 -o head.o head.s

font.o: font.c
	gcc -mcmodel=large -fno-builtin -m64 -c font.c

clean: downd
	rm -rf *.o *.s~ *.s *.S~ *.c~ *.h~ system  Makefile~ Kernel.lds~ kernel.bin 


