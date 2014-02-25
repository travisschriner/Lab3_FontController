----------------------------------------------------------------------------------
-- Company: USAFA DFEC
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    11:15:28 02/21/2014 
-- Design Name: 
-- Module Name:    character_gen - Behavioral 
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

entity character_gen is
    port ( clk            : in std_logic;
           blank          : in std_logic;
           row            : in std_logic_vector(10 downto 0);
           column         : in std_logic_vector(10 downto 0);
           ascii_to_write : in std_logic_vector(7 downto 0);
           write_en       : in std_logic;
           r,g,b          : out std_logic_vector(7 downto 0)
         );
end character_gen;

architecture Behavioral of character_gen is

begin


end Behavioral;

