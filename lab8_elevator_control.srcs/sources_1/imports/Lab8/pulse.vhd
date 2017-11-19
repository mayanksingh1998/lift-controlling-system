library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pulse is
 Port (in4 :in std_logic_vector(3 downto 0):="0000";
        clk: in std_logic;
   out4 :out std_logic_vector(3 downto 0));
end pulse;

architecture structure of pulse is
signal a,b,c,d,o1,o2,o3,o4:std_logic:='0';

begin
    pulse1: entity work.pulse1(structure)
    port map(clk=>clk,in1=>a,out1=>o1);
 pulse2: entity work.pulse1(structure)
       port map(clk=>clk,in1=>b,out1=>o2);
        pulse3: entity work.pulse1(structure)
          port map(clk=>clk,in1=>c,out1=>o3);
           pulse4: entity work.pulse1(structure)
             port map(clk=>clk,in1=>d,out1=>o4);
             
          a<=   in4(0);
          b<=in4(1);
          c<=in4(2);
          d<=in4(3);
          
          out4(0)<=o1;
          out4(1)<=o2;
          out4(2)<=o3;
          out4(3)<=o4;
end structure;
