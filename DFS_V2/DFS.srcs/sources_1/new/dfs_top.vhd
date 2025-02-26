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
          ready:out std_logic;
          maze_out:out std_logic_vector(WIDTH-1 downto 0);
          addr_maze_dfs_to_bram_maze, addr_stackXX_dfs_to_bram_stackX,addr_stackYY_dfs_to_bram_stackY:out std_logic_vector(2*WIDTH-1 downto 0);
          data_maze_dfs_to_bram_maze,data_stackXX_dfs_to_bram_stackX,data_stackYY_dfs_to_bram_stackY:out std_logic_vector(WIDTH-1 downto 0);
          maze_ctrl_dfs_to_bram_maze,stackX_ctrl_dfs_to_bram_stackX,stackY_ctrl_dfs_to_bram_stackY:out std_logic;
          en_maze,en_stackX,en_stackY:out std_logic
 );         
end dfs_top;

architecture Behavioral of dfs_top is
     signal s1,s5,s9:std_logic_vector(2*WIDTH-1 downto 0);
     signal s2,s6,s10,s12,s13,s14:std_logic_vector(WIDTH-1 downto 0);
     signal s3,s4,s7,s8,s11,s15:std_logic;
   
       
begin



dfs:entity work.dfs(Behavioral)
port map(
       rows=>rows,
       cols=>cols,
       start=>start,
       clk=>clk,
       rst=>rst,
       addr_mazee=>s1,
       data_mazee=>s2,
       maze_ctrl=>s3,
       addr_stackXX=>s5,
       data_stackXX=>s6,
       stackX_ctrl=>s7,
       addr_stackYY=>s9,
       data_stackYY=>s10,
       stackY_ctrl=>s11,
       en_maze=>s4,
       en_stackX=>s8,
       en_stackY=>s15,
       ready=>ready,
       data_stackX_in=>s13,
       data_stackY_in=>s14,
       data_maze_in=>s12

);



mem_maze:entity work.mem_maze(Behavioral)
port map(
       addr_maze=>s1,
       di_maze=>s2,
       we_maze=>s3,
       en_maze=>s4,
       clk_maze=>clk,
       do_maze=>s12

);

mem_stack:entity work.mem_stackX_stackY(Behavioral)
port map(
         addr_stackX=>s5,
         addr_stackY=>s9,
         we_stackX=>s7,
         we_stackY=>s11,
         en_stackX=>s8,
         en_stackY=>s15,
         di_stackX=>s6,
         di_stackY=>s10,
         clk_stackX=>clk,
         clk_stackY=>clk,
         do_stackX=>s13,
         do_stackY=>s14

);


maze_out<=s12;
addr_maze_dfs_to_bram_maze<=s1;
addr_stackXX_dfs_to_bram_stackX<=s5;
addr_stackYY_dfs_to_bram_stackY<=s9;

data_maze_dfs_to_bram_maze<=s2;
data_stackXX_dfs_to_bram_stackX<=s6;
data_stackYY_dfs_to_bram_stackY<=s10;


maze_ctrl_dfs_to_bram_maze<=s3;
stackX_ctrl_dfs_to_bram_stackX<=s7;
stackY_ctrl_dfs_to_bram_stackY<=s11;

en_maze<=s4;
en_stackX<=s8;
en_stackY<=s15;



end Behavioral;
