all:
	@echo "请先保证当前目录下有 boot.img 如若不存在：请用bximage"


	nasm boot.asm -g -o boot.bin
	nasm loader.asm -o loader.bin
	dd if=boot.bin of=./boot.img bs=512 count=1 conv=notrunc
	rm boot.bin
	
	sudo mount ./boot.img /media/colby/ -t vfat -o loop
	sudo cp loader.bin /media/colby/
	sudo sync
	sudo umount /media/colby
	
	rm loader.bin

	bochs -f ./bochsrc
	
