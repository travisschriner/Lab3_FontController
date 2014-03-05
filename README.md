Lab3_FontController
===================
The purpose of this lab is to create a font controller that is displayed over a VGA signal. First, fonts must be displayed properly on the screen. Once that is complete, the fonts must be updated based off the switch configuration on the spartan 6 board. The final functionality is to interface with an NES controller and utilize the controller to scroll between fonts and then pick one. 

design
------

From the start, this lab proved to be very challenging. The design constraints were quite unclear and I had a difficult time understanding what each component was supposed to do. Eventually, Trae Barnett was able to explain to me the purpose of the input_to_pulse signal. The largest part to figuring out what the module did was to first understand that it was simply a debouncing tool. After that, the STD had to be created. My STD is as follows:

```vhdl
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
```

The next part to understanding the code and getting the design to work was developing the character_gen. This part was simply an instantiation of several parts and register delays to get the timing down. An example of the timing delays is as follows:

```vhld
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
```

Because the signals were parsed and used for different things throughout the module, I was able to use combinational logic to not only lay out the individual char boxes, but also to concatenate the signals.

```vhdl
--contacination of address signal
addr_sig <= data_b_sig(6 downto 0) & std_logic_vector(unsigned(row_delay1(3 downto 0))) ;

--individual char boxes being establishes
row_col_multiply <= std_logic_vector((unsigned(row(10 downto 4)) * 80) + unsigned(column(10 downto 3)));
```

The individual char boxes proved to be the most difficult thing to debug. Before I got to B functionality, I had an issue with the characters being too far to the right and cutting off the next character by a couple of pixels. After a wile of tinkering and staring at the char_gen module, I realized it was because I had delayed my row and column signal going into my row_col_multiply. After I removed the delays from those two signals, B functionality was satisfied. 

Conclusion
----------
Overall this lab was very challenging. If it were not for the help of Trae Barnett explaining what stuff was supposed to do at the beginning, I would have never been able to complete the lab. Once I understood what each component was supposed to do, the lab proved to be very strait-forward because it only really needed two extra modules to get to B functionality. Though Char_gen required multiple components inside of it, I lump them all into one big char_gen component. The hardest thing to debug was timing issues. I kept playing with my timing to see if I could illicite a change, but ultimately, I used the correct amount of delays and realized my bug was due to attaching the wrong wire to my VGA Sync. In the end, this lab proved to be useful and I learned the importance of signal timing to get a proper product. I tried to understand what was going on with the given ROM, but I had a tough time following everything. 

