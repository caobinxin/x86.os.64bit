all:
	@echo "编译"
	@nasm boot.asm -o boot.bin
	@echo "写入"
	@dd if=boot.bin of=boot.img bs=512 count=1 conv=notrunc
	@nasm loader.asm -o loader.bin
	
run:
	@bochs -f bochsrc 

loader:
	@sudo mount ./boot.img /media/ -t vfat -o loop
	@sudo cp loader.bin /media/
	@sync
	@sudo umount /media/
	@rm -rf *.bin

clean:
	@rm -rf *.bin
