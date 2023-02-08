library ieee;
use ieee.std_logic_1164.all;

entity sseg32 is 
port(
	data	:	IN STD_LOGIC_VECTOR(31 downto 0);
	Result0, Result1, Result2, Result3, Result4, Result5, Result6, Result7 :	OUT STD_LOGIC_VECTOR(6 downto 0)
);
end sseg32;

architecture Behavior of sseg32 is 
	component sseg is
	port(
		I	:	IN STD_LOGIC_VECTOR(3 downto 0);
		O	:	OUT STD_LOGIC_VECTOR(6 downto 0)
	);
	end component;
begin 
	stage0: sseg port map (I => data(3 downto 0), O => Result0);
	stage1: sseg port map (I => data(7 downto 4), O => Result1);
	stage2: sseg port map (I => data(11 downto 8), O => Result2);
	stage3: sseg port map (I => data(15 downto 12), O => Result3);
	stage4: sseg port map (I => data(19 downto 16), O => Result4);
	stage5: sseg port map (I => data(23 downto 20), O => Result5);
	stage6: sseg port map (I => data(27 downto 24), O => Result6);
	stage7: sseg port map (I => data(31 downto 28), O => Result7);
end Behavior;

