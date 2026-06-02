#include "../libuc.h"

static long randomseed = 1;

long rand() {
    randomseed = (randomseed * 1366l + 150889l) % 714025l;
    return randomseed;
}

long random() {
    return rand();
}

