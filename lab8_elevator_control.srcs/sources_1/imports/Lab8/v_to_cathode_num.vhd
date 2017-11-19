library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity v_to_cathode_num is
PORT (
	to_display : IN std_logic_vector(1 downto 0);
	res : OUT std_logic_vector (6 downto 0)
	);
end v_to_cathode_num;

architecture structure of v_to_cathode_num is

begin
PROCESS (to_display)
		BEGIN
			CASE to_display IS
				when "00"=>res<="1000000";--0
				when "01"=>res<="1111001";--1
				when "10"=>res<="0100100";--2
				when others =>res<="0110000";--3

			END CASE;
		END PROCESS;


end structure;
