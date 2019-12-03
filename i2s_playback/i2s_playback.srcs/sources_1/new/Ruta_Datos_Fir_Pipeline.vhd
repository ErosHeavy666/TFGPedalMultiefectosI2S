----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2019 18:47:33
-- Design Name: 
-- Module Name: Ruta_Datos_Fir_Pipeline - Behavioral
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

entity Ruta_Datos_Fir_Pipeline is
GENERIC(
    d_width         :  INTEGER := 16);
Port (  s_M12: in STD_LOGIC_VECTOR(2 downto 0); --Señan de control del Mux con los registros R1 y R2
        s_M3: in STD_LOGIC; --Señal de control del Mux para el registro R3
        clk_12megas: in STD_LOGIC; --Entrada del reloj general del sistema de 12MHz
        reset: in STD_LOGIC; --Reset síncrono general del Fir
        Sample_In : in signed (d_width-1 downto 0); --Muestras de entrada codificadas en <1,7>
        Sample_In_enable : in STD_LOGIC;--entrada de control que informa de cuando se ha actualizado el
                                        --valor de Sample_In con un pulso activo durante un ciclo de reloj.
        filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
        Sample_Out : out signed (d_width-1 downto 0) --Muestras de salida codificadas en <1,7>
       ); 
end Ruta_Datos_Fir_Pipeline;

architecture Behavioral of Ruta_Datos_Fir_Pipeline is

signal x0,x1,x2,x3,x4 : SIGNED (d_width-1 downto 0); --Señales auxiliares para los registros de la ruta de datos
signal c0,c1,c2,c3,c4 : SIGNED (d_width-1 downto 0);  --Coeficientes del filtrado FIR

component reg is --Declaracion estructural para el fichero reg
    Port (
        clk_12megas: in STD_LOGIC;
        enable: in STD_LOGIC;
        reset: in STD_LOGIC;
        dato_in : in SIGNED(d_width-1 downto 0);
        dato_out: out SIGNED(d_width-1 downto 0)
    );
end component;
   --Señales auxiliares de registros y operaciones de lógica combinacional de la ruta de datos diseñada
   
     signal R1_reg, R2_reg, R1_next, R2_next : signed((d_width*2 - 2) downto 0); --Registros R1 y R2
     signal mult_aux: signed((d_width*2 - 1) downto 0); --Multiplicación
     signal R3_reg, R3_next: signed(d_width-1 downto 0); --Registros R3
     signal M3_aux, M2_aux, M1_aux : signed(d_width-1 downto 0); 
     signal mult : signed (d_width*2-2 downto 0);
     signal sample_out_aux : signed(d_width-1 downto 0); 
     
begin

         --FIR-filter-Ruta de datos-Flujo de los datos Xn con sus Cn
reg0: reg
    PORT MAP(
          clk_12megas => clk_12megas,  
          enable =>  Sample_In_enable,
          reset => reset,
          dato_in => Sample_in, --Registramos Sample_In
          dato_out => x0
    );  
reg1: reg                            
    PORT MAP(                        
          clk_12megas => clk_12megas,
          enable =>  Sample_In_enable,
          reset => reset,
          dato_in => x0,      
          dato_out => x1             
    );                               
reg2: reg                            
     PORT MAP(                        
          clk_12megas => clk_12megas,
          enable =>  Sample_In_enable,
          reset => reset,
          dato_in => x1,      
          dato_out => x2             
     );                                                         
reg3: reg                            
    PORT MAP(                        
          clk_12megas => clk_12megas,
          enable =>  Sample_In_enable,
          reset => reset,
          dato_in => x2,      
          dato_out => x3             
    );                               
reg4: reg                            
    PORT MAP(                        
         clk_12megas => clk_12megas,
         enable =>  Sample_In_enable,
         reset => reset,
         dato_in => x3,      
         dato_out => x4             
    );       
  process(clk_12megas) --Proceso que si 
  begin
    if(rising_edge(clk_12megas)) then --detecta un flanco de subida del reloj general del sistema
        if(reset = '1') then --Y el reset se encuentra activado, pondra a cero los registros R1,R2,R3
            R3_reg <= (others => '0');
            R2_reg <= (others => '0');
            R1_reg <= (others => '0');
        else --Y si esta desactivado cargara en el registro de los registros el valor actualizado antes del flanco 
            R3_reg <= R3_next; --sobre el valor combinacional registrado
            R2_reg <= R2_next;
            R1_reg <= R1_next;
        end if;
    end if;
  end process;  

  process(filter_select) --Selección del tipo de filtrado que deseamos realizar
  begin                 --Cargamos el valor de los coeficientes deseados
  
    if (filter_select = '1') then --Hamming Lowpass for CHORUS

        c0 <= "0111111111111111";
        c1 <= (others => '0');
        c2 <= (others => '0');
        c3 <= (others => '0');
        c4 <= (others => '0'); 
              
    else --Noise

        c0 <= (others => '0');
        c1 <= (others => '0');
        c2 <= (others => '0');
        c3 <= (others => '0');
        c4 <= (others => '0'); 
         
    end if;
  end process;
       --Proceso encargado de suministrar los coeficientes de Cn a las señales de ruta Xn
   process (s_M12,M1_aux,M2_aux,c0,c1,c2,c3,c4,x0,x1,x2,x3,x4) 
            begin
            case s_M12 is
              when "000"  => 
                    M1_aux <= c0;
                    M2_aux <= x0;
              when "001"  => 
                    M1_aux <= c1;
                    M2_aux <= x1;
              when "010"  =>
                    M1_aux <= c2;
                    M2_aux <= x2;
              when "011"  =>
                    M1_aux <= c3;
                    M2_aux <= x3;
              when others  => 
                    M1_aux <= c4;
                    M2_aux <= x4;      
            end case;
       end process;
   --Proceso que multiplica las señales del flujo por los correspondientes coeficientes       
   process(M1_aux, M2_aux, mult_aux)
        begin
            mult_aux <= M1_aux * M2_aux; --Cn*Xn
            mult <= mult_aux(d_width*2-2 downto 0);
   end process;
    --Proceso que carga en R1 el valor de mult    
   process(mult)
        begin
            R1_next <= mult;    
   end process;
        --Proceso que carga en R2 el valor de R1, la síntesis esto la va a asociar como dos medios multiplicadores
  process(R1_reg)
        begin    
            R2_next <= R1_reg;    
  end process;
        --Proceso que coloca a la salida del Mux3 el R3 o "00000000"
  process(s_M3, R3_reg)
        begin
            if(s_M3 = '1') then
                 M3_aux <=  R3_reg;
            else 
                 M3_aux <= (others => '0');
             end if;            
  end process;
         --Proceso que suma la salida del Mux3 con los 8 bits más significativos del registro R2 y los asocia a R3
  process(R2_reg, M3_aux)
        begin         
            R3_next <= R2_reg(d_width*2-2 downto d_width*2-2-15) + M3_aux;
  end process;
        --Proceso que asigna a la señal auxiliar de salida el valor del registro R3 calcilado anteriormente 
  process(R3_reg)
        begin 
            sample_out_aux <= R3_reg(d_width-1 downto 0);
  end process;
        
        --Asignación de la salida tras haber realizado toda la lógica combinacional
        --Esta sentencia es equivalente a:
        --reg5: reg                            
        --    PORT MAP(                        
        --         clk_12megas => clk_12megas,
        --         enable =>  Sample_In_enable,
        --         reset => reset,
        --         dato_in => sample_out_aux,      
        --         dato_out => Sample_Out             
        --    );  
        Sample_out <= sample_out_aux;
        
end Behavioral;
