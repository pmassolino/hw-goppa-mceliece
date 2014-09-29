----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Find_Correct_Errors_N
-- Module Name:    Find_Correct_Errors_N
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 3rd step in Goppa Code Decoding. 
-- 
-- This circuit should be used along side polynomial_evaluator_n or polynomial_evaluator_n_v2.
-- This circuit when used along side follows the same number of stages of polynomial evaluators.
-- It receives the values of messages and when it is detected to be last evaluation.
-- During the last evaluations with the result is 0 then it write on memory the inverted value,
-- if not it writes on the memory the original value.
--
-- This circuit is optimized. A newer version with both polynomial evaluator and this unit were
-- constructed in order to optimize syndrome generation. 
-- This circuit is polynomial_syndrome_computing_n
-- 
--
-- The circuits parameters
--
-- number_of_pipelines :
--
-- Number of pipelines used in the circuit to test the support elements and
-- correct the message. Each pipeline needs at least 2 memory ram to store 
-- intermediate results.
--
-- pipeline_size : 
--
-- The number of stages of the pipeline. More stages means more values of sigma 
-- are tested at once.
--
-- gf_2_m :
--
-- The size of the field used in this circuit. This parameter depends of the 
-- Goppa code used.
--
-- length_support_elements :
--
-- The number of support elements. This parameter depends of the Goppa code used.
--
-- size_support_elements :
--
-- The size of the memory that holds all support elements. This parameter 
-- depends of the Goppa code used.
-- This is ceil(log2(length_support_elements))
--
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- controller_find_correct_errors_n Rev 1.0
-- counter_rst_nbits Rev 1.0
-- counter_load_nbits Rev 1.0
-- register_nbits Rev 1.0
-- register_rst_nbits Rev 1.0
-- shift_register_nbits Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity find_correct_errors_n is
	Generic (	
		
		-- GOPPA [2048, 1751, 27, 11] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 28;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_support_elements: integer := 2048;
--		size_support_elements : integer := 11
		
		-- GOPPA [2048, 1498, 50, 11] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 51;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_support_elements: integer := 2048;
--		size_support_elements : integer := 11

		-- GOPPA [3307, 2515, 66, 12] --

--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 67;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_support_elements: integer := 3307;
--		size_support_elements : integer := 12
		
		-- QD-GOPPA [2528, 2144, 32, 12] --
		
		number_of_pipelines : integer := 1;
		pipeline_size : integer := 33;
		gf_2_m : integer range 1 to 20 := 12;
		length_support_elements: integer := 2528;
		size_support_elements : integer := 12
		
		-- QD-GOPPA [2816, 2048, 64, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 65;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_support_elements: integer := 2816;
--		size_support_elements : integer := 12
		
		-- QD-GOPPA [3328, 2560, 64, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_support_elements: integer := 3328;
--		size_support_elements : integer := 12
		
		-- QD-GOPPA [7296, 5632, 128, 13] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 129;
--		gf_2_m : integer range 1 to 20 := 13;
--		length_support_elements: integer := 7296;
--		size_support_elements : integer := 13

	);
	Port(
		value_message : in STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
		value_evaluated : in  STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		address_value_evaluated : in STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
		enable_correction : in STD_LOGIC;
		evaluation_finalized : in STD_LOGIC;
		clk : in  STD_LOGIC;
		rst : in STD_LOGIC;
		correction_finalized : out STD_LOGIC;
		address_new_value_message : out STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
		address_value_error : out STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
		write_enable_new_value_message : out STD_LOGIC;
		write_enable_value_error : out STD_LOGIC;
		new_value_message : out STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
		value_error : out STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0)
	);
end find_correct_errors_n;

architecture RTL of find_correct_errors_n is

component controller_find_correct_errors_n
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		enable_correction : in STD_LOGIC;
		evaluation_finalized : in STD_LOGIC;
		reg_value_evaluated_ce : out STD_LOGIC;
		reg_address_store_new_value_message_ce : out STD_LOGIC;
		reg_address_store_new_value_message_rst : out STD_LOGIC;
		reg_write_enable_new_value_message_ce : out STD_LOGIC;
		reg_write_enable_new_value_message_rst : out STD_LOGIC;
		correction_finalized : out STD_LOGIC
	);
end component;

