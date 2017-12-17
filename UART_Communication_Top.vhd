library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_Communication_Top is port (
	
	--Clocks
	CLOCK_50			: in std_logic;
	CLOCK2_50			: in std_logic;
	CLOCK3_50			: in std_logic;
	CLOCK4_50			: in std_logic;
	
	--Reset Button
	RESET_N				: in std_logic;
	
	--Keys (Push Buttons) ACTIVE LOW
	KEY					: in std_logic_vector(3 downto 0);
		
	--Switches
	SW					: in std_logic_vector(9 downto 0);
	
	--LEDR (Red LEDs)
	LEDR				: out std_logic_vector(9 downto 0);
	
	--Seven Segment Displays
	HEX0				: out std_logic_vector(6 downto 0);
	HEX1				: out std_logic_vector(6 downto 0);
	HEX2				: out std_logic_vector(6 downto 0);
	HEX3				: out std_logic_vector(6 downto 0);
	HEX4				: out std_logic_vector(6 downto 0);
	HEX5				: out std_logic_vector(6 downto 0);
	
	--DRAM
	DRAM_ADDR			: out std_logic_vector(12 downto 0);
	DRAM_BA				: out std_logic_vector(1 downto 0);
	DRAM_CAS_N			: out std_logic;
	DRAM_CKE			: out std_logic;
	DRAM_CLK			: out std_logic;
	DRAM_CS_N			: out std_logic;
	DRAM_DQ				: inout std_logic_vector(15 downto 0);
	DRAM_LDQM			: out std_logic;
	DRAM_RAS_N			: out std_logic;
	DRAM_UDQM			: out std_logic;
	DRAM_WE_N			: out std_logic;
	
	--GPIOs
	GPIO_0				: inout std_logic_vector(35 downto 0);
	GPIO_1				: inout std_logic_vector(15 downto 0);
	
	--PS2
	PS2_CLK				: inout std_logic;
	PS2_CLK2			: inout std_logic;
	PS2_DAT				: inout std_logic;
	PS2_DAT2			: inout std_logic;
	
	--SD
	SD_CLK				: out std_logic;
	SD_CMD				: inout std_logic;
	SD_DATA				: inout std_logic_vector(3 downto 0);
	
	
	--VGA
	VGA_B				: out std_logic_vector(3 downto 0);
	VGA_G				: out std_logic_vector(3 downto 0);
	VGA_HS				: out std_logic;
	VGA_R				: out std_logic_vector(3 downto 0);
	VGA_VS				: out std_logic
	
);
end UART_Communication_Top ;

architecture overall of UART_Communication_Top is

	-- COMPONENT DECLARATION
	
	component TX is port(
	
		clk				:in std_logic;  --50 MHz clock
		start				:in std_logic;	 --signal that starts the transmission
		busy				:out std_logic; --signal indicating transmission is going on
		data				:in std_logic_vector(7 downto 0); --data that needs to be transmitted (8 bit wide)
		TX_line_out		: out std_logic --the transmission line that goes out
	
	);
	end component;
	
	component RX is port(
	
		clk		: in std_logic;
		RX_line 	: in std_logic;	--incoming data transmission line
		data		: out std_logic_vector(7 downto 0);	--data recieved
		busy		: out std_logic	--signal if reciever is busy
	
	);
	end component;
	
	component eightBitDecoder is port(

		input			: in std_logic_vector ( 7 downto 0 );
		ouput			: out	std_logic_vector ( 13 downto 0 );

	);
	end component;
	
	-- INTERNAL SIGNALS 
	
	signal startTransmission		: std_logic;
	signal inputData					: std_logic_vector (7 downto 0);
	signal outputData					: std_logic_vector (7 downto 0);
	signal dataLine					: std_logic;
	signal transmitterBusy			: std_logic;
	signal receiverBusy				: std_logic;
	signal decoderOutput				: std_logic_vector (13 downto 0);
	
	
begin

	-- YOUR CODE HERE 
	
	startTransmission <= NOT KEY(0);
	inputData <= SW (7 downto 0);
	LEDR(7 downto 0) <= outputData;
	LEDR(8) <= transmitterBusy;
	LEDR(9) <= receiverBusy;
	
	Transmitter	:	TX port map(CLOCK_50, startTransmission, transmitterBusy, inputData, dataLine);
	Receiver		:	RX port map(CLOCK_50, dataLine, outputData, receiverBusy);
	
	Decoder		: 	eightBitDecoder port map(outputData, decoderOutput);

	HEX5 <= decoderOutput(13 downto 7);
	HEX4 <= decoderOutput(6 downto 0);
	
	HEX3 <= decoderOutput(13 downto 7);
	HEX2 <= decoderOutput(6 downto 0);
	
	HEX1 <= decoderOutput(13 downto 7);
	HEX0 <= decoderOutput(6 downto 0);

end overall;