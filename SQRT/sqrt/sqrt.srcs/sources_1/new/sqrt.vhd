----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/30/2025 03:29:07 PM
-- Design Name: 
-- Module Name: sqrt - Behavioral
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

entity sqrt is
 Port (
        x:in std_logic_vector(31 downto 0);
        res:out std_logic_vector(31 downto 0);
        start:in std_logic;
        clk:in std_logic;
        rst:in std_logic;
        ready:out std_logic
  );
end sqrt;

architecture Behavioral of sqrt is
    type stanja_fsm is(idle,s1,s2,s3,s4,s5,s6);
    signal stanje,naredno_stanje:stanja_fsm;
    signal op_reg,op_next:unsigned(31 downto 0);
    signal res_reg,res_next:unsigned(31 downto 0);
    signal one_reg,one_next:unsigned(31 downto 0);
begin
       
MEM_EL_I_REG_STANJA:process(rst,clk)
begin
       if(rst='1')then
       
          stanje<=idle;
          op_reg<=(others=>'0');
          res_reg<=(others=>'0');
          one_reg<=(others=>'0');
          
       elsif(rising_edge(clk))then
       
          stanje<=naredno_stanje;
          op_reg<=op_next;
          res_reg<=res_next;
          one_reg<=one_next;
       
       end if;
             
end process;

KOMBINACIONA_LOGIKA:process(x,op_reg,res_reg,one_reg,op_next,res_next,one_next,stanje,start)
begin
      op_next<=op_reg;
      res_next<=res_reg;
      one_next<=one_reg;
      ready<='0';
    case(stanje)is
     
     when idle=>
          report "Usao u stanje idle"severity note;
      ready<='1';
      report "Usao u stanje idle,ready=1"severity note;
      if(start='1')then
         report"Proverava da li je start=1"severity note;
      op_next<=unsigned(x);
      res_next<=(others=>'0');
      one_next<=TO_UNSIGNED(1,32);
           report "idle::Vrednost op_next=: " & integer'image(to_integer(op_next));
           report "idle:Vrednost res_next=: " & integer'image(to_integer(res_next));
           report "idle:Vrednost one_next=: " & integer'image(to_integer(one_next));
      naredno_stanje<=s1;
       else
        naredno_stanje<=idle;
        report"Usao u else deo iddel stanja,tj vraca se ponovo u idle narendo_stanje=idle"severity note;
      end if;

       when s1=>
      --  ready<='0';
       report "Usao u stanje s1"severity note;
       one_next<=shift_left(one_reg,30);
       report "s1:Vrednost one_next=: " & integer'image(to_integer(one_next));
        naredno_stanje<=s2;
       when s2=>
                 report "Usao u stanje s2"severity note;
             if(one_reg>op_reg)then
                 naredno_stanje<=s3;
              else
                 naredno_stanje<=s4;   
             end if;
           
         when s3=>
                report "Usao u stanje s3"severity note;
                one_next<=shift_right(one_reg,2);
                report "s3:Vrednost one_next=: " & integer'image(to_integer(one_next));    
                naredno_stanje<=s2;
             
          
       when s4=>
         -- ready<='0';
         report "Usao u stanje s4"severity note;
         report "s4:Vrednost one_next=: " & integer'image(to_integer(one_next));
            if(one_reg /=TO_UNSIGNED(0,32))then
            report "s4:Vrednost res_next=: " & integer'image(to_integer(res_next));
            
                if(op_reg>=res_reg+one_reg)then
                  naredno_stanje<=s5;
                 else
                 naredno_stanje<=s6;
                end if;--kraj 2 if-a
                else
                 naredno_stanje<=idle;
            end if;--kraj 1 if-a
            
      when s5=>
       --ready<='0';
            op_next<=op_reg-(res_reg+one_reg);
            res_next<=RESIZE(res_reg+2*one_reg,32);
            naredno_stanje<=s6;
       when s6=>
        --ready<='0';
           res_next<=shift_right(res_reg,1);
           one_next<=shift_right(one_reg,2);
           naredno_stanje<=s4;

     end case;
end process;   
       
       res<=std_logic_vector(res_reg) when start='0';--ovo je dodatno da ne bi bilo gliceva.Zato sto ce uzeti sve nove vrednosti iz proces bloka koje imaju veze sa res_reg i upisati u reg.
      -- ready<='1' when stanje=idle else '0';
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       

end Behavioral;
