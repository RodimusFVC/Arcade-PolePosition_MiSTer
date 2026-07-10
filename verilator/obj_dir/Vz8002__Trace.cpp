// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vz8002__Syms.h"


void Vz8002::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vz8002__Syms* __restrict vlSymsp = static_cast<Vz8002__Syms*>(userp);
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vz8002::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vz8002__Syms* __restrict vlSymsp = static_cast<Vz8002__Syms*>(userp);
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[1U])) {
            tracep->chgSData(oldp+0,(vlTOPp->z8002__DOT__pc),16);
            tracep->chgSData(oldp+1,(vlTOPp->z8002__DOT__fcw),16);
            tracep->chgSData(oldp+2,(vlTOPp->z8002__DOT__ir),16);
            tracep->chgCData(oldp+3,(vlTOPp->z8002__DOT__state),2);
            tracep->chgBit(oldp+4,(vlTOPp->z8002__DOT__retire));
        }
        tracep->chgBit(oldp+5,(vlTOPp->clk));
        tracep->chgBit(oldp+6,(vlTOPp->ce));
        tracep->chgBit(oldp+7,(vlTOPp->reset_n));
        tracep->chgSData(oldp+8,(vlTOPp->addr),16);
        tracep->chgSData(oldp+9,(vlTOPp->dout),16);
        tracep->chgSData(oldp+10,(vlTOPp->din),16);
        tracep->chgBit(oldp+11,(vlTOPp->mreq));
        tracep->chgBit(oldp+12,(vlTOPp->iorq));
        tracep->chgBit(oldp+13,(vlTOPp->we));
        tracep->chgBit(oldp+14,(vlTOPp->wordacc));
        tracep->chgBit(oldp+15,(vlTOPp->wait_n));
        tracep->chgBit(oldp+16,(vlTOPp->nmi_n));
        tracep->chgBit(oldp+17,(vlTOPp->nvi_n));
        tracep->chgBit(oldp+18,(vlTOPp->vi_n));
        tracep->chgSData(oldp+19,(vlTOPp->dbg_pc),16);
        tracep->chgSData(oldp+20,(vlTOPp->dbg_fcw),16);
        tracep->chgSData(oldp+21,(vlTOPp->dbg_ir),16);
        tracep->chgBit(oldp+22,(vlTOPp->dbg_retire));
    }
}

void Vz8002::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vz8002__Syms* __restrict vlSymsp = static_cast<Vz8002__Syms*>(userp);
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
        vlTOPp->__Vm_traceActivity[1U] = 0U;
    }
}
