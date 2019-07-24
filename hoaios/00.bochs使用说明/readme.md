

# 编译bochs

	用svn　去拉这个版本的代码，进行编译安装bochs: 

	svn checkout -r r13534 http://svn.code.sf.net/p/bochs/code/trunk/bochs bochs


# 启动虚拟机
	bochs -f bochsrc 


# Bochs　调试的命令如下：

[cmd]:[说明]:[举例]


b address : 在某物理地址上设置断点 : b 0x7c00

c         : 继续执行，直到遇到断点 : c

info cpu  : 查看寄存器的信息       : info cpu

r         : 查看寄存器的信息       : r

sreg      : 查看寄存器的信息       : sreg

creg      : 查看寄存器的信息       : creg




xp /nuf addr : 查看内存物理地址内容　: xp /10bx 0x10_0000

x /nuf addr  : 查看线性地址内容      : x  /40wd 0x9_0000

u start end  : 反汇编一段内存        : u 0x10_0000 0x10_0010


注解：nuf
	n: 代表显示单元个数；

	u: 代表显示单元大小:
		b: Byte
		h: Word
		w: DWord
		g: QWord(四字节)

	f: 代表显示格式：
		x: 十六进制
		d: 十进制
		t: 二进制
		c: 字符
