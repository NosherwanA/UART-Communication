library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TX is port(
	
	clk				:in std_logic;  --50 MHz clock
	start				:in std_logic;	 --signal that starts the transmission
	busy				:out std_logic; --signal indicating transmission is going on
	data				:in std_logic_vector(7 downto 0); --data that needs to be transmitted (8 bit wide)
	TX_line_out		:out std_logic --the transmission line that goes out

);
end TX;

architecture internal of TX is 
	
	signal prescaler	:Integer range 0 to 5208:=0; --for the main clock
	signal index		:Integer range 0 to 9:=0;  --to select which bit to send
	signal datafll		:std_logic_vector (9 downto 0); --data to be transmitted including start and stop bits
	signal TX_flg		:std_logic:= '0'; --will start the transmission

begin

	process(clk)
	
	begin
		
		if rising_edge(clk) then
		
			if (TX_flg = '0') AND (start = '1') then
			
				TX_flg <= '1';
				busy <= '1';
				datafll(0) <= '0';
				datafll(9) <= '1';
				
				datafll(8 downto 1) <= data;
				
			
			end if;
			
			if (TX_flg = '1') then 
			
				if (prescaler < 5207) then
					
					prescaler <= prescaler + 1;
				
				else
					
					prescaler <= 0;
					
				end if;
				
				if (prescaler = 2607) then
					
					TX_line_out <= datafll(index);
					
					if (index < 9) then 
						
						index <= index + 1;
					
					else
						
						TX_flg <= '0';
						busy <= '0';
						index <= 0;
					
					end if;
					
				end if;
				
			end if;
		
		end if;
		
	end process;


end internal;


--	component TX is port(
--	
--		clk				:in std_logic;  --50 MHz clock
--		start				:in std_logic;	 --signal that starts the transmission
--		busy				:out std_logic; --signal indicating transmission is going on
--		data				:in std_logic_vector(7 downto 0); --data that needs to be transmitted (8 bit wide)
--		TX_line_out		: out std_logic --the transmission line that goes out
--	
--	);
--	end component;