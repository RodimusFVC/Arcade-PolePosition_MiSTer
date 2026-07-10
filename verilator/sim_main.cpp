// ============================================================================
//  sim_main.cpp — headless Verilator co-sim harness for the z8002 core
//
//  The C++ side is the "board": it owns a 64 KB BIG-ENDIAN memory, drives the
//  clock/reset, services the CPU bus every cycle, and prints an instruction
//  trace.  This is where the golden-trace diff against MAME will plug in later.
//
//  Build:  make            (in this directory)
//  Run:    ./obj_dir/Vz8002 [--program file.bin] [--cycles N] [--trace]
//
//  Default (no --program) runs a tiny fetch-only demo to prove the flow:
//  the skeleton core fetches words until the 0x7A00 sentinel and halts.
// ============================================================================

#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vz8002.h"

#include <cstdio>
#include <cstdint>
#include <cstring>
#include <cstdlib>

static uint8_t  mem[65536];
static uint64_t main_time = 0;
double sc_time_stamp() { return (double)main_time; }

// Z8000 is big-endian: high byte at the lower (even) address.
static inline uint16_t rd16(uint16_t a) {
    return (uint16_t(mem[a]) << 8) | mem[uint16_t(a + 1)];
}
static inline void wr16(uint16_t a, uint16_t d, bool word) {
    if (word) { mem[a] = uint8_t(d >> 8); mem[uint16_t(a + 1)] = uint8_t(d); }
    else      { mem[(a & 1) ? a : a] = uint8_t(d); } // byte write refined later
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    const char* prog   = nullptr;
    long        cycles = 64;
    bool        do_trace = false;
    for (int i = 1; i < argc; i++) {
        if      (!strcmp(argv[i], "--program") && i + 1 < argc) prog = argv[++i];
        else if (!strcmp(argv[i], "--cycles")  && i + 1 < argc) cycles = atol(argv[++i]);
        else if (!strcmp(argv[i], "--trace"))                   do_trace = true;
    }

    memset(mem, 0, sizeof(mem));
    if (prog) {
        FILE* f = fopen(prog, "rb");
        if (!f) { fprintf(stderr, "cannot open %s\n", prog); return 1; }
        fread(mem, 1, sizeof(mem), f);
        fclose(f);
    } else {
        // fetch-only demo (big-endian words); 0x7A00 = HALT sentinel
        const uint16_t demo[] = { 0x0000, 0x1111, 0x2222, 0x3333, 0x7A00 };
        for (unsigned i = 0; i < sizeof(demo) / 2; i++) {
            mem[i * 2]     = uint8_t(demo[i] >> 8);
            mem[i * 2 + 1] = uint8_t(demo[i]);
        }
    }

    Vz8002* top = new Vz8002;
    VerilatedVcdC* tfp = nullptr;
    if (do_trace) {
        Verilated::traceEverOn(true);
        tfp = new VerilatedVcdC;
        top->trace(tfp, 99);
        tfp->open("z8002.vcd");
    }

    auto half = [&](int clk_val) {
        top->din = rd16(top->addr);   // combinational memory read
        top->clk = clk_val;
        top->eval();
        if (tfp) tfp->dump(main_time++);
    };

    // ---- reset ----
    top->reset_n = 0; top->ce = 1;
    top->nmi_n = 1; top->nvi_n = 1; top->vi_n = 1; top->wait_n = 1;
    for (int i = 0; i < 4; i++) { half(0); half(1); }
    top->reset_n = 1;

    // ---- run ----
    printf("  cyc  pc    ir    fcw   ret\n");
    printf("  ---  ----  ----  ----  ---\n");
    for (long c = 0; c < cycles; c++) {
        half(0);
        half(1);
        if (top->mreq && top->we) wr16(top->addr, top->dout, top->wordacc);
        if (top->dbg_retire)
            printf("  %3ld  %04X  %04X  %04X   %d\n",
                   c, top->dbg_pc, top->dbg_ir, top->dbg_fcw, top->dbg_retire);
    }

    if (tfp) tfp->close();
    delete top;
    return 0;
}
