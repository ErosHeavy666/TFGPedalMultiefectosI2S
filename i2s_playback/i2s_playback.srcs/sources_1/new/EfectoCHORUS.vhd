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

entity EfectoCHORUS is
GENERIC(
    n               :  INTEGER := 1000;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    SW14                  : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC  
); 
end EfectoCHORUS;

architecture Behavioral of EfectoCHORUS is

    signal r_lfsr_reg, l_lfsr_reg : signed (15 downto 0);
    signal r_random, l_random : signed (15 downto 0);
    signal seed_l : signed (15 downto 0) := "0000000001100110";
    signal seed_r : signed (15 downto 0) := "0000000001100110";
        
    signal l_data_out_aux, r_data_out_aux: STD_LOGIC_VECTOR(d_width-1 downto 0);
     
    type fifo_t is array (0 to n-1) of signed(d_width-1 downto 0);
    signal l_data_next_aux, r_data_next_aux, l_data_reg_aux, r_data_reg_aux: fifo_t;
    
    signal filter_select_aux, sample_out_ready_aux : STD_LOGIC;
    --signal counter_reg, counter_next : unsigned (8 downto 0);
    --signal addra_reg, addra_next : STD_LOGIC;
    signal l_data_in_reg, r_data_in_reg : signed (d_width-1  downto 0);
    signal s_axis_data_tready : STD_LOGIC := '1';
    signal m_axis_data_tvalid : STD_LOGIC;
    
component fir_compiler_0 IS
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_data_tvalid : IN STD_LOGIC;
    s_axis_data_tready : OUT STD_LOGIC;
    s_axis_data_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END component;

component fir_filter is
GENERIC(
    d_width         :  INTEGER := 16);
Port (  clk_12megas : in STD_LOGIC; --Entrada del reloj general del sistema de 12MHz
        Reset : in STD_LOGIC;  --Reset síncrono general del Fir
        Sample_In : in signed (d_width-1 downto 0); --Muestras de entrada codificadas en <1,15>
        Sample_In_enable : in STD_LOGIC; --entrada de control que informa de cuando se ha actualizado el
                                         --valor de Sample_In con un pulso activo durante un ciclo de reloj.
        filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
        Sample_Out : out signed (d_width-1 downto 0); --Muestras de salida codificadas en <1,15>
        Sample_Out_ready : out STD_LOGIC); --salida de control que informa de cuando se ha actualizado el
                                           --valor de Sample_Out con un pulso activo durante un ciclo de reloj.
        
end component;

--component fir_filter_pipeline is
--GENERIC(
--    d_width         :  INTEGER := 16);
--Port (  clk_12megas : in STD_LOGIC; --Entrada del reloj general del sistema de 12MHz
--        Reset : in STD_LOGIC;  --Reset síncrono general del Fir
--        Sample_In : in signed (d_width-1 downto 0); --Muestras de entrada codificadas en <1,15>
--        Sample_In_enable : in STD_LOGIC; --entrada de control que informa de cuando se ha actualizado el
--                                         --valor de Sample_In con un pulso activo durante un ciclo de reloj.
--        filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
--        Sample_Out : out signed (d_width-1 downto 0); --Muestras de salida codificadas en <1,15>
--        Sample_Out_ready : out STD_LOGIC); --salida de control que informa de cuando se ha actualizado el
--                                           --valor de Sample_Out con un pulso activo durante un ciclo de reloj.
        
--end component;
     
begin

Unit_FIR_Filter_L : fir_filter 
GENERIC MAP(d_width => 16)
PORT MAP (
    clk_12megas => clk,
    Reset => reset_n,
    Sample_In => l_lfsr_reg,
    Sample_In_Enable => enable_in,
    filter_select => filter_select_aux,
    Sample_Out => l_random,
    Sample_Out_ready => open
);

Unit_FIR_Filter_R : fir_filter 
GENERIC MAP(d_width => 16)
PORT MAP (
    clk_12megas => clk,
    Reset => reset_n,
    Sample_In => r_lfsr_reg,
    Sample_In_Enable => enable_in,
    filter_select => filter_select_aux,
    Sample_Out => r_random,
    Sample_Out_ready => open
);

--Unit_FIR_Filter_pipeline_L : fir_filter_pipeline 
--GENERIC MAP(d_width => 16)
--PORT MAP (
--    clk_12megas => clk,
--    Reset => reset_n,
--    Sample_In => signed(l_data_in),
--    Sample_In_Enable => enable_in,
--    filter_select => filter_select_aux,
--    Sample_Out => l_data_in_reg,
--    Sample_Out_ready => open
--);

--Unit_FIR_Filter_pipeline_R : fir_filter_pipeline 
--GENERIC MAP(d_width => 16)
--PORT MAP (
--    clk_12megas => clk,
--    Reset => reset_n,
--    Sample_In => signed(r_data_in),
--    Sample_In_Enable => enable_in,
--    filter_select => filter_select_aux,
--    Sample_Out => r_data_in_reg,
--    Sample_Out_ready => sample_out_ready_aux
--);

