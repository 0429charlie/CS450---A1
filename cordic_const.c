/* This program generates values of atan(2^-i) for i=0..15 and generates
 * x_0.  All constants are expressed in 16 bit fix-point representation
 * with the decimal point between bit 14 and bit 13.  These values are
 * incorporated into the cordic module stub.  Students don't need to use
 * this file.
 */
#include <stdio.h>
#include <math.h>

int main(void) {
	const int bits = 16;
	int scale = 1 << (bits - 2);
	double A = 1;
	for(int i=0; i<bits; i++) {
		printf("%x\n", (int)(atan(pow(2,-i))*scale + 0.5));
		A *= sqrt(1 + pow(2,-2*i));
	}
	printf("X_0=%x\n", (int)(scale/A +0.5));
}
