library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lift_controller is
    Port (
     reset : in STD_LOGIC:='0';                            
    
           lift_command : in STD_LOGIC_VECTOR (3 downto 0); 
           lift_status : out STD_LOGIC_VECTOR (9 downto 0);   
           clock : in STD_LOGIC;                              
           fast_clock: in std_logic;
           opener: in std_logic;
           closer : in std_logic;
           lift_floor : in STD_LOGIC_VECTOR (3 downto 0):="0000");      
end lift_controller;

architecture structure of lift_controller is
SIGNAL lift_floor_indicator: std_logic_vector(3 downto 0):="0000"; 
signal lift_state: std_logic_vector(1 downto 0):="00"; 
signal door_opening_counter,door_closing_counter: std_logic_vector(2 downto 0):="000";
signal door_open_counter:std_logic_vector(3 downto 0):="0000";
signal lift_floor_out:std_logic_vector(1 downto 0):="00";
signal lift_movement:std_logic_vector(1 downto 0):="00"; 
signal door_status: std_logic:='0'; 
signal lift_movement_counter: std_logic_vector(4 downto 0):="00000";
signal lift_command_stored:std_logic_vector(3 downto 0):="0000";
signal lift_to_stop_combined:std_logic_vector(3 downto 0):="0000";
begin


lift_to_stop_combined<= lift_command_stored or lift_floor_indicator;

process(clock, reset,opener,closer)
begin
    if (reset='1') then
        door_opening_counter<="101";
        door_closing_counter<="101";
        door_open_counter<="1010";
        lift_floor_out<="00";  
        lift_movement<="11";  
        lift_movement_counter<="10100"; 
    elsif(opener='1' and (lift_movement="11" or lift_movement="10")) then
                      door_open_counter<="1010";

            if(lift_movement="10") then
                door_opening_counter<="101";
              end if;
     elsif(closer='1' and (lift_movement="11" or lift_movement="10")) then
                      door_open_counter<="0000";
                 if(lift_movement="11") then
                    door_closing_counter<="101";
                 end if;
    elsif (rising_edge(clock)) then
        if(lift_movement="11") then
            if (lift_state="01" or lift_state="10") then
                if not(door_open_counter="0000") then
                   door_open_counter<=door_open_counter-1;
                elsif not(door_closing_counter="000") then
                    lift_movement<="10";
                end if;
             else
                if(door_open_counter="0000") then
                    lift_movement<="10";
                 end if;
             end if;
             
         elsif(lift_movement="10") then
                if(door_open_counter="0000" and door_closing_counter="000") then
                     lift_movement_counter<="10100";
                    if(lift_state="01") then
                         lift_movement<="00";
                    elsif(lift_state="10") then
                         lift_movement<="01";
                    end if;
                 elsif not(door_opening_counter="000") then
                    door_opening_counter<=door_opening_counter-1;
                 elsif (door_opening_counter="000" and not(door_open_counter="0000")) then
                    lift_movement<="11";
                       elsif not(door_closing_counter="000") then
                            door_closing_counter<=door_closing_counter-1;
                  end if;
         elsif(lift_movement="01") then
             if not(lift_movement_counter="00000") then
                        lift_movement_counter<=lift_movement_counter-1;
                    else
                        if(lift_floor_out="11") then
                            lift_floor_out<="10";
                            if(lift_to_stop_combined(2)='0') then
                                lift_movement_counter<="10100";
                            else
                                door_opening_counter<="101";
                                door_closing_counter<="101";
                                door_open_counter<="1010";
                                lift_movement<="10";
                             end if;
                        elsif(lift_floor_out="10") then
                            lift_floor_out<="01";
                            if(lift_to_stop_combined(1)='0') then
                                lift_movement_counter<="10100";
                            else
                                door_opening_counter<="101";
                                door_closing_counter<="101";
                                door_open_counter<="1010";
                                lift_movement<="10";
                             end if;
                        
                        elsif(lift_floor_out="01") then
                            lift_floor_out<="00";
                                lift_movement_counter<="10100";
                                door_opening_counter<="101";
                                door_closing_counter<="101";
                                door_open_counter<="1010";
                                lift_movement<="10";
                        end if;
              end if;
         elsif(lift_movement="00") then
            if not(lift_movement_counter="00000") then
                lift_movement_counter<=lift_movement_counter-1;
            else
                if(lift_floor_out="00") then
                    lift_floor_out<="01";
                    if(lift_to_stop_combined(1)='0') then
                        lift_movement_counter<="10100";
                    else
                        door_opening_counter<="101";
                        door_closing_counter<="101";
                        door_open_counter<="1010";
                        lift_movement<="10";
                     end if;
                elsif(lift_floor_out="01") then
                    lift_floor_out<="10";
                    if(lift_to_stop_combined(2)='0') then
                        lift_movement_counter<="10100";
                    else
                        door_opening_counter<="101";
                        door_closing_counter<="101";
                        door_open_counter<="1010";
                        lift_movement<="10";
                     end if;
                
                elsif(lift_floor_out="10") then
                    lift_floor_out<="11";
                        lift_movement_counter<="10100";
                        door_opening_counter<="101";
                        door_closing_counter<="101";
                        door_open_counter<="1010";
                        lift_movement<="10";
                end if;
               end if; 
               end if;
    end if;
