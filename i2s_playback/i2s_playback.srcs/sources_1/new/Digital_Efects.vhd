----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.10.2019 16:43:01
-- Design Name: 
-- Module Name: Digital_Efects - Behavioral
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

entity Digital_Efects is
GENERIC(
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC; 
    enable_out            : out STD_LOGIC;
    SW0                   : in STD_LOGIC;
    SW1                   : in STD_LOGIC;
    SW2                   : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0)  
);
end Digital_Efects;

architecture Behavioral of Digital_Efects is

component EfectoES is
GENERIC(
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : IN STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            : out STD_LOGIC
);
end component;

component EfectoDELAY is
GENERIC(
    n               :  INTEGER := 4000;
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
end component;

component EfectoCHORUS is
GENERIC(
    n               :  INTEGER := 1000;
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
end component;

component EfectoREVERB is
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
end component;

component EfectoECO is
GENERIC(
    n               :  INTEGER := 5000;
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
end component;


signal enable_in_DELAY, enable_in_ES, enable_in_CHORUS, enable_in_REVERB, enable_in_REVERB_test: STD_LOGIC;
signal r_data_out_DELAY, l_data_out_DELAY, r_data_in_DELAY, l_data_in_DELAY : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_ES, l_data_out_ES, r_data_in_ES, l_data_in_ES : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_CHORUS, l_data_out_CHORUS, r_data_in_CHORUS, l_data_in_CHORUS : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_REVERB, l_data_out_REVERB, r_data_in_REVERB, l_data_in_REVERB : STD_LOGIC_VECTOR (d_width-1  downto 0);
signal r_data_out_REVERB_test, l_data_out_REVERB_test, r_data_in_REVERB_test, l_data_in_REVERB_test : STD_LOGIC_VECTOR (d_width-1  downto 0);

begin

Unit_EfectES : EfectoES 
GENERIC MAP(d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_ES,
     l_data_in => l_data_in_ES , 
     l_data_out => l_data_out_ES, 
     r_data_in => r_data_in_ES, 
     r_data_out => r_data_out_ES,
     enable_out => enable_out
); 

Unit_EfectDELAY : EfectoDELAY 
GENERIC MAP(n => 4000, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_DELAY,
     l_data_in => l_data_in_DELAY, 
     l_data_out => l_data_out_DELAY, 
     r_data_in => r_data_in_DELAY, 
     r_data_out => r_data_out_DELAY,
     enable_out => enable_out
); 

Unit_EfectCHORUS : EfectoCHORUS
GENERIC MAP(n => 1000, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_CHORUS,
     l_data_in => l_data_in_CHORUS, 
     l_data_out => l_data_out_CHORUS, 
     r_data_in => r_data_in_CHORUS, 
     r_data_out => r_data_out_CHORUS,
     enable_out => enable_out
);

Unit_EfectREVERB : EfectoREVERB
GENERIC MAP(n => 1500, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_REVERB,
     l_data_in => l_data_in_REVERB, 
     l_data_out => l_data_out_REVERB, 
     r_data_in => r_data_in_REVERB, 
     r_data_out => r_data_out_REVERB,
     enable_out => enable_out
);

Unit_EfectECO : EfectoECO
GENERIC MAP(n => 5000, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in_REVERB_test,
     l_data_in => l_data_in_REVERB_test, 
     l_data_out => l_data_out_REVERB_test, 
     r_data_in => r_data_in_REVERB_test, 
     r_data_out => r_data_out_REVERB_test,
     enable_out => enable_out
);

--Process que se encarga de decir que tipo de efecto le vamos a pasar a las muestars
process (SW0, SW1, SW2, enable_in, l_data_out_ES, r_data_out_ES, r_data_out_DELAY, l_data_out_DELAY, l_data_out_CHORUS, r_data_out_CHORUS, r_data_out_REVERB, l_data_out_REVERB, r_data_out_REVERB_test, l_data_out_REVERB_test, l_data_in, r_data_in)
begin
    if (SW0 = '0' AND SW1 = '0' AND SW2 = '0') then --ES
        enable_in_ES <= '1' and enable_in; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0';
        enable_in_REVERB <= '0';
        enable_in_REVERB_test <= '0';
        
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_REVERB_test <= (others => '0');
        r_data_in_REVERB_test <= (others => '0');   
                    
        l_data_in_ES <= l_data_in;
        r_data_in_ES <= r_data_in;        
        l_data_out <= l_data_out_ES;
        r_data_out <= r_data_out_ES;
        
    elsif (SW0 = '1' AND SW1 = '0' AND SW2 = '0') then --DELAY
        enable_in_ES <= '0'; 
        enable_in_DELAY <= '1' and enable_in; 
        enable_in_CHORUS <= '0'; 
        enable_in_REVERB <= '0';
        enable_in_REVERB_test <= '0';
         
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
        l_data_in_REVERB_test <= (others => '0');
        r_data_in_REVERB_test <= (others => '0');
                        
        l_data_in_DELAY <= l_data_in;
        r_data_in_DELAY <= r_data_in;       
        l_data_out <= l_data_out_DELAY;
        r_data_out <= r_data_out_DELAY; 
         
    elsif (SW0 = '0' AND SW1 = '1' AND SW2 = '0') then --CHORUS
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '1' and enable_in;  
        enable_in_REVERB <= '0';
        enable_in_REVERB_test <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0'); 
        l_data_in_REVERB_test <= (others => '0');
        r_data_in_REVERB_test <= (others => '0');
                                
        l_data_in_CHORUS <= l_data_in;
        r_data_in_CHORUS <= r_data_in;       
        l_data_out <= l_data_out_CHORUS;
        r_data_out <= r_data_out_CHORUS;
        
    elsif (SW0 = '1' AND SW1 = '1' AND SW2 = '0') then --REVERB   
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0';  
        enable_in_REVERB <= '1' and enable_in; 
        enable_in_REVERB_test <= '0';
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_REVERB_test <= (others => '0');
        r_data_in_REVERB_test <= (others => '0');
                
        l_data_in_REVERB <= l_data_in;
        r_data_in_REVERB <= r_data_in;       
        l_data_out <= l_data_out_REVERB;
        r_data_out <= r_data_out_REVERB;
        
    elsif (SW0 = '0' AND SW1 = '0' AND SW2 = '1') then --REVERB_test
        enable_in_ES <= '0' ; 
        enable_in_DELAY <= '0'; 
        enable_in_CHORUS <= '0';  
        enable_in_REVERB <= '0'; 
        enable_in_REVERB_test <= '1' and enable_in;
        
        l_data_in_ES <= (others => '0');
        r_data_in_ES <= (others => '0');
        l_data_in_DELAY <= (others => '0');
        r_data_in_DELAY <= (others => '0');
        l_data_in_CHORUS <= (others => '0');
        r_data_in_CHORUS <= (others => '0');
        l_data_in_REVERB <= (others => '0');
        r_data_in_REVERB <= (others => '0');
                
        l_data_in_REVERB_test <= l_data_in;
        r_data_in_REVERB_test <= r_data_in;       
        l_data_out <= l_data_out_REVERB_test;
        r_data_out <= r_data_out_REVERB_test;
    else
       enable_in_ES <= '0' ; 
       enable_in_DELAY <= '0'; 
       enable_in_CHORUS <= '0';  
       enable_in_REVERB <= '0'; 
       enable_in_REVERB_test <= '0';
       
       l_data_in_ES <= (others => '0');
       r_data_in_ES <= (others => '0');
       l_data_in_DELAY <= (others => '0');
       r_data_in_DELAY <= (others => '0');
       l_data_in_CHORUS <= (others => '0');
       r_data_in_CHORUS <= (others => '0');
       l_data_in_REVERB <= (others => '0');
       r_data_in_REVERB <= (others => '0');
       l_data_in_REVERB_test <= (others => '0');
       r_data_in_REVERB_test <= (others => '0');  
       
       l_data_out <= (others => '0');
       r_data_out <= (others => '0');
    end if;
end process;
end Behavioral;
