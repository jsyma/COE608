library verilog;
use verilog.vl_types.all;
entity lab3_block is
    port(
        HEX0            : out    vl_logic_vector(6 downto 0);
        SW3             : in     vl_logic;
        SW2             : in     vl_logic;
        SW1             : in     vl_logic;
        SW0             : in     vl_logic;
        SW7             : in     vl_logic;
        SW6             : in     vl_logic;
        SW5             : in     vl_logic;
        SW4             : in     vl_logic;
        SW17            : in     vl_logic;
        SW16            : in     vl_logic;
        SW15            : in     vl_logic;
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX3            : out    vl_logic_vector(6 downto 0);
        HEX4            : out    vl_logic_vector(6 downto 0);
        HEX5            : out    vl_logic_vector(6 downto 0);
        HEX6            : out    vl_logic_vector(6 downto 0);
        HEX7            : out    vl_logic_vector(6 downto 0);
        LEDG            : out    vl_logic_vector(1 downto 0)
    );
end lab3_block;
