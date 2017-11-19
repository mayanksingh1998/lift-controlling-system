library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity request_handler is
    Port (
     reset : in STD_LOGIC;                              
           up_request : in STD_LOGIC_VECTOR (3 downto 0);         
           down_request : in STD_LOGIC_VECTOR (3 downto 0); 
           lift1_status : in STD_LOGIC_VECTOR (9 downto 0);        
           lift2_status : in STD_LOGIC_VECTOR (9 downto 0);    
           clock: in std_logic;        
           fast_clock: in std_logic;
           lift1_command : out STD_LOGIC_VECTOR (3 downto 0); 
           lift2_command : out STD_LOGIC_VECTOR (3 downto 0); 
           up_req,down_req: out std_logic_vector(3 downto 0));       
end request_handler;

architecture struc of request_handler is
signal lift1_state, 
        lift1_floor,lift1_movement,lift2_state,lift2_floor,lift2_movement: std_logic_vector(1 downto 0):="00";
signal lift1_floor_indicator,lift2_floor_indicator: std_logic_vector(3 downto 0):="0000";

signal up_req_indicator,down_req_indicator: std_logic_vector(3 downto 0):="0000";
signal lift1_command_internal,lift2_command_internal:std_logic_vector( 3 downto 0):="0000";

signal urul1,urul2,drdl1,drdl2,urdl1,urdl2,drul1,drul2,pending_up,pending_down,au1,au2,ad1,ad2:std_logic_vector(3 downto 0):="0000";
begin

up_req<=up_req_indicator;
down_req<=down_req_indicator;
lift1_command<=lift1_command_internal;
lift2_command<=lift2_command_internal;


lift1_state<=lift1_status(9 downto 8);
lift1_floor_indicator<=lift1_status(7 downto 4);
lift1_floor<=lift1_status(3 downto 2);
lift1_movement<=lift1_status(1 downto 0);

lift2_state<=lift2_status(9 downto 8);
lift2_floor_indicator<=lift2_status(7 downto 4);
lift2_floor<=lift2_status(3 downto 2);
lift2_movement<=lift2_status(1 downto 0);


process(fast_clock, reset)
begin
    if(rising_edge(fast_clock)) then
       if( lift1_floor="00") then 
            urul1<='0' &  pending_up(2 downto 1) & '0';
            drul1<= "000" & pending_up(0) ;
            urdl1<=pending_down(3 downto 1) & '0';
            drdl1<="0000";
        elsif(lift1_floor="01") then
               urul1<='0'& pending_up(2) & "00";
               drul1<= "00" & pending_up(1 downto 0) ;
               urdl1<=pending_down(3 downto 2) & "00";
               drdl1<="00" & pending_down(1)&'0';
         elsif(lift1_floor="10") then
                 urul1<="0000";
                 drul1<= '0' & pending_up(2 downto 0) ;
                 urdl1<=pending_down(3) & "000";
                 drdl1<='0' & pending_down(2 downto 1) & '0';
          elsif(lift1_floor="11") then
                  urul1<="0000";
                  drul1<= '0' & pending_up(2 downto 0) ;
                  urdl1<="0000";
                  drdl1<= pending_down(3 downto 1) & '0';
         end if;
         if( lift2_floor="00") then 
                 urul2<='0' &  pending_up(2 downto 1) & '0';
                 drul2<= "000" & pending_up(0) ;
                 urdl2<=pending_down(3 downto 1) & '0';
                 drdl2<="0000";
             elsif(lift2_floor="01") then
                    urul2<='0'& pending_up(2) & "00";
                    drul2<= "00" & pending_up(1 downto 0) ;
                    urdl2<=pending_down(3 downto 2) & "00";
                    drdl2<="00" & pending_down(1)&'0';
              elsif(lift2_floor="10") then
                      urul2<="0000";
                      drul2<= '0' & pending_up(2 downto 0) ;
                      urdl2<=pending_down(3) & "000";
                      drdl2<='0' & pending_down(2 downto 1) & '0';
               elsif(lift2_floor="11") then
                       urul2<="0000";
                       drul2<= '0' & pending_up(2 downto 0) ;
                       urdl2<="0000";
                       drdl2<= pending_down(3 downto 1) & '0';
              end if;
         
    end if;
