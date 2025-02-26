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
      signal s_rows:std_logic_vector(WIDTH-1 downto 0);
      signal s_cols:std_logic_vector(WIDTH-1 downto 0);
      signal s_start:std_logic;
      signal s_clk:std_logic;
      signal s_rst:std_logic;
      signal s_ready:std_logic;
      signal s_maze_out:std_logic_vector(WIDTH-1 downto 0);
      signal s_addr_maze_dfs_to_bram_maze,s_addr_stackXX_dfs_to_bram_stackX,s_addr_stackYY_dfs_to_bram_stackY:std_logic_vector(2*WIDTH-1 downto 0);
      signal s_data_maze_dfs_to_bram_maze,s_data_stackXX_dfs_to_bram_stackX,s_data_stackYY_dfs_to_bram_stackY:std_logic_vector(WIDTH-1 downto 0);
      signal s_maze_ctrl_dfs_to_bram_maze,s_stackX_ctrl_dfs_to_bram_stackX,s_stackY_ctrl_dfs_to_bram_stackY:std_logic;
      signal s_en_maze,s_en_stackX,s_en_stackY: std_logic;
      
      
    constant CLK_PERIOD:time:=10ns;
      
begin

dut:entity work.dfs_top(Behavioral)
port map(
      rows=>s_rows,
      cols=>s_cols,
      start=>s_start,
      clk=>s_clk,
      rst=>s_rst,
      ready=>s_ready,
      maze_out=>s_maze_out,
      addr_maze_dfs_to_bram_maze=>s_addr_maze_dfs_to_bram_maze,
      addr_stackXX_dfs_to_bram_stackX=>s_addr_stackXX_dfs_to_bram_stackX,
      addr_stackYY_dfs_to_bram_stackY=>s_addr_stackYY_dfs_to_bram_stackY,
      data_maze_dfs_to_bram_maze=>s_data_maze_dfs_to_bram_maze,
      data_stackXX_dfs_to_bram_stackX=>s_data_stackXX_dfs_to_bram_stackX,
      data_stackYY_dfs_to_bram_stackY=>s_data_stackYY_dfs_to_bram_stackY,
      maze_ctrl_dfs_to_bram_maze=>s_maze_ctrl_dfs_to_bram_maze,
      stackX_ctrl_dfs_to_bram_stackX=>s_stackX_ctrl_dfs_to_bram_stackX,
      stackY_ctrl_dfs_to_bram_stackY=>s_stackY_ctrl_dfs_to_bram_stackY,
      en_maze=>s_en_maze,
      en_stackX=>s_en_stackX,
      en_stackY=>s_en_stackY
);



clk_gen:process
begin
    s_clk<='0';
    wait for clk_period/2;
    s_clk<='1';
    wait for clk_period/2;


end process;






stimulus:process
begin
    s_rst<='1';
    s_ready<='0';
    wait for 5*clk_period;
    s_rst<='0';
    s_ready<='1';
   
    s_rows<=std_logic_vector(TO_UNSIGNED(5,WIDTH));
    s_cols<=std_logic_vector(TO_UNSIGNED(5,WIDTH));
      wait for clk_period/2;
    s_start<='1';
      wait for 10*clk_period;
     s_start<='0';
     s_ready<='1';
     
     
     
     
     
     
     
     
 
 



wait;
end process;






















end Behavioral;