component counter_rst_nbits
	Generic (
		size : integer;
		increment_value : integer
	);
	Port (
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component counter_load_nbits
	Generic (
		size : integer;
		increment_value : integer
	);
	Port (
		d : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in STD_LOGIC;
		ce : in STD_LOGIC;
		load : in STD_LOGIC;
		q : out STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component register_nbits
	Generic(size : integer);
	Port(
		d : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in STD_LOGIC;
		ce : in STD_LOGIC;
		q : out STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component register_rst_nbits
	Generic(size : integer);
	Port(
		d : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in STD_LOGIC;
		ce : in STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component shift_register_nbits
	Generic (size : integer);
	Port (
		data_in : in STD_LOGIC;
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0);
		data_out : out STD_LOGIC
	);
end component;

signal is_error_position : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);

constant error_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');

signal reg_value_evaluated_d : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal reg_value_evaluated_ce : STD_LOGIC;
signal reg_value_evaluated_q : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);

signal reg_address_store_new_value_message_d : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
signal reg_address_store_new_value_message_ce : STD_LOGIC;
signal reg_address_store_new_value_message_rst : STD_LOGIC;
constant reg_address_store_new_value_message_rst_value : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0) := (others => '0');
signal reg_address_store_new_value_message_q : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);

signal reg_write_enable_new_value_message_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_write_enable_new_value_message_ce : STD_LOGIC;
signal reg_write_enable_new_value_message_rst : STD_LOGIC;
constant reg_write_enable_new_value_message_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_write_enable_new_value_message_q : STD_LOGIC_VECTOR(0 downto 0);

signal message_data_in : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
signal message_data_out : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);

begin

pipelines : for I in 0 to (number_of_pipelines - 1) generate
	
reg_value_evaluated_I : register_nbits
	Generic Map( size => gf_2_m )
	Port Map(
		d => reg_value_evaluated_d(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))),
		clk => clk,
		ce => reg_value_evaluated_ce,
		q => reg_value_evaluated_q(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I)))
	);

shift_message : shift_register_nbits
	Generic Map(size => pipeline_size + 1)
	Port Map(
		data_in => message_data_in(I),
		clk => clk,
		ce => '1',
		q => open,
		data_out => message_data_out(I)
	);

is_error_position(I) <= '1' when reg_value_evaluated_q(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) = error_value else '0';

message_data_in(I) <= value_message(I);
new_value_message(I) <= (not message_data_out(I)) when is_error_position(I) = '1' else message_data_out(I);
value_error(I) <= is_error_position(I);

reg_value_evaluated_d(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) <= value_evaluated(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I)));
end generate;

controller : controller_find_correct_errors_n
	Port Map(
		clk => clk,
		rst => rst,
		enable_correction => enable_correction,
		evaluation_finalized => evaluation_finalized,
		reg_value_evaluated_ce => reg_value_evaluated_ce,
		reg_address_store_new_value_message_ce => reg_address_store_new_value_message_ce,
		reg_address_store_new_value_message_rst => reg_address_store_new_value_message_rst,
		reg_write_enable_new_value_message_ce => reg_write_enable_new_value_message_ce,
		reg_write_enable_new_value_message_rst => reg_write_enable_new_value_message_rst,
		correction_finalized => correction_finalized
	);
	
reg_address_store_new_message : register_rst_nbits
	Generic Map( size => size_support_elements )
	Port Map(
		d => reg_address_store_new_value_message_d,
		clk => clk,
		ce => reg_address_store_new_value_message_ce,
		rst => reg_address_store_new_value_message_rst,
		rst_value => reg_address_store_new_value_message_rst_value,
		q => reg_address_store_new_value_message_q
	);

reg_write_enable_new_message : register_rst_nbits
	Generic Map( size => 1 )
	Port Map(
		d => reg_write_enable_new_value_message_d,
		clk => clk,
		ce => reg_write_enable_new_value_message_ce,
		rst => reg_write_enable_new_value_message_rst,
		rst_value => reg_write_enable_new_value_message_rst_value,
		q => reg_write_enable_new_value_message_q
	);

reg_address_store_new_value_message_d <= address_value_evaluated;

reg_write_enable_new_value_message_d(0) <= enable_correction;

address_new_value_message <= reg_address_store_new_value_message_q;
address_value_error <= reg_address_store_new_value_message_q;

write_enable_new_value_message <= reg_write_enable_new_value_message_q(0);
write_enable_value_error <= reg_write_enable_new_value_message_q(0);

end RTL;