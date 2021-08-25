// 01_º¯Êı±¾ÖÊ.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"


int a = 20;
int b = 30;

int sum(int a, int b)
{
	int c = 3;
	int d = 4;
	int e = c + d;

	return a + b + e;
}

int main(int argc, char* argv[])
{

	sum(1, 2);
	
	int c = 0;
	__asm {
		mov c, eax
	}

	printf("%d\n", c);

	return 0;
}