end process;

process(clock,reset)
begin

    if (reset='1') then
       lift1_command_internal<="0000";
       lift2_command_internal<="0000";
       au1<="0000";
       au2<="0000";
       ad1<="0000";
       ad2<="0000";

    elsif(rising_edge(clock)) then
       
        if (lift1_state="00" and lift2_state="00") then
        
            if(not(urul1="0000")) then
                lift1_command_internal<=urul1;
                au1<=urul1;
                
            elsif(not(urdl1="0000")) then
                if(urdl1(3)='1') then
                    lift1_command_internal<="1000";
                    ad1<="1000";
                elsif(urdl1(2)='1') then
                    lift1_command_internal<="0100";
                    ad1<="0100";
                else
                    lift1_command_internal<="0010";
                    ad1<="0010";
                 end if;
            elsif(not(drul1="0000")) then
                if(drul1(0)='1') then
                                lift1_command_internal<="0001";
                                au1<="0001";
                            elsif(drul1(1)='1') then
                                lift1_command_internal<="0010";
                                au1<="0010";
                            else
                                lift1_command_internal<="0100";
                                au1<="0100";
                             end if;
            else
                lift1_command_internal<=drdl1;
                ad1<=drdl1;

             end if;
        elsif( lift1_state="00" and lift2_state="01") then
                        lift2_command_internal<=urul2;
                        au2<=urul2;
                        
                        if(not(urul1="0000")) then
                                lift1_command_internal<=urul1 and not(urul2);
                                au1<=urul1 and not(urul2);
                            elsif(not(urdl1="0000")) then
                               if(urdl1(3)='1') then
                                                lift1_command_internal<="1000";
                                                ad1<="1000";
                                            elsif(urdl1(2)='1') then
                                                lift1_command_internal<="0100";
                                                ad1<="0100";
                                            else
                                                lift1_command_internal<="0010";
                                                ad1<="0010";
                                             end if;
                            elsif(not(drul1="0000")) then
                             if(drul1(0)='1') then
                               lift1_command_internal<="0001"and not(urul2);
                               au1<="0001"and not(urul2);
                           elsif(drul1(1)='1') then
                               lift1_command_internal<="0010"and not(urul2);
                               au1<="0010"and not(urul2);
                           else
                               lift1_command_internal<="0100"and not(urul2);
                               au1<="0100"and not(urul2);
                            end if;
                            else
                                lift1_command_internal<=drdl1;
                                ad1<=drdl1;
                             end if;
    elsif( lift1_state="00" and lift2_state="10") then
                            lift2_command_internal<=drdl2;
                            ad2<=drdl2;

        
                            if(not(urul1="0000")) then
                                    lift1_command_internal<=urul1;
                                    au1<=urul1;
                                elsif(not(urdl1="0000")) then
                                                  if(urdl1(3)='1') then
                                                  lift1_command_internal<="1000"and not(drdl2);
                                                  ad1<="1000"and not(drdl2);
                                              elsif(urdl1(2)='1') then
                                                  lift1_command_internal<="0100"and not(drdl2);
                                                  ad1<="0100"and not(drdl2);
                                              else
                                                  lift1_command_internal<="0010"and not(drdl2);
                                                  ad1<="0010"and not(drdl2);
                               end if;
                                elsif(not(drul1="0000")) then
                                                         if(drul1(0)='1') then
                                                               lift1_command_internal<="0001";
                                                               au1<="0001";
                                                           elsif(drul1(1)='1') then
                                                               lift1_command_internal<="0010";
                                                               au1<="0010";
                                                           else
                                                               lift1_command_internal<="0100";
                                                               au1<="0100";
                                                            end if;
                                else
                                    lift1_command_internal<=drdl1 and not(drdl2);
                                    ad1<=drdl1 and not(drdl2);
                                 end if;
     elsif( lift1_state="01" and lift2_state="00") then
                         lift1_command_internal<=urul1;
                         au1<=urul1;
                           if(not(urul2="0000")) then
                               lift2_command_internal<=urul2 and not(urul1);
                               au2<=urul2 and not(urul1);
                           elsif(not(urdl2="0000")) then
                                       if(urdl2(3)='1') then
                                       lift2_command_internal<="1000";
                                       ad2<="1000";
                                       elsif(urdl2(2)='1') then
                                       lift2_command_internal<="0100";
                                       ad2<="0100";
                                       else
                                       lift2_command_internal<="0010";
                                       ad2<="0010";
                                       end if;
                           elsif(not(drul2="0000")) then
                                       if(drul2(0)='1') then
                                       lift2_command_internal<="0001" and not(urul1);
                                       au2<="0001" and not(urul1);
                                       elsif(drul2(1)='1') then
                                       lift2_command_internal<="0010" and not(urul1);
                                       au2<="0010" and not(urul1);
                                       else
                                       lift2_command_internal<="0100" and not(urul1);
                                       au2<="0100" and not(urul1);
                                       end if;
                           else
                               lift2_command_internal<=drdl2;
                               ad2<=drdl2;
                            end if;
        elsif( lift1_state="01" and lift2_state="01") then
                            lift1_command_internal<=urul1;
                            au1<=urul1;
                            lift2_command_internal<=urul2 and not(urul1);
                            au2<=urul2 and not(urul1);
        
        
        elsif( lift1_state="01" and lift2_state="10") then
                        lift1_command_internal<=urul1;
                        au1<=urul1;
                        lift2_command_internal<=drdl2;
                        ad2<=drdl2;

        elsif( lift1_state="10" and lift2_state="00") then
                        lift1_command_internal<=drdl1;
                        ad1<=drdl1;
                        
                        if(not(urul2="0000")) then
                            lift2_command_internal<=urul2;
                            au2<=urul2;
                        elsif(not(urdl2="0000")) then
                                        if(urdl2(3)='1') then
                                        lift2_command_internal<="1000"and not(drdl1);
                                        ad2<="1000"and not(drdl1);
                                        elsif(urdl2(2)='1') then
                                        lift2_command_internal<="0100"and not(drdl1);
                                        ad2<="0100"and not(drdl1);
                                        else
                                        lift2_command_internal<="0010"and not(drdl1);
                                        ad2<="0010"and not(drdl1);
                                        end if;
                        elsif(not(drul2="0000")) then
                                        if(drul2(0)='1') then
                                        lift2_command_internal<="0001" ;
                                        au2<="0001" ;
                                        elsif(drul2(1)='1') then
                                        lift2_command_internal<="0010";
                                        au2<="0010";
                                        else
                                        lift2_command_internal<="0100";
                                        au2<="0100";
                                        end if;
                        else
                            lift2_command_internal<=drdl2 and not(drdl1);
                            ad2<=drdl2 and not(drdl1);
                         end if;
                         
        elsif( lift1_state="10" and lift2_state="01") then
                          lift2_command_internal<=urul2;
                          au2<=urul2;
                          lift1_command_internal<=drdl1;
                          ad1<=drdl1;
        elsif( lift1_state="10" and lift2_state="10") then
                         lift1_command_internal<=drdl1;
                         ad1<=drdl1;
                       lift2_command_internal<=drdl2 and not(drdl1);
                       ad2<=drdl2 and not(drdl1);
        end if;
     end if;


