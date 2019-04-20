all:
	echo "编译"
	nasm boot.asm -o boot.bin
	echo "写入"
	dd if=boot.bin of=boot.img bs=512 count=1 conv=notrunc
	bochs -f bochsrc 
