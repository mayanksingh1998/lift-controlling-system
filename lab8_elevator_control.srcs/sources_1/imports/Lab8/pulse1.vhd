library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pulse1 is
  Port (in1 :in std_logic:='0';
        clk: in std_logic;
   out1 :out std_logic);
end pulse1;

architecture structure of pulse1 is
signal d1,d2:STD_LOGIC:='0';
begin
    process(clk)
    begin
         if clk= '1' and clk'event then
               d1<=in1;
               d2<=d1;
         end if;
    end process;
    out1<= (not(d2)) and d1; 

end structure;
