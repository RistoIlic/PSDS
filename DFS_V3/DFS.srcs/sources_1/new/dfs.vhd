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
           addr_maze:out std_logic_vector(2*WIDTH-1 downto 0);
           data_maze:out std_logic_vector(WIDTH-1 downto 0);
           ctrl_maze:out std_logic; --kontorlni signal za write
           
            --memorijski interfejs za memoriju gde se smesta stackX
           addr_stackX:out std_logic_vector(2*WIDTH-1 downto 0);
           data_stackX:out std_logic_vector(WIDTH-1 downto 0);--kontorlni signal za write
           ctrl_stackX:out std_logic; 
           
            --memorijski interfejs za memoriju gde se smesta stackY
           addr_stackY:out std_logic_vector(2*WIDTH-1 downto 0);
           data_stackY:out std_logic_vector(WIDTH-1 downto 0);
           ctrl_stackY:out std_logic;--kontorlni signal za write
           
           --Podaci koji se citaju iz memorija
           data_stackX_in:in std_logic_vector(WIDTH-1 downto 0);--;--podatak koji se procita iz stackX memorije
          data_stackY_in:in std_logic_vector(WIDTH-1 downto 0);--podatak koji se procita iz stackY memorije
          data_maze_in:in std_logic_vector(WIDTH-1 downto 0);--podatak koji se procota iz maze memorije
          
          --enable signali pomocu kojih dfs daje indikator memoriji da li je potrebno citanje sa neke od memorijskih lokacija
           en_maze,en_stackX,en_stackY:out std_logic
  
  
  );
end dfs;

architecture Behavioral of dfs is

type stanja_fsm is(idle,rows_init,cols_init,dfs_start,write_memory,lfsr_update,rnd_bit_lfsr,rnd_path,new_cord,swap_path1,swap_path2,read_maze,check_cordinate,break_wall,stack_pop,load_direction,tmp_load,new_cord_is_maze,new_cord_push_stack);--enumeracija
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
 slucajniPravac_next,slucajniPravac_reg,tmpPravacX_next,tmpPravacX_reg,tmpPravacY_next,tmpPravacY_reg,lfsr_next,lfsr_reg,trenutniPravac_reg,trenutniPravac_next,novoX_reg,novoX_next,novoY_reg,novoY_next,data_stackX_in,
  data_stackY_in, data_maze_in)
