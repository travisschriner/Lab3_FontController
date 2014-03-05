----------------------------------------------------------------------------------
-- Company: USAFA DFEC
-- Engineer: C2C Travis Schriner
--
--DOCUMENTATION: C2C Trae Barnett explained that input_to_pulse is in fact
--					  just a button debouncer. After he clarified that, he explained
--					  his STD and that helped me tremendously to get the thing working. 
-- 
-- Create Date:    18:25:31 02/24/2014 
-- Design Name: 
-- Module Name:    input_to_pulse - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity input_to_pulse is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           button : in  STD_LOGIC;
           button_pulse : out  STD_LOGIC);
end input_to_pulse;

architecture Behavioral of input_to_pulse is

type button_state is (idle, push, hold);
signal button_reg, button_next : button_state;
signal count : unsigned(12 downto 0);
signal pulse, pulse_next, button_cur, button_prev, debounce : std_logic;

begin


--=========================================
-----------------REGISTER------------------
--=========================================

	
	process(clk,reset,button)
	begin
		if( reset = '1') then
			button_prev <= '0';
			pulse <= '0';
			button_reg <= idle;
		elsif(rising_edge(clk)) then
			button_prev <= button;
			pulse <= pulse_next;
			button_reg <= button_next;
		end if;
	end process;
	
--=========================================
---------DEBOUNCE_LOGIC--------------------
--=========================================
	process(clk,reset,button_prev)
	begin

		if( reset = '1') then
			count <= (others => '0');
			button_cur <= '0';			
		elsif( rising_edge(clk)) then

			debounce <= '0';

			if(button_cur = button_prev) then
				count <= count + 1;
			else
				button_cur <= button_prev;
				count <= (others => '0');
			end if;

			if( count >= 5000 ) then
				debounce <= '1';
				count <= (others => '0');
			end if;
		end if;

	end process;

--=========================================
---------NEXT_STATE_LOGIC------------------
--=========================================	

	process(button_reg,button,debounce)
	begin
	
		button_next <= button_reg;
		case button_reg is
			when  idle =>
				if(button = '1') then
					button_next <= push;
				end if;
			when push =>
				button_next <= hold;
			when hold =>
				if(button = '0' and debounce = '1') then
					button_next <= idle;
				end if;
		end case;
	end process;

--==========================================
-------Combinational and Output Logic-------
--==========================================

	pulse_next <= 	'1' when button_next = push else
						'0';

	button_pulse <= pulse;

end Behavioral;

