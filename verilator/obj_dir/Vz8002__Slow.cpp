// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vz8002.h for the primary calling header

#include "Vz8002.h"
#include "Vz8002__Syms.h"

//==========

Vz8002::Vz8002(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModule{_vcname__}
 {
    Vz8002__Syms* __restrict vlSymsp = __VlSymsp = new Vz8002__Syms(_vcontextp__, this, name());
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values

    // Reset structure values
    _ctor_var_reset(this);
}

void Vz8002::__Vconfigure(Vz8002__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    vlSymsp->_vm_contextp__->timeunit(-12);
    vlSymsp->_vm_contextp__->timeprecision(-12);
}

Vz8002::~Vz8002() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = nullptr);
}

void Vz8002::_initial__TOP__1(Vz8002__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::_initial__TOP__1\n"); );
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->iorq = 0U;
    vlTOPp->we = 0U;
    vlTOPp->wordacc = 1U;
    vlTOPp->dout = 0U;
}

void Vz8002::_settle__TOP__3(Vz8002__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::_settle__TOP__3\n"); );
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->addr = vlTOPp->z8002__DOT__pc;
    vlTOPp->mreq = (0U == (IData)(vlTOPp->z8002__DOT__state));
    vlTOPp->dbg_pc = vlTOPp->z8002__DOT__pc;
    vlTOPp->dbg_fcw = vlTOPp->z8002__DOT__fcw;
    vlTOPp->dbg_ir = vlTOPp->z8002__DOT__ir;
    vlTOPp->dbg_retire = vlTOPp->z8002__DOT__retire;
}

void Vz8002::_eval_initial(Vz8002__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::_eval_initial\n"); );
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__1(vlSymsp);
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
}

void Vz8002::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::final\n"); );
    // Variables
    Vz8002__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vz8002::_eval_settle(Vz8002__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::_eval_settle\n"); );
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__3(vlSymsp);
}

void Vz8002::_ctor_var_reset(Vz8002* self) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::_ctor_var_reset\n"); );
    // Body
    if (false && self) {}  // Prevent unused
    self->clk = VL_RAND_RESET_I(1);
    self->ce = VL_RAND_RESET_I(1);
    self->reset_n = VL_RAND_RESET_I(1);
    self->addr = VL_RAND_RESET_I(16);
    self->dout = VL_RAND_RESET_I(16);
    self->din = VL_RAND_RESET_I(16);
    self->mreq = VL_RAND_RESET_I(1);
    self->iorq = VL_RAND_RESET_I(1);
    self->we = VL_RAND_RESET_I(1);
    self->wordacc = VL_RAND_RESET_I(1);
    self->wait_n = VL_RAND_RESET_I(1);
    self->nmi_n = VL_RAND_RESET_I(1);
    self->nvi_n = VL_RAND_RESET_I(1);
    self->vi_n = VL_RAND_RESET_I(1);
    self->dbg_pc = VL_RAND_RESET_I(16);
    self->dbg_fcw = VL_RAND_RESET_I(16);
    self->dbg_ir = VL_RAND_RESET_I(16);
    self->dbg_retire = VL_RAND_RESET_I(1);
    self->z8002__DOT__pc = VL_RAND_RESET_I(16);
    self->z8002__DOT__fcw = VL_RAND_RESET_I(16);
    self->z8002__DOT__ir = VL_RAND_RESET_I(16);
    self->z8002__DOT__state = VL_RAND_RESET_I(2);
    self->z8002__DOT__retire = VL_RAND_RESET_I(1);
    for (int __Vi0=0; __Vi0<2; ++__Vi0) {
        self->__Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }
}
