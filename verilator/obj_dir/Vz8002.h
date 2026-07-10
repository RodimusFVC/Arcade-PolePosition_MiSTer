// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef VERILATED_VZ8002_H_
#define VERILATED_VZ8002_H_  // guard

#include "verilated_heavy.h"

//==========

class Vz8002__Syms;
class Vz8002_VerilatedVcd;


//----------

VL_MODULE(Vz8002) {
  public:

    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_IN8(clk,0,0);
    VL_IN8(ce,0,0);
    VL_IN8(reset_n,0,0);
    VL_OUT8(mreq,0,0);
    VL_OUT8(iorq,0,0);
    VL_OUT8(we,0,0);
    VL_OUT8(wordacc,0,0);
    VL_IN8(wait_n,0,0);
    VL_IN8(nmi_n,0,0);
    VL_IN8(nvi_n,0,0);
    VL_IN8(vi_n,0,0);
    VL_OUT8(dbg_retire,0,0);
    VL_OUT16(addr,15,0);
    VL_OUT16(dout,15,0);
    VL_IN16(din,15,0);
    VL_OUT16(dbg_pc,15,0);
    VL_OUT16(dbg_fcw,15,0);
    VL_OUT16(dbg_ir,15,0);

    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    CData/*1:0*/ z8002__DOT__state;
    CData/*0:0*/ z8002__DOT__retire;
    SData/*15:0*/ z8002__DOT__pc;
    SData/*15:0*/ z8002__DOT__fcw;
    SData/*15:0*/ z8002__DOT__ir;

    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    CData/*0:0*/ __Vclklast__TOP__clk;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;

    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vz8002__Syms* __VlSymsp;  // Symbol table

    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vz8002);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// If contextp is null, then the model will use the default global context
    /// If name is "", then makes a wrapper with a
    /// single model invisible with respect to DPI scope names.
    Vz8002(VerilatedContext* contextp, const char* name = "TOP");
    Vz8002(const char* name = "TOP")
      : Vz8002(nullptr, name) {}
    /// Destroy the model; called (often implicitly) by application code
    ~Vz8002();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options = 0);

    // API METHODS
    /// Return current simulation context for this model.
    /// Used to get to e.g. simulation time via contextp()->time()
    VerilatedContext* contextp();
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();

    // INTERNAL METHODS
    static void _eval_initial_loop(Vz8002__Syms* __restrict vlSymsp);
    void __Vconfigure(Vz8002__Syms* symsp, bool first);
  private:
    static QData _change_request(Vz8002__Syms* __restrict vlSymsp);
    static QData _change_request_1(Vz8002__Syms* __restrict vlSymsp);
    static void _ctor_var_reset(Vz8002* self) VL_ATTR_COLD;
  public:
    static void _eval(Vz8002__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(Vz8002__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(Vz8002__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _initial__TOP__1(Vz8002__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__2(Vz8002__Syms* __restrict vlSymsp);
    static void _settle__TOP__3(Vz8002__Syms* __restrict vlSymsp) VL_ATTR_COLD;
  private:
    static void traceChgSub0(void* userp, VerilatedVcd* tracep);
    static void traceChgTop0(void* userp, VerilatedVcd* tracep);
    static void traceCleanup(void* userp, VerilatedVcd* /*unused*/);
    static void traceFullSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceFullTop0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitTop(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    void traceRegister(VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
