#ifndef __PRINTK_H__
#define __PRINTK_H__

#include <stdarg.h>
struct position{
	int XResolution; // resolution 分辨率
	int YResolution;

	int XPosition;
	int YPosition;

	int XCharSize;
	int YCharSize;

	unsigned int * FB_addr;
	unsigned long FB_length;
}Pos;



#endif
