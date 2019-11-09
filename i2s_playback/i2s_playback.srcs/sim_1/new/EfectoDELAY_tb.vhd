----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2019 19:42:47
-- Design Name: 
-- Module Name: EfectoDELAY_tb - Behavioral
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

entity EfectoDELAY_tb is
--  Port ( );
end EfectoDELAY_tb;

architecture Behavioral of EfectoDELAY_tb is

constant d_width : INTEGER := 16;

component EfectoDELAY is
GENERIC(
     n               :  INTEGER := 32;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    en_rx                 : in STD_LOGIC;
    en_tx                 : in STD_LOGIC;
    enable_DELAY          : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0)  
);
end component;

signal clk, reset_n, en_rx, en_tx, enable_DELAY : STD_LOGIC;
signal l_data_in, l_data_out, r_data_in, r_data_out : STD_LOGIC_VECTOR (d_width-1  downto 0);

constant  clk_period : time := 89ns;

begin

Unit_EfectDELAY : EfectoDELAY 
GENERIC MAP(n => 32, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     en_rx => en_rx,
     en_tx => en_tx,
     enable_DELAY => enable_DELAY,
     l_data_in => l_data_in, 
     l_data_out => l_data_out, 
     r_data_in => r_data_in, 
     r_data_out => r_data_out
); 

    clk_process :process
      begin    
          clk <= '1';
          wait for clk_period/2;
          clk <= '0';
          wait for clk_period/2;
      end process; 

    stim_proc: process 
      begin
          reset_n <= '1';
          en_rx <= '0';
          en_tx <= '0';
          enable_DELAY <= '0';
          l_data_in <= "0000111100001111";
          r_data_in <= "1111000011110000";
          wait for 10*clk_period;
          
          reset_n <= '0';
          en_rx <= '0';
          en_tx <= '0';
          enable_DELAY <= '0';
          wait for 10*clk_period; 
  
          reset_n <= '0';
          en_rx <= '1';
          en_tx <= '0';
          enable_DELAY <= '0';
          wait for 10*clk_period;
          
          reset_n <= '0';
          en_rx <= '0';
          en_tx <= '1';
          enable_DELAY <= '0';
          wait for 10*clk_period;
          
          reset_n <= '0';
          en_rx <= '0';
          en_tx <= '0';
          enable_DELAY <= '1';
          wait for 10*clk_period;
          
          reset_n <= '0';
          en_rx <= '1';
          en_tx <= '1';
          enable_DELAY <= '1';
          wait;
      end process;

end Behavioral;
