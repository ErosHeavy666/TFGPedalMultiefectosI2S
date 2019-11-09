----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.10.2019 21:11:55
-- Design Name: 
-- Module Name: Buffer16_IN_OUT - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EfectoREVERB is
GENERIC(
    n               :  INTEGER := 1500;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end EfectoREVERB;

architecture Behavioral of EfectoREVERB is
    type fifo_t is array (0 to n-1) of signed(d_width-1 downto 0);
    signal l_data_next, l_data_reg, r_data_reg, r_data_next, l_data_next_aux, r_data_next_aux, l_data_reg_aux, r_data_reg_aux: fifo_t;
    signal l_data_out_aux, r_data_out_aux: STD_LOGIC_VECTOR(d_width-1 downto 0); 
begin

process(clk, reset_n, enable_in)
begin
    if reset_n = '1' then
        l_data_reg <= (others => (others => '0'));
        r_data_reg <= (others => (others => '0'));  
        l_data_reg_aux <= (others => (others => '0')); 
        r_data_reg_aux <= (others => (others => '0'));
    elsif (rising_edge(clk)) then --MCLK
        if(enable_in = '1')then
            l_data_reg <= l_data_next;
            r_data_reg <= r_data_next;
            l_data_reg_aux <= l_data_next_aux;
            r_data_reg_aux <= r_data_next_aux;
        end if;
    end if;
end process;

process (l_data_in, l_data_reg, r_data_in, r_data_reg)
begin
    l_data_next(0) <= signed(l_data_in);
    r_data_next(0) <= signed(r_data_in);
    for i in 1 to n-1 loop
        l_data_next(i) <= l_data_reg(i-1);
        r_data_next(i) <= r_data_reg(i-1);
    end loop;
end process;

process (l_data_out_aux, r_data_out_aux, l_data_reg_aux, r_data_reg_aux)
begin
    l_data_next_aux(0) <= signed(l_data_out_aux);
    r_data_next_aux(0) <= signed(l_data_out_aux);
    for i in 1 to n-1 loop
        l_data_next_aux(i) <= l_data_reg_aux(i-1);
        r_data_next_aux(i) <= r_data_reg_aux(i-1);
    end loop;
end process;

process(clk, reset_n)
begin
    if reset_n = '1' then
        l_data_out_aux <= (others => '0');
        r_data_out_aux <= (others => '0');
        enable_out <= '0';
    elsif (rising_edge(clk)) then --MCLK
        enable_out <= enable_in;
        if(enable_in = '1')then
            l_data_out_aux <= std_logic_vector(-signed(l_data_in)/2 + shift_right(l_data_reg(n-1),0) + shift_right(l_data_reg_aux(n-1),1));
            r_data_out_aux <= std_logic_vector(-signed(r_data_in)/2 + shift_right(r_data_reg(n-1),0) + shift_right(r_data_reg_aux(n-1),1));
        end if;
    end if;
end process;
l_data_out <= l_data_out_aux;
r_data_out <= r_data_out_aux;     
    
end Behavioral;