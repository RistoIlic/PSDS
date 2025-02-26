----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 12:18:42 PM
-- Design Name: 
-- Module Name: dfs - Behavioral
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

entity dfs is
generic(
          WIDTH:positive:=8
 );
  Port ( 
           rows:in std_logic_vector(WIDTH-1 downto 0);
           cols:in std_logic_vector(WIDTH-1 downto 0);
           
           clk:in std_logic;
           rst:in std_logic;
           --komandi i statusni interfejs
           start:in std_logic;
           ready:out std_logic;
            
            --memorijski interfejs za memoriju gde se smesta maze
           addr_mazee:out std_logic_vector(2*WIDTH-1 downto 0);
           data_mazee:out std_logic_vector(WIDTH-1 downto 0);
           maze_ctrl:out std_logic; --kontorlni signal za write
           
            --memorijski interfejs za memoriju gde se smesta stackX
           addr_stackXX:out std_logic_vector(2*WIDTH-1 downto 0);
           data_stackXX:out std_logic_vector(WIDTH-1 downto 0);--kontorlni signal za write
           stackX_ctrl:out std_logic; 
           
            --memorijski interfejs za memoriju gde se smesta stackY
           addr_stackYY:out std_logic_vector(2*WIDTH-1 downto 0);
           data_stackYY:out std_logic_vector(WIDTH-1 downto 0);
           stackY_ctrl:out std_logic;--kontorlni signal za write
           
           --Podaci koji se citaju iz memorija
           data_stackX_in:in std_logic_vector(WIDTH-1 downto 0);--;--podatak koji se procita iz stackX memorije
          data_stackY_in:in std_logic_vector(WIDTH-1 downto 0);--podatak koji se procita iz stackY memorije
          data_maze_in:in std_logic_vector(WIDTH-1 downto 0);--podatak koji se procota iz maze memorije
          
          --enable signali pomocu kojih dfs daje indikator memoriji da li je potrebno citanje sa neke od memorijskih lokacija
           en_maze,en_stackX,en_stackY:out std_logic
  
  
  );
end dfs;

architecture Behavioral of dfs is

type stanja_fsm is(idle,rows_init,cols_init,stack_init,mem_stack_init,mem_maze_init,dfs_start,mxd_path,lfsr,s0,rnd_path,s1,s2,s3,s4,s5,s6);--enumeracija.PROMENITI S0,S1,S2,S3,S4,S5,S6 SA ODGOVARAJUCIM IMENOM!!!!
signal state,state_next:stanja_fsm;
signal stackTop_reg,stackTop_next:signed(WIDTH-1 downto 0);
signal y_reg_desno,y_reg_desno_next:signed(WIDTH-1 downto 0);
signal x_reg_desno,x_reg_desno_next:signed(WIDTH-1 downto 0);
signal y_reg_levo,y_reg_levo_next:signed(WIDTH-1 downto 0);
signal x_reg_levo,x_reg_levo_next:signed(WIDTH-1 downto 0);
signal y_reg_gore,y_reg_gore_next:signed(WIDTH-1 downto 0);
signal x_reg_gore,x_reg_gore_next:signed(WIDTH-1 downto 0);
signal y_reg_dole,y_reg_dole_next:signed(WIDTH-1 downto 0);
signal x_reg_dole,x_reg_dole_next:signed(WIDTH-1 downto 0);
signal i_reg,i_next:unsigned(WIDTH-1 downto 0);
signal j_reg,j_next:unsigned(WIDTH-1 downto 0);
signal trenutnoX_reg,trenutnoX_next:unsigned(WIDTH-1 downto 0);
signal trenutnoY_reg,trenutnoY_next:unsigned(WIDTH-1 downto 0);
signal slucajniPravac_reg,slucajniPravac_next:unsigned(WIDTH-1 downto 0);
signal tmpPravacX_reg,tmpPravacX_next:signed(WIDTH-1 downto 0);
signal tmpPravacY_reg,tmpPravacY_next:signed(WIDTH-1 downto 0);
signal lfsr_reg,lfsr_next:unsigned(2*WIDTH-1 downto 0);
signal bit_reg,bit_next:unsigned(2*WIDTH-1 downto 0);
signal trenutniPravac_reg,trenutniPravac_next:unsigned(WIDTH-1 downto 0);
signal novoX_reg,novoX_next:signed(WIDTH-1 downto 0);
signal novoY_reg,novoY_next:signed(WIDTH-1 downto 0);

