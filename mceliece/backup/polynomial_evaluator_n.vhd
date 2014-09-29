----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Polynomial_Evaluator_N
-- Module Name:    Polynomial_Evaluator_N
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 3rd step in Goppa Code Decoding. 
--
-- This circuit is to be used together with find_correct_erros_n to find the roots
-- of polynomial sigma. This circuit can also be alone to evaluate a polynomial withing
-- a range of values.
--
-- For the computation this circuit applies the school book algorithm of powering x
-- and multiplying by the respective polynomial coefficient and adding into the accumulator.
-- This method is not appropriate for this computation, so in polynomial_evaluator_n_v2
-- Horner scheme is applied to reduce circuits costs. 
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
-- The number of stages the pipeline has. More stages means more values of value_sigma 
-- are tested at once.
--
-- size_pipeline_size :
--
-- The number of bits necessary to store the pipeline_size.
-- This number is ceil(log2(pipeline_size))
--
-- gf_2_m :
--
-- The size of the field used in this circuit. This parameter depends of the 
-- Goppa code used.
--
-- polynomial_degree :
-- 
-- The polynomial degree to be evaluated. Therefore the polynomial has
-- polynomial_degree+1 coefficients. This parameters depends of the Goppa code used.
--
-- size_polynomial_degree :
--
-- The number of bits necessary to store polynomial_degree.
-- This number is ceil(log2(polynomial_degree+1))
--
-- number_of_values_x :
--
-- The size of the memory that holds all support elements. This parameter 
-- depends of the Goppa code used.
--
-- size_number_of_values_x :
-- The number of bits necessary to store all support elements. 
-- this number is ceil(log2(number_of_values_x)).
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- pipeline_polynomial_calc Rev 1.0
-- shift_register_rst_nbits Rev 1.0
-- shift_register_nbits Rev 1.0
-- register_nbits Rev 1.0
-- register_rst_nbits Rev 1.0
-- counter_rst_nbits Rev 1.0
-- controller_polynomial_evaluator Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity polynomial_evaluator_n is
	Generic (	
		
		-- GOPPA [2048, 1751, 27, 11] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 11;
--		polynomial_degree : integer := 27; 
--		size_polynomial_degree : integer := 5;
--		number_of_values_x: integer := 2048;
--		size_number_of_values_x : integer := 11
		
		-- GOPPA [2048, 1498, 50, 11] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 11;
--		polynomial_degree : integer := 50; 
--		size_polynomial_degree : integer := 6;
--		number_of_values_x: integer := 2048;
--		size_number_of_values_x : integer := 11

		-- GOPPA [3307, 2515, 66, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 12;
--		polynomial_degree : integer := 66; 
--		size_polynomial_degree : integer := 7;
--		number_of_values_x: integer := 3307;
--		size_number_of_values_x : integer := 12
		
		-- QD-GOPPA [2528, 2144, 32, 12] --
		
		number_of_pipelines : integer := 1;
		pipeline_size : integer := 9;
		size_pipeline_size : integer := 5;
		gf_2_m : integer range 1 to 20 := 12;
		polynomial_degree : integer := 32; 
		size_polynomial_degree : integer := 6;
		number_of_values_x: integer := 2528;
		size_number_of_values_x : integer := 12
		
		-- QD-GOPPA [2816, 2048, 64, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 12;
--		polynomial_degree : integer := 64; 
--		size_polynomial_degree : integer := 6;
--		number_of_values_x: integer := 2816;
--		size_number_of_values_x : integer := 12
		
		-- QD-GOPPA [3328, 2560, 64, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 12;
--		polynomial_degree : integer := 128; 
--		size_polynomial_degree : integer := 7;
--		number_of_values_x: integer := 3200;
--		size_number_of_values_x : integer := 12
		
		-- QD-GOPPA [7296, 5632, 128, 13] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 15;
--		polynomial_degree : integer := 128; 
--		size_polynomial_degree : integer := 7;
--		number_of_values_x: integer := 8320;
--		size_number_of_values_x : integer := 14

	);
	Port(
		value_x : in  STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		value_acc : in  STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		value_x_pow : in  STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		value_polynomial : in  STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		clk : in  STD_LOGIC;
		rst : in STD_LOGIC;
		last_evaluations : out STD_LOGIC;
		evaluation_finalized : out STD_LOGIC;
		address_value_polynomial : out STD_LOGIC_VECTOR((size_polynomial_degree - 1) downto 0);
		address_value_x : out STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0);
		address_value_acc : out STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0);
		address_value_x_pow : out STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0);
		address_new_value_acc : out STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0);
		address_new_value_x_pow : out STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0);
		write_enable_new_value_acc : out STD_LOGIC;
		write_enable_new_value_x_pow : out STD_LOGIC;
		new_value_acc : out STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		new_value_x_pow : out STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0)
	);
