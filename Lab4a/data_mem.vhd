library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
port(
	clk		:	IN STD_LOGIC;
	addr		:	IN UNSIGNED(7 downto 0);
	data_in	:	IN STD_LOGIC_VECTOR(31 downto 0);
	wen		:	IN STD_LOGIC;
	en			:	IN	STD_LOGIC;
	data_out	:	OUT STD_LOGIC_VECTOR(31 downto 0)
);
end data_mem;

architecture Behavior of data_mem is
	type RAM is array(0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
	signal DATAMEM: RAM;

begin
	process(clk, en, wen)
	begin
		if(clk'event and clk = '0') then
			if(en = '0') then
				data_out <= (others => '0');
			else
				if(wen = '0') then
					data_out <= DATAMEM(to_integer(addr));
				end if;
				if(wen = '1') then
					DATAMEM(to_integer(addr)) <= data_in;
					data_out <= (others => '0');
				end if;
			end if;
		end if;
	end process;
end Behavior;