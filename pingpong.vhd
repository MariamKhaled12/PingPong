library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pingpong is
    Port ( clk, reset : in STD_LOGIC;
           upleft,upright,downleft,downright: in std_logic; --buttons
           R, G, B: out std_logic_vector(3 downto 0);
           hsync, vsync: out std_logic);
end pingpong;

--game logic: two players required to keep the ball/square outside bounds of the paddle, if the ball passes the paddle limits
-- the game is lost and the ball is returned to original position and game automatically resets
--there's a reset button for restting the game as well

architecture Behavioral of pingpong is

--to draw screen
signal count: integer:=1;
signal tmp : std_logic := '0';
signal clkout: std_logic;
signal hcount: integer:=0;
signal vcount: integer:=0;

--paddle dimensions
shared variable pleft_h: integer:=50;
shared variable pright_h: integer:= 589;

shared variable topleft: integer:=164;
shared variable bottomleft: integer:= topleft+200;

shared variable topright: integer:=164;
shared variable bottomright: integer:= topright+200;

--ball position
shared variable ball_h: integer:=360;
shared variable ball_v: integer:=230;
constant radius: integer:=30;

--ball motion flags
signal bupleft: boolean:=false;
signal bupright: boolean:=false;
signal bdownleft: boolean:=false;
signal bdownright: boolean:=false;
signal start: boolean:=true;
signal finish: boolean:=false;

--speed
constant horiz: integer:=1 ;
constant vertic: integer:=1;

--scores
shared variable playerone: integer:=0;
shared variable playertwo: integer:=0;

begin

process (clk)
begin
    if ( rising_edge (clk)) then
        if ( count = 1) then
         count <= 0;
        tmp <= not(tmp);
        else
        count <= count+1;
        end if;
        clkout <= tmp;
    end if;
end process;