--Unit_Fir_compiler_0_r : Fir_compiler_0 PORT MAP (
--    aclk                => clk     ,          
--    s_axis_data_tvalid  => enable_in, 
--    s_axis_data_tready  => s_axis_data_tready, 
--    s_axis_data_tdata   => std_logic_vector(r_lfsr_reg),  
--    m_axis_data_tvalid  => m_axis_data_tvalid, 
--    m_axis_data_tdata   => r_random
--);

--Unit_Fir_compiler_0_l : Fir_compiler_0 PORT MAP (
--    aclk                => clk     ,          
--    s_axis_data_tvalid  => enable_in, 
--    s_axis_data_tready  => s_axis_data_tready, 
--    s_axis_data_tdata   => std_logic_vector(l_lfsr_reg),  
--    m_axis_data_tvalid  => m_axis_data_tvalid, 
--    m_axis_data_tdata   => l_random
--);

process(SW14)
begin
    if(SW14 = '1') then
        filter_select_aux <= '1';
    else
        filter_select_aux <= '0';
    end if;
end process;

process(clk, reset_n, enable_in)
begin
    if reset_n = '1' then 
        l_data_reg_aux <= (others => (others => '0')); 
        r_data_reg_aux <= (others => (others => '0'));
    elsif (rising_edge(clk)) then --MCLK
        if(enable_in = '1')then
            l_data_reg_aux <= l_data_next_aux;
            r_data_reg_aux <= r_data_next_aux;
        end if;
    end if;
end process;

process(clk, reset_n, enable_in, seed_l, seed_r, l_lfsr_reg, r_lfsr_reg)
begin
    if(reset_n = '1') then
        l_lfsr_reg <= (others=>'0');
        r_lfsr_reg <= (others=>'0');    
    elsif(rising_edge(clk)) then
        if(enable_in = '1') then
            l_lfsr_reg <= seed_l;
            r_lfsr_reg <= seed_r;
       
            l_lfsr_reg(0) <= l_lfsr_reg(7);
            l_lfsr_reg(1) <= l_lfsr_reg(0);
            l_lfsr_reg(2) <= l_lfsr_reg(1) xnor l_lfsr_reg(7);
            l_lfsr_reg(3) <= l_lfsr_reg(2) xnor l_lfsr_reg(7);
            l_lfsr_reg(4) <= l_lfsr_reg(3) xnor l_lfsr_reg(7);
            l_lfsr_reg(5) <= l_lfsr_reg(4);
            l_lfsr_reg(6) <= l_lfsr_reg(5);
            l_lfsr_reg(7) <= l_lfsr_reg(6);
                        
            r_lfsr_reg(0) <= r_lfsr_reg(7);
            r_lfsr_reg(1) <= r_lfsr_reg(0);
            r_lfsr_reg(2) <= r_lfsr_reg(1) xnor r_lfsr_reg(7);
            r_lfsr_reg(3) <= r_lfsr_reg(2) xnor r_lfsr_reg(7);
            r_lfsr_reg(4) <= r_lfsr_reg(3) xnor r_lfsr_reg(7);
            r_lfsr_reg(5) <= r_lfsr_reg(4);
            r_lfsr_reg(6) <= r_lfsr_reg(5);
            r_lfsr_reg(7) <= r_lfsr_reg(6);
            
      end if;
    end if;
end process;

process (l_data_out_aux, r_data_out_aux, l_data_reg_aux, r_data_reg_aux)
begin
    l_data_next_aux(0) <= signed(l_data_out_aux);
    r_data_next_aux(0) <= signed(r_data_out_aux);
    for i in 1 to n-1 loop
        l_data_next_aux(i) <= l_data_reg_aux(i-1);
        r_data_next_aux(i) <= r_data_reg_aux(i-1);
    end loop;
end process;

process(clk, reset_n, enable_in)
begin
    if reset_n = '1' then
        l_data_out_aux <= (others => '0');
        r_data_out_aux <= (others => '0');
        enable_out <= '0';
    elsif (rising_edge(clk)) then --MCLK
        enable_out <= enable_in;
        if(enable_in = '1')then
            l_data_out_aux <= std_logic_vector(signed(l_data_in)/2 + shift_right(l_data_reg_aux(n-to_integer(unsigned(l_random))-1),1));
            r_data_out_aux <= std_logic_vector(signed(r_data_in)/2 + shift_right(r_data_reg_aux(n-to_integer(unsigned(r_random))-1),1));
        end if;
    end if;
end process;
l_data_out <= l_data_out_aux;
r_data_out <= r_data_out_aux;
--enable_out <= sample_out_ready_aux; 

end Behavioral;
