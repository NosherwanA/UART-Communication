library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RX is port(

	clk		: in std_logic;
	RX_line 	: in std_logic;	--incoming data transmission line
	data		: out std_logic_vector(7 downto 0);	--data recieved
	busy		: out std_logic	--signal if reciever is busy


);
end RX;

architecture internal of RX is 

	signal datafll		: std_logic_vector (9 downto 0);
	signal prescaler	: Integer range 0 to 5208 := 0;
	signal index		: Integer range 0 to 9 := 0;
	signal RX_flg		: std_logic := '0';
	

begin

	process(clk)
	
	begin

		if rising_edge(clk) then
		
			if (RX_flg = '0') AND (RX_line = '0') then
			
				index <= 0;
				prescaler <= 0;
				RX_flg <= '1';
				busy <= '1';
			
			end if;
			
			if (RX_flg = '1') then 
			
				datafll(index) <= RX_line;
				
				if (prescaler < 5207) then
				
					prescaler <= prescaler + 1;
					
				else
				
					prescaler <= 0;
				
				end if;
				
				if (prescaler = 2607) then
					
					if (index < 9) then 
						
						index <= index + 1;
						
					else 
					
						if (datafll(0) = '0' AND datafll(9) = '1') then 
							
							data <= datafll(8 downto 1);
							
						else 
						
							data <= (others => '0');
						
						end if;
						
						RX_flg <= '0';
						
						busy <= '0';
						
					
					end if;
				
				end if;
				
			
			end if;
		
		end if;
		
	end process;

end internal;

--component RX is port(
--
--	clk		: in std_logic;
--	RX_line 	: in std_logic;	--incoming data transmission line
--	data		: out std_logic_vector(7 downto 0);	--data recieved
--	busy		: out std_logic	--signal if reciever is busy
--
--
--);
--end component;
