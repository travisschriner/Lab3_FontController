----------------------------------------------------------------------------------
-- Company: USAFA DFEC	
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    11:06:43 02/21/2014 
-- Design Name: 
-- Module Name:    font_rom - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity font_rom is
    port(
           clk: in std_logic;
           addr: in std_logic_vector(10 downto 0);
           data: out std_logic_vector(7 downto 0)
         );
end font_rom;

architecture Behavioral of font_rom is

begin


end Behavioral;

