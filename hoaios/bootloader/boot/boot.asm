org 0x7c00 ;由于指定程序的起始地址，如果程序不使用org伪指令修饰，编译器会把0x00作为程序的起始地址

BaseOfStack equ 0x7c00 ;等价语句 类似 c中的define

Label_Start:
	mov ax, cs 
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, BaseOfStack

; clear screen
	mov ax, 0600h
	mov bx, 0700h
	mov cx, 0
	mov dx, 0184fh
	int 10h

; set focus
	mov ax, 0200h
	mov bx, 0h
	mov dx, 0h
	int 10h

; display on screen: start booting...

	mov ax, 1301h
	mov bx, 0fh
	mov dx, 0h
	mov cx, 10 
	push ax 
	mov ax, ds 
	mov es, ax 
	pop ax 
	mov bp, StartBootMessage
	int 10h 

; reset floppy
	xor ah, ah
	xor dl, dl
	int 13h

	jmp $

StartBootMessage: db "hoaios boot ..." ; 定义一个一维数组 数组的名字叫 StartBootMessage

; fill zero until whole sector
times 510 - ($ - $$) db 0 ; times 是一个关键字 首先 这行的意思是计算将要填充的数据长度 
						  ;$代表本行的起始地址
						  ;$$代表本section(可以是 数据段 代码段的一种，不能把section理解成为一个函数)
dw 0xaa55 ;将一个字 填充到程序的结尾

