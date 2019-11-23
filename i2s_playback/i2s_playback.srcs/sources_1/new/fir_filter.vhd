----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eros Garcíia Arroyo y Daniel Payno Zarceño
-- 
-- Create Date: 30.11.2018 12:42:36
-- Design Name: 
-- Module Name: fir_filter - Behavioral
-- Project Name: Sistema de grabación, tratamiento y reproducción de audio
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

entity fir_filter is
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
        
end fir_filter;

architecture Behavioral of fir_filter is

component Ruta_datos_Fir is --Declaracion estructural para el fichero Ruta_Datos_Fir
Port (  s_M12                :  in STD_LOGIC_VECTOR(2 downto 0);
        s_M3                 :  in STD_LOGIC;
        clk_12megas          :  in STD_LOGIC;
        reset                :  in STD_LOGIC;
        Sample_In            :  in signed (d_width-1 downto 0);
        Sample_In_enable     :  in STD_LOGIC;
        filter_select        :  in STD_LOGIC;
        Sample_Out           :  out signed (d_width-1 downto 0)
       );       
end component;

component controlador_fir is --Declaracion estructural para el fichero Controlador

Port (                                    
    clk_12megas       : in STD_LOGIC;                
    reset             : in STD_LOGIC; 
    sample_in_enable  : in STD_LOGIC;                     
    s_M12             : out STD_LOGIC_VECTOR (2 downto 0); 
    s_M3              : out STD_LOGIC;   
    Sample_Out_Ready  : out STD_LOGIC                     
);
end component;

signal s_M12_aux : STD_LOGIC_VECTOR(2 downto 0);
signal s_M3_aux : STD_LOGIC;

begin

U0  : Ruta_datos_Fir 
PORT MAP (
        s_M12               => s_M12_aux,
        s_M3                => s_M3_aux,
        clk_12megas         => clk_12megas,
        reset               => reset,
        Sample_In           => Sample_In,
        Sample_In_enable    => Sample_In_Enable,
        filter_select       => filter_select,
        Sample_Out          => Sample_Out
 );  
 
U1 : controlador_Fir 
PORT MAP (
        clk_12megas         => clk_12megas,
        reset               => reset,
        sample_in_enable    => sample_in_enable,
        s_M12               => s_M12_aux,
        s_M3                => s_M3_aux,  
        Sample_Out_Ready    => Sample_Out_Ready  
);
   
      
end Behavioral;

    