end polynomial_evaluator_n;

architecture RTL of polynomial_evaluator_n is

component pipeline_polynomial_calc
	Generic (		
		gf_2_m : integer range 1 to 20 := 11;
		size : integer := 2
	);
	Port (
		value_x : in  STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_polynomial : in STD_LOGIC_VECTOR((((gf_2_m)*size) - 1) downto 0);
		value_acc : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_x_pow : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		clk : in STD_LOGIC;
		new_value_x_pow : out  STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_acc : out  STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end component;

component shift_register_rst_nbits
	Generic (size : integer);
	Port (
		data_in : in STD_LOGIC;
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR((size - 1) downto 0);		
		q : out STD_LOGIC_VECTOR((size - 1) downto 0);
		data_out : out STD_LOGIC
	);
end component;

component shift_register_nbits
	Generic (size : integer);
	Port (
		data_in : in STD_LOGIC;
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		q : out STD_LOGIC_VECTOR((size - 1) downto 0);
		data_out : out STD_LOGIC
	);
end component;

component register_nbits
	Generic(size : integer);
	Port(
		d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component register_rst_nbits
	Generic(size : integer);
	Port(
		d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		rst_value : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
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

component controller_polynomial_evaluator
	Port(
		clk : in  STD_LOGIC;
		rst : in STD_LOGIC;
		last_load_x_values : in STD_LOGIC;
		last_store_x_values : in STD_LOGIC;
		limit_polynomial_degree : in STD_LOGIC;
		pipeline_ready : in STD_LOGIC;
		evaluation_data_in : out STD_LOGIC;
		reg_write_enable_rst : out STD_LOGIC;
		ctr_load_x_address_ce : out STD_LOGIC;
		ctr_load_x_address_rst : out STD_LOGIC;
		ctr_store_x_address_ce : out STD_LOGIC;
		ctr_store_x_address_rst : out STD_LOGIC;
		reg_first_values_ce : out STD_LOGIC;
		reg_first_values_rst : out STD_LOGIC;
		ctr_address_polynomial_ce : out STD_LOGIC;
		ctr_address_polynomial_rst : out STD_LOGIC;
		shift_polynomial_ce_ce : out STD_LOGIC;
		shift_polynomial_ce_rst : out STD_LOGIC;
		last_coefficients : out STD_LOGIC;
		evaluation_finalized : out STD_LOGIC
	);
end component;

signal pipeline_value_acc : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal pipeline_value_x_pow : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);

constant coefficient_zero : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(0, gf_2_m));

constant first_acc : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(0, gf_2_m));
constant first_x_pow : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(1, gf_2_m));

signal reg_polynomial_coefficients_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_polynomial_coefficients_ce : STD_LOGIC_VECTOR((pipeline_size - 1) downto 0);
signal reg_polynomial_coefficients_q : STD_LOGIC_VECTOR((((gf_2_m)*pipeline_size) - 1) downto 0);

signal shift_polynomial_ce_data_in : STD_LOGIC;
signal shift_polynomial_ce_ce : STD_LOGIC;
signal shift_polynomial_ce_rst : STD_LOGIC;
constant shift_polynomial_ce_rst_value : STD_LOGIC_VECTOR(pipeline_size downto 0) := std_logic_vector(to_unsigned(1, pipeline_size+1));
signal shift_polynomial_ce_q : STD_LOGIC_VECTOR(pipeline_size downto 0);

