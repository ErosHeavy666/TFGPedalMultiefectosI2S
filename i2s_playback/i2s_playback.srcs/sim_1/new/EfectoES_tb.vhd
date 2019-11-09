----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2019 19:32:23
-- Design Name: 
-- Module Name: EfectoES_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EfectoES_tb is
--  Port ( );
end EfectoES_tb;

architecture Behavioral of EfectoES_tb is

constant d_width : INTEGER := 16;

component EfectoES is
GENERIC(
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    en_rx                 : in STD_LOGIC;
    enable_ES             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0)  
);
end component;

signal clk, reset_n, en_rx, enable_ES : STD_LOGIC;
signal l_data_in, l_data_out, r_data_in, r_data_out : STD_LOGIC_VECTOR (d_width-1  downto 0);

constant  clk_period : time := 89ns;

begin

Unit_EfectES : EfectoES 
GENERIC MAP(d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     en_rx => en_rx,
     enable_ES => enable_ES,
     l_data_in => l_data_in , 
     l_data_out => l_data_out, 
     r_data_in => r_data_in, 
     r_data_out => r_data_out
);

    clk_process :process
      begin    
          clk <= '0';
          wait for clk_period/2;
          clk <= '1';
          wait for clk_period/2;
      end process; 
      
    stim_proc: process 
      begin
          reset_n <= '1';
          en_rx <= '0';
          enable_ES <= '0';
          l_data_in <= "0000111100001111";
          r_data_in <= "1111000011110000";
          wait for 10*clk_period;
          
          reset_n <= '0';
          en_rx <= '0';
          enable_ES <= '0';
          wait for 10*clk_period; 
  
          reset_n <= '0';
          en_rx <= '1';
          enable_ES <= '0';
          wait for 10*clk_period;
          
          reset_n <= '0';
          en_rx <= '0';
          enable_ES <= '1';
          wait for 10*clk_period;
          
          reset_n <= '0';
          en_rx <= '1';
          enable_ES <= '1';
          wait for 10*clk_period;
          
          reset_n <= '1';
          en_rx <= '1';
          enable_ES <= '1';
          wait;
      end process;
end Behavioral;
