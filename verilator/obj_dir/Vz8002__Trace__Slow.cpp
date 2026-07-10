// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vz8002__Syms.h"


//======================

void Vz8002::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void Vz8002::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vz8002__Syms* __restrict vlSymsp = static_cast<Vz8002__Syms*>(userp);
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    Vz8002::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void Vz8002::traceInitTop(void* userp, VerilatedVcd* tracep) {
    Vz8002__Syms* __restrict vlSymsp = static_cast<Vz8002__Syms*>(userp);
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void Vz8002::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    Vz8002__Syms* __restrict vlSymsp = static_cast<Vz8002__Syms*>(userp);
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBit(c+6,"clk", false,-1);
        tracep->declBit(c+7,"ce", false,-1);
        tracep->declBit(c+8,"reset_n", false,-1);
        tracep->declBus(c+9,"addr", false,-1, 15,0);
        tracep->declBus(c+10,"dout", false,-1, 15,0);
        tracep->declBus(c+11,"din", false,-1, 15,0);
        tracep->declBit(c+12,"mreq", false,-1);
        tracep->declBit(c+13,"iorq", false,-1);
        tracep->declBit(c+14,"we", false,-1);
        tracep->declBit(c+15,"wordacc", false,-1);
        tracep->declBit(c+16,"wait_n", false,-1);
        tracep->declBit(c+17,"nmi_n", false,-1);
        tracep->declBit(c+18,"nvi_n", false,-1);
        tracep->declBit(c+19,"vi_n", false,-1);
        tracep->declBus(c+20,"dbg_pc", false,-1, 15,0);
        tracep->declBus(c+21,"dbg_fcw", false,-1, 15,0);
        tracep->declBus(c+22,"dbg_ir", false,-1, 15,0);
        tracep->declBit(c+23,"dbg_retire", false,-1);
        tracep->declBit(c+6,"z8002 clk", false,-1);
        tracep->declBit(c+7,"z8002 ce", false,-1);
        tracep->declBit(c+8,"z8002 reset_n", false,-1);
        tracep->declBus(c+9,"z8002 addr", false,-1, 15,0);
        tracep->declBus(c+10,"z8002 dout", false,-1, 15,0);
        tracep->declBus(c+11,"z8002 din", false,-1, 15,0);
        tracep->declBit(c+12,"z8002 mreq", false,-1);
        tracep->declBit(c+13,"z8002 iorq", false,-1);
        tracep->declBit(c+14,"z8002 we", false,-1);
        tracep->declBit(c+15,"z8002 wordacc", false,-1);
        tracep->declBit(c+16,"z8002 wait_n", false,-1);
        tracep->declBit(c+17,"z8002 nmi_n", false,-1);
        tracep->declBit(c+18,"z8002 nvi_n", false,-1);
        tracep->declBit(c+19,"z8002 vi_n", false,-1);
        tracep->declBus(c+20,"z8002 dbg_pc", false,-1, 15,0);
        tracep->declBus(c+21,"z8002 dbg_fcw", false,-1, 15,0);
        tracep->declBus(c+22,"z8002 dbg_ir", false,-1, 15,0);
        tracep->declBit(c+23,"z8002 dbg_retire", false,-1);
        tracep->declBus(c+1,"z8002 pc", false,-1, 15,0);
        tracep->declBus(c+2,"z8002 fcw", false,-1, 15,0);
        tracep->declBus(c+3,"z8002 ir", false,-1, 15,0);
        tracep->declBus(c+24,"z8002 RESET_FCW", false,-1, 15,0);
        tracep->declBus(c+25,"z8002 RESET_PC", false,-1, 15,0);
        tracep->declBus(c+26,"z8002 S_FETCH", false,-1, 1,0);
        tracep->declBus(c+27,"z8002 S_HALT", false,-1, 1,0);
        tracep->declBus(c+4,"z8002 state", false,-1, 1,0);
        tracep->declBit(c+5,"z8002 retire", false,-1);
    }
}

void Vz8002::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void Vz8002::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    Vz8002__Syms* __restrict vlSymsp = static_cast<Vz8002__Syms*>(userp);
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void Vz8002::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    Vz8002__Syms* __restrict vlSymsp = static_cast<Vz8002__Syms*>(userp);
    Vz8002* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullSData(oldp+1,(vlTOPp->z8002__DOT__pc),16);
        tracep->fullSData(oldp+2,(vlTOPp->z8002__DOT__fcw),16);
        tracep->fullSData(oldp+3,(vlTOPp->z8002__DOT__ir),16);
        tracep->fullCData(oldp+4,(vlTOPp->z8002__DOT__state),2);
        tracep->fullBit(oldp+5,(vlTOPp->z8002__DOT__retire));
        tracep->fullBit(oldp+6,(vlTOPp->clk));
        tracep->fullBit(oldp+7,(vlTOPp->ce));
        tracep->fullBit(oldp+8,(vlTOPp->reset_n));
        tracep->fullSData(oldp+9,(vlTOPp->addr),16);
        tracep->fullSData(oldp+10,(vlTOPp->dout),16);
        tracep->fullSData(oldp+11,(vlTOPp->din),16);
        tracep->fullBit(oldp+12,(vlTOPp->mreq));
        tracep->fullBit(oldp+13,(vlTOPp->iorq));
        tracep->fullBit(oldp+14,(vlTOPp->we));
        tracep->fullBit(oldp+15,(vlTOPp->wordacc));
        tracep->fullBit(oldp+16,(vlTOPp->wait_n));
        tracep->fullBit(oldp+17,(vlTOPp->nmi_n));
        tracep->fullBit(oldp+18,(vlTOPp->nvi_n));
        tracep->fullBit(oldp+19,(vlTOPp->vi_n));
        tracep->fullSData(oldp+20,(vlTOPp->dbg_pc),16);
        tracep->fullSData(oldp+21,(vlTOPp->dbg_fcw),16);
        tracep->fullSData(oldp+22,(vlTOPp->dbg_ir),16);
        tracep->fullBit(oldp+23,(vlTOPp->dbg_retire));
        tracep->fullSData(oldp+24,(0x5000U),16);
        tracep->fullSData(oldp+25,(0U),16);
        tracep->fullCData(oldp+26,(0U),2);
        tracep->fullCData(oldp+27,(1U),2);
    }
}
