----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2025 05:24:56 PM
-- Design Name: 
-- Module Name: stack_memory_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stack_memory_tb is
--  Port ( );
end stack_memory_tb;

architecture Behavioral of stack_memory_tb is
constant WIDTH_STACK:positive:=8;
 
 signal s_addr_stackX:std_logic_vector(2*WIDTH_STACK-1 downto 0);
 signal s_addr_stackY:std_logic_vector(2*WIDTH_STACK-1 downto 0);
 signal s_we_stackX: std_logic;
 signal s_we_stackY:std_logic;
 signal s_en_stackX:std_logic;
 signal s_en_stackY:std_logic;
 signal s_di_stackX:std_logic_vector(WIDTH_STACK-1 downto 0);
 signal s_di_stackY:std_logic_vector(WIDTH_STACK-1 downto 0);
signal s_clk:std_logic;
signal s_do_stackX:std_logic_vector(WIDTH_STACK-1 downto 0):="00000000";
signal s_do_stackY:std_logic_vector(WIDTH_STACK-1 downto 0):="00000000"; 



begin



duv:entity work.mem_stackX_stackY(Behavioral)
port map( addr_stackX=>s_addr_stackX,
          addr_stackY=>s_addr_stackY,
          we_stackX=>s_we_stackX,
          we_stackY=>s_we_stackY,
          en_stackX=>s_en_stackX,
          en_stackY=>s_en_stackY,
          di_stackX=>s_di_stackX,
          di_stackY=>s_di_stackY,
          clk_stackX=>s_clk,
          clk_stackY=>s_clk,
          do_stackX=>s_do_stackX,
          do_stackY=>s_do_stackY);




clk_gen:process
begin

     s_clk <= '0', '1' after 4ns;
            wait for 8ns; 

end process;



stimulus:process
begin
     wait for 10ns;
     
   for i in 0 to 8 loop
       
 s_addr_stackX<=std_logic_vector(TO_UNSIGNED(i,16));
 s_di_stackX<=std_logic_vector(TO_UNSIGNED(2*i+1,8));
 s_we_stackX<='1';
 s_en_stackX<='0';
  wait for 10ns; 
   
   end loop;



for i in 0 to 8 loop
       
 s_addr_stackY<=std_logic_vector(TO_UNSIGNED(9+i,16));
 s_di_stackY<=std_logic_vector(TO_UNSIGNED(2*i,8));
 s_we_stackY<='1';
 s_en_stackY<='0';
  wait for 10ns; 
   
   end loop;




for i in 0 to 8 loop
       
 s_addr_stackX<=std_logic_vector(TO_UNSIGNED(i,16));
 s_di_stackX<=std_logic_vector(TO_UNSIGNED(2*i+1,8));
 s_we_stackX<='0';
 s_en_stackX<='1';
  wait for 10ns; 
   
   end loop;



for i in 0 to 8 loop
       
 s_addr_stackY<=std_logic_vector(TO_UNSIGNED(9+i,16));
 s_di_stackY<=std_logic_vector(TO_UNSIGNED(2*i,8));
 s_we_stackY<='0';
 s_en_stackY<='1';
  wait for 10ns; 
   
   end loop;







wait;
end process;








































end Behavioral;