end process;


process(fast_clock,reset)
begin
  if(reset='1') then
               up_req_indicator<="0000";
    elsif(rising_edge(fast_clock)) then
        if(((lift1_state="01" or lift1_state="00") and lift1_floor="00")or((lift2_state="01" or lift2_state="00") and lift2_floor="00")) then
            up_req_indicator(0)<='0';
        elsif(up_request(0)='1') then
            up_req_indicator(0)<='1';
        end if;
        
        if(((lift1_state="01" or lift1_state="00") and lift1_floor="01")or((lift2_state="01" or lift2_state="00") and lift2_floor="01")) then
                up_req_indicator(1)<='0';
            elsif(up_request(1)='1') then
                up_req_indicator(1)<='1';
            end if;
                
                
         if(((lift1_state="01" or lift1_state="00") and lift1_floor="10")or((lift2_state="01" or lift2_state="00") and lift2_floor="10")) then
                    up_req_indicator(2)<='0';
                elsif(up_request(2)='1') then
                    up_req_indicator(2)<='1';
                end if;
     end if;
end process;

process(fast_clock,reset)
begin
  if(reset='1') then
               down_req_indicator<="0000";
               
     elsif(rising_edge(fast_clock)) then
     
        if(((lift1_state="10" or lift1_state="00") and lift1_floor="11")or((lift2_state="10" or lift2_state="00") and lift2_floor="11")) then
            down_req_indicator(3)<='0';
        elsif(down_request(3)='1') then
            down_req_indicator(3)<='1';
        end if;
        
        if (((lift1_state="10" or lift1_state="00") and lift1_floor="10")or ((lift2_state="10" or lift2_state="00") and lift2_floor="10")) then
                    down_req_indicator(2)<='0';
                elsif(down_request(2)='1') then
                    down_req_indicator(2)<='1';
                end if;
                
                
         if(((lift1_state="10" or lift1_state="00") and lift1_floor="01")or((lift2_state="10" or lift2_state="00") and lift2_floor="01")) then
                            down_req_indicator(1)<='0';
                        elsif(down_request(1)='1') then
                            down_req_indicator(1)<='1';
                        end if;
      end if;