process (clkout)
    begin
        if(rising_edge(clkout))then        
            
            if(hcount<=800 and vcount<=525) then
            if(hcount>=0 and hcount<=639)then
            
                --hsync
                if(vcount<480) then
                   vsync<='1';
                   if((hcount>=0 and hcount<0+pleft_h) and (vcount>=topleft and vcount<bottomleft)) then
                                       R<="1111";
                                       G<="1111";
                                       B<="0000";
                   elsif ((hcount>pright_h and hcount<=639) and (vcount>=topright and vcount<bottomright)) then
                                       R<="1111";
                                       G<="0000";
                                       B<="0000";
                   elsif((hcount>=ball_h and hcount<radius+ball_h) and (vcount>=ball_v and vcount<radius+ball_v)) then                    
                                       R<="0000";
                                       G<="0000";
                                       B<="1111";
                   else
                
                      R<="1111";
                      G<="1111";
                      B<="1111";
                    end if;
                end if;

                hsync<='1';
                hcount<=hcount+1;
            
            elsif(hcount>639 and hcount<=655) or (hcount>=752 and hcount<800) then
                    R<="0000";
                    G<="0000";
                    B<="0000";      
                    hcount<=hcount+1;
                    hsync<='1';
                    
            elsif(hcount>655 and hcount<752) then
                    R<="0000";
                    G<="0000";
                    B<="0000";
                    hsync<='0';
                    hcount<=hcount+1;
                    
            elsif(hcount>=800) then
                    hsync<='1';
                    hcount<=0;
                    vcount<=vcount+1;              
            end if;              
            
            --vsync
            if (vcount>=480 and vcount<490)or(vcount>=492 and vcount<525) then
                vsync<='1';
            elsif(vcount>=490 and vcount<492)  then
                vsync<='0';
            elsif (vcount>524) then
                vsync<='1';
                hcount<=0;
                vcount<=0;  
                
                
            --paddle motion
            
                
                if(upleft='1' and downleft='0') then
                    if(topleft>0) then
                        topleft:=topleft-1;
                    elsif(topleft=0) then
                        topleft:=0;
                    end if;
                elsif(upleft='0' and downleft='1') then
                    if(bottomleft<479) then
                        topleft:=topleft+1;
                    elsif(bottomleft=479) then
                        topleft:=279;    
                    end if;    
                elsif(upright='1' and downright='0') then
                    if(topright>0) then
                        topright:=topright-1;
                    elsif(topright=0) then
                        topright:=0;
                    end if;
                elsif(upright='0' and downright='1') then
                    if(bottomright<479) then
                        topright:=topright+1;
                    elsif(bottomright=479) then
                        topright:=279;    
                    end if;                                           
                end if;
            
            
                    
            --ball motion
            
                
                if(reset='1') then
                        ball_v:=230;
                        ball_h:=360;
                        bupleft<=false;
                        bdownleft<=false;
                        bupright<=false;
                        bdownright<=false; 
                        start<=true; 
                   end if;   
                      
                if(start=true) then
                    if(ball_h>0) and (ball_v>0) then
                        ball_h:=ball_h - horiz;
                        ball_v:=ball_v - vertic;
                       
                    elsif (ball_h>0) and (ball_v=0) then
                        bupleft<=false;
                        bdownleft<=true;
                        bupright<=false;
                        bdownright<=false; 
                        start<=false;  
                                         
                    end if;
                  end if; 
                  
                if((ball_v+radius<topleft) and ball_h=50) then
                             bupleft<=false;
                             bdownleft<=false;
                             bupright<=false;
                             bdownright<=false; 
                             start<=true; 
                             ball_v:=230;
                             ball_h:=360;
                             
                  elsif((ball_v>=topleft and ball_v+radius<=bottomleft) and (ball_h=50)) then
                             bupleft<=false;
                             bdownleft<=false;
                             bupright<=false;
                             bdownright<=true; 
                             start<=false;  
                             
                  elsif((ball_v>bottomleft)and ball_h=50) then
                             bupleft<=false;
                             bdownleft<=false;
                             bupright<=false;
                             bdownright<=false; 
                             start<=true;
                             ball_v:=230;
                             ball_h:=360;
            
                  end if;
                  if((ball_v+radius<topright) and ball_h+radius=589) then
                             bupleft<=false;
                             bdownleft<=false;
                             bupright<=false;
                             bdownright<=false; 
                             start<=true; 
                             ball_v:=230;
                             ball_h:=360;
                             
                  elsif((ball_v>=topright and ball_v+radius<=bottomright) and (ball_h+radius=589)) then
                             bupleft<=true;
                             bdownleft<=false;
                             bupright<=false;
                             bdownright<=false; 
                             start<=false;
                             
                   elsif((ball_v>bottomright) and ball_h+radius=589) then
                             start<=true;
                             bupleft<=false;
                             bdownleft<=false;
                             bupright<=false;
                             bdownright<=false; 
                             ball_v:=230;
                             ball_h:=360;
                  end if;
                                   
                  if(ball_h>0 and ball_v+radius=479) then
                        bupleft<=false;
                        bdownleft<=false;
                        bupright<=true;
                        bdownright<=false; 
                        start<=false;  
                  end if; 
                  
                  if ((ball_h>0) and (ball_v=0)) then
                        bupleft<=false;
                        bdownleft<=true;
                        bupright<=false;
                        bdownright<=false; 
                        start<=false;  
                   end if;
 
                  
                  if(bdownleft=true) then
                        ball_v:= ball_v+vertic; 
                        ball_h:= ball_h-horiz; 
                   end if;                     

                  if(bdownright=true) then
                       ball_v:= ball_v+vertic; 
                       ball_h:= ball_h+horiz;   
                                          end if;                     
 
                  if(bupright=true) then
                       ball_v:= ball_v-vertic; 
                       ball_h:= ball_h+horiz;    
                       end if;
                  if(bupleft=true) then
                       ball_v:= ball_v-vertic; 
                       ball_h:= ball_h-horiz;    
                  
                                  end if;                     

                   end if;                     
                  
                      
                end if;    
                
                end if;  
                           
     
end process;
end Behavioral;