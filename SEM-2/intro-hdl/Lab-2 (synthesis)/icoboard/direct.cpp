#include <stdio.h>
#include <stdlib.h>
#include "Vdirect.h"
#include "verilated.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    //instantiated a testbench for the module "direct"
    Vdirect *tb = new Vdirect;
    
    //loop for t=20 time units
    for (int t=0; t<20; t++) {
        //change input
        tb->inp = t&1;
        //and evaluate 
        tb->eval();
        printf("i = %2d, inp = %2d, outp = %2d\n", t, tb->inp, tb->outp);
    }

}

