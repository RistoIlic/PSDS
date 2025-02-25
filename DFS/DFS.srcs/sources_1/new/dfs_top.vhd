----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 01:45:11 PM
-- Design Name: 
-- Module Name: dfs_top - Behavioral
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

entity dfs_top is
 generic(
    WIDTH:positive:=8
 );
 Port ( 
          rows:in std_logic_vector(WIDTH-1 downto 0);
          cols:in std_logic_vector(WIDTH-1 downto 0);
          start:in std_logic;
          clk:in std_logic;
          rst:in std_logic;
          ready:out std_logic
 );         
end dfs_top;

architecture Behavioral of dfs_top is
       signal addr_maze,addr_stackXX,addr_stackYY:std_logic_vector(2*WIDTH-1 downto 0);
       signal data_maze,data_stackXX,data_stackYY:std_logic_vector(WIDTH-1 downto 0);
       signal maze_ctrl,stackX_ctrl,stackY_ctrl:std_logic;
       signal en_maze,en_stackX,en_stackY:std_logic;
       signal maze_out,stackX_out,stackY_out:std_logic_vector(WIDTH-1 downto 0);
begin


dfs:entity work.dfs(Behavioral)
port map(
     rows=>rows,
     cols=>cols,
     start=>start,
     clk=>clk,
     rst=>rst,
     ready=>ready,
     addr_mazee=>addr_maze,
     data_mazee=>data_maze,
     maze_ctrl=>maze_ctrl,
     addr_stackXX=>addr_stackXX,
     data_stackXX=>data_stackXX,
     stackX_ctrl=>stackX_ctrl,
     addr_stackYY=>addr_stackYY,
     data_stackYY=>data_stackYY,
     stackY_ctrl=>stackY_ctrl,
     en_maze=>en_maze,
     en_stackX=>en_stackX,
     en_stackY=>en_stackY,
     data_stackX_in=>stackX_out,
     data_stackY_in=>stackY_out,
     data_maze_in=>maze_out
     
);


mem_maze:entity work.mem_maze(Behavioral)
port map(
       addr_maze=>addr_maze,
       di_maze=>data_maze,
       we_maze=>maze_ctrl,
       en_maze=>en_maze,
       clk_maze=>clk,
       do_maze=>maze_out
);

mem_stackX_stackY:entity work.mem_stackX_stackY(Behavioral)
port map(
          addr_stackX=>addr_stackXX,
          addr_stackY=>addr_stackYY,
          we_stackX=>stackX_ctrl,
          we_stackY=>stackY_ctrl,
          en_stackX=>en_stackX,
          en_stackY=>en_stackY,
          di_stackX=>data_stackXX,
          di_stackY=>data_stackYY,
          clk_stackX=>clk,
          clk_stackY=>clk,
          do_stackX=>stackX_out,
          do_stackY=>stackY_out


);













end Behavioral;
