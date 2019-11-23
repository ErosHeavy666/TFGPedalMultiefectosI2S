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
use work.sine_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EfectoVIBRATO is
GENERIC(
    n               :  INTEGER := 500;
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
end EfectoVIBRATO;

architecture Behavioral of EfectoVIBRATO is
type fifo_t is array (0 to n-1) of signed(d_width-1 downto 0);
signal counter_reg, counter_next : unsigned (23 downto 0) := (others => '0');
signal l_data_next, l_data_reg, r_data_reg, r_data_next : fifo_t; 

SIGNAL  wave_out: sine_vector_type;
type state_type is ( counting_up, change_down, counting_down, change_up );
signal state, next_state : state_type;
signal table_index : table_index_type;
signal positive_cycle : boolean;
signal enable_5HZ : STD_LOGIC:= '0';
     
begin

  process( clk, reset_n, enable_in, enable_5HZ )
  begin
    if reset_n = '1' then
      state <= counting_up;
    elsif rising_edge( clk ) then
      if (enable_in = '1' and enable_5HZ = '1') then
        state <= next_state;
      end if;
    end if;
  end process;

  process( state, table_index )
  begin
    next_state <= state;
    case state is
      when counting_up =>
        if table_index = max_table_index then
          next_state <= change_down;
        end if;
      when change_down =>
        next_state <= counting_down;
      when counting_down =>
        if table_index = 0 then
          next_state <= change_up;
        end if;
      when others => -- change_up
        next_state <= counting_up;
    end case;
  end process;

  process( clk, reset_n, enable_in, enable_5HZ )
  begin
    if reset_n = '1' then
      table_index <= 0;
      positive_cycle <= true;
    elsif rising_edge( clk ) then
      if( enable_in = '1' and enable_5HZ = '1') then
        case next_state is
          when counting_up =>
            table_index <= table_index + 1;
          when counting_down =>
            table_index <= table_index - 1;
          when change_up =>
            positive_cycle <= not positive_cycle;
          when others =>
            -- nothing to do
        end case;
      end if;
    end if;
  end process;

  process( table_index, positive_cycle )
    variable table_value: table_value_type;
  begin
    table_value := get_table_value( table_index );
    if positive_cycle then
      wave_out <= std_logic_vector(to_signed(table_value,sine_vector_type'length));
    else
      wave_out <= std_logic_vector(to_signed(-table_value,sine_vector_type'length));
    end if;
  end process;

process(clk, reset_n)
begin
    if reset_n = '1' then
        counter_reg <= (others => '0');
    elsif (rising_edge(clk)) then --MCLK
        counter_reg <= counter_next;
    end if;
end process;

process (counter_reg, enable_5HZ)
begin
    if counter_reg = 16 then
        enable_5HZ <= '1';
        counter_next <= (others => '0');
    else
        enable_5HZ <= '0';
        counter_next <= counter_reg + 1;
    end if;
end process;

process(clk, reset_n, enable_in)
begin
    if reset_n = '1' then
        l_data_reg <= (others => (others => '0'));
        r_data_reg <= (others => (others => '0'));  
    elsif (rising_edge(clk)) then --MCLK
        if(enable_in = '1')then
            l_data_reg <= l_data_next;
            r_data_reg <= r_data_next;
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

process(clk, reset_n, enable_in)
begin
    if reset_n = '1' then
        l_data_out <= (others => '0');
        r_data_out <= (others => '0');
        enable_out <= '0';
    elsif (rising_edge(clk)) then --MCLK
        enable_out <= enable_in;
        if(enable_in = '1')then
            --l_data_out_aux <= std_logic_vector(signed(l_data_in) + shift_right(l_data_reg_aux(n-to_integer(l_random)-1),2));
            --r_data_out_aux <= std_logic_vector(signed(r_data_in) + shift_right(r_data_reg_aux(n-to_integer(r_random)-1),2));
            l_data_out <= std_logic_vector(shift_right(l_data_reg(n-to_integer(unsigned(wave_out))-1),1));
            r_data_out <= std_logic_vector(shift_right(r_data_reg(n-to_integer(unsigned(wave_out))-1),1));
        end if;
    end if;
end process;

end Behavioral;
