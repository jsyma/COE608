library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Data_Path is
	port(
			--Clock Signal
			Clk, mClk		:		in		std_logic;
			
			--Memory Signals
			WEN, EN			:		in		std_logic;
			
			--Register Control Signals (CLR and LD)													
			Clr_A, Ld_A		:		in		std_logic;
			Clr_B, Ld_B		:		in		std_logic;
			Clr_C, Ld_C		:		in		std_logic;
			Clr_Z, Ld_Z		:		in		std_logic;
			ClrPC, Ld_PC	:		in		std_logic;
			ClrIR, Ld_IR	:		in		std_logic;
			
			--Register Outputs
			Out_A				:		out	std_logic_vector(31 downto 0);
			Out_B				:		out	std_logic_vector(31 downto 0);
			Out_C				:		out	std_logic;
			Out_Z				:		out	std_logic;
			Out_PC			:		out	std_logic_vector(31 downto 0);
			Out_IR			:		out	std_logic_vector(31 downto 0);
			
			--Special Inputs to PC
			Inc_PC			:		in		std_logic;
			
			--Address and Data Bus signals for debugging
			ADDR_OUT			: 		out	std_logic_vector(31 downto 0);
			DATA_IN			:		in		std_logic_vector(31 downto 0);
			DATA_BUS,
			MEM_OUT,
			MEM_IN			:		out	std_logic_vector(31 downto 0);
			MEM_ADDR			:		out	unsigned(7 downto 0);
			
			--Various MUX controls
			DATA_MUX			:		in		std_logic_vector(1 downto 0);
			REG_MUX			:		in		std_logic;
			A_MUX,
			B_MUX				:		in		std_logic;
			IM_MUX1			:		in		std_logic;
			IM_MUX2			:		in		std_logic_vector(1 downto 0);
			
			--ALU Operations
			ALU_Op			:		in		std_logic_vector(2 downto 0)
			);
end entity;

architecture Behavior of Data_Path is
		--Component Instantiations
		--Data Memory Module
		component data_mem is
			port(
					clk		:		in 	std_logic;
					addr		:		in		unsigned(7 downto 0);
					data_in	:		in		std_logic_vector(31 downto 0);
					wen		:		in		std_logic;
					en			:		in		std_logic;
					data_out	:		out	std_logic_vector(31 downto 0)
					);
		end component;
		
		--Register32
		component register32 is
			port(
					d			:		in		std_logic_vector(31 downto 0);
					ld			:		in		std_logic;
					clr		:		in		std_logic;
					clk		:		in		std_logic;
					Q			:		out	std_logic_vector(31 downto 0)
					);
		end component;
		
		--Program Counter
		component pc is
			port(
					clr		:		in		std_logic;
					clk		:		in		std_logic;
					ld			:		in		std_logic;
					inc		:		in		std_logic;
					d			:		in		std_logic_vector(31 downto 0);
					q			:		out	std_logic_vector(31 downto 0)
					);
		end component;
		
		--LZE
		component LZE is
			port(
					LZE_in	:		in		std_logic_vector(31 downto 0);
					LZE_out	:		out	std_logic_vector(31 downto 0)
					);
		end component;
		
		--UZE
		component UZE is
			port(
					UZE_in	:		in		std_logic_vector(31 downto 0);
					UZE_out	:		out	std_logic_vector(31 downto 0)
					);
		end component;
		
		--RED
		component RED is
			port(
					RED_in	:		in		std_logic_vector(31 downto 0);
					RED_out	:		out	unsigned(7 downto 0)
					);
		end component;
		
		--mux2to1
		component mux2to1 is
			port(
					s			:		in		std_logic;
					w0, w1	:		in		std_logic_vector(31 downto 0);
					f			:		out	std_logic_vector(31 downto 0)
					);
		end component;
		
		--mux4to1
		
		component mux4to1 is
			port(
					s					:		in		std_logic_vector(1 downto 0);
					X1, X2, X3, X4	:		in		std_logic_vector(31 downto 0);
					f					:		out	std_logic_vector(31 downto 0)
					);
		end component;
		
		--ALU
		component alu is
			port(
					a			:		in		std_logic_vector(31 downto 0);
					b			:		in		std_logic_vector(31 downto 0);
					op			:		in		std_logic_vector(2 downto 0);
					result	:		out	std_logic_vector(31 downto 0);
					zero		:		out	std_logic;
					cout		:		out	std_logic
					);
		end component;
		
		--Signal Instantiations
		signal	IR_out				:		std_logic_vector(31 downto 0);
		signal	data_bus_s			:		std_logic_vector(31 downto 0);
		signal	LZE_out_PC			:		std_logic_vector(31 downto 0);
		signal	LZE_out_A_Mux		:		std_logic_vector(31 downto 0);
		signal	LZE_out_B_Mux		:		std_logic_vector(31 downto 0);
		signal	RED_out_Data_Mem	:		unsigned(7 downto 0);
		signal	A_Mux_out			:		std_logic_vector(31 downto 0);
		signal	B_Mux_out			:		std_logic_vector(31 downto 0);
		signal	reg_A_out			:		std_logic_vector(31 downto 0);
		signal	reg_B_out			:		std_logic_vector(31 downto 0);
		signal	reg_Mux_out			:		std_logic_vector(31 downto 0);
		signal	data_mem_out		:		std_logic_vector(31 downto 0);
		signal	UZE_IM_MUX1_out	:		std_logic_vector(31 downto 0);
		signal	IM_MUX1_out			:		std_logic_vector(31 downto 0);
		signal	LZE_IM_MUX2_out	:		std_logic_vector(31 downto 0);
		signal	IM_MUX2_out			:		std_logic_vector(31 downto 0);
		signal	ALU_out				:		std_logic_vector(31 downto 0);
		signal	zero_flag			:		std_logic;
		signal	carry_flag			:		std_logic;
		signal	temp					:		std_logic_vector(30 downto 0) := (others => '0');
		signal	out_pc_sig			:		std_logic_vector(31 downto 0);
		
