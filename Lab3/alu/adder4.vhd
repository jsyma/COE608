library ieee;
use ieee.std_logic_1164.all;

entity adder4 is
port(
	Cin	:	IN STD_LOGIC;
	X, Y	:	IN	STD_LOGIC_VECTOR(3 downto 0);
	S		:	OUT STD_LOGIC_VECTOR(3 downto 0);
	Cout	:	OUT STD_LOGIC
);
end adder4;

architecture Behavior of adder4 is
	component fulladd
	port(
		Cin, x, y	:	IN STD_LOGIC;
		s, Cout		:	OUT STD_LOGIC
	);
	end component;
	
	signal C	:	STD_LOGIC_VECTOR(1 to 3);
begin	
	stage0: fulladd port map(Cin, X(0), Y(0), S(0), C(1));
	stage1: fulladd port map(C(1), X(1), Y(1), S(1), C(2));
	stage2: fulladd port map(C(2), X(2), Y(2), S(2), C(3));
	stage3: fulladd port map(C(3), X(3), Y(3), S(3), Cout);
end Behavior;