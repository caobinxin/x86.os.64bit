all:
	@echo "请先保证当前目录下有 boot.img 如若不存在：请用bximage"

	nasm boot.S -o boot.bin
	dd if=boot.bin of=./boot.img bs=512 count=1 conv=notrunc
	rm boot.bin
	bochs -f ./bochsrc
	