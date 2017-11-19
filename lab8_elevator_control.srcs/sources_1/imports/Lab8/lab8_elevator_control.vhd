----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.09.2017 07:24:00
-- Design Name: 
-- Module Name: lab8_elevator_control - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab8_elevator_control is
  Port ( 
            up_request: in std_logic_vector(3 downto 0):="0000";
         down_request : in std_logic_vector(3 downto 0):="0000";
         lift1_floor : in std_logic_vector(3 downto 0):="0000";
         lift2_floor : in std_logic_vector(3 downto 0):="0000";
         up_request_indicator  : out std_logic_vector (3 downto 0);
            down_request_indicator          : out std_logic_vector (3 downto 0);
         lift1_floor_indicator         : out std_logic_vector (3 downto 0);
         lift2_floor_indicator      : out std_logic_vector (3 downto 0);
            anode    : out std_logic_vector (3 downto 0);
         reset : in std_logic:='0';
         clk:in std_logic:='0';
         sim_mode:in std_logic:='0';
         cathode : out std_logic_vector(6 downto 0);
         door_open : in std_logic_vector (1 downto 0):="00";
          door_close: in std_logic_vector (1 downto 0):="00");
end lab8_elevator_control;

architecture Behavioral of lab8_elevator_control is
signal display: std_logic_vector(5 downto 0):="000000";
signal lift1_status,lift2_status: std_logic_vector (9 downto 0):="0000000000";
signal ten_hertz_clock,display_clock,clk2,clk3: std_logic:='0';
signal lift1_command,lift2_command: std_logic_vector(3 downto 0):="0000";
signal up_req,down_req,up_request1,down_request1,lift1_floor1,lift2_floor1,temp1,temp2: std_logic_vector(3 downto 0):="0000";
signal door_opener1,door_opener2,door_closer1,door_closer2:std_logic:='0';
signal sim2_mode,slow_display_clock:std_logic:='0';
signal count:std_logic_vector(2 downto 0):="000";
begin

temp1<=door_open & door_close;

door_opener1<=temp2(2);
door_opener2<=temp2(3);
door_closer1<=temp2(0);
door_closer2<=temp2(1);

slow_display_clock<=count(2);

process(display_clock)
begin 
    if(rising_edge(display_clock) )then  
    count<=count+1;
    end if;
 end process;

pulse1: entity work.pulse(structure)
    port map(clk=>display_clock,in4=>up_request,out4=>up_request1);
pulse2: entity work.pulse(structure)
        port map(clk=>display_clock,in4=>down_request,out4=>down_request1);
pulse3: entity work.pulse(structure)
        port map(clk=>display_clock,in4=>lift1_floor,out4=>lift1_floor1);
pulse4: entity work.pulse(structure)
        port map(clk=>display_clock,in4=>lift2_floor,out4=>lift2_floor1);
pulse5: entity work.pulse(structure)
        port map(clk=>display_clock,in4=>temp1,out4=>temp2);

--temp2<=temp1;
----door_opener2<=door_opener1;
----door_closer2<=door_closer1;
--lift1_floor1<=lift1_floor;
--lift2_floor1<=lift2_floor;
--up_request1<=up_request;
--down_request1<=down_request;

ten_clock: entity work.ten_clock(structure)
    port map(clock=>clk,out_clock=>clk2);

with sim2_mode select
    ten_hertz_clock<= count(2) when'1'
        ,clk2 when others;

clock_modifier: entity work.display_clock(structure)
    port map(clock=>clk,out_clock=>clk3);
    
 with sim2_mode select
        display_clock<= clk when'1'
            ,clk3 when others;
            
request_handler: entity work.request_handler(struc)
    port map(
    reset=>reset,up_request=>up_request1,down_request=>down_request1,
--    display=>display,
    lift1_status=>lift1_status,
    lift2_status=>lift2_status,
    lift1_command=>lift1_command,
    lift2_command=>lift2_command,
    fast_clock=>display_clock,
    clock=>slow_display_clock,
    up_req=>up_req,
    down_req=>down_req);

status_display: entity work.status_display_block(structure)
    port map(
    up_req=>up_req,
    down_req=>down_req,
    lift1_status=>lift1_status,
    lift2_status=>lift2_status,
    clock=>display_clock,
    lift1_floor_indicator=>lift1_floor_indicator,
    lift2_floor_indicator=>lift2_floor_indicator,
    down_request_indicator=>down_request_indicator,
    up_request_indicator=>up_request_indicator,
    anode=>anode,
    cathode=>cathode);


lift1_controller: entity work.lift_controller(structure)
    port map(
    reset=>reset,
    lift_command=>lift1_command,
    lift_status=>lift1_status,
    clock=>ten_hertz_clock,
    lift_floor=>lift1_floor1,
    fast_clock=>display_clock,
    opener=>door_opener1,
    closer=>door_closer1);

lift2_controller: entity work.lift_controller(structure)
    port map(
    reset=>reset,
    lift_command=>lift2_command,
    lift_status=>lift2_status,
    clock=>ten_hertz_clock,
    fast_clock=>display_clock,
    lift_floor=>lift2_floor1,
    opener=>door_opener2,
        closer=>door_closer2);

end Behavioral;
