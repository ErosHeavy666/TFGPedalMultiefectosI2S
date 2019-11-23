----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2018 11:44:32
-- Design Name: 
-- Module Name: sumador - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sumador is
GENERIC(
    d_width         :  INTEGER := 16);
Port ( 
    s_in1: in  SIGNED(d_width-1    downto 0);
    s_in2: in  SIGNED(d_width-1   downto 0);
    y: out  SIGNED (d_width-1    downto 0)
);
end sumador;

architecture Behavioral of sumador is

signal y_aux : SIGNED (d_width   downto 0);

begin

process(s_in1, s_in2) is
    begin
        y_aux <= SIGNED ((s_in1) + (s_in2));
    end process;
        y <= y_aux(d_width - 1 downto 0);
end Behavioral;
