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

entity EfectoBANKFILTER is
GENERIC(
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
end EfectoBANKFILTER;

architecture Behavioral of EfectoBANKFILTER is
        
    signal l_data_out_aux, r_data_out_aux: STD_LOGIC_VECTOR(d_width-1 downto 0);
     
    signal l_data_reg, r_data_reg: signed(d_width-1 downto 0);
    
    signal wave_out_retard : sine_vector_type;
    signal filter_select_aux : STD_LOGIC_VECTOR(2 downto 0);
    --signal filter_select_pipeline : STD_LOGIC := '1';
    
    --signal sample_out_ready_aux : STD_LOGIC;
    
    --signal l_data_in_reg, r_data_in_reg : signed (d_width-1  downto 0);
    
component Fir_Filter_bankfilter is
GENERIC(
    d_width         :  INTEGER := 16);
Port (  clk_12megas : in STD_LOGIC; --Entrada del reloj general del sistema de 12MHz
        Reset : in STD_LOGIC;  --Reset síncrono general del Fir
        Sample_In : in signed (d_width-1 downto 0); --Muestras de entrada codificadas en <1,15>
        Sample_In_enable : in STD_LOGIC; --entrada de control que informa de cuando se ha actualizado el
                                         --valor de Sample_In con un pulso activo durante un ciclo de reloj.
        filter_select: in STD_LOGIC_VECTOR(2 downto 0); --0 lowpass, 1 highpass
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

component sine_wave_bankfilter is
  port( clk, reset_n, enable_in: in std_logic;
        wave_out: out sine_vector_type);
end component;
  
signal gain : integer := 8;   

begin

Unit_sine_wave_bankfilter : sine_wave_bankfilter 
PORT MAP(
    clk => clk,
    reset_n => reset_n,
    enable_in => enable_in,
    wave_out => wave_out_retard
);

Unit_FIR_Filter_bankfilter_L : Fir_Filter_bankfilter 
GENERIC MAP(d_width => 16)
PORT MAP (
    clk_12megas => clk,
    Reset => reset_n,
    Sample_In => signed(l_data_in),
    Sample_In_Enable => enable_in,
    filter_select => filter_select_aux,
    Sample_Out => l_data_reg,
    Sample_Out_ready => open
);

Unit_FIR_Filter_bankfilter_R : Fir_Filter_bankfilter 
GENERIC MAP(d_width => 16)
PORT MAP (
    clk_12megas => clk,
    Reset => reset_n,
    Sample_In => signed(r_data_in),
    Sample_In_Enable => enable_in,
    filter_select => filter_select_aux,
    Sample_Out => r_data_reg,
    Sample_Out_ready => open
);

--Unit_FIR_Filter_pipeline_L : fir_filter_pipeline 
--GENERIC MAP(d_width => 16)
--PORT MAP (
--    clk_12megas => clk,
--    Reset => reset_n,
--    Sample_In => signed(l_data_in),
--    Sample_In_Enable => enable_in,
--    filter_select => filter_select_pipeline, --1
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
--    filter_select => filter_select_pipeline, --1
--    Sample_Out => r_data_in_reg,
--    Sample_Out_ready => sample_out_ready_aux
--);

process(wave_out_retard)
begin
    if(wave_out_retard >= "10000001" and wave_out_retard < "10100001") then
        filter_select_aux <= "000";
    elsif(wave_out_retard >= "10100001" and wave_out_retard < "11000001") then
        filter_select_aux <= "110";
    elsif(wave_out_retard >= "11000001" and wave_out_retard < "11100001") then
        filter_select_aux <= "101";  
    elsif(wave_out_retard >= "11100001" and wave_out_retard < "00000000") then
        filter_select_aux <= "100"; 
    elsif(wave_out_retard >= "00000000" and wave_out_retard < "00011111") then
        filter_select_aux <= "011";  
    elsif(wave_out_retard >= "00011111" and wave_out_retard < "00111111") then
        filter_select_aux <= "010";
    elsif(wave_out_retard >= "00111111" and wave_out_retard < "01011111") then
        filter_select_aux <= "001";                             
    else
        filter_select_aux <= "000";     
    end if;
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
            l_data_out <= std_logic_vector(signed(l_data_in)/8 + l_data_reg);
            r_data_out <= std_logic_vector(signed(r_data_in)/8 + r_data_reg);
            --l_data_out <= std_logic_vector(l_data_reg + l_data_reg + l_data_reg + l_data_reg);
            --r_data_out <= std_logic_vector(r_data_reg + r_data_reg + r_data_reg + r_data_reg);          
        end if;
    end if;
end process;

end Behavioral;
