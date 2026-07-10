# Headless Verilator co-sim for the z8002 core (no SDL/GUI).
#   make        build ./obj_dir/Vz8002
#   make run    build + run the built-in demo
#   make clean

VERILATOR ?= verilator
TOP        = z8002
RTL        = ../rtl/cpu/z8002

V_SRC      = $(RTL)/z8002.sv
C_SRC      = sim_main.cpp

VFLAGS     = --cc --exe --build --trace -O3 \
             --top-module $(TOP) -o V$(TOP) -Mdir obj_dir \
             -Wall -Wno-fatal -Wno-UNUSED -Wno-DECLFILENAME \
             -CFLAGS "-O2 -std=c++17"

all:
	$(VERILATOR) $(VFLAGS) $(V_SRC) $(C_SRC)

run: all
	./obj_dir/V$(TOP)

clean:
	rm -rf obj_dir z8002.vcd
