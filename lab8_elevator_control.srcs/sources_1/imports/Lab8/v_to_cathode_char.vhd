library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity v_to_cathode_char is
PORT (
	to_display : IN std_logic_vector(1 downto 0);
	res : OUT std_logic_vector (6 downto 0)
	);
end v_to_cathode_char;

architecture structure of v_to_cathode_char is

begin
PROCESS (to_display)
		BEGIN
			CASE to_display IS
				when "00"=>res<="1100011";--u
				when "01"=>res<="0100001";--d
				when "10"=>res<="0100111";--c
				when others =>res<="0100011";--o

			END CASE;
		END PROCESS;


end structure;
