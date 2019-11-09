----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2019 18:56:07
-- Design Name: 
-- Module Name: i2s_transceiver_0_tb - Behavioral
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

entity i2s_transceiver_0_tb is
--  Port ( );
end i2s_transceiver_0_tb;

architecture Behavioral of i2s_transceiver_0_tb is

constant d_width : INTEGER := 16;

COMPONENT i2s_transceiver IS
        GENERIC(
        mclk_sclk_ratio  :  INTEGER := 8;    --number of mclk periods per sclk period
        sclk_ws_ratio    :  INTEGER := 64;   --number of sclk periods per word select period
        d_width          :  INTEGER := 16);  --data width
      PORT(
        reset_n    :  IN   STD_LOGIC;                             --asynchronous active low reset
        mclk       :  IN   STD_LOGIC;                             --master clock
        play_enable:  IN   STD_LOGIC;
        -- PMOD
        sclk       :  OUT  STD_LOGIC;                             --serial clock (or bit clock)
        ws         :  OUT  STD_LOGIC;                             --word select (or left-right clock)
        sd_tx      :  OUT  STD_LOGIC;                             --serial data transmit
        sd_rx      :  IN   STD_LOGIC;                             --serial data receive
        
        -- Audio IF
        --en_tx      :  out   STD_LOGIC;
        l_data_tx  :  IN   STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --left channel data to transmit
        r_data_tx  :  IN   STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --right channel data to transmit
        
        en_rx      :  OUT  STD_LOGIC;
        l_data_rx  :  OUT  STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --left channel data received
        r_data_rx  :  OUT  STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --right channel data received
    END COMPONENT;

signal reset_n, m_clk, play_enable, sclk, ws, sd_tx, sd_rx, en_rx : STD_LOGIC := '0';
signal l_data_tx, r_data_tx, l_data_rx, r_data_rx : STD_LOGIC_VECTOR (d_width-1 DOWNTO 0);
signal a,b,c: STD_LOGIC := '0';
constant  clk_period : time := 89ns;

begin

--instantiate I2S Transceiver component
    i2s_transceiver_0: i2s_transceiver
    GENERIC MAP(mclk_sclk_ratio => 8, sclk_ws_ratio => 64, d_width => 16)
    PORT MAP(
        mclk => m_clk, 
        reset_n => reset_n,
        play_enable => play_enable,
        
        sclk => sclk, 
        ws => ws, 
        sd_tx => sd_tx, 
        sd_rx => sd_rx,
        
        --en_tx => en_tx,
        l_data_tx => l_data_tx, 
        r_data_tx => r_data_tx, 
        
        en_rx     => en_rx,
        l_data_rx => l_data_rx, 
        r_data_rx => r_data_rx
    );                                                               
 
    

    stim_proc_a_b_c: process(a,b,c)
    begin        
        a <= not a after 40ns;
        b <= not b after 56ns;
        c <= not c after 73ns;    
    end process; 
    
    clk_process :process
      begin
      sd_rx <= a xor b xor c;      
          m_clk <= '1';
          wait for clk_period/2;
          m_clk <= '0';
          wait for clk_period/2;
      end process;   
       
    stim_proc: process 
    begin
        reset_n <= '1';
        play_enable <= '0';
        r_data_tx <= "0000111100001111";
        l_data_tx <= "1111000011110000";
        wait for 10*clk_period;
        
        reset_n <= '0';
        play_enable <= '0';
        wait for 10*clk_period; 

        reset_n <= '0';
        play_enable <= '1';
        wait;           
    end process;
end Behavioral;