begin
		IR:		register32 port map(
					data_bus_s,
					Ld_IR,
					ClrIR,
					Clk,
					IR_out
					);
					
		LZE_PC:	LZE			port map(
					IR_OUT,
					LZE_out_PC
					);
		
		PC0:		PC				port map(
					CLRPC,
					Clk,
					ld_PC,
					INC_PC,
					LZE_out_PC,
					--ADDR_OUT
					out_Pc_sig
					);
					
		LZE_A_Mux:LZE			port map(
					 IR_OUT,
					 LZE_out_A_Mux
					 );
					 
		A_Mux0:	mux2to1		port map(
					A_MUX,
					data_bus_s, LZE_out_A_Mux,
					A_Mux_out
					);
					
		Reg_A:	register32	port map(
					A_Mux_out,
					Ld_A,
					Clr_A,
					Clk,
					reg_A_out
					);
					
		LZE_B_Mux:	LZE		port map(
						IR_OUT,
						LZE_out_B_Mux
						);
						
		B_Mux0:		mux2to1	port map(
						B_MUX,
						data_bus_s, LZE_out_B_Mux,
						B_mux_out
						);
						
		Reg_B:		register32	port map(
						B_mux_out,
						Ld_B,
						Clr_B,
						Clk,
						reg_B_out
						);
						
		Reg_Mux0:	mux2to1		port map(
						REG_MUX,
						Reg_A_out, Reg_B_out,
						Reg_Mux_out
						);
						
		RED_Data_Mem:	RED		port map(
							IR_OUT,
							RED_out_Data_mem
							);
							
		Data_Mem0:		data_mem	port map(
							mClk,
							RED_out_Data_mem,
							Reg_Mux_out,
							WEN,
							EN,
							data_mem_out
							);
							
		UZE_IM_MUX1:	UZE		port map(
							IR_OUT,
							UZE_IM_MUX1_out
							);
							
		IM_MUX1a:		mux2to1	port map(
							IM_MUX1,
							reg_A_out, UZE_IM_MUX1_out,
							IM_MUX1_out
							);
							
		LZE_IM_MUX2:	LZE		port map(
							IR_OUT,
							LZE_IM_MUX2_out
							);
			
		IM_MUX2a:		mux4to1	port map(
							IM_MUX2,
							reg_B_out, LZE_IM_MUX2_out, (temp & '1'), (others => '0'),
							IM_MUX2_out
							);
							
		ALU0:				ALU		port map(
							IM_MUX1_out,
							IM_MUX2_out,
							ALU_OP,
							ALU_out,
							zero_flag,
							carry_flag
							);
							
		DATA_MUX0:		mux4to1	port map(
							DATA_MUX,
							DATA_IN, data_mem_out, ALU_out, (others => '0'),
							data_bus_s
							);
							
		DATA_BUS	<= data_bus_s;
		OUT_A 	<= reg_A_out;
		OUT_B		<= reg_B_out;
		OUT_IR	<= IR_OUT;
		ADDR_OUT <= out_pc_sig;
		OUT_PC 	<= out_pc_sig;
		
		MEM_ADDR <= RED_out_Data_Mem;
		MEM_IN 	<= Reg_Mux_out;
		MEM_OUT	<= data_mem_out;
		
end Behavior;

--How does this data-path implement the INCA, ADDI, LDBI and LDA operations?
-- The way INCA operation is implemented is with the help of the inc_pc signal.
-- This is what increments the PC by 4. The PC is then stored into the PC component
-- and the output of the component is connected to the addr_out signal which is used
-- to access the memory to fetch the instruction. With ADDI, the immediate value is
-- provided through the data_in signal. The value is then sign-extended using the LZE
-- component and added to the register B value using the ALU component. The result then
-- gets stored into register B. To implement LDBI, it is very similar to ADDI. The
-- immediate value is provided via the data_in signal. From there, the immediate value is 
-- sign-extended and then loaded into register B. The last operation LDA is implemented by
-- first having the address of the memory location to be loaded via data_in. After this,
-- The address gets stored into register B and the contents of the memory location are
-- accessed using the data memory component and loaded into register A.

--The data-path has a maximum reliable operating speed (Clk). What determines this speed?
--(i.e. how would you estimate the data-path circuit clock)?
-- The maximum reliable operating speed of the data-path is determined by the slowest
-- operation in the critical path (which is the path with the longest delay and it
-- determines the maximum clock frequency at which the circuit and reliably operate). To
-- estimate the data-path circuit clock, you need to identify the critical path and
-- calculate its delay.

--What is a reliable limit for your data-path clock?
-- The reliable limit for the data-path clock can depend on various factors like the
-- The clock speed is tpyically determined through the simulations and testing to make
-- sure there are no errors. To conclude, the reliable limit will vary depending on the
-- design and the way that it is implemented.
							
		
		