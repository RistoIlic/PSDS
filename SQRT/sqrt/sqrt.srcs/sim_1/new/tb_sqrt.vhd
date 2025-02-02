LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sqrt_tb IS
END sqrt_tb;

ARCHITECTURE behavior OF sqrt_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT sqrt
    PORT(
         x : IN  std_logic_vector(31 downto 0);
         res : OUT  std_logic_vector(31 downto 0);
         start : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         ready : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal x : std_logic_vector(31 downto 0) := (others => '0');
   signal start : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

    --Outputs
   signal res : std_logic_vector(31 downto 0);
   signal ready : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
BEGIN

    -- Instantiate the Unit Under Test (UUT)
   uut: sqrt PORT MAP (
          x => x,
          res => res,
          start => start,
          clk => clk,
          rst => rst,
          ready => ready
        );

   -- Clock process definitions
   clk_process :process
   begin
      
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        
    end process;
   

   -- Stimulus process
   stim_proc: process
   begin        
         rst <= '1';
      wait for 20 ns;  
      rst <= '0';
      wait for 50ns;
        

      -- insert stimulus here 
      x <= std_logic_vector(to_unsigned(308025, 32));
      start <= '1';
      wait for 400ns;
      start <= '0';
      
      
      
     wait until ready='1';

      wait;
   end process;

END;
