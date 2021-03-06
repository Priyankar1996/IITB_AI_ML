-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/unisims/unisim/VITAL/OBUF_LVCMOS33_S_6.vhd,v 1.1 2008/06/19 16:59:25 vandanad Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 11.1
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                  Output Buffer with LVCMOS33 I/O Standard Slow Slew 6 mA Drive
-- /___/   /\     Filename : OBUF_LVCMOS33_S_6.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:56:19 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL OBUF_LVCMOS33_S_6 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity OBUF_LVCMOS33_S_6 is
  port(
    O : out std_ulogic;

    I : in std_ulogic
    );
end OBUF_LVCMOS33_S_6;

architecture OBUF_LVCMOS33_S_6_V of OBUF_LVCMOS33_S_6 is
begin
  O <= TO_X01(I);
end OBUF_LVCMOS33_S_6_V;


