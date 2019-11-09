----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2019 17:58:29
-- Design Name: 
-- Module Name: shift_register - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.project_trunk.all; 

-- Standard shift register as proposed by Dr. Chu (see references)
entity shift_register is
    GENERIC(
    n               :  INTEGER := 16;
    d_width         :  INTEGER := 16);
    
    Port ( clk : in STD_LOGIC;
           en_rx : in STD_LOGIC;
           en_tx : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           l_data_in : in STD_LOGIC_VECTOR (d_width - 1 downto 0);
           l_data_out : out STD_LOGIC_VECTOR (d_width - 1 downto 0);
           r_data_in : in STD_LOGIC_VECTOR (d_width - 1 downto 0);
           r_data_out : out STD_LOGIC_VECTOR (d_width - 1 downto 0)
           );
end shift_register;

architecture Behavioral of shift_register is

    type t_sreg is array (0 to n-1) of signed(d_width-1 downto 0);
    signal r_data, l_data: t_sreg;

begin

process(clk, reset_n, en_rx)
begin
    if (rising_edge(clk)) then
        if(reset_n = '1') then
            r_data <= (others => (others => '0'));
            l_data <= (others => (others => '0'));
        elsif(en_rx = '1') then
            r_data(0) <= signed (r_data_in);
            l_data(0) <= signed (l_data_in);
            for idx_r in 1 to r_data'length-1 loop
                r_data(idx_r) <= r_data(idx_r-1);
            end loop;
            for idx_l in 1 to l_data'length-1 loop
                l_data(idx_l) <= l_data(idx_l-1);
            end loop; 
        end if;
    end if;
end process;

process(clk, en_tx)
begin
    if (rising_edge(clk)) then --MCLK
        if(en_tx = '1')then
            r_data_out <= std_logic_vector(signed(r_data(r_data'length-1)));
            l_data_out <= std_logic_vector(signed(l_data(l_data'length-1)));
        end if;
    end if;
end process;

end Behavioral;