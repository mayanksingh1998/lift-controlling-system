library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity status_display_block is
Port (
	 up_req:in std_logic_vector(3 downto 0);
	 
	 down_req:in std_logic_vector(3 downto 0);

	 lift1_status: in std_logic_vector(9 downto 0);           
	 lift2_status: in std_logic_vector(9 downto 0);
	 clock: in std_logic;  
	 lift1_floor_indicator: out std_logic_vector (3 downto 0);  
	 anode: out std_logic_vector (3 downto 0);
	 up_request_indicator: out std_logic_vector (3 downto 0);
	 down_request_indicator: out std_logic_vector (3 downto 0);
	 lift2_floor_indicator: out std_logic_vector (3 downto 0);
	 cathode : out std_logic_vector(6 downto 0)
);
end status_display_block;

architecture structure of status_display_block is
signal ring_counter:std_logic_vector(3 downto 0):="0000";
signal result:std_logic_vector(7 downto 0):="00000000";
begin
	lift1_floor_indicator<=lift1_status(7 downto 4);
	result(7 downto 4)<=lift1_status(3 downto 0);
	lift2_floor_indicator<=lift2_status(7 downto 4);
	result(3 downto 0)<=lift2_status(3 downto 0);
	up_request_indicator<=up_req;
	down_request_indicator<=down_req;
		counter_ring: ENTITY WORK.ringer(struc)
		PORT MAP(clock=>clock,count=>ring_counter);
		anode<=ring_counter;

  displayer: ENTITY WORK.display(struc)
             PORT MAP(result=>result,ring_counter=>ring_counter,cathode=>cathode);
		
end structure;
