library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eightBitDecoder is port(

	input			: in std_logic_vector ( 7 downto 0 );
	ouput			: out	std_logic_vector ( 13 downto 0 );


);
end eightBitDecoder;

architecture internal of eightBitDecoder is 

	signal digit0		: std_logic_vector ( 4 downto 0 );
	signal digit1		: std_logic_vector ( 4 downto 0 );
	signal display0	: std_logic_vector ( 6 downto 0 );
	signal display1	: std_logic_vector ( 6 downto 0 );

begin

	digit0 <= input (3 downto 0);
	digit1 <= input (7 downto 4);
	
	with digit0 select
	
		display0 <= 
		
			--	6,5,4,3,2,1,0	
			"1000000" when "0000", 
			"1111001" when "0001",
			"0100100" when "0010",
			"0110000" when "0011",
			"0011001" when "0100",
			"0010010" when "0101",
			"0000010" when "0110",
			"1111000" when "0111",
			"0000000" when "1000",
			"0011000" when "1001",
			"0001000" when "1010",
			"0000011" when "1011",
			"1000110" when "1100",
			"0100001" when "1101",
			"0000110" when "1110",
			"0001110" when "1111";
			
			
	with digit1 select
	
		display1 <= 
		
			--	6,5,4,3,2,1,0	
			"1000000" when "0000", 
			"1111001" when "0001",
			"0100100" when "0010",
			"0110000" when "0011",
			"0011001" when "0100",
			"0010010" when "0101",
			"0000010" when "0110",
			"1111000" when "0111",
			"0000000" when "1000",
			"0011000" when "1001",
			"0001000" when "1010",
			"0000011" when "1011",
			"1000110" when "1100",
			"0100001" when "1101",
			"0000110" when "1110",
			"0001110" when "1111";


	output <= digit1 & digit0;


end internal;

--component eightBitDecoder is port(
--
--	input			: in std_logic_vector ( 7 downto 0 );
--	ouput			: out	std_logic_vector ( 13 downto 0 );
--
--
--);
--end component;