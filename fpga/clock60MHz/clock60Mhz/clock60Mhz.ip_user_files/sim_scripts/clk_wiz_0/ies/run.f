-makelib ies/xil_defaultlib -sv \
  "/home/Xilinx_2017.1/Vivado/2017.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies/xpm \
  "/home/Xilinx_2017.1/Vivado/2017.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies/xil_defaultlib \
  "../../../../clock60Mhz.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_clk_wiz.v" \
  "../../../../clock60Mhz.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.v" \
-endlib
-makelib ies/xil_defaultlib \
  glbl.v
-endlib

