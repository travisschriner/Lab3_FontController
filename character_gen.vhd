----------------------------------------------------------------------------------
-- Company: USAFA DFEC
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    09:46:26 02/21/2014 
-- Design Name: 
-- Module Name:    character_gen - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity character_gen is
    Port ( clk : in  STD_LOGIC;
           blank : in  STD_LOGIC;
           row : in  STD_LOGIC_VECTOR (10 downto 0);
           column : in  STD_LOGIC_VECTOR (10 downto 0);
           ascii_to_write : in  STD_LOGIC_VECTOR (7 downto 0);
           write_en : in  STD_LOGIC;
           r,g,b : out  STD_LOGIC_VECTOR (7 downto 0));
end character_gen;

architecture Behavioral of character_gen is


signal row_col_multiply : std_logic_vector(13 downto 0);
signal count_reg, count_next: std_logic_vector(11 downto 0);
signal address, addr_sig, col_delay1, col_delay2, row_delay1 : std_logic_vector(10 downto 0);
signal rom_data, data_b_sig, font_data_sig : std_logic_vector(7 downto 0);
signal mux_out : std_logic;

begin


--=======================================================
-----------------Col_Delay2--------------------
--=======================================================
		process(clk) is 
		begin
			if(rising_edge(clk)) then
				col_delay1 <= column;
			end if;
		end process;

		process(clk) is
		begin
			if(rising_edge(clk)) then
				col_delay2 <= col_delay1;
				end if;
		end process;


		
--=======================================================
-----------------row_delay1--------------------
--=======================================================
		process(clk) is 
		begin
			if(rising_edge(clk)) then
				row_delay1 <= row;
			end if;
		end process;
		
--=======================================================
-----------------Instantiations--------------------
--=======================================================		

		Inst_char_screen_buffer: entity work.char_screen_buffer(Behavioral) PORT MAP(
			clk => clk,
			we => write_en,
			address_a => count_reg ,
			address_b => row_col_multiply(11 downto 0),
			data_in => ascii_to_write,
			data_out_a => open,
			data_out_b => data_b_sig
		);

		Inst_font_rom: entity work.font_rom(arch) PORT MAP(
			clk => clk ,
			addr => addr_sig,
			data =>  font_data_sig
		);



		Inst_Mux8_1: entity work.Mux8_1(Behavioral) PORT MAP(
			data => font_data_sig,
			sel => std_logic_vector(unsigned(col_delay2(2 downto 0))),
			output => mux_out
		);



--=======================================================
-----------------combinational_logic---------------------
--=======================================================



		--concatinates data sig as well as the lower 4 bits of the row
		addr_sig <= data_b_sig(6 downto 0) & std_logic_vector(unsigned(row_delay1(3 downto 0))) ;

		count_reg <= (others => '0') when unsigned(count_reg) = to_unsigned(2400, 12)  else 
						  std_logic_vector(unsigned(count_reg) + 1) when rising_edge(write_en) else 
						  count_reg;

		--Trae explained how this creates the blocks for each character
		row_col_multiply <= std_logic_vector((unsigned(row(10 downto 4)) * 80) + unsigned(column(10 downto 3)));


--=======================================================
-----------------Output Logic---------------------
--=======================================================

		process(mux_out, blank) is
		begin
		
			r <= (others => '0');
			g <= (others => '0');
			b <= (others => '0');
			
			if(blank = '0') then
				if(mux_out = '1') then
					g <= (others => '1');
				end if;
			end if;	
		end process;

end Behavioral;