end process;

process(fast_clock,reset)

    begin 
    
        if (reset='1') then
            lift_floor_indicator<="0000";
            
        elsif(rising_edge(fast_clock)) then
          
             if(lift_floor_out="00") then
                lift_floor_indicator(0)<='0';
             elsif(lift_floor(0)='1')then
                lift_floor_indicator(0)<='1';
            end if;
            
            if(lift_floor_out="01") then
                            lift_floor_indicator(1)<='0';
                         elsif(lift_floor(1)='1')then
                            lift_floor_indicator(1)<='1';
                        end if;
                        
                        
            if(lift_floor_out="10") then
                            lift_floor_indicator(2)<='0';
                         elsif(lift_floor(2)='1')then
                            lift_floor_indicator(2)<='1';
                        end if;
                        
                        
            if(lift_floor_out="11") then
                            lift_floor_indicator(3)<='0';
                         elsif(lift_floor(3)='1')then
                            lift_floor_indicator(3)<='1';
                        end if;

    end if;
    end process;

process(fast_clock,reset)
begin
        if (reset='1') then
            lift_command_stored<="0000";
           
          elsif(rising_edge(fast_clock)) then
          
                if(lift_floor_out="00") then
                    lift_command_stored(0)<='0';
                elsif(lift_command(0)='1') then
                    lift_command_stored(0)<='1';
                 end if;
             
             
              if(lift_floor_out="01") then
                 lift_command_stored(1)<='0';
             elsif(lift_command(1)='1') then
                 lift_command_stored(1)<='1';
              end if;
                          
                          
        if(lift_floor_out="10") then
                          lift_command_stored(2)<='0';
                      elsif(lift_command(2)='1') then
                          lift_command_stored(2)<='1';
                       end if;
                                       
                                       
       if(lift_floor_out="11") then
                           lift_command_stored(3)<='0';
                       elsif(lift_command(3)='1') then
                           lift_command_stored(3)<='1';
                        end if;
            
            
            
          end if;
end process;

process(fast_clock,reset)
begin
    if(reset='1') then
        lift_state<="00";
    elsif(rising_edge(fast_clock)) then
        if(lift_floor_out="00") then
            if  (lift_to_stop_combined(3 downto 1)="000") then
                lift_state<="00";
            else
                lift_state<="01";
            end if;
        elsif (lift_floor_out="01") then
            if  (not(lift_to_stop_combined(3 downto 2)="00")) then
                        lift_state<="01";
            elsif lift_to_stop_combined(0)='1' then
                lift_state<="10"; 
            else    
                 lift_state<="00";
             end if;
         elsif (lift_floor_out="10") then
                         if  ((lift_to_stop_combined(3)='1')) then
                                     lift_state<="01";
                         elsif not(lift_to_stop_combined(1 downto 0)="00") then
                             lift_state<="10"; 
                         else    
                              lift_state<="00";
                          end if;        
        elsif (lift_floor_out="11") then
                                      if (lift_to_stop_combined(2 downto 0)="000") then
                                          lift_state<="00"; 
                                      else    
                                           lift_state<="10";
                                       end if;
        end if;
        end if;
end process;

lift_status<= lift_state & lift_floor_indicator & lift_floor_out & lift_movement;
end structure;
