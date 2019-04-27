org 0x7c00 ;由于指定程序的起始地址，如果程序不使用org伪指令修饰，编译器会把0x00作为程序的起始地址

BaseOfStack equ 0x7c00 ;等价语句 类似 c中的define

; BaseOfLoader << 4 + OffsetOfLoader = 0x1000 为loader程序的起始物理地址
BaseOfLoader equ 0x1000
OffsetOfLoader equ 0x00 

RootDirSectors equ 14           ;根目录所占用的扇区数 (BPB_RootEntCnt * 32 + BPB_BytesPerSec -1) / BPB_BytesPerSec
SectorNumOfRootDirStart equ 19  ;根目录的起始扇区号 BPB_RsvdSecCnt + BPB_NumFATs * BPB_FATSz16
SectorNumOfFAT1Start equ 1      ;FAT1 表的起始扇区号

;SectorBalance用于平衡文件或者是目录的起始簇号和数据区起始簇号的差值。具体解释参照 p45
SectorBalance equ 17

; FAT12 文件系统引导扇区结构
jmp short Label_Start
nop
BS_OEMName db 'hoaios'         ;生产厂商名
BPB_BytesPerSec dw 512         ;每个扇区字节数
BPB_SecPerClus db 1            ;每个簇扇区数
BPB_RsvdSecCnt dw 1            ;保留扇区数
BPB_NumFATs db 2               ;FAT 表的个数
BPB_RootEntCnt dw 224          ;根目录可以容纳的目录项的数量
BPB_TotSec16 dw 2880           ;总的扇区数
BPB_Media db 0xf0              ;介质描述符
BPB_FATSz16 dw 9               ;每个FAT表 所占的扇区数
BPB_SecPerTrk dw 18            ;每个磁道所占的扇区数
BPB_NumHeads dw 2              ;磁头的数量
BPB_HiddSec dd 0               ;隐藏扇区数
BPB_TotSec32 dd 0              ;如果BPB_TotSec16 值为0,则由这个值记录扇区数
BS_DrvNum db 0                 ;int 13h的驱动器号
BS_Reserved1 db 0              ;未使用
BS_BootSig db 29h              ;扩展引导标记
BS_VolID dd 0                  ;卷序列号
BS_VolLab db 'boot loader'     ;卷标
BS_FileSysType db 'FAT12'      ;文件系统类型


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




;==================================================================== search loader.bin
	mov word [SectorNo], SectorNumOfRootDirStart # 语法:在nasm编译器中，如果直接引用变量名或者标识符，则被编译器认为正在引用该变量的地址。如果希望访问变量里的数据，则必须使用符号[]

Lable_Search_In_Root_Dir_Begin:
	
	cmp word [RootDirSizeForLoop], 0
	jz Label_No_LoaderBin
	dec word [RootDirSizeForLoop]                # 自减1
	mov ax, 00h
	mov es, ax 
	mov bx, 8000h
	mov ax, [SectorNo]                           # ax 待读取的磁盘起始扇区号
	mov cl, 1                                    # cl 读入的扇区数量
	call Func_ReadOneSector
	mov si, LoaderFileName
	mov di, 8000h
	cld                                         # cld 使得传送方向从低地址到高地址，而 std 就刚好相反 cld 和 std 都是在字行块传送时使用的，他们决定了块传送的方向
	mov dx, 10h 

Label_Search_For_LoaderBin:

	cmp dx, 0
	jz Label_Goto_Next_Sector_In_Root_Dir
	dec dx 
	mov cx, 11 

Label_Cmp_FileName:

	cmp cx, 0
	jz Label_FileName_Found
	dec cx 
	lodsb
	cmp al, byte [es:di]
	jz Label_Go_On
	jmp Label_Different

Label_Go_On:

	inc di 
	jmp Label_Cmp_FileName

Label_Different:
	
	and di, 0ffe0h
	add di, 20h 
	mov si, LoaderFileName
	jmp Label_Search_For_LoaderBin

Label_Goto_Next_Sector_In_Root_Dir:

	add word [SectorNo], 1
	jmp Lable_Search_In_Root_Dir_Begin



;====================================================================== read one sector from floppy
;INT 13h ,ah=02h 功能：读取磁盘扇区
;al = 读入的扇区数(必须非0)
;ch = 磁道号(柱面号)的低8位
;cl = 扇区号1~63(bit 0~5) ,磁道号(柱面号)的高2位(bit 6~7,只对硬盘有效)
;dh = 磁头号
;dl = 驱动器号(如果操作的是硬盘驱动器,bit 7必须被置位)
;es:bx => 数据缓冲区
Func_ReadOneSector:
	
	push bp 
	mov bp, sp
	sub esp, 2
	mov byte [bp -2], cl 
	push bx 
	mov bl, [BPB_SecPerTrk]
	div bl                      # ax / bl : 商保存在al中(目标磁道号) 余数保存在ah中(目标磁道内的起始扇区号)
	inc ah                      #考虑到磁道内的起始扇区号是从1开始计数，故此出将余数值加1 
	mov cl, ah                  # cl 为目标磁道内的起始扇区号
	mov dh, al                  # 磁头号 
	shr al, 1
	mov ch, al                  # 磁道号(柱面号)
	and dh, 1
	pop bx 
	mov dl, [BS_DrvNum]
Label_Go_On_Reading:
	mov ah, 2                  # int 13h ah=02h 功能: 读取磁道扇区
	mov al, byte [bp -2]
	int 13h                    # 最后执行INT 13h 中断服务程序从软盘扇区读取数据到内存中，当数据读取成功(CF标志位被复位)后恢复调用现场
	jc Label_Go_On_Reading
	add esp, 2
	pop bp 
	ret
