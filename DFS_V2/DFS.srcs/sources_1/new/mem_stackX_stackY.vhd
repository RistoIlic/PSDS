----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 11:56:04 AM
-- Design Name: 
-- Module Name: mem_stackX_stackY - Behavioral
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

entity mem_stackX_stackY is
generic(
       WIDTH_STACK:positive:=8;
       SIZE_STACK:positive:=5000
);
 Port ( 
           addr_stackX:in std_logic_vector(2*WIDTH_STACK-1 downto 0);
           addr_stackY:in std_logic_vector(2*WIDTH_STACK-1 downto 0);
           we_stackX:in std_logic;
           we_stackY:in std_logic;
           en_stackX:in std_logic;
           en_stackY:in std_logic;
           di_stackX:in std_logic_vector(WIDTH_STACK-1 downto 0);
           di_stackY:in std_logic_vector(WIDTH_STACK-1 downto 0);
           clk_stackX:in std_logic;
           clk_stackY:in std_logic;
           do_stackX:out std_logic_vector(WIDTH_STACK-1 downto 0);
           do_stackY:out std_logic_vector(WIDTH_STACK-1 downto 0) 

 
 );
end mem_stackX_stackY;

architecture Behavioral of mem_stackX_stackY is
type ram_type is array(SIZE_STACK-1 downto 0) of std_logic_vector(WIDTH_STACK-1 downto 0);
signal ram:ram_type;
 
 attribute ram_style:string;
 attribute ram_style of ram:signal is "block";
 
begin


process(clk_stackX,clk_stackY)
begin
   if(rising_edge(clk_stackX))then
       if(en_stackX='1')then
           do_stackX<=ram(TO_INTEGER(unsigned(addr_stackX)));
           
       if(we_stackX='1')then
           ram(TO_INTEGER(unsigned(addr_stackX)))<=di_stackX;
       end if;    
           
       end if;
   
   end if;
   
   
   if(rising_edge(clk_stackY))then
       if(en_stackY='1')then
           do_stackY<=ram(TO_INTEGER(unsigned(addr_stackY)));
           
       if(we_stackY='1')then
           ram(TO_INTEGER(unsigned(addr_stackY)))<=di_stackY;
       end if;    
           
       end if;
   
   end if;
   
   


end process;















end Behavioral;
