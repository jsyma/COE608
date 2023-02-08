library ieee;
use ieee.std_logic_1164.all;

entity fulladd is
port(
	Cin, x, y	:	IN STD_LOGIC;
	s, Cout		:	OUT STD_LOGIC
);	
end fulladd;

architecture Behavior of fulladd is 
begin
	s <= x XOR y XOR Cin;
	Cout <= (x AND y) OR (Cin AND x) OR (Cin AND y);
end Behavior;
