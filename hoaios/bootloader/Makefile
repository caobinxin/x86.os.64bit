all:
	nasm boot.asm -g -o boot.bin
	nasm loader.asm -o loader.bin
	dd if=boot.bin of=../boot.img bs=512 count=1 conv=notrunc
	rm boot.bin
	
	sudo mount ../boot.img /media/colby/ -t vfat -o loop
	sudo cp loader.bin /media/colby/
	rm loader.bin
	sudo sync
