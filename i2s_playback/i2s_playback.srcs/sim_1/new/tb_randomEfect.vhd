----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2019 16:19:38
-- Design Name: 
-- Module Name: tb_randomEfect - Behavioral
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
use STD.textio.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_randomEfect is
--  Port ( );
end tb_randomEfect;


architecture Behavioral of tb_randomEfect is

constant d_width : INTEGER := 16;

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
    enable_out            :out STD_LOGIC  
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
    n               :  INTEGER := 2500;
    d_width         :  INTEGER := 16);
Port ( 
    clk                   : in STD_LOGIC;
    reset_n               : in STD_LOGIC;
    enable_in             : in STD_LOGIC;
    l_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    l_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    r_data_in             : in STD_LOGIC_VECTOR (d_width-1  downto 0); -- STD_LOGIC;
    r_data_out            : out STD_LOGIC_VECTOR (d_width-1  downto 0);
    enable_out            :out STD_LOGIC  
);
end component;

signal clk, reset_n, enable_in, enable_out : STD_LOGIC:='0';
--signal l_data_out, r_data_out : STD_LOGIC_VECTOR (d_width-1  downto 0);


file data_in_file: text OPEN read_mode IS "C:\Vivado\i2s_playback\sample_in.dat";
file data_out_file: text OPEN write_mode IS "C:\Vivado\i2s_playback\sample_out.dat";
signal Sample_In, sample_out : STD_LOGIC_VECTOR (15 downto 0);
signal en_tx, en_rx : STD_LOGIC := '1';
constant  clk_period : time := 10ns;

begin
clk_process :process
begin    
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process; 

--Unit_EfectDELAY : EfectoDELAY 
--GENERIC MAP(n => 4000, d_width => 16)
--PORT MAP(
--     clk => clk,
--     reset_n => reset_n, 
--     enable_in => enable_in,
--     l_data_in => Sample_In, 
--     l_data_out => open, 
--     r_data_in => Sample_In, 
--     r_data_out => Sample_out,
--     enable_out => enable_out
--); 

Unit_EfectCHORUS : EfectoCHORUS
GENERIC MAP(n => 1000, d_width => 16)
PORT MAP(
     clk => clk,
     reset_n => reset_n, 
     enable_in => enable_in,
     l_data_in => Sample_In, 
     l_data_out => open, 
     r_data_in => Sample_In, 
     r_data_out => Sample_out,
     enable_out => enable_out
); 

--Unit_EfectREVERB : EfectoREVERB
--GENERIC MAP(n => 2500, d_width => 16)
--PORT MAP(
--     clk => clk,
--     reset_n => reset_n, 
--     enable_in => enable_in,
--     l_data_in => Sample_In, 
--     l_data_out => open, 
--     r_data_in => Sample_In, 
--     r_data_out => Sample_out,
--     enable_out => enable_out
--); 

process(clk)
VARIABLE in_line : line;
VARIABLE in_read_ok : BOOLEAN;
VARIABLE in_int : integer;
begin
    if(rising_edge(clk))then
       if NOT endfile(data_in_file) then
         ReadLine(data_in_file,in_line);
         report "line: " & in_line.all;
         Read(in_line, in_int, in_read_ok);
         Sample_In <= std_logic_vector(to_signed(in_int, 16)); -- 16 = the bit width
         enable_in <= '1';
       else
         assert false report "Simulation Finished" severity failure;
          
       end if;
    end if;
end process;

write_process: PROCESS(clk, enable_in, Sample_Out)
VARIABLE out_line : line;
VARIABLE out_int : integer;
VARIABLE out_integer : integer;
begin
    if (rising_edge(clk)) then
        if(enable_out = '1') then
            out_integer := to_integer(signed(Sample_out));
            Write(out_line, out_integer);
            Writeline(data_out_file, out_line);
        end if;
    end if;
end process;

Stim_proc : process
begin
    reset_n <= '1';
    wait for CLK_period*7;
    reset_n <= '0';       
    wait;
end process;


end Behavioral;