signal tmp_addr_maze:std_logic_vector(2*WIDTH-1 downto 0);
signal tmp_data_maze:std_logic_vector(WIDTH-1 downto 0);

begin

LOGIKA_NAREDNO_STANJA_MEMORISJKI_EL:process(clk,rst)
begin
   if(rst='1')then
     state<=idle;
     
     stackTop_reg<=(others=>'0');
     y_reg_desno<=(others=>'0');
     x_reg_desno<=(others=>'0');
     y_reg_levo<=(others=>'0');
     x_reg_levo<=(others=>'0');
     y_reg_gore<=(others=>'0');
     x_reg_gore<=(others=>'0');
     y_reg_dole<=(others=>'0');
     x_reg_dole<=(others=>'0');
     i_reg<=(others=>'0');
     j_reg<=(others=>'0');
     trenutnoX_reg<=(others=>'0');
     trenutnoY_reg<=(others=>'0');
     slucajniPravac_reg<=(others=>'0');
     tmpPravacX_reg<=(others=>'0');
     tmpPravacY_reg<=(others=>'0');
     lfsr_reg<=(others=>'0');
     bit_reg<=(others=>'0');
     trenutniPravac_reg<=(others=>'0');
     novoX_reg<=(others=>'0');
     novoY_reg<=(others=>'0');
         
   elsif(rising_edge(clk))then
     state<=state_next;
     
     stackTop_reg<=stackTop_next;
     y_reg_desno<=y_reg_desno_next;
     x_reg_desno<=x_reg_desno_next;
     y_reg_levo<=y_reg_levo_next;
     x_reg_levo<=x_reg_levo_next;
     y_reg_gore<=y_reg_gore_next;
     x_reg_gore<=x_reg_gore_next;
     y_reg_dole<=y_reg_dole_next;
     x_reg_dole<=x_reg_dole_next;
     i_reg<=i_next;
     j_reg<=j_next;
     trenutnoX_reg<=trenutnoX_next;
     trenutnoY_reg<=trenutnoY_next;
     slucajniPravac_reg<=slucajniPravac_next;
     tmpPravacX_reg<=tmpPravacX_next;
     tmpPravacY_reg<=tmpPravacY_next;
     lfsr_reg<=lfsr_next;
     bit_reg<=bit_next;
     trenutniPravac_reg<=trenutniPravac_next;
     novoX_reg<=novoX_next;
     novoY_reg<=novoY_next;

   end if;

end process;



--ovde ce biti implementirano datapath,logika_narednog_stanja,izlaz
KOMBINACIONA_LOGIKA_IZLAZ:process(state,start,rows,cols,stackTop_next,stackTop_reg,y_reg_desno_next,y_reg_desno,bit_reg,bit_next,x_reg_desno_next,x_reg_desno,y_reg_levo_next,y_reg_levo,x_reg_levo_next,x_reg_levo,
 y_reg_gore_next,y_reg_gore, x_reg_gore_next,x_reg_gore,y_reg_dole_next,y_reg_dole,x_reg_dole_next,x_reg_dole,i_next,i_reg,j_next,j_reg,trenutnoX_next,trenutnoX_reg,trenutnoY_next,trenutnoY_reg,
 slucajniPravac_next,slucajniPravac_reg,tmpPravacX_next,tmpPravacX_reg,tmpPravacY_next,tmpPravacY_reg,lfsr_next,lfsr_reg,trenutniPravac_reg,trenutniPravac_next,novoX_reg,novoX_next,novoY_reg,novoY_next)
begin
       --default assigments
     stackTop_next<=stackTop_reg;
     y_reg_desno_next<= y_reg_desno;
     x_reg_desno_next<=x_reg_desno;
     y_reg_levo_next<=y_reg_levo;
     x_reg_levo_next<=x_reg_levo;
     y_reg_gore_next<=y_reg_gore;
     x_reg_gore_next<=x_reg_gore;
     y_reg_dole_next<=y_reg_dole;
     x_reg_dole_next<=x_reg_dole;
     i_next<=i_reg;
     j_next<=j_reg;
     trenutnoX_next<=trenutnoX_reg;
     trenutnoY_next<=trenutnoY_reg;
     slucajniPravac_next<=slucajniPravac_reg;
     tmpPravacX_next<=tmpPravacX_reg;
     tmpPravacY_next<=tmpPravacY_reg;
     lfsr_next<=lfsr_reg;
     bit_next<=bit_reg;
     trenutniPravac_next<=trenutniPravac_reg;
     novoX_next<=novoX_reg;
     novoY_next<=novoY_reg;
     
      addr_mazee<=(others=>'0');
      data_mazee<=(others=>'0');
      maze_ctrl<='0';
      en_maze<='0';
            
       addr_stackXX<=(others=>'0');
       data_stackXX<=(others=>'0');
       stackX_ctrl<='0';
       en_stackX<='0'; 
        
        addr_stackYY<=(others=>'0');
        data_stackYY<=(others=>'0');
        stackY_ctrl<='0'; 
        en_stackY<='0';  

