----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2025 04:32:43 PM
-- Design Name: 
-- Module Name: maze_memory_tb - Behavioral
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

entity maze_memory_tb is
--  Port ( );
end maze_memory_tb;

architecture Behavioral of maze_memory_tb is
     constant WIDTH:positive:=8;
     
     signal    s_addr_maze:std_logic_vector(2*WIDTH-1 downto 0);
     signal    s_di_maze:std_logic_vector(WIDTH-1 downto 0);
     signal    s_we_maze:std_logic;
     signal    s_en_maze:std_logic;
     signal    s_clk_maze:std_logic;
     signal    s_do_maze:std_logic_vector(WIDTH-1 downto 0);




begin


DUT:entity work.mem_maze(Behavioral)
   port map(
     addr_maze=>s_addr_maze,
     di_maze=>s_di_maze,
     we_maze=>s_we_maze,
     en_maze=>s_en_maze,
     clk_maze=>s_clk_maze,
     do_maze=>s_do_maze);


clk_gen:process
begin

s_clk_maze<='0','1' after 30ns;
wait for 50ns;

end process;


stimulus_process:process
begin
      wait for 20ns;
      
      s_we_maze<='1';
      s_en_maze<='0';
  --upis podataka u memoriju
  for i in 0 to 8 loop
  
  s_addr_maze<=std_logic_vector(TO_UNSIGNED(i,2*WIDTH));
  s_di_maze<=std_logic_vector(TO_UNSIGNED(2*i+1,8));
  
  wait for 50ns;
  end loop; 
        
      
  s_we_maze<='0';
  wait for 80ns;
  s_en_maze<='1';
  --citanje iz memroije
  for i in 0 to 8 loop
      s_addr_maze<=std_logic_vector(TO_UNSIGNED(i,2*WIDTH));
  wait for 50ns;
  
  end loop;
  
  
  
  
  
  
wait;




end process;













end Behavioral;
