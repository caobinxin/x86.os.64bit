/***************************************************
*		版权声明
*
*	本操作系统名为：MINE
*	该操作系统未经授权不得以盈利或非盈利为目的进行开发，
*	只允许个人学习以及公开交流使用
*
*	代码最终所有权及解释权归田宇所有；
*
*	本模块作者：	田宇
*	EMail:		345538255@qq.com
*
*
***************************************************/

#ifndef __LIB_H__
#define __LIB_H__


#define NULL 0

#define container_of(ptr,type,member)							\
({											\
	typeof(((type *)0)->member) * p = (ptr);					\
	(type *)((unsigned long)p - (unsigned long)&(((type *)0)->member));		\
})


#define sti() 		__asm__ __volatile__ ("sti	\n\t":::"memory")
#define cli()	 	__asm__ __volatile__ ("cli	\n\t":::"memory")
#define nop() 		__asm__ __volatile__ ("nop	\n\t")
#define io_mfence() 	__asm__ __volatile__ ("mfence	\n\t":::"memory")


struct List
{
	struct List * prev;
	struct List * next;
};


/*

*/

#define port_insw(port,buffer,nr)	\
__asm__ __volatile__("cld;rep;insw;mfence;"::"d"(port),"D"(buffer),"c"(nr):"memory")

#define port_outsw(port,buffer,nr)	\
__asm__ __volatile__("cld;rep;outsw;mfence;"::"d"(port),"S"(buffer),"c"(nr):"memory")

#endif
extern void list_init(struct List * list);
extern void list_add_to_behind(struct List * entry,struct List * new);	////add to entry behind
extern void list_add_to_before(struct List * entry,struct List * new);	////add to entry behind
extern void list_del(struct List * entry);
extern long list_is_empty(struct List * entry);
extern struct List * list_prev(struct List * entry);
extern struct List * list_next(struct List * entry);
extern void * memcpy(void *From,void * To,long Num);
extern int memcmp(void * FirstPart,void * SecondPart,long Count);
extern void * memset(void * Address,unsigned char C,long Count);
extern char * strcpy(char * Dest,char * Src);
extern char * strncpy(char * Dest,char * Src,long Count);
extern char * strcat(char * Dest,char * Src);
extern int strcmp(char * FirstPart,char * SecondPart);
extern int strncmp(char * FirstPart,char * SecondPart,long Count);
extern int strlen(char * String);
extern unsigned long bit_set(unsigned long * addr,unsigned long nr);
extern unsigned long bit_get(unsigned long * addr,unsigned long nr);
extern unsigned long bit_clean(unsigned long * addr,unsigned long nr);
extern unsigned char io_in8(unsigned short port);
extern unsigned int io_in32(unsigned short port);
extern void io_out8(unsigned short port,unsigned char value);
extern void io_out32(unsigned short port,unsigned int value);
