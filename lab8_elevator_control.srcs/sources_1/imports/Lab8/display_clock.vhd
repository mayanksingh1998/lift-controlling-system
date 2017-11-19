library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_clock is
  Port ( 
	  clock : in STD_LOGIC;
          out_clock : out STD_LOGIC);
  end display_clock;

architecture structure of display_clock is
	SIGNAL ring : std_logic_vector (14 downto 0) := "000000000000000";
begin
process(clock)
begin
		IF (clock='1' AND clock'EVENT) THEN 
		ring <= ring +1;
		END IF;
	 	
		out_clock <= ring(14);
end process;
end structure;
