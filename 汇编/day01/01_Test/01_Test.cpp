// 01_Test.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"


int a = 20;
int b = 10;

/*
0040D708   mov         eax,[a (00425168)]
0040D70D   add         eax,dword ptr [b (0042516c)]

0040D708   mov         eax,[a (00425168)]
0040D70D   add         eax,dword ptr [b (0042516c)]
*/


int main(int argc, char* argv[])
{
	int c = a + b;
	int d = 20;
	d = c + d;
	printf("c is %d\n", c);

	return 0;
}

/*
int array[] = {10, 20};
00401028   mov         dword ptr [ebp-8],0Ah
0040102F   mov         dword ptr [ebp-4],14h

struct Student {
	int age;
	int no;
} stu = {10, 20};
00401028   mov         dword ptr [ebp-8],0Ah
0040102F   mov         dword ptr [ebp-4],14h
*/

