-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/unisims/unisim/VITAL/IBUFG_LVCMOS33.vhd,v 1.1 2008/06/19 16:59:23 vandanad Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 11.1
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                  Input Clock Buffer with LVCMOS33 I/O Standard
-- /___/   /\     Filename : IBUFG_LVCMOS33.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:55:37 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL IBUFG_LVCMOS33 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IBUFG_LVCMOS33 is
  port(
    O : out std_ulogic;

    I : in std_ulogic
    );
end IBUFG_LVCMOS33;

architecture IBUFG_LVCMOS33_V of IBUFG_LVCMOS33 is
begin
  O <= TO_X01(I);
end IBUFG_LVCMOS33_V;


