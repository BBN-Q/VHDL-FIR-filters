# VHDL-FIR-filters

Synthesizable FIR filters in VHDL with a focus on optimal mapping to Xilinx DSP slices.  This repository contains a transposed direct form, systolic form for single-rate FIR filters and a custom parallel polyphase FIR decimating filter. The VHDL has been synthesized with [Xilinx Vivado 2015.1](http://www.xilinx.com/products/design-tools/vivado.html) to confirm the correct DSP cascade chain is inferred.
