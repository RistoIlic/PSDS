----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 03:24:20 PM
-- Design Name: 
-- Module Name: dfs_top_tb - Behavioral
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

entity dfs_top_tb is
--  Port ( );
end dfs_top_tb;

architecture Behavioral of dfs_top_tb is
  constant WIDTH:positive:=8;
      signal rows:std_logic_vector(WIDTH-1 downto 0);
      signal cols:std_logic_vector(WIDTH-1 downto 0);
      signal start:std_logic;
      signal clk:std_logic;
      signal rst:std_logic;
      signal ready:std_logic;
    constant CLK_PERIOD:time:=10ns;
      
begin



dut:entity work.dfs_top(Behavioral)
port map(
          rows=>rows,
          cols=>cols,
          start=>start,
          clk=>clk,
          rst=>rst,
          ready=>ready

);



clk_gen:process
begin
       clk<='0';
       wait for clk_period/2;
       clk<='1';
       wait for clk_period/2;

end process;


stimulus:process
begin


      rst <= '1';
      wait for 20 ns;  
      rst <= '0';
      wait for 50ns;
        

      -- insert stimulus here 
      rows<= std_logic_vector(to_unsigned(9,WIDTH));
      cols<=std_logic_vector(TO_UNSIGNED(9,WIDTH));
      start <= '1';
      wait for 400ns;
      start <= '0';
      
      
      
     wait until ready='1';



wait;
end process;







end Behavioral;