case(state)is
    when idle=>
     -- report "DFS:USAO SAM U IDLE STANJE" severity note;
    ready<='1';
        
        if(start='1')then 
           stackTop_next<=TO_SIGNED(-1,WIDTH);
           i_next<=TO_UNSIGNED(0,WIDTH);
           j_next<=TO_UNSIGNED(0,WIDTH);
           lfsr_next<=TO_UNSIGNED(44257,2*WIDTH); 
           y_reg_desno_next<=TO_SIGNED(0,WIDTH);
           x_reg_desno_next<=TO_SIGNED(1,WIDTH);
           y_reg_levo_next<=TO_SIGNED(0,WIDTH);
           x_reg_levo_next<=TO_SIGNED(-1,WIDTH);
           y_reg_gore_next<=TO_SIGNED(1,WIDTH);
           x_reg_gore_next<=TO_SIGNED(0,WIDTH);
           y_reg_dole_next<=TO_SIGNED(-1,WIDTH);
           x_reg_dole_next<=TO_SIGNED(0,WIDTH); 
           state_next<=rows_init;
           else
        state_next<=idle;
    end if;
      when rows_init=>
          --report "DFS:USAO SAM U ROWS_INIT STANJE" severity note;
          --report "JAVLAJM SE IZ ROWS_INIT,GDE JE I_NEXT=" & integer'image(to_integer(i_next)) severity note;
       if(i_next<unsigned(rows))then
           state_next<=cols_init;
           --report"PRELAZIM IZ ROWS_INIT->COLS_INIT" severity note;   
       else
            state_next<=stack_init;
             --report"PRELAZIM IZ ROWS_INIT->STACK_INIT" severity note;
       end if;
     
     when cols_init=>
          --report "DFS:USAO SAM U COLS_INIT STANJE" severity note;
          --report"VREDNOST J_NEXT=" & integer'image(TO_INTEGER(j_next))severity note;
          
        if(j_reg<unsigned(cols))then
        
            addr_mazee<=std_logic_vector((j_reg*unsigned(cols)+i_reg));
            maze_ctrl<='1';
            en_maze<='0';
            data_mazee<=std_logic_vector(TO_UNSIGNED(1,WIDTH));
            
            j_next<=j_reg+1;
            --report"J_NEXT=J_REG+1="& integer'image(TO_INTEGER(j_next))severity note;
            state_next<=cols_init;
           else
           i_next<=i_reg+1;
           j_next<=TO_UNSIGNED(0,WIDTH);
           state_next<=rows_init;
        end if;

  when stack_init=>
       --report "DFS:USAO SAM U STACK_INIT STANJE" severity note;
       --report"STACK_TOP_REG="& integer'image(TO_INTEGER(stackTop_reg))severity note;
       stackTop_next<=stackTop_reg+1;
       --report"STACK_TOP_NEXT="& integer'image(TO_INTEGER(stackTop_next))severity note;
       state_next<=mem_stack_init;
       
  when mem_stack_init=>
     report "DFS:USAO SAM U MEM_STACK_INIT STANJE" severity note;
     addr_stackXX<=std_logic_vector(signed(RESIZE(stackTop_reg,16)));
     stackX_ctrl<='1';
     en_stackX<='0';
     data_stackXX<=std_logic_vector(TO_UNSIGNED(0,WIDTH));
     
     addr_stackYY<=std_logic_vector(unsigned(rows)*unsigned(cols)+unsigned(stackTop_reg));
     stackY_ctrl<='1';
     en_stackY<='0';
     data_stackYY<=std_logic_vector(TO_UNSIGNED(0,WIDTH));
     
     state_next<=mem_maze_init;
     
    when mem_maze_init=>
      -- report "DFS:USAO SAM U MEM_MAZE_INIT STANJE" severity note;
            addr_mazee<=std_logic_vector(TO_UNSIGNED(0,2*WIDTH));
            maze_ctrl<='1';
            en_maze<='0';
            data_mazee<=std_logic_vector(TO_UNSIGNED(0,WIDTH));
            
            state_next<=dfs_start;
            
     when dfs_start=>
    -- report "DFS:USAO SAM U DFS_START STANJE" severity note;
          if(stackTop_next>=0)then
          
               addr_stackXX<=std_logic_vector(unsigned(RESIZE(stackTop_next,16)));
               stackX_ctrl<='0';
               en_stackX<='1';
               trenutnoX_next<=unsigned(data_stackX_in);
               
               addr_stackYY<=std_logic_vector(RESIZE((1*unsigned(rows)*unsigned(cols)+unsigned(stackTop_next)),16));
               stackY_ctrl<='0';
               en_stackY<='1';
               trenutnoY_next<=unsigned(data_stackY_in);
               
               stackTop_next<=stackTop_reg-1;
               trenutniPravac_next<=TO_UNSIGNED(0,WIDTH);
               
               state_next<=mxd_path;
             else
                 state_next<=idle;  
          end if;
      
     when mxd_path=> 
                      -- report "DFS:USAO SAM U MXD_PATH STANJE" severity note;
       
           if(trenutniPravac_next<4)then
           
      bit_next<=(shift_right(lfsr_reg,0) xor shift_right(lfsr_reg,2) xor shift_right(lfsr_reg,3) xor shift_right(lfsr_reg,5)) and TO_UNSIGNED(1,2*WIDTH);
           state_next<=lfsr;
           else
                state_next<=s0;--promeniti ime s0 u dogvarjacue ime stanja kad se dodje do tog dela.NARADZASTO OZNACENO NA PAPIRU
              
           end if;
      
      
      when lfsr=>
                         -- report "DFS:USAO SAM U LFSR STANJE" severity note;
          lfsr_next<=shift_right(lfsr_reg,1) or shift_left(bit_reg,15);
          state_next<=rnd_path;
      
      when rnd_path=>
                     --report "DFS:USAO SAM U RND_PATH STANJE" severity note;
            slucajniPravac_next<=RESIZE(lfsr_reg-shift_left(shift_right(lfsr_reg,2),2),WIDTH);--umesto lfsr_reg % 4
            
            if(trenutniPravac_next=TO_UNSIGNED(0,WIDTH))then
                    tmpPravacX_next<=x_reg_desno;
                    tmpPravacY_next<=y_reg_desno;
                    state_next<=s1;
               elsif(trenutniPravac_next=TO_UNSIGNED(1,WIDTH))then
                    tmpPravacX_next<=x_reg_levo;
                    tmpPravacY_next<=y_reg_levo;
                    state_next<=s1;
               elsif(trenutniPravac_next=TO_UNSIGNED(2,WIDTH))then
                    tmpPravacX_next<=x_reg_gore;
                    tmpPravacY_next<=y_reg_gore;
                    state_next<=s1;
                 elsif(trenutniPravac_next=TO_UNSIGNED(3,WIDTH))then
                    tmpPravacX_next<=x_reg_dole;
                    tmpPravacY_next<=y_reg_dole;
                    state_next<=s1; 
                 else
                      state_next<=IDLE;  
           end if;
      
      when s1=>--promeniti s1 sa odgovarajucim imenom
         --report "DFS:USAO SAM U S1 STANJE" severity note;
              
              if(trenutniPravac_next=0)then
                   if(slucajniPravac_next=0)then
                         y_reg_desno_next<=y_reg_desno;
                         x_reg_desno_next<=x_reg_desno;
                         state_next<=s2;
                   elsif(slucajniPravac_next=1)then
                         y_reg_desno_next<=y_reg_levo;
                         x_reg_desno_next<=x_reg_levo;
                         state_next<=s2;
                   elsif(slucajniPravac_next=2)then
                   
                         y_reg_desno_next<=y_reg_gore;
                         x_reg_desno_next<=x_reg_gore;
                         state_next<=s2;     
                              
                   elsif(slucajniPravac_next=3)then
                         y_reg_desno_next<=y_reg_dole;
                         x_reg_desno_next<=x_reg_dole;
                         state_next<=s2;    
                    else
                           state_next<=idle;
                               
                   end if;
                   
                  
                elsif(trenutniPravac_next=1)then
                
                       if(slucajniPravac_next=0)then
                         y_reg_levo_next<=y_reg_desno;
                         x_reg_levo_next<=x_reg_desno;
                         state_next<=s2;
                   elsif(slucajniPravac_next=1)then
                         y_reg_levo_next<=y_reg_levo;
                         x_reg_levo_next<=x_reg_levo;
                         state_next<=s2;
                   elsif(slucajniPravac_next=2)then
                   
                         y_reg_levo_next<=y_reg_gore;
                         x_reg_levo_next<=x_reg_gore;
                         state_next<=s2;     
                              
                   elsif(slucajniPravac_next=3)then
                         y_reg_levo_next<=y_reg_dole;
                         x_reg_levo_next<=x_reg_dole;
                         state_next<=s2;    
                    else
                           state_next<=idle;
                               
                   end if; 
                        
                
                
                elsif(trenutniPravac_next=2)then
                
                   if(slucajniPravac_next=0)then
                         y_reg_gore_next<=y_reg_desno;
                         x_reg_gore_next<=x_reg_desno;
                         state_next<=s2;
                   elsif(slucajniPravac_next=1)then
                         y_reg_gore_next<=y_reg_levo;
                         x_reg_gore_next<=x_reg_levo;
                         state_next<=s2;
                   elsif(slucajniPravac_next=2)then
                   
                         y_reg_gore_next<=y_reg_gore;
                         x_reg_gore_next<=x_reg_gore;
                         state_next<=s2;     
                              
                   elsif(slucajniPravac_next=3)then
                         y_reg_gore_next<=y_reg_dole;
                         x_reg_gore_next<=x_reg_dole;
                         state_next<=s2;    
                    else
                           state_next<=idle;
                               
                   end if;
                
                
                elsif(trenutniPravac_next=3)then
                   
                     if(slucajniPravac_next=0)then
                         y_reg_dole_next<=y_reg_desno;
                         x_reg_dole_next<=x_reg_desno;
                         state_next<=s2;
                   elsif(slucajniPravac_next=1)then
                         y_reg_dole_next<=y_reg_levo;
                         x_reg_dole_next<=x_reg_levo;
                         state_next<=s2;
                   elsif(slucajniPravac_next=2)then
                   
                         y_reg_dole_next<=y_reg_gore;
                         x_reg_dole_next<=x_reg_gore;
                         state_next<=s2;     
                              
                   elsif(slucajniPravac_next=3)then
                         y_reg_dole_next<=y_reg_dole;
                         x_reg_dole_next<=x_reg_dole;
                         state_next<=s2;    
                    else
                           state_next<=idle;--mozda ovde cak treba da ga vratim u idle
                               
                   end if;
                
                
              else
                   state_next<=idle;  --mozda cak i u idle
           
              end if;
           
           when s2=>
                       ---report "DFS:USAO SAM U S2 STANJE" severity note;
                  if(slucajniPravac_next=0)then
                      y_reg_desno_next<=tmpPravacY_reg;
                      x_reg_desno_next<=tmpPravacX_reg;
                      state_next<=s3;
                     elsif(slucajniPravac_next=0)then
                       y_reg_levo_next<=tmpPravacY_reg;
                      x_reg_levo_next<=tmpPravacX_reg;
                       state_next<=s3;
                      elsif(slucajniPravac_next=0)then
                       y_reg_gore_next<=tmpPravacY_reg;
                      x_reg_gore_next<=tmpPravacX_reg;
                       state_next<=s3;
                      elsif(slucajniPravac_next=0)then
                       y_reg_dole_next<=tmpPravacY_reg;
                      x_reg_dole_next<=tmpPravacX_reg;
                       state_next<=s3;
                  else
                       state_next<=idle;
                  
                  end if;
           when s3=>
             -- report "DFS:USAO SAM U S3 STANJE" severity note;
               trenutniPravac_next<=trenutniPravac_reg+1;
               state_next<=mxd_path;
               
            when s0=>
               -- report "DFS:USAO SAM U S0 STANJE" severity note;
                  trenutniPravac_next<=TO_UNSIGNED(0,WIDTH);   
                  
                  if(trenutniPravac_next<4)then
                      if(trenutniPravac_next=0)then
                         novoX_next<=RESIZE(signed(std_logic_vector(trenutnoX_reg))+2*x_reg_desno,WIDTH);  
                         novoY_next<=RESIZE(signed(std_logic_vector(trenutnoY_reg))+2*y_reg_desno,WIDTH);    
                         state_next<=s4;
                        elsif(trenutniPravac_next=1)then
                        novoX_next<=RESIZE(signed(std_logic_vector(trenutnoX_reg))+2*x_reg_levo,WIDTH);  
                         novoY_next<=RESIZE(signed(std_logic_vector(trenutnoY_reg))+2*y_reg_levo,WIDTH);
                          state_next<=s4;
                          elsif(trenutniPravac_next=2)then
                        novoX_next<=RESIZE(signed(std_logic_vector(trenutnoX_reg))+2*x_reg_gore,WIDTH);  
                         novoY_next<=RESIZE(signed(std_logic_vector(trenutnoY_reg))+2*y_reg_gore,WIDTH);
                          state_next<=s4;
                          elsif(trenutniPravac_next=3)then
                        novoX_next<=RESIZE(signed(std_logic_vector(trenutnoX_reg))+2*x_reg_dole,WIDTH);  
                         novoY_next<=RESIZE(signed(std_logic_vector(trenutnoY_reg))+2*y_reg_dole,WIDTH);
                          state_next<=s4;
                           else
                             state_next<=idle;   
                      end if;  
                
                  else
                     state_next<=dfs_start;
                  
                  end if;
                  
             when s4=>
                    --      report "DFS:USAO SAM U S4 STANJE" severity note;
                 addr_mazee<=std_logic_vector(novoX_reg*signed(cols)+novoY_reg);
                 maze_ctrl<='0';
                 en_maze<='1';
                 
                 if(novoX_next>=0 and novoX_next<signed(rows) and novoY_next>=0 and novoY_next<signed(cols) and data_maze_in=std_logic_vector(TO_UNSIGNED(1,WIDTH)))then
                         
                         if(trenutniPravac_next=0)then
                            
                            addr_mazee<=std_logic_vector((novoX_reg-x_reg_desno)*signed(cols)+(novoY_reg-y_reg_desno));
                            maze_ctrl<='1';
                            en_maze<='0';
                            data_mazee<=std_logic_vector(TO_UNSIGNED(0,WIDTH));
                             state_next<=s5;
                         elsif(trenutniPravac_next=1)then
                           
                            addr_mazee<=std_logic_vector((novoX_reg-x_reg_levo)*signed(cols)+(novoY_reg-y_reg_levo));
                            maze_ctrl<='1';
                            en_maze<='0';
                            data_mazee<=std_logic_vector(TO_UNSIGNED(0,WIDTH));
                             state_next<=s5;
                           elsif(trenutniPravac_next=2)then
                           
                            addr_mazee<=std_logic_vector((novoX_reg-x_reg_gore)*signed(cols)+(novoY_reg-y_reg_gore));
                            maze_ctrl<='1';
                            en_maze<='0';
                            data_mazee<=std_logic_vector(TO_UNSIGNED(0,WIDTH)); 
                          state_next<=s5;
                            elsif(trenutniPravac_next=3)then
                           
                            addr_mazee<=std_logic_vector((novoX_reg-x_reg_dole)*signed(cols)+(novoY_reg-y_reg_dole));
                            maze_ctrl<='1';
                            en_maze<='0';
                            data_mazee<=std_logic_vector(TO_UNSIGNED(0,WIDTH)); 
                             state_next<=s5;
                           else
                                state_next<=idle; 
                         
                         end if;
                         
                       
                         else
                         
                         trenutniPravac_next<=trenutniPravac_reg+1;
                          state_next<=s0;
                 end if;
                  
                when s5=>
                       --  report "DFS:USAO SAM U S5 STANJE" severity note;
                  
                            addr_mazee<=std_logic_vector((novoX_reg)*signed(cols)+novoY_reg);
                            maze_ctrl<='1';
                            en_maze<='0';
                            data_mazee<=std_logic_vector(TO_UNSIGNED(0,WIDTH)); 
                            stackTop_next<=stackTop_reg+1;
                            state_next<=s6;
                when s6=>
                             report "DFS:USAO SAM U S6 STANJE" severity note;
                            addr_stackXX<=std_logic_vector(RESIZE(stackTop_reg,2*WIDTH));  
                            stackX_ctrl<='1';
                            data_stackXX<=std_logic_vector(novoX_reg);
                           
                            
                            addr_stackYY<=std_logic_vector(signed(rows)*signed(cols)+stackTop_reg);  
                            stackY_ctrl<='1';
                            data_stackYY<=std_logic_vector(novoY_reg);
                            
                            state_next<=idle;
                            
                                   
end case;
end process;




--addr_mazee<=tmp_addr_maze;
--data_mazee<=tmp_data_maze;












end Behavioral;
