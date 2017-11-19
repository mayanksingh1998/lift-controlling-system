library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ten_clock is
    Port ( 
    clock : in STD_LOGIC;
           out_clock : out STD_LOGIC);
end ten_clock;

architecture structure of ten_clock is

signal count : integer :=1;
signal clk:std_logic:='0';
begin
process(clock)
	begin
	if(clock'event and clock='1') then
    count <=count+1;
    if(count = 10000000) then
clk <= not clk;
    count <=1;
    end if;
    end if;
	end process;
out_clock<=clk;
end structure;
