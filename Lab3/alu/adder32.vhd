library ieee;
use ieee.std_logic_1164.all;

entity adder32 is 
port(
	Cin	:	IN STD_LOGIC;
	X, Y	:	IN STD_LOGIC_VECTOR(31 downto 0);
	S		:	OUT STD_LOGIC_VECTOR(31 downto 0);
	Cout	:	OUT STD_LOGIC
);
end adder32;

architecture Behavior of adder32 is 
	component adder16
	port(
		Cin	:	IN STD_LOGIC;
		X, Y	:	IN STD_LOGIC_VECTOR(15 downto 0);
		S		:	OUT STD_LOGIC_VECTOR(15 downto 0);
		Cout  :	OUT STD_LOGIC
	);
	end component;
	
	signal C : STD_LOGIC;
begin
	stage0:	adder16 port map(Cin, X(15 downto 0), Y(15 downto 0), S(15 downto 0), C);
	stage1:	adder16 port map(C, X(31 downto 16), Y(31 downto 16), S(31 downto 16), Cout);
end Behavior;
