LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY alu IS 
PORT(
	a			:	IN STD_LOGIC_VECTOR(31 downto 0);
	b			:	IN STD_LOGIC_VECTOR(31 downto 0);
	op			:	IN STD_LOGIC_VECTOR(2 downto 0);
	result	:	OUT STD_LOGIC_VECTOR(31 downto 0);
	cout		:	OUT STD_LOGIC;
	zero		:	OUT STD_LOGIC
);
END alu;

ARCHITECTURE Behavior OF alu is 
	component adder32 
	port(
		Cin	:	IN STD_LOGIC;
		X, Y	:	IN STD_LOGIC_VECTOR(31 downto 0);
		S		:	OUT STD_LOGIC_VECTOR(31 downto 0);
		Cout	:	OUT STD_LOGIC
	);
	end component;
	
	signal result_s: STD_LOGIC_VECTOR(31 downto 0):=(others => '0');
	signal result_add: STD_LOGIC_VECTOR(31 downto 0):=(others => '0');
	signal result_sub: STD_LOGIC_VECTOR(31 downto 0):=(others => '0');
	signal cout_s:	STD_LOGIC:= '0';
	signal cout_add: STD_LOGIC:= '0';
	signal cout_sub:	STD_LOGIC:= '0';
	signal zero_s:	STD_LOGIC;
begin
	add0: adder32 port map(op(2), a, b, result_add, cout_add);
	sub0: adder32 port map(op(2), a, not b, result_sub, cout_sub);
	
	process(a, b ,op)
	begin
		case(op) is
			when "000" =>
				result_s <= a and b;
				cout_s <= '0';
			when "001" =>
				result_s <= a or b;
				cout_s <= '0';
			when "010" =>
				result_s <= result_add;
				cout_s <= cout_add;
			when "011" =>
				result_s <= b;
				cout_s <= '0';
			when "110" =>
				result_s <= result_sub;
				cout_s <= cout_sub;
			when "100" =>
				result_s <= a(30 downto 0) & '0';
				cout_s <= a(31);
			when "101" =>
				result_s <= '0' & a(31 downto 1);
				cout_s <= '0';
			when others =>
				result_s <= a;
				cout_s <= '0';
		end case;
		
		case(result_s) is
			when (others => '0') =>
				zero_s <= '1';
			when others =>
				zero_s <= '0';
		end case;
	end process;
	
	result <= result_s;
	cout <= cout_s;
	zero <= zero_s;
END Behavior;
