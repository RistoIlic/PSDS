----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2025 04:33:55 PM
-- Design Name: 
-- Module Name: dfs_tb - Behavioral
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

entity dfs_tb is
--  Port ( );
end dfs_tb;

architecture Behavioral of dfs_tb is


signal rows : std_logic_vector(7 downto 0) := (others => '0');
    signal cols : std_logic_vector(7 downto 0) := (others => '0');
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal start : std_logic := '0';
    signal data_stackX_in : std_logic_vector(7 downto 0) := (others => '0');
    signal data_stackY_in : std_logic_vector(7 downto 0) := (others => '0');
    signal data_maze_in : std_logic_vector(7 downto 0) := (others => '0');

    -- Outputs
    signal ready : std_logic;
    signal addr_maze : std_logic_vector(15 downto 0);
    signal data_maze : std_logic_vector(7 downto 0);
    signal ctrl_maze : std_logic;
    signal addr_stackX : std_logic_vector(15 downto 0);
    signal data_stackX : std_logic_vector(7 downto 0);
    signal ctrl_stackX : std_logic;
    signal addr_stackY : std_logic_vector(15 downto 0);
    signal data_stackY : std_logic_vector(7 downto 0);
    signal ctrl_stackY : std_logic;
    signal en_maze : std_logic;
    signal en_stackX : std_logic;
    signal en_stackY : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;
    
    -- Memory simulation
    type maze_mem is array (0 to 255) of std_logic_vector(7 downto 0);
    signal maze_memory : maze_mem := (others => (others => '0'));
    
    type stack_mem is array (0 to 511) of std_logic_vector(7 downto 0);
    signal stackX_memory : stack_mem := (others => (others => '0'));
    signal stackY_memory : stack_mem := (others => (others => '0'));



begin
DUT:entity work.dfs(Behavioral) 
    generic map (
        WIDTH => 8
    )
    port map (
        rows => rows,
        cols => cols,
        clk => clk,
        rst => rst,
        start => start,
        ready => ready,
        addr_maze => addr_maze,
        data_maze => data_maze,
        ctrl_maze => ctrl_maze,
        addr_stackX => addr_stackX,
        data_stackX => data_stackX,
        ctrl_stackX => ctrl_stackX,
        addr_stackY => addr_stackY,
        data_stackY => data_stackY,
        ctrl_stackY => ctrl_stackY,
        data_stackX_in => data_stackX_in,
        data_stackY_in => data_stackY_in,
        data_maze_in => data_maze_in,
        en_maze => en_maze,
        en_stackX => en_stackX,
        en_stackY => en_stackY
    );

 -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Memory simulation process
    mem_process: process(clk)
    begin
        if rising_edge(clk) then
            -- Maze memory write
            if ctrl_maze = '1' then
                maze_memory(to_integer(unsigned(addr_maze))) <= data_maze;
            end if;
            
            -- Maze memory read
            if en_maze = '1' then
                data_maze_in <= maze_memory(to_integer(unsigned(addr_maze)));
            end if;
            
            -- StackX memory write
            if ctrl_stackX = '1' then
                stackX_memory(to_integer(unsigned(addr_stackX))) <= data_stackX;
            end if;
            
            -- StackX memory read
            if en_stackX = '1' then
                data_stackX_in <= stackX_memory(to_integer(unsigned(addr_stackX)));
            end if;
            
            -- StackY memory write
            if ctrl_stackY = '1' then
                stackY_memory(to_integer(unsigned(addr_stackY))) <= data_stackY;
            end if;
            
            -- StackY memory read
            if en_stackY = '1' then
                data_stackY_in <= stackY_memory(to_integer(unsigned(addr_stackY)));
            end if;
        end if;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize maze size (8x8 for this test)
        rows <= std_logic_vector(to_unsigned(8, 8));
        cols <= std_logic_vector(to_unsigned(8, 8));
        
        -- Reset the system
        rst <= '1';
        wait for clk_period*2;
        rst <= '0';
        wait for clk_period*2;
        
        -- Start the maze generation
        start <= '1';
        wait for clk_period;
        start <= '0';
        
        -- Wait for completion
        wait until ready = '1';
        
        -- Add some delay to observe the final state
        wait for clk_period*10;
        
        -- End simulation
        assert false report "Simulation Finished" severity failure;
    end process;
































end Behavioral;
