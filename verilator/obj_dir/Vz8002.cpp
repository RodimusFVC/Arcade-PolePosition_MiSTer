// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vz8002.h for the primary calling header

#include "Vz8002.h"
#include "Vz8002__Syms.h"

//==========

VerilatedContext* Vz8002::contextp() {
    return __VlSymsp->_vm_contextp__;
}

void Vz8002::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vz8002::eval\n"); );
    Vz8002__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        vlSymsp->__Vm_activity = true;
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("../rtl/cpu/z8002/z8002.sv", 21, "",
                "Verilated model didn't converge\n"
                "- See https://verilator.org/warn/DIDNOTCONVERGE");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vz8002::_eval_initial_loop(Vz8002__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("../rtl/cpu/z8002/z8002.sv", 21, "",
                "Verilated model didn't DC converge\n"
                "- See https://verilator.org/warn/DIDNOTCONVERGE");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vz8002::_sequent__TOP__2(Vz8002__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::_sequent__TOP__2\n"); );
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    CData/*1:0*/ __Vdly__z8002__DOT__state;
    // Body
    __Vdly__z8002__DOT__state = vlTOPp->z8002__DOT__state;
    if ((1U & (~ (IData)(vlTOPp->reset_n)))) {
        vlTOPp->z8002__DOT__fcw = 0x5000U;
    }
    if (vlTOPp->reset_n) {
        if (vlTOPp->ce) {
            vlTOPp->z8002__DOT__retire = 0U;
            if ((0U == (IData)(vlTOPp->z8002__DOT__state))) {
                vlTOPp->z8002__DOT__ir = vlTOPp->din;
                if ((0x7a00U == (IData)(vlTOPp->din))) {
                    __Vdly__z8002__DOT__state = 1U;
                } else {
                    vlTOPp->z8002__DOT__pc = (0xffffU 
                                              & ((IData)(2U) 
                                                 + (IData)(vlTOPp->z8002__DOT__pc)));
                    vlTOPp->z8002__DOT__retire = 1U;
                }
            } else if ((1U != (IData)(vlTOPp->z8002__DOT__state))) {
                __Vdly__z8002__DOT__state = 0U;
            }
        }
    } else {
        vlTOPp->z8002__DOT__pc = 0U;
        __Vdly__z8002__DOT__state = 0U;
        vlTOPp->z8002__DOT__ir = 0U;
        vlTOPp->z8002__DOT__retire = 0U;
    }
    vlTOPp->z8002__DOT__state = __Vdly__z8002__DOT__state;
    vlTOPp->dbg_fcw = vlTOPp->z8002__DOT__fcw;
    vlTOPp->dbg_retire = vlTOPp->z8002__DOT__retire;
    vlTOPp->dbg_ir = vlTOPp->z8002__DOT__ir;
    vlTOPp->mreq = (0U == (IData)(vlTOPp->z8002__DOT__state));
    vlTOPp->addr = vlTOPp->z8002__DOT__pc;
    vlTOPp->dbg_pc = vlTOPp->z8002__DOT__pc;
}

void Vz8002::_eval(Vz8002__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::_eval\n"); );
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (((IData)(vlTOPp->clk) & (~ (IData)(vlTOPp->__Vclklast__TOP__clk)))) {
        vlTOPp->_sequent__TOP__2(vlSymsp);
        vlTOPp->__Vm_traceActivity[1U] = 1U;
    }
    // Final
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
}

VL_INLINE_OPT QData Vz8002::_change_request(Vz8002__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::_change_request\n"); );
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData Vz8002::_change_request_1(Vz8002__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::_change_request_1\n"); );
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vz8002::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vz8002::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((ce & 0xfeU))) {
        Verilated::overWidthError("ce");}
    if (VL_UNLIKELY((reset_n & 0xfeU))) {
        Verilated::overWidthError("reset_n");}
    if (VL_UNLIKELY((wait_n & 0xfeU))) {
        Verilated::overWidthError("wait_n");}
    if (VL_UNLIKELY((nmi_n & 0xfeU))) {
        Verilated::overWidthError("nmi_n");}
    if (VL_UNLIKELY((nvi_n & 0xfeU))) {
        Verilated::overWidthError("nvi_n");}
    if (VL_UNLIKELY((vi_n & 0xfeU))) {
        Verilated::overWidthError("vi_n");}
}
#endif  // VL_DEBUG