end process;

process(fast_clock,reset)
   begin
        if(reset='1') then
                  pending_up<="0000";
        elsif(rising_edge(fast_clock)) then
            if ( au1(0)='1' ) or (au2(0)='1')   then
                pending_up(0)<='0';
            elsif(up_request(0)='1' and up_req_indicator(0)='0') then
                pending_up(0)<='1';
             
            end if;
            
          if( au1(1)='1'  ) or (au2(1)='1' ) then
                pending_up(1)<='0';
        elsif(up_request(1)='1' and up_req_indicator(1)='0') then
            pending_up(1)<='1';
          end if;              
           if( au1(1)='1'  ) or (au2(1)='1') then
                    pending_up(2)<='0';
            elsif(up_request(2)='1' and up_req_indicator(2)='0') then
                pending_up(2)<='1';
                                    
                end if;
   
   end if;
   end process;
   
   
 process(fast_clock,reset)
      begin
           if(reset='1') then
                     pending_down<="0000";
          elsif(rising_edge(fast_clock)) then
               if( ad1(3)='1'  ) or (ad2(3)='1') then
                   pending_down(3)<='0';
               elsif(down_request(3)='1' and down_req_indicator(3)='0') then
                   pending_down(3)<='1';
               end if;
               
             if( ad1(1)='1' ) or (ad2(1)='1' ) then
                                   pending_down(1)<='0';
               elsif(down_request(1)='1' and down_req_indicator(1)='0') then
                   pending_down(1)<='1';
                     end if;              
              if( ad1(2)='1'  ) or (ad2(2)='1' ) then
                       pending_down(2)<='0';
                   elsif(down_request(2)='1' and down_req_indicator(2)='0') then
                       pending_down(2)<='1';
                   end if;
      
      end if;
      end process;
end struc;
