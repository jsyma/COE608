library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PC is
port(
	clr   :  in std_logic;
	clk   :  in std_logic;
	ld  :	in std_logic;
	inc   :  in std_logic;
	d   : in std_logic_vector(31 DOWNTO 0);
	q 	 : out std_logic_vector(31 DOWNTO 0)
);
end PC;

architecture Behavior of PC isg
	component add
	 port(
			A   : in std_logic_vector(31 DOWNTO 0);
			B	 : out std_logic_vector(31 DOWNTO 0)
		);
  end component;
  component mux2to1
	 port(
		 s     : in std_logic;
  	w0, w1	 : in std_logic_vector(31 DOWNTO 0);
		 f     : out std_logic_vector(31 DOWNTO 0)
		);
  end component;
  component register32
	 port(
		d   : in std_logic_vector(31 DOWNTO 0);
		ld  :	in std_logic;
		clr   :  in std_logic;
		clk   :  in std_logic;
		Q 	 : out std_logic_vector(31 DOWNTO 0)
		);
  end component;
  signal add_out : std_logic_vector(31 DOWNTO 0);
  signal mux_out : std_logic_vector(31 DOWNTO 0);
  signal q_out   : std_logic_vector(31 DOWNTO 0);
  --signal ld    : std_logic := '1';
  
  begin
	 add0: add port map(q_out, add_out);
	 mux0: mux2to1 port map(inc, d, add_out, mux_out);
	 reg0: register32 port map(mux_out, ld, clr, clk, q_out);
	 q <= q_out;
end Behavior;