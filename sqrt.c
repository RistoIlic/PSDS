#include<stdio.h>
int koren(int x) {
    int op = x;
    int res = 0;
    int one = 1 << 30;

start1:
    if (one > op) {
        one >>= 2;
        goto start1;
    }

start2:
    if (one != 0) {
        if (op >= res + one) {
            op = op - (res + one);
            res = res + 2 * one;
        }
        res >>= 1;
        one >>= 2;
        goto start2;
    }

    return res;
}

int main(){
      int rez=koren(15625);
      printf("Koren=%d",rez);




return 0;
}