begin
       --default assigments-sprecava latche efekte,tj efekte neodredjenosti
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
     
      
     
      addr_maze<=std_logic_vector(i_reg*unsigned(cols)+j_reg-TO_UNSIGNED(1,8));
     -- addr_maze<=(others=>'0');
      data_maze<=std_logic_vector(TO_UNSIGNED(1,WIDTH));
      ctrl_maze<='0';
      en_maze<='0';
            
       addr_stackX<=std_logic_vector(i_reg*unsigned(cols)+j_reg-TO_UNSIGNED(1,8));
      --- data_stackX<=std_logic_vector(TO_UNSIGNED(1,WIDTH));
       ctrl_stackX<='0';
       en_stackX<='0'; 
        
        addr_stackY<=std_logic_vector(i_reg*unsigned(cols)+j_reg-TO_UNSIGNED(1,8)+unsigned(rows)*unsigned(cols));
      --  data_stackY<=std_logic_vector(TO_UNSIGNED(1,WIDTH));
        ctrl_stackY<='0'; 
        en_stackY<='0';  
         
        ready<='0';
         
  
    
  case(state)is
    
    when idle=>
        ready<='1';
        report"JAVLJAM SE IZ IDLE STANJA"severity note;
    if(start='1')then
    
         stackTop_next<=TO_SIGNED(-1,WIDTH);
         ------------------------------------    
         i_next<=TO_UNSIGNED(0,WIDTH);
         j_next<=TO_UNSIGNED(0,WIDTH);
         -----------------------------------
         lfsr_next<=TO_UNSIGNED(57005,2*WIDTH);
         --------------------------------------
         y_reg_desno_next<=TO_SIGNED(0,WIDTH);
         x_reg_desno_next<=TO_SIGNED(1,WIDTH);
         ------------------------------------
          y_reg_levo_next<=TO_SIGNED(0,WIDTH);
         x_reg_levo_next<=TO_SIGNED(-1,WIDTH);
         -----------------------------------------
          y_reg_gore_next<=TO_SIGNED(-1,WIDTH);
          x_reg_gore_next<=TO_SIGNED(0,WIDTH);
         ---------------------------------------
          y_reg_dole_next<=TO_SIGNED(1,WIDTH);
          x_reg_dole_next<=TO_SIGNED(0,WIDTH);
         ---------------------------------------
         state_next<=rows_init;
        
        report"PRELAZIM IZ IDEL-->ROWS_INIT"severity note; 
        
     else
       state_next<=idle;
     
     end if;    
    
    
    
    when rows_init=>
        
        report"JAVALJAM SE IZ STANJA ROWS_INIT"severity note;
     report"U ROWS INITI STANJU I_NEXT= "&integer'image(TO_INTEGER(i_next))&"A,ROWS="&integer'image(TO_INTEGER(unsigned(rows)))severity note;
     
        
        if(i_reg<unsigned(rows))then
           state_next<=cols_init;
           report"PRELAZIM IZ ROWS_INIT--->COLS_INIT"severity note;
         else
         report"ROWS_INIT---->MEM_INIT"severity note;
         state_next<=write_memory;
        
        end if;
     
    when cols_init=>
     
 report"JAVLAJMA SE IZ COLS_INIT STANJA,GDE JE J_NEXT="&integer'image(TO_INTEGER(j_reg))&"A,COLS="&integer'image(TO_INTEGER(unsigned(cols)))severity note;
      
    
        if(j_reg<unsigned(cols))then
             
             addr_maze<=std_logic_vector(i_reg*unsigned(cols)+j_reg);
             ctrl_maze<='1';
             en_maze<='0';
             data_maze<=std_logic_vector(TO_UNSIGNED(1,WIDTH));
        -- report"NA MEMORIJSKOJ LOKACIJI="&integer'image(TO_INTEGER(unsigned(tmp_addr_maze)))&"UPISAN JE PODATAK="&integer'image(TO_INTEGER(unsigned(tmp_data_maze)))severity note;
             j_next<=j_reg+1;
               state_next<=cols_init;
         report"COLS_INIT--->COLS_INIT"severity note;
        else
             i_next<=i_reg+1;
             j_next<=TO_UNSIGNED(0,WIDTH);
             state_next<=rows_init;
         report"COLS_INIT--->ROWS_INIT"severity note;
        end if;
    
    
    
    when write_memory=>
        report"JAVLAJM SE IZ WRITE_MEMORY STANJA"severity note;
           
          addr_stackX<=std_logic_vector(TO_UNSIGNED(0,2*WIDTH));
          ctrl_stackX<='1';
          en_stackX<='0';
          data_stackX<=std_logic_vector(TO_UNSIGNED(0,WIDTH));
          
          addr_stackY<=std_logic_vector(signed(rows)*signed(cols));
          ctrl_stackY<='1';
          en_stackY<='0';
          data_stackY<=std_logic_vector(TO_UNSIGNED(0,WIDTH));
           
         addr_maze<="0000000000000000";
           ctrl_maze<='1';
           en_maze<='0';
           data_maze<=std_logic_vector(TO_UNSIGNED(0,WIDTH)); 
           
           stackTop_next<=stackTop_reg+1;
            state_next<=dfs_start;
           
          report"WRITE_MEMORY:VREDNSOT STACK_TOP_NEXT= "&integer'image(TO_INTEGER(stackTop_next))severity note;
             
           report"WRITE_MEMORY--->DFS_START"severity note; 
     
  
    when dfs_start=>
      report"JAVLJAM SE IZ STANJA DFS_START"severity note;
   report"DFS_START:STACK_TOP_REG="&integer'image(TO_INTEGER(stackTop_reg))severity note;
   
             if(stackTop_reg>=0)then
             
                 addr_stackX<=std_logic_vector(RESIZE(stackTop_reg,2*WIDTH));
                 ctrl_stackX<='0';
                 en_stackX<='1';
                 trenutnoX_next<=unsigned(data_stackX_in);
              report"DFS_START:TRENUTNO_X_NEXT: "&integer'image(TO_INTEGER(trenutnoX_next))severity note;
                 
                 addr_stackY<=std_logic_vector(signed(rows)*signed(cols)+stackTop_reg);
                 ctrl_stackY<='0';
                 en_stackY<='1';
                 trenutnoY_next<=unsigned(data_stackX_in);
    report"DFS_START:TRENUTNO_Y_NEXT: "&integer'image(TO_INTEGER(trenutnoY_next))severity note;
                 
                 
                 state_next<=stack_pop;
                 
                 
                 report"DFS_START--->STACK_POP"severity note;
                    
             else
                 
                 state_next<=idle;
                 report"DFS_START--->IDLE"severity note;
             end if;  
    
    when stack_pop=>
          stackTop_next<=stackTop_reg-1;
                 report"STACK_POP:STACK_TOP_NEXT= "&integer'image(TO_INTEGER(stackTop_next));
                 trenutniPravac_next<=TO_UNSIGNED(0,WIDTH);
           state_next<=rnd_bit_lfsr;
           report"PRELAZIM IZ STANJA STACK_POP--->RND_BIT_LFSR"severity note;
    
    
    when rnd_bit_lfsr=>
   report"JAVALJAM SE IZ STANJA RND_BIT_LFSR,GDE JE TRENUTNI_PRAVAC_REG= "&integer'image(TO_INTEGER(trenutniPravac_reg))severity note;
   report"RND_BIT_LFSR:LFSR_REG= "&integer'image(TO_INTEGER(lfsr_reg))severity note;
   report"RND_BIT_LFSR:TRENUTNI_PRAVAC_REG= "&integer'image(TO_INTEGER(trenutniPravac_reg));
   
            if(trenutniPravac_reg<4)then
                
   bit_next<=RESIZE((shift_right(lfsr_reg,0) xor shift_right(lfsr_reg,2) xor shift_right(lfsr_reg,3) xor shift_right(lfsr_reg,5)) and TO_UNSIGNED(1,2*WIDTH),16);
  report"RND_BIT_LFSR:BIT_NEXT= "&integer'image(TO_INTEGER(BIT_NEXT))severity note;  
                state_next<=lfsr_update;
            report"RND_BIT_LFSR--->LFSR_UPDATE"severity note;
                
              else
                trenutniPravac_next<=TO_UNSIGNED(0,WIDTH);
                state_next<=load_direction;
                report"RND_BIT_LFSR--->LOAD_DIRECTION"severity note;
            
            end if;
    
    when lfsr_update=>
    report"JAVALJAM SE IZ LFSR_UPDATE STANJA"severity note;
    report"LFSR_UPDATE:LFSR_REG= "&integer'image(TO_INTEGER(lfsr_reg))severity note;
        lfsr_next<=shift_right(lfsr_reg,1) or shift_left(bit_reg,15);
         report"LFSR_UPDATE:LFSR_NEXT= "&integer'image(TO_INTEGER(lfsr_next))severity note;
        state_next<=rnd_path;
        REPORT"LFSR_UPDATE--->RND_PATH"severity note;
     
   when rnd_path=>
      report"JAVLAJM SE IZ STANJA RND_PATH"severity note;
      report"RND_PATH:LFSR_REG= "&integer'image(TO_INTEGER(lfsr_reg))severity note;
      
      
          slucajniPravac_next<=RESIZE(shift_right(lfsr_reg*4,16),8);--ograniceno da uvek bude u opsegu 0 do 3,tj nikad nece biti vece od 3 
          
          report"RND_PATH:SLUCAJNI_PRAVAC_NEXT= "&integer'image(TO_INTEGER(slucajniPravac_next))severity note;  
          
       
          
          state_next<=tmp_load;
          report"RND_PATH----->TMP_LOAD"severity note;
   
  when tmp_load=>
          
            report"JAVLJAM SE IZ STANJA TMP_LOAD"severity note;
            
            
           report"tmp_load:TRENUTNI_PRAVAC_REG= "&integer'image(TO_INTEGER(trenutniPravac_reg))severity note; 
          
       REPORT"tmp_load:X_REG_DESNO= "&integer'image(TO_INTEGER(x_reg_desno))severity note;  
       REPORT"tmp_load:Y_REG_DESNO= "&integer'image(TO_INTEGER(y_reg_desno))severity note;  
       REPORT"tmp_load:X_REG_LEVO= "&integer'image(TO_INTEGER(x_reg_levo))severity note;  
       REPORT"tmp_load:Y_REG_LEVO= "&integer'image(TO_INTEGER(y_reg_levo))severity note;  
      REPORT"tmp_load:X_REG_GORE= "&integer'image(TO_INTEGER(x_reg_gore))severity note;  
       REPORT"tmp_load:Y_REG_GORE= "&integer'image(TO_INTEGER(y_reg_gore))severity note;  
      REPORT"tmp_load:X_REG_DOLE= "&integer'image(TO_INTEGER(x_reg_dole))severity note;  
       REPORT"tmp_load:Y_REG_DOLE= "&integer'image(TO_INTEGER(y_reg_dole))severity note;   
           
           
           
           
           
           
            if(trenutniPravac_reg=0)then
            
             report"RND_PATH:TP=0"severity note;
             
               tmpPravacX_next<=x_reg_desno;
               tmpPravacY_next<=y_reg_desno;
               report"RND_PATH:TMP_PRAVAC_X_NEXT= "&integer'image(TO_INTEGER(tmpPravacX_next))severity note;
                report"RND_PATH:TMP_PRAVAC_Y_NEXT= "&integer'image(TO_INTEGER(tmpPravacY_next))severity note;
               
               
               state_next<=swap_path1;
               report"TMP_LOAD--->SWAP_PATH1"severity note;
                 ---state_next<=idle;
               
            elsif(trenutniPravac_reg=1)then
            
            report"RND_PATH:TP=1"severity note;
               tmpPravacX_next<=x_reg_levo;
               tmpPravacY_next<=y_reg_levo;
               
               report"RND_PATH:TMP_PRAVAC_X_NEXT= "&integer'image(TO_INTEGER(tmpPravacX_next))severity note;
                report"RND_PATH:TMP_PRAVAC_Y_NEXT= "&integer'image(TO_INTEGER(tmpPravacY_next))severity note;
                
                state_next<=swap_path1;
               report"TMP_LOAD--->SWAP_PATH1"severity note;
            elsif(trenutniPravac_reg=2)then
              
              report"RND_PATH:TP=2"severity note;
                 
               tmpPravacX_next<=x_reg_gore;  
               tmpPravacY_next<=y_reg_gore;
              
               
               
                report"RND_PATH:TMP_PRAVAC_X_NEXT= "&integer'image(TO_INTEGER(tmpPravacX_next))severity note;
                report"RND_PATH:TMP_PRAVAC_Y_NEXT= "&integer'image(TO_INTEGER(tmpPravacY_next))severity note;
               
                state_next<=swap_path1;
                report"TMP_LOAD--->SWAP_PATH1"severity note;
                
            elsif(trenutniPravac_reg=3)then  
            
            report"USAO SAM U IF DEO GDE JE TP=3,Y_REG_DOLE= "&integer'image(TO_INTEGER(y_reg_dole));
            report"USAO SAM U IF DEO GDE JE TP=3,X_REG_DOLE= "&integer'image(TO_INTEGER(x_reg_dole));
                 
                tmpPravacX_next<=x_reg_dole; 
                tmpPravacY_next<=y_reg_dole;
              
               
               report"RND_PATH:TMP_PRAVAC_X_NEXT= "&integer'image(TO_INTEGER(tmpPravacX_next))severity note;
                report"RND_PATH:TMP_PRAVAC_Y_NEXT= "&integer'image(TO_INTEGER(tmpPravacY_next))severity note;
               
              state_next<=swap_path1;
              report"TMP_LOAD--->SWAP_PATH1"severity note;
                              
            end if;
     
      when swap_path1=>
          report"JAVALJAM SE IZ SWAP_PATH_1"severity note;
          report"SWAP_PATH_1:TRENUTNI_PRAVAC_REG= "&integer'image(TO_INTEGER(trenutniPravac_reg))severity note;
          report"SWAP_PATH_1:SLUCAJNI_PRAVAC_REG= "&integer'image(TO_INTEGER(slucajniPravac_reg))severity note;
          
          
      REPORT"SWAP_PATH_1:X_REG_DESNO= "&integer'image(TO_INTEGER(x_reg_desno));  
       REPORT"SWAP_PATH_1:Y_REG_DESNO= "&integer'image(TO_INTEGER(y_reg_desno));  
       REPORT"SWAP_PATH_1:X_REG_LEVO= "&integer'image(TO_INTEGER(x_reg_levo));  
       REPORT"SWAP_PATH_1:Y_REG_LEVO= "&integer'image(TO_INTEGER(y_reg_levo));  
       REPORT"SWAP_PATH_1:X_REG_GORE= "&integer'image(TO_INTEGER(x_reg_gore));  
       REPORT"SWAP_PATH_1:Y_REG_GORE= "&integer'image(TO_INTEGER(y_reg_gore));  
       REPORT"SWAP_PATH_1:X_REG_DOLE= "&integer'image(TO_INTEGER(x_reg_dole));  
       REPORT"SWAP_PATH_1:Y_REG_DOLE= "&integer'image(TO_INTEGER(y_reg_dole));  
          
        
          
            case(trenutniPravac_reg)is
            
            when "00000000"=>
            report"USAO SAM U CASE DEO 00000000,RND_PATH_1"severity note;
                 if(slucajniPravac_reg=0)then
                  report"SLUCAJNI PRAVA_REG=0"severity note;
                  REPORT"RND_PATH_1:X_REG_DESNO= "&integer'image(TO_INTEGER(x_reg_desno));  
                  REPORT"RND_PATH_1:Y_REG_DESNO= "&integer'image(TO_INTEGER(y_reg_desno));  
                      y_reg_desno_next<=y_reg_desno;
                      x_reg_desno_next<=x_reg_desno;
                   
                  REPORT"RND_PATH_1:X_REG_DESNO_NEXT= "&integer'image(TO_INTEGER(x_reg_desno_next));  
                   REPORT"RND_PATH_1:Y_REG_DESNO_NEXT= "&integer'image(TO_INTEGER(y_reg_desno_next));    
                      state_next<=swap_path2;
                      
                   elsif(slucajniPravac_reg=1)then
                    report"SLUCAJNI PRAVA_REG=1"severity note;
                   REPORT"RND_PATH_1:X_REG_LEVO= "&integer'image(TO_INTEGER(x_reg_levo));  
                  REPORT"RND_PATH_1:Y_REG_LEVO= "&integer'image(TO_INTEGER(y_reg_levo));  
                      y_reg_desno_next<=y_reg_levo;
                      x_reg_desno_next<=x_reg_levo;
                   REPORT"RND_PATH_1:X_REG_DESNO_NEXT= "&integer'image(TO_INTEGER(x_reg_desno_next));  
                   REPORT"RND_PATH_1:Y_REG_DESNO_NEXT= "&integer'image(TO_INTEGER(y_reg_desno_next));    
                       state_next<=swap_path2;
                    elsif(slucajniPravac_reg=2)then
                     report"SLUCAJNI PRAVA_REG=2"severity note;
                   REPORT"RND_PATH_1:X_REG_GORE= "&integer'image(TO_INTEGER(x_reg_gore));  
                  REPORT"RND_PATH_1:Y_REG_GORE= "&integer'image(TO_INTEGER(y_reg_gore));
                      y_reg_desno_next<=y_reg_gore;
                      x_reg_desno_next<=x_reg_gore; 
                      REPORT"RND_PATH_1:X_REG_DESNO_NEXT= "&integer'image(TO_INTEGER(x_reg_desno_next));  
                   REPORT"RND_PATH_1:Y_REG_DESNO_NEXT= "&integer'image(TO_INTEGER(y_reg_desno_next));     
                      state_next<=swap_path2;
                    elsif(slucajniPravac_reg=3)then
                     report"SLUCAJNI PRAVA_REG=3"severity note;
                   REPORT"RND_PATH_1:X_REG_DOLE= "&integer'image(TO_INTEGER(x_reg_dole));  
                  REPORT"RND_PATH_1:Y_REG_DOLE= "&integer'image(TO_INTEGER(y_reg_dole));
                      y_reg_desno_next<=y_reg_dole;
                      x_reg_desno_next<=x_reg_dole;
                      REPORT"RND_PATH_1:X_REG_DESNO_NEXT= "&integer'image(TO_INTEGER(x_reg_desno_next));  
                   REPORT"RND_PATH_1:Y_REG_DESNO_NEXT= "&integer'image(TO_INTEGER(y_reg_desno_next));  
                       state_next<=swap_path2;
                        
                  
                 end if;
                 
                 
                 
                 
                  when "00000001"=>
                  report"USAO SAM U CASE DEO 00000001,RND_PATH_1"severity note;
                 if(slucajniPravac_reg=0)then
                 report"SLUCAJNI PRAVA_REG=0"severity note;
                 REPORT"RND_PATH_1:X_REG_DESNO= "&integer'image(TO_INTEGER(x_reg_desno));  
                  REPORT"RND_PATH_1:Y_REG_DESNO= "&integer'image(TO_INTEGER(y_reg_desno));
                      y_reg_levo_next<=y_reg_desno;
                      x_reg_levo_next<=x_reg_desno;
                     REPORT"RND_PATH_1:X_REG_LEVO_NEXT= "&integer'image(TO_INTEGER(x_reg_levo_next));  
                  REPORT"RND_PATH_1:Y_REG_LEVO_NEXT= "&integer'image(TO_INTEGER(y_reg_levo_next)); 
                      
                      
                       state_next<=swap_path2;
                   elsif(slucajniPravac_reg=1)then
                     report"SLUCAJNI_PRAVAC_REG=1"severity note;
                    REPORT"RND_PATH_1:X_REG_LEVO= "&integer'image(TO_INTEGER(x_reg_levo));  
                  REPORT"RND_PATH_1:Y_REG_LEVO= "&integer'image(TO_INTEGER(y_reg_levo));
                      y_reg_levo_next<=y_reg_levo;
                      x_reg_levo_next<=x_reg_levo;
                       REPORT"RND_PATH_1:X_REG_LEVO_NEXT= "&integer'image(TO_INTEGER(x_reg_levo_next));  
                  REPORT"RND_PATH_1:Y_REG_LEVO_NEXT= "&integer'image(TO_INTEGER(y_reg_levo_next)); 
                     state_next<=swap_path2;
                    elsif(slucajniPravac_reg=2)then
                   report"SLUCAJNI_PRAVAC_REG=2"severity note;
                    REPORT"RND_PATH_1:X_REG_GORE= "&integer'image(TO_INTEGER(x_reg_gore));  
                  REPORT"RND_PATH_1:Y_REG_GORE= "&integer'image(TO_INTEGER(y_reg_gore));
                      y_reg_levo_next<=y_reg_gore;
                      x_reg_levo_next<=x_reg_gore; 
                 REPORT"RND_PATH_1:X_REG_LEVO_NEXT= "&integer'image(TO_INTEGER(x_reg_levo_next));  
                  REPORT"RND_PATH_1:Y_REG_LEVO_NEXT= "&integer'image(TO_INTEGER(y_reg_levo_next)); 
                      state_next<=swap_path2;
                    elsif(slucajniPravac_reg=3)then
                    report"SLUCAJNI_PRAVAC_REG=3"severity note;
                   REPORT"RND_PATH_1:X_REG_DOLE= "&integer'image(TO_INTEGER(x_reg_dole));  
                  REPORT"RND_PATH_1:Y_REG_DOLE= "&integer'image(TO_INTEGER(y_reg_dole));
                      y_reg_levo_next<=y_reg_dole;
                      x_reg_levo_next<=x_reg_dole;
                       REPORT"RND_PATH_1:X_REG_LEVO_NEXT= "&integer'image(TO_INTEGER(x_reg_levo_next));  
                  REPORT"RND_PATH_1:Y_REG_LEVO_NEXT= "&integer'image(TO_INTEGER(y_reg_levo_next)); 
                       state_next<=swap_path2;
                        
                  
                 end if;
               
                 when "00000010"=>
                 report"USAO SAM U CASE DEO 00000010,RND_PATH_1"severity note;
                 if(slucajniPravac_reg=0)then
                 report"SLUCAJNI_PRAVAC_REG=0"severity note;
                 REPORT"RND_PATH_1:X_REG_DESNO= "&integer'image(TO_INTEGER(x_reg_desno));  
                  REPORT"RND_PATH_1:Y_REG_DESNO= "&integer'image(TO_INTEGER(y_reg_desno));
                      y_reg_gore_next<=y_reg_desno;
                      x_reg_gore_next<=x_reg_desno;
                     REPORT"RND_PATH_1:X_REG_GORE_NEXT= "&integer'image(TO_INTEGER(x_reg_gore_next));  
                  REPORT"RND_PATH_1:Y_REG_GORE_NEXT= "&integer'image(TO_INTEGER(y_reg_gore_next));   
                       state_next<=swap_path2;
                      
                   elsif(slucajniPravac_reg=1)then
                   report"SLUCAJNI_PRAVAC_REG=1"severity note;
                   REPORT"RND_PATH_1:X_REG_LEVO= "&integer'image(TO_INTEGER(x_reg_levo));  
                  REPORT"RND_PATH_1:Y_REG_LEVO= "&integer'image(TO_INTEGER(y_reg_levo));
                      y_reg_gore_next<=y_reg_levo;
                      x_reg_gore_next<=x_reg_levo;
                  REPORT"RND_PATH_1:X_REG_GORE_NEXT= "&integer'image(TO_INTEGER(x_reg_gore_next));  
                  REPORT"RND_PATH_1:Y_REG_GORE_NEXT= "&integer'image(TO_INTEGER(y_reg_gore_next));   
                       state_next<=swap_path2;
                       
                       
                    elsif(slucajniPravac_reg=2)then
                   report"SLUCAJNI_PRAVAC_REG=2"severity note;
                      REPORT"RND_PATH_1:X_REG_GORE= "&integer'image(TO_INTEGER(x_reg_gore));  
                  REPORT"RND_PATH_1:Y_REG_GORE= "&integer'image(TO_INTEGER(y_reg_gore));
                   
                      y_reg_gore_next<=y_reg_gore;
                      x_reg_gore_next<=x_reg_gore;  
                      
                  REPORT"RND_PATH_1:X_REG_GORE_NEXT= "&integer'image(TO_INTEGER(x_reg_gore_next));  
                  REPORT"RND_PATH_1:Y_REG_GORE_NEXT= "&integer'image(TO_INTEGER(y_reg_gore_next)); 
                  
                       state_next<=swap_path2;
                     
                    elsif(slucajniPravac_reg=3)then
                    report"SLUCAJNI_PRAVAC_REG=3"severity note;
                   REPORT"RND_PATH_1:X_REG_DOLE= "&integer'image(TO_INTEGER(x_reg_dole));  
                  REPORT"RND_PATH_1:Y_REG_DOLE= "&integer'image(TO_INTEGER(y_reg_dole));
                   
                      y_reg_gore_next<=y_reg_dole;
                      x_reg_gore_next<=x_reg_dole;
                      
                      REPORT"RND_PATH_1:X_REG_GORE_NEXT= "&integer'image(TO_INTEGER(x_reg_gore_next));  
                  REPORT"RND_PATH_1:Y_REG_GORE_NEXT= "&integer'image(TO_INTEGER(y_reg_gore_next)); 
                     state_next<=swap_path2;
                      
                  
                 end if;   
            
            
                when "00000011"=>
                report"USAO SAM U CASE DEO 00000011,RND_PATH_1"severity note;
                    if(slucajniPravac_reg=0)then
                     report"SLUCAJNI_PRAVAC_REG=0"severity note;
                     REPORT"RND_PATH_1:X_REG_DESNO= "&integer'image(TO_INTEGER(x_reg_desno));  
                  REPORT"RND_PATH_1:Y_REG_DESNO= "&integer'image(TO_INTEGER(y_reg_desno));
                     
                      y_reg_dole_next<=y_reg_desno;
                      x_reg_dole_next<=x_reg_desno;
                       REPORT"RND_PATH_1:X_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(x_reg_dole_next));  
                  REPORT"RND_PATH_1:Y_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(y_reg_dole_next)); 
                      
                          state_next<=swap_path2;
                   elsif(slucajniPravac_reg=1)then
                   report"SLUCAJNI_PRAVAC_REG=1"severity note;
                     REPORT"RND_PATH_1:X_REG_LEVO= "&integer'image(TO_INTEGER(x_reg_levo));  
                  REPORT"RND_PATH_1:Y_REG_LEVO= "&integer'image(TO_INTEGER(y_reg_levo));
                   
                   
                      y_reg_dole_next<=y_reg_levo;
                      x_reg_dole_next<=x_reg_levo;
                      
                      REPORT"RND_PATH_1:X_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(x_reg_dole_next));  
                  REPORT"RND_PATH_1:Y_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(y_reg_dole_next)); 
                      
                       state_next<=swap_path2;
                      
                    elsif(slucajniPravac_reg=2)then
                    report"SLUCAJNI_PRAVAC_REG=2"severity note;
                     REPORT"RND_PATH_1:X_REG_GORE= "&integer'image(TO_INTEGER(x_reg_gore));  
                  REPORT"RND_PATH_1:Y_REG_GORE= "&integer'image(TO_INTEGER(y_reg_gore));
                    
                    
                   
                      y_reg_dole_next<=y_reg_gore;
                      x_reg_dole_next<=x_reg_gore;  
                      
                       REPORT"RND_PATH_1:X_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(x_reg_dole_next));  
                  REPORT"RND_PATH_1:Y_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(y_reg_dole_next)); 
                  
                     state_next<=swap_path2;
                    elsif(slucajniPravac_reg=3)then
                   report"SLUCAJNI_PRAVAC_REG=3"severity note;
                     REPORT"RND_PATH_1:X_REG_DOLE= "&integer'image(TO_INTEGER(x_reg_dole));  
                  REPORT"RND_PATH_1:Y_REG_DOLE= "&integer'image(TO_INTEGER(y_reg_dole));
                      y_reg_dole_next<=y_reg_dole;
                      x_reg_dole_next<=x_reg_dole;
                      REPORT"RND_PATH_1:X_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(x_reg_dole_next));  
                  REPORT"RND_PATH_1:Y_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(y_reg_dole_next)); 
                      
                      
                      state_next<=swap_path2;
                       
                  
                 end if;   
                         when others=>
                            report"NEDOZOVLJENO STANJE"severity note;
                            
            end case;
            
       when swap_path2=>
         
         report"JAVLJAM SE IZ SWAP_PATH_2 STANJA"severity note;
         report"SWAP_PATH_2:SLUCAJNI_PRAVAC_REG= "&integer'image(TO_INTEGER(slucajniPravac_reg))severity note;
         
            if(slucajniPravac_reg=0)then
           REPORT"SWAP_PATH_2:SLUCAJNI_PRAVAC_REG=0"severity note;
                  
                 REPORT"RND_PATH_1:TMP_PRAVAC_X_REG= "&integer'image(TO_INTEGER(tmpPravacX_reg));  
                  REPORT"RND_PATH_1:TMP_PRAVAC_Y_REG= "&integer'image(TO_INTEGER(tmpPravacY_reg));  
                  
                 x_reg_desno_next<=tmpPravacX_reg;
                 y_reg_desno_next<=tmpPravacY_reg;
           
                  REPORT"RND_PATH_1:X_REG_DESNO_NEXT= "&integer'image(TO_INTEGER(x_reg_desno_next));  
                  REPORT"RND_PATH_1:Y_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(y_reg_desno_next));  
                 trenutniPravac_next<=trenutniPravac_reg+1;
                 report"RND_PATH2---->RND_BIT_LFSR"severity note;
                 state_next<=rnd_bit_lfsr;
                 
             elsif(slucajniPravac_reg=1)then
             
                REPORT"RND_PATH_1:TMP_PRAVAC_X_REG= "&integer'image(TO_INTEGER(tmpPravacX_reg));  
                  REPORT"RND_PATH_1:TMP_PRAVAC_Y_REG= "&integer'image(TO_INTEGER(tmpPravacY_reg)); 
             
                  x_reg_levo_next<=tmpPravacX_reg;
                 y_reg_levo_next<=tmpPravacY_reg;
                 REPORT"RND_PATH_1:X_REG_LEVO_NEXT= "&integer'image(TO_INTEGER(x_reg_levo_next));  
                  REPORT"RND_PATH_1:Y_REG_LEVO_NEXT= "&integer'image(TO_INTEGER(y_reg_levo_next));  
                 
                 trenutniPravac_next<=trenutniPravac_reg+1;
                 report"RND_PATH2---->RND_BIT_LFSR"severity note;
                 state_next<=rnd_bit_lfsr;
             elsif(slucajniPravac_reg=2)then
                 
                 REPORT"RND_PATH_1:TMP_PRAVAC_X_REG= "&integer'image(TO_INTEGER(tmpPravacX_reg));  
                  REPORT"RND_PATH_1:TMP_PRAVAC_Y_REG= "&integer'image(TO_INTEGER(tmpPravacY_reg)); 
                  x_reg_gore_next<=tmpPravacX_reg;
                 y_reg_gore_next<=tmpPravacY_reg;
                 REPORT"RND_PATH_1:X_REG_GORE_NEXT= "&integer'image(TO_INTEGER(x_reg_gore_next));  
                  REPORT"RND_PATH_1:Y_REG_GORE_NEXT= "&integer'image(TO_INTEGER(y_reg_gore_next)); 
                 
                 trenutniPravac_next<=trenutniPravac_reg+1;
                 report"RND_PATH2---->RND_BIT_LFSR"severity note;
                 state_next<=rnd_bit_lfsr;    
             elsif(slucajniPravac_reg=3)then
                 REPORT"RND_PATH_1:TMP_PRAVAC_X_REG= "&integer'image(TO_INTEGER(tmpPravacX_reg));  
                  REPORT"RND_PATH_1:TMP_PRAVAC_Y_REG= "&integer'image(TO_INTEGER(tmpPravacY_reg)); 
             
                  x_reg_dole_next<=tmpPravacX_reg;
                 y_reg_dole_next<=tmpPravacY_reg;
                 
                 REPORT"RND_PATH_1:X_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(x_reg_dole_next));  
                  REPORT"RND_PATH_1:Y_REG_DOLE_NEXT= "&integer'image(TO_INTEGER(y_reg_dole_next));
                 trenutniPravac_next<=trenutniPravac_reg+1;
                 report"RND_PATH2---->RND_BIT_LFSR"severity note;
                 state_next<=rnd_bit_lfsr;
                 
                          
            end if;
        
      when load_direction=>
               report"JAVLJAM SE IZ STANJA LOAD_DIRECTION"severity note;
               x_reg_desno_next<=x_reg_desno;
               y_reg_desno_next<=y_reg_desno;
                 -----------------------
               x_reg_levo_next<=x_reg_levo;
               y_reg_levo_next<=y_reg_levo;
               -------------------------------
               x_reg_gore_next<=x_reg_gore;
               y_reg_gore_next<=y_reg_gore;
                 -----------------------
               x_reg_dole_next<=x_reg_dole;
               y_reg_dole_next<=y_reg_dole;


               
               
               
       REPORT"LOAD_DIRECTION:X_REG_DESNO= "&integer'image(TO_INTEGER(x_reg_desno_next));  
       REPORT"LOAD_DIRECTION:Y_REG_DESNO= "&integer'image(TO_INTEGER(y_reg_desno_next));  
       REPORT"LOAD_DIRECTION:X_REG_LEVO= "&integer'image(TO_INTEGER(x_reg_levo_next));  
       REPORT"LOAD_DIRECTION:Y_REG_LEVO= "&integer'image(TO_INTEGER(y_reg_levo_next));  
       REPORT"LOAD_DIRECTION:X_REG_GORE= "&integer'image(TO_INTEGER(x_reg_gore_next));  
       REPORT"LOAD_DIRECTION:Y_REG_GORE= "&integer'image(TO_INTEGER(y_reg_gore_next));  
       REPORT"LOAD_DIRECTION:X_REG_DOLE= "&integer'image(TO_INTEGER(x_reg_dole_next));  
       REPORT"LOAD_DIRECTION:Y_REG_DOLE= "&integer'image(TO_INTEGER(y_reg_dole_next));  
               
           state_next<=new_cord;    
      
      report"LOAD_DIRECTION--->NEW_CORD"severity note;
        
       when new_cord=>
     report"JAVLJAM SE IZ STANJA NOVE_KOORDINATE"severity note;  
     --report"NOVE_KOORDINATE:TRENUTNI_PRAVAC_REG= "&integer'image(TO_INTEGER(trenutniPravac_reg))severity note;
     --report"NOVE_KOORDINATE:X_REG_DESNO= "&integer'image(TO_INTEGER(x_reg_desno))severity note;
     --report"NOVE_KOORDINATE:Y_REG_DESNO= "&integer'image(TO_INTEGER(y_reg_desno))severity note;
     --report"NOVE_KOORDINATE:TRENUTNO_X_REG= "&integer'image(TO_INTEGER(trenutnoX_reg))severity note;
      --report"NOVE_KOORDINATE:TRENUTNO_Y_REG= "&integer'image(TO_INTEGER(trenutnoY_reg))severity note;
       
       
       report"NOVE_KOORDINATE:TRENUTNI_PRAVAC_REG= "&integer'image(TO_INTEGER(trenutniPravac_reg))severity note;
       
       report"NOVE KOORDINATE:TRENUTNO_X= "&integer'image(TO_INTEGER(trenutnoX_reg))severity note;
       report"NOVE KOORDINATE:TRENUTNO_Y= "&integer'image(TO_INTEGER(trenutnoY_reg))severity note;
              
      
       REPORT"NOVE_KOORDINATE:X_REG_DESNO= "&integer'image(TO_INTEGER(x_reg_desno));  
       REPORT"NOVE_KOORDINATE:Y_REG_DESNO= "&integer'image(TO_INTEGER(y_reg_desno));  
       REPORT"NOVE_KOORDINATE:X_REG_LEVO= "&integer'image(TO_INTEGER(x_reg_levo));  
       REPORT"NOVE_KOORDINATE:Y_REG_LEVO= "&integer'image(TO_INTEGER(y_reg_levo));  
       REPORT"NOVE_KOORDINATE:X_REG_GORE= "&integer'image(TO_INTEGER(x_reg_gore));  
       REPORT"NOVE_KOORDINATE:Y_REG_GORE= "&integer'image(TO_INTEGER(y_reg_gore));  
       REPORT"NOVE_KOORDINATE:X_REG_DOLE= "&integer'image(TO_INTEGER(x_reg_dole));  
       REPORT"NOVE_KOORDINATE:Y_REG_DOLE= "&integer'image(TO_INTEGER(y_reg_dole)); 
      
      
      
               
                      
                      case(trenutniPravac_reg)is
                      
                         when "00000000"=>
                   report"NOVE_KOORDINATE:USAO U WHEN 00000000"severity note;  
                   
                   
                   --report"2*X_REG_DESNO= "&INTEGER'image(TO_INTEGER(2*x_reg_desno))severity note;
                   --report"2*Y_REG_DESNO= "&INTEGER'image(TO_INTEGER(2*y_reg_desno))severity note;
                   
                   
                   
                   novoX_next<=RESIZE(TO_SIGNED(TO_INTEGER(trenutnoX_reg),8)+2*x_reg_desno,8);
                    novoY_next<=RESIZE(TO_SIGNED(TO_INTEGER(trenutnoY_reg),8)+2*y_reg_desno,8);
                            
                            
                            
              report"NOVE_KOORDINATE:00000000-->NOVO_X_NEXT= "&integer'image(to_integer(novoX_next))severity note;
               report"NOVE_KOORDINATE:00000000-->NOVO_Y_NEXT= "&integer'image(to_integer(novoY_next))severity note;
                            state_next<=check_cordinate;
                            
                            
                         report"NOVE_KOORDINATE--->READ_MAZE"severity note;
                         
                         when "00000001"=>
                            report"NOVE_KOORDINATE:USAO U WHEN 00000001"severity note;  
                            novoX_next<=RESIZE(TO_SIGNED(TO_INTEGER(trenutnoX_reg),8)+2*x_reg_levo,8); 
                            novoY_next<=RESIZE(TO_SIGNED(TO_INTEGER(trenutnoY_reg),8)+2*y_reg_levo,8);
                              state_next<=check_cordinate;

                            report"NOVE_KOORDINATE:00000001-->NOVO_X_NEXT= "&integer'image(to_integer(novoX_NEXT))severity note;
               report"NOVE_KOORDINATE:00000001-->NOVO_Y_NEXT= "&integer'image(to_integer(novoY_NEXT))severity note;
                            report"NOVE_KOORDINATE--->READ_MAZE"severity note;
                            
                         when "00000010"=>
                            report"NOVE_KOORDINATE:USAO U WHEN 00000010"severity note;  
                            novoX_next<=RESIZE(TO_SIGNED(TO_INTEGER(trenutnoX_reg),8)+2*x_reg_gore,8); 
                            novoY_next<=RESIZE(TO_SIGNED(TO_INTEGER(trenutnoY_reg),8)+2*y_reg_gore,8);
                            state_next<=check_cordinate;
                            report"NOVE_KOORDINATE:00000010-->NOVO_X_NEXT= "&integer'image(to_integer(novoX_NEXT))severity note;
               report"NOVE_KOORDINATE:00000010-->NOVO_Y_NEXT= "&integer'image(to_integer(novoY_NEXT))severity note;
                            report"NOVE_KOORDINATE--->READ_MAZE"severity note;
                          
                         when "00000011"=>
                            report"NOVE_KOORDINATE:USAO U WHEN 00000011"severity note;  
                            novoX_next<=RESIZE(TO_SIGNED(TO_INTEGER(trenutnoX_reg),8)+2*x_reg_dole,8); 
                            novoY_next<=RESIZE(TO_SIGNED(TO_INTEGER(trenutnoY_reg),8)+2*y_reg_dole,8);
                            report"NOVE_KOORDINATE:00000011-->NOVO_X_NEXT= "&integer'image(to_integer(novoX_NEXT))severity note;
               report"NOVE_KOORDINATE:00000011-->NOVO_Y_NEXT= "&integer'image(to_integer(novoY_NEXT))severity note;
                            state_next<=check_cordinate;  
                            report"NOVE_KOORDINATE--->READ_MAZE"severity note; 
                      
                        when others=>
                             
                            state_next<=dfs_start;
                            report"NOVE_KOORDINATE--->DFS_START"severity note;
                      
                      end case;
                      
           
       
       when check_cordinate=>
               
                report"JAVLJAM SE IZ STANJA CHECK_CORDINATE"severity note;
    report"CHECK_CORDINATE:NOVO_X_REG= "&integer'image(TO_INTEGER(novoX_reg));
    report"CHECK_CORDINATE:NOVO_Y_REG= "&integer'image(TO_INTEGER(novoY_reg));
    report"CHECK_CORDINATE:COLS= "&integer'image(TO_INTEGER(unsigned(cols)));
    
                
       
           if(novoX_reg>=0 and novoX_reg<signed(rows) and novoY_reg>=0 and novoY_reg<signed(cols))then
                       
                       state_next<=read_maze;
                       report"CHECK_CORDINATE--->READ_MAZE"severity note;
            else        
                       trenutniPravac_next<=trenutniPravac_reg+1;
                       report"CHECK_CORDINATE---->NOVE_KOORDINATE"severity note;
                       state_next<=new_cord;           
           
           end if;
       
       
      when read_maze=>
                 
                 report"JAVLJAM SE IZ STANJA READ_MAZE"severity note;
                 report"READ_MAZE:NOVO_X_REG= "&integer'image(TO_INTEGER(novoX_reg));
                  report"READ_MAZE:NOVO_Y_REG= "&integer'image(TO_INTEGER(novoY_reg));
            
                   --addr_maze<="0000000000001010";
                   addr_maze<=std_logic_vector(novoX_reg*signed(cols)+novoY_reg);
                   ctrl_maze<='0';
                   en_maze<='1';
          
                     if(data_maze_in="00000001")then  
                           
                           state_next<=break_wall;
                      else
                          trenutniPravac_next<=trenutniPravac_reg+1;
                          state_next<=new_cord;     
   
                     end if;
   
   
   
   when break_wall=>
               
               
               report"JAVLAJM SE IZ BREAK_WALL STANJA"severity note;
               report"BREAK_WALL= "&integer'image(TO_INTEGER(trenutniPravac_reg))severity note;
               
              if(trenutniPravac_reg=0)then
                 addr_maze<=std_logic_vector(abs((novoX_reg-x_reg_desno))*signed(cols)-(novoY_reg-y_reg_desno));
                ctrl_maze<='1';
                data_maze<="00000000";
                state_next<=new_cord_is_maze;
                
            elsif(trenutniPravac_reg=1)then
              
              addr_maze<=std_logic_vector(abs((novoX_reg-x_reg_levo))*signed(cols)-(novoY_reg-y_reg_levo));
                ctrl_maze<='1';
                data_maze<="00000000";
                state_next<=new_cord_is_maze;
                
            elsif(trenutniPravac_reg=2)then
              
              addr_maze<=std_logic_vector(abs((novoX_reg-x_reg_gore))*signed(cols)+(novoY_reg-y_reg_gore));
                ctrl_maze<='1';
                data_maze<="00000000";
            state_next<=new_cord_is_maze;
          elsif(trenutniPravac_reg=3)then
              
              addr_maze<=std_logic_vector(abs((novoX_reg-x_reg_dole))*signed(cols)+(novoY_reg-y_reg_dole));
                ctrl_maze<='1';
                data_maze<="00000000";  
              state_next<=new_cord_is_maze;
              
              end if;
   
   
   
   when new_cord_is_maze=>
      report"JAVLJAM SE IZ STANJA NEW CORD IS MAZE"severity note;
   
             addr_maze<=std_logic_vector(novoX_reg*signed(cols)+novoY_reg);
             ctrl_maze<='1';
             data_maze<="00000000";
             stackTop_next<=stackTop_reg+1;
             
           state_next<=new_cord_push_stack;
           report"NEW_CORD_IS_MAZE--->NEW_CORD_PUSH_STACK"severity note;  
   
   when new_cord_push_stack=>
       
       report"JAVLJAM SE IZ STANJA NEW CORD PUSH STACK"severity note;
       report"NEW_CORD_PUSH_STACK= "&integer'image(TO_INTEGER(stackTop_reg))severity note;
       report"NEW_CORD_PUSH_STACK:NOVO_X_REG= "&integer'image(TO_INTEGER(novoX_reg))severity note;
       report"NEW_CORD_PUSH_STACK:NOVO_Y_REG= "&integer'image(TO_INTEGER(novoY_reg))severity note;
       
       
       
       
   addr_stackX<=std_logic_vector(RESIZE(stackTop_reg+1,16));
   ctrl_stackX<='1';
   data_stackX<=std_logic_vector(novoX_reg);
   
   addr_stackY<=std_logic_vector(signed(rows)*signed(cols)+stackTop_reg+1);
   ctrl_stackY<='1';
   data_stackY<=std_logic_vector(novoY_reg);
   
   trenutniPravac_next<=trenutniPravac_reg+1;
   state_next<=new_cord;
   
   report"NEW_CORD_PUSH_STACK---->NEW_CORD"severity note;
   
       
            
    
  end case;  
        
        
END process;




end Behavioral;