----------------------------------------------------------------------------------
-- Company: USAFA DFEC
-- Engineer: C2C Travis Schriner
-- 
-- Create Date:    11:59:35 01/31/2014 
-- Design Name: 
-- Module Name:    vga_sync - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_sync is
    port ( clk         : in  std_logic;
           reset       : in  std_logic;
           h_sync      : out std_logic;
           v_sync      : out std_logic;
           v_completed : out std_logic;
           blank       : out std_logic;
           row         : out unsigned(10 downto 0);
           column      : out unsigned(10 downto 0)
     );
end vga_sync;


architecture Behavioral of vga_sync is

component h_sync_gen 
	port ( clk       : in  std_logic;
           reset     : in  std_logic;
           h_sync    : out std_logic;
           blank     : out std_logic;
           completed : out std_logic;
           column    : out unsigned(10 downto 0)
     );
end component;
	  
component v_sync_gen
	port ( clk         : in  std_logic;
           reset       : in std_logic;
           h_blank     : in std_logic;
           h_completed : in std_logic;
           v_sync      : out std_logic;
           blank       : out std_logic;
           completed   : out std_logic;
           row         : out unsigned(10 downto 0)
     );
end component;

signal h_blank_sig, h_completed_sig, v_blank_sig : std_logic;

begin
	h_sync_instance : h_sync_gen
		port map (clk => clk, 
					 reset => reset, 
					 h_sync => h_sync, 
					 blank => h_blank_sig, 
					 completed => h_completed_sig, 
					 column => column);
		
	v_sync_instance : v_sync_gen
		port map (clk => clk, 
					 reset => reset, 
					 h_blank => h_blank_sig, 
					 h_completed => h_completed_sig, 
					 v_sync => v_sync, 
					 blank => v_blank_sig, 
					 completed => v_completed, 
					 row => row);
					 

	
	--output logic

		blank <= h_blank_sig or v_blank_sig;

end Behavioral;