signal ctr_address_polynomial_ce : STD_LOGIC;
signal ctr_address_polynomial_rst : STD_LOGIC;
constant ctr_address_polynomial_rst_value : STD_LOGIC_VECTOR((size_polynomial_degree) downto 0) := std_logic_vector(to_unsigned(0, size_polynomial_degree+1));
signal ctr_address_polynomial_q : STD_LOGIC_VECTOR((size_polynomial_degree) downto 0);

signal ctr_load_x_address_ce : STD_LOGIC;
signal ctr_load_x_address_rst : STD_LOGIC;
constant ctr_load_x_address_rst_value : STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0) := std_logic_vector(to_unsigned(0, size_number_of_values_x));
signal ctr_load_x_address_q : STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0);

signal ctr_store_x_address_ce : STD_LOGIC;
signal ctr_store_x_address_rst : STD_LOGIC;
constant ctr_store_x_message_address_rst_value : STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0) := std_logic_vector(to_unsigned(0, size_number_of_values_x));
signal ctr_store_x_address_q : STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0);

signal reg_first_values_ce : STD_LOGIC;
signal reg_first_values_rst : STD_LOGIC;
signal reg_first_values_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "1";
signal reg_first_values_q : STD_LOGIC_VECTOR(0 downto 0);

signal evaluation_data_in : STD_LOGIC;
signal evaluation_data_out : STD_LOGIC;

signal reg_write_enable_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_write_enable_rst : STD_LOGIC;
constant reg_write_enable_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_write_enable_q : STD_LOGIC_VECTOR(0 downto 0);

signal pipeline_ready : STD_LOGIC;
signal limit_polynomial_degree : STD_LOGIC;
signal last_coefficients : STD_LOGIC;
signal last_load_x_values : STD_LOGIC;
signal last_store_x_values : STD_LOGIC;

begin

pipelines : for I in 0 to (number_of_pipelines - 1) generate

pipeline_I : pipeline_polynomial_calc
	Generic Map (
		gf_2_m => gf_2_m,
		size => pipeline_size
	)
	Port Map(
		value_x => value_x(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))),
		value_polynomial => reg_polynomial_coefficients_q,
		value_acc => pipeline_value_acc(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))),
		value_x_pow => pipeline_value_x_pow(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))),
		clk => clk,
		new_value_x_pow => new_value_x_pow(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))),
		new_value_acc => new_value_acc(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I)))
	);
	
pipeline_value_acc(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) <= first_acc when reg_first_values_q = "1" else 
																				value_acc(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I)));
pipeline_value_x_pow(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) <= first_x_pow when reg_first_values_q = "1" else
																				value_x_pow(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I)));
	
end generate;

polynomial : for I in 0 to (pipeline_size - 1) generate

reg_polynomial_coefficients_I : register_nbits
	Generic Map (size => gf_2_m)
	Port Map(
		d => reg_polynomial_coefficients_d,
		clk => clk,
		ce => reg_polynomial_coefficients_ce(I),
		q => reg_polynomial_coefficients_q(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I)))
	);

end generate;

controller : controller_polynomial_evaluator
	Port Map(
		clk => clk,
		rst => rst,
		last_load_x_values => last_load_x_values,
		last_store_x_values => last_store_x_values, 
		limit_polynomial_degree => limit_polynomial_degree,
		pipeline_ready => pipeline_ready,
		evaluation_data_in => evaluation_data_in,
		reg_write_enable_rst => reg_write_enable_rst,
		ctr_load_x_address_ce => ctr_load_x_address_ce,
		ctr_load_x_address_rst => ctr_load_x_address_rst,
		ctr_store_x_address_ce => ctr_store_x_address_ce,
		ctr_store_x_address_rst => ctr_store_x_address_rst,
		reg_first_values_ce => reg_first_values_ce,
		reg_first_values_rst => reg_first_values_rst,
		ctr_address_polynomial_ce => ctr_address_polynomial_ce,
		ctr_address_polynomial_rst => ctr_address_polynomial_rst,
		shift_polynomial_ce_ce => shift_polynomial_ce_ce,
		shift_polynomial_ce_rst => shift_polynomial_ce_rst,
		last_coefficients => last_coefficients,
		evaluation_finalized => evaluation_finalized
	);
	
shift_polynomial_ce : shift_register_rst_nbits
	Generic Map(
		size => pipeline_size + 1
	)
	Port Map(
		data_in => shift_polynomial_ce_data_in,
		clk => clk,
		ce => shift_polynomial_ce_ce,
		rst => shift_polynomial_ce_rst,
		rst_value => shift_polynomial_ce_rst_value,
		q => shift_polynomial_ce_q,
		data_out => shift_polynomial_ce_data_in
	);	

evaluation : shift_register_nbits
	Generic Map(
		size => pipeline_size - 1
	)
	Port Map(
		data_in => evaluation_data_in,
		clk => clk,
		ce => '1',
		q => open,
		data_out => evaluation_data_out
	);	
	
reg_write_enable : register_rst_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_write_enable_d,
		clk => clk,
		ce => '1',
		rst => reg_write_enable_rst,
		rst_value => reg_write_enable_rst_value,
		q => reg_write_enable_q
	);
	
ctr_address_polynomial : counter_rst_nbits
	Generic Map(
		size => size_polynomial_degree+1,
		increment_value => 1
	)
	Port Map(	
		clk => clk,
		ce => ctr_address_polynomial_ce,
		rst => ctr_address_polynomial_rst,
		rst_value => ctr_address_polynomial_rst_value,
		q => ctr_address_polynomial_q
	);
	
ctr_load_x_address : counter_rst_nbits
	Generic Map(
		size => size_number_of_values_x,
		increment_value => number_of_pipelines
	)
	Port Map(	
		clk => clk,
		ce => ctr_load_x_address_ce,
		rst => ctr_load_x_address_rst,
		rst_value => ctr_load_x_address_rst_value,
		q => ctr_load_x_address_q
	);
	
ctr_store_x_address : counter_rst_nbits
	Generic Map(
		size => size_number_of_values_x,
		increment_value => number_of_pipelines
	)
	Port Map(	
		clk => clk,
		ce => ctr_store_x_address_ce,
		rst => ctr_store_x_address_rst,
		rst_value => ctr_store_x_message_address_rst_value,
		q => ctr_store_x_address_q
	);
	
reg_first_values : register_rst_nbits
	Generic Map(size => 1)
	Port Map(
		d => "0",
		clk => clk,
		ce => reg_first_values_ce,
		rst => reg_first_values_rst,
		rst_value => reg_first_values_rst_value,
		q  => reg_first_values_q
	);
	
reg_polynomial_coefficients_d <= coefficient_zero when last_coefficients = '1' else
											value_polynomial;
reg_polynomial_coefficients_ce <= shift_polynomial_ce_q((pipeline_size - 1) downto 0);

address_value_polynomial <= ctr_address_polynomial_q((size_polynomial_degree - 1) downto 0);

address_value_x <= ctr_load_x_address_q;
address_value_acc <= ctr_load_x_address_q;
address_value_x_pow <= ctr_load_x_address_q;

address_new_value_acc <= ctr_store_x_address_q;
address_new_value_x_pow <= ctr_store_x_address_q;

pipeline_ready <= shift_polynomial_ce_q(pipeline_size-1);
limit_polynomial_degree <= '1' when (unsigned(ctr_address_polynomial_q) = to_unsigned(polynomial_degree+1, ctr_address_polynomial_q'length)) else '0';
last_evaluations <= limit_polynomial_degree and shift_polynomial_ce_q(pipeline_size);

reg_write_enable_d(0) <= evaluation_data_out;

write_enable_new_value_acc <= reg_write_enable_q(0);
write_enable_new_value_x_pow <= reg_write_enable_q(0);

last_load_x_values <= '1' when ctr_load_x_address_q = std_logic_vector(to_unsigned(((number_of_values_x - 1)/number_of_pipelines)*number_of_pipelines, ctr_load_x_address_q'Length)) else '0';
last_store_x_values <= '1' when ctr_store_x_address_q = std_logic_vector(to_unsigned(((number_of_values_x - 1)/number_of_pipelines)*number_of_pipelines, ctr_load_x_address_q'Length)) else '0';

end RTL;