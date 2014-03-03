----------------------------------------------------------------------------------
-- Company: USAFA DFEC
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    12:04:08 01/31/2014 
-- Design Name: 
-- Module Name:    h_sync_gen - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity h_sync_gen is
    port ( clk       : in  std_logic;
           reset     : in  std_logic;
           h_sync    : out std_logic;
           blank     : out std_logic;
           completed : out std_logic;
           column    : out unsigned(10 downto 0)
     );
end h_sync_gen;

architecture Behavioral of h_sync_gen is

	--had to make my own type...
	type states is (activeVid, frontPorch, sync, backPorch, Complete);
	signal state_reg, state_next : states;
	signal count_reg, count_next : unsigned (10 downto 0);
	signal h_sync_reg, blank_reg, completed_reg,
	       h_sync_next, blank_next, completed_next : std_logic;
	signal column_next, column_reg: unsigned (10 downto 0);
	
begin


   --state reg
	process(clk, reset)
	begin
		if(reset ='1') then
			state_reg <= activeVid;
		elsif( rising_edge(clk)) then
			state_reg <= state_next;
		end if;
	end process;
	
	
	
	--count reg
	process(clk, reset)
	begin
		if (reset = '1') then
			count_reg <= (others => '0');
		elsif( rising_edge(clk)) then
			count_reg <= count_next;
		end if;
	end process;
	
	count_next <= (others => '0') when state_reg /= state_next else
						count_reg +1;
	
	--output buf
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			h_sync_reg <= h_sync_next;
			blank_reg <= blank_next;
			column_reg <= column_next;
			completed_reg <= completed_next;
		end if;
	end process;

	
			
			
	--C2C Jason Mossing gave me the idea to use a case statement with nested if statements to decide when to choose states
	process(state_reg, count_reg)
	begin
		state_next <= state_reg;
		
		case state_reg is
		
		--active vid logic
		when activeVid =>
			if(count_reg =639) then
				state_next <= frontPorch;
			end if;
			
		--frontPorch logic	
		when frontPorch =>
			if(count_reg = 15) then
				state_next <= sync;
			end if;
			
		--sync logic	
		when sync =>
			if (count_reg = 95) then
				state_next <= backPorch;
			end if;
			
		--backporch logich	
		when backPorch =>
			if (count_reg = 46) then
				state_next <= Complete;
			end if;
			
		--completed logich	
		when Complete =>
				state_next <= activeVid;
		end case;
		
		
	end process;
	
	--output logic C2C Good explained I needed to add an output buffer
		process(state_next, count_next)
	begin
		case state_next is
			when sync =>
				h_sync_next <= '0';
				blank_next <= '1';
				column_next <= (others => '0');
				completed_next <= '0';
			when backPorch =>
				h_sync_next <= '1';
				blank_next <= '1';
				column_next <= (others => '0');
				completed_next <= '0';
			when complete =>
				h_sync_next <= '1';
				blank_next <= '1';
				column_next <= (others => '0');
				completed_next <= '1';
			when activeVid =>
				h_sync_next <= '1';
				blank_next <= '0';
				column_next <= count_next;
				completed_next <= '0';
			when frontPorch =>
				h_sync_next <= '1';
				blank_next <= '1';
				column_next <= (others => '0');
				completed_next <= '0';
		end case;
	end process;
	
	
	h_sync <= h_sync_reg;
	blank <= blank_reg;
	column <= column_reg;
	completed <= completed_reg;
	
end Behavioral;