----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 10:34:08 AM
-- Design Name: 
-- Module Name: mem_maze - Behavioral
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

entity mem_maze is
generic(
      WIDTH:positive:=8;
      SIZE:positive:=2500
    );
 Port (
         addr_maze:in std_logic_vector(2*WIDTH-1 downto 0);
         di_maze:in std_logic_vector(WIDTH-1 downto 0);
         we_maze:in std_logic;
         en_maze:in std_logic;
         clk_maze:in std_logic;
         do_maze:out std_logic_vector(WIDTH-1 downto 0)
 
  );
end mem_maze;

architecture Behavioral of mem_maze is
type ram_type is array(SIZE-1 downto 0) of std_logic_vector(WIDTH-1 downto 0);
signal ram:ram_type;
 attribute ram_style:string;
 attribute ram_style of ram:signal is "block";
 
begin

process(clk_maze)
begin
   
  
    if (rising_edge(clk_maze)) then

        if (en_maze = '1') then
            do_maze <= ram(to_integer(unsigned(addr_maze)));
          end if;

            if (we_maze='1') then
                ram(to_integer(unsigned(addr_maze))) <= di_maze;
            end if;
        
    end if;


end process;








end Behavioral;
