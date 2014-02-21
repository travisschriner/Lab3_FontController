----------------------------------------------------------------------------------
-- Company: USAFA DFEC
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    12:00:29 01/31/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity pixel_gen is
    port ( row      : in unsigned(10 downto 0);
           column   : in unsigned(10 downto 0);
           blank    : in std_logic;
			  ball_x	  : in unsigned (10 downto 0);
			  ball_y	  : in unsigned (10 downto 0);
			  paddle_y : in unsigned (10 downto 0);
			  r,g,b    : out std_logic_vector(7 downto 0));
          
end pixel_gen;


architecture Behavioral of pixel_gen is
signal r_sig, g_sig, b_sig : std_logic_vector(7 downto 0);

begin

	
	
	
	process(row, blank, column, ball_x, ball_y, paddle_y)
	begin
	
			r <= (others => '0');
			g <= (others => '0');
			b <= (others => '0');
			
		if(blank = '0') then
		
			--ball
			if(row > ball_y and row < ball_y +15 and column > ball_x and column < ball_x +15) then
				g <= (others => '1');
			end if;
			
			--left A col
			if(row > 140 and column >170 and row <340 and column < 200) then
				b <= (others => '1');
				r <= (others => '0');
				g <= (others => '0');
			end if;
			--top A strut
			if(row > 140 and column >199 and row <170 and column <290) then
				b <= (others => '1');
				r <= (others => '0');
				g <= (others => '0');
			end if;
			
			--bottom A strut
			if(row > 240 and column >199 and row <270 and column <290) then
				b <= (others => '1');
				r <= (others => '0');
				g <= (others => '0');
			end if;
			
			--right A col
			if(row > 140 and column >289 and row <340 and column <320) then
				b <= (others => '1');
				r <= (others => '0');
				g <= (others => '0');
			end if;
			
			--left F col
			if(row > 140 and column >370 and row <340 and column <400) then
				b <= (others => '1');
				r <= (others => '0');
				g <= (others => '0');
			end if;
			
			--top F strut
			if(row > 140 and column > 399 and row <170 and column <470) then
				b <= (others => '1');
				r <= (others => '0');
				g <= (others => '0');
			end if;
			
			--bottom F strut
			if(row > 240 and column > 399 and row <270 and column <470) then
				b <= (others => '1');
				r <= (others => '0');
				g <= (others => '0');
			end if;
			
			--paddle
			if(column > 5 and column < 25 and row > paddle_y and row < (paddle_y + 100)) then
				r <= (others => '1');
			end if;
			
			
		end if;
	end process;
	
	
	
end Behavioral;

