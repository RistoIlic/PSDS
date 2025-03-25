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
      signal s_maze_out:std_logic_vector(WIDTH-1 downto 0):="00000000";
      signal s_addr_maze_dfs_to_bram_maze,s_addr_stackXX_dfs_to_bram_stackX,s_addr_stackYY_dfs_to_bram_stackY:std_logic_vector(2*WIDTH-1 downto 0);
      signal s_data_maze_dfs_to_bram_maze,s_data_stackXX_dfs_to_bram_stackX,s_data_stackYY_dfs_to_bram_stackY:std_logic_vector(WIDTH-1 downto 0);
      signal s_maze_ctrl_dfs_to_bram_maze,s_stackX_ctrl_dfs_to_bram_stackX,s_stackY_ctrl_dfs_to_bram_stackY:std_logic;
      signal s_en_maze,s_en_stackX,s_en_stackY: std_logic:='0';
      signal s_stackX_out:std_logic_vector(WIDTH-1 downto 0);
      signal  s_stackY_out:std_logic_vector(WIDTH-1 downto 0);
      
    constant CLK_PERIOD:time:=8ns;
      
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
      en_stackY=>s_en_stackY,
      stackX_out=>s_stackX_out,
      stackY_out=>s_stackY_out
);




clk_gen:process
begin

   s_clk <= '0','1' after 1ns;
   wait for 2ns;
  
end process;








stimulus:process
begin
    
   s_rst<='1';
   s_start<='0';
   s_rows<=std_logic_vector(TO_UNSIGNED(5,8));
   s_cols<=std_logic_vector(TO_UNSIGNED(5,8));
   wait until falling_edge(s_clk);
   s_rst<='0';
   wait until falling_edge(s_clk);
   wait until falling_edge(s_clk);
   wait until falling_edge(s_clk);
   s_start<='1';
   wait until falling_edge(s_clk);
   s_start<='0';
    
 
wait until s_ready = '1';
 wait until falling_edge(s_clk);
   wait until falling_edge(s_clk);   
     
     
     
wait;
end process;






















end Behavioral;
