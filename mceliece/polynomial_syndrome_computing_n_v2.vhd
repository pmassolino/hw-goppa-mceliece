----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Polynomial_Syndrome_Computing_N_v2
-- Module Name:    Polynomial_Syndrome_Computing_N_v2
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 1st and 3rd step in Goppa Decoding. 
--
-- This circuit can find the roots of polynomial sigma and compute the syndrome from
-- the received ciphertext. The algorithm run by the circuit is chosen from one of the inputs.
-- Both circuits were joined into the same, because several computing parts are reused in
-- the computations, therefore this circuit needs less area than two apart. 
--
-- For the computation this circuit applies the Horner scheme during finding roots, where at each stage
-- an accumulator is multiplied by respective x and then added accumulated with coefficient.
-- In Horner scheme algorithm, it begin from the most significative coefficient until reaches
-- lesser significative coefficient.
--
-- In syndrome generation it is applied alternant syndrome generation, where at each pipeline
-- stage is computed one syndrome iteration. A syndrome iteration is the multiplication of 
-- one powering element by one support element. 
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
-- pipeline_polynomial_calc_v4 Rev 1.0
-- controller_polynomial_computing Rev 1.0
-- controller_syndrome_computing Rev 1.0
-- pow2_gf_2_m Rev 1.0
-- shift_register_rst_nbits Rev 1.0
-- shift_register_nbits Rev 1.0
-- register_nbits Rev 1.0
-- counter_rst_nbits Rev 1.0
-- counter_increment_decrement_load_rst_nbits Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity polynomial_syndrome_computing_n_v2 is
	Generic (	
		
		-- GOPPA [2048, 1751, 27, 11] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 28;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 11;
--		number_of_errors : integer := 27; 
--		size_number_of_errors : integer := 5;
--		number_of_support_elements: integer := 2048;
--		size_number_of_support_elements : integer := 11
		
		-- GOPPA [2048, 1498, 50, 11] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 51;
--		size_pipeline_size : integer := 6;
--		gf_2_m : integer range 1 to 20 := 11;
--		number_of_errors : integer := 50; 
--		size_number_of_errors : integer := 6;
--		number_of_support_elements: integer := 2048;
--		size_number_of_support_elements : integer := 11

		-- GOPPA [3307, 2515, 66, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 67;
--		size_pipeline_size : integer := 6;
--		gf_2_m : integer range 1 to 20 := 12;
--		number_of_errors : integer := 66;
--		size_number_of_errors : integer := 7;
--		number_of_support_elements : integer := 3307;
--		size_number_of_support_elements : integer := 12;
		
		-- QD-GOPPA [2528, 2144, 32, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 33;
--		size_pipeline_size : integer := 6;
--		gf_2_m : integer range 1 to 20 := 12;
--		number_of_errors : integer := 32; 
--		size_number_of_errors : integer := 6;
--		number_of_support_elements: integer := 2528;
--		size_number_of_support_elements : integer := 12
		
		-- QD-GOPPA [2816, 2048, 64, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 65;
--		size_pipeline_size : integer := 7;
--		gf_2_m : integer range 1 to 20 := 12;
--		number_of_errors : integer := 64; 
--		size_number_of_errors : integer := 7;
--		number_of_support_elements: integer := 2816;
--		size_number_of_support_elements : integer := 12
		
		-- QD-GOPPA [2816, 2048, 64, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 65;
--		size_pipeline_size : integer := 7;
--		gf_2_m : integer range 1 to 20 := 12;
--		number_of_errors : integer := 64; 
--		size_number_of_errors : integer := 7;
--		number_of_support_elements: integer := 3328;
--		size_number_of_support_elements : integer := 12
		
		-- QD-GOPPA [7296, 5632, 128, 13] --
		
		number_of_pipelines : integer := 1;
		pipeline_size : integer := 2;
		size_pipeline_size : integer := 2;
		gf_2_m : integer range 1 to 20 := 13;
		number_of_errors : integer := 128; 
		size_number_of_errors : integer := 8;
		number_of_support_elements: integer := 7296;
		size_number_of_support_elements : integer := 13

	);
	Port(
		value_x : in  STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		value_acc : in  STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		value_polynomial : in  STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_message : in STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
		value_h : in  STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		mode_polynomial_syndrome : in STD_LOGIC;
		clk : in  STD_LOGIC;
		rst : in STD_LOGIC;
		computation_finalized : out STD_LOGIC;
		address_value_polynomial : out STD_LOGIC_VECTOR((size_number_of_errors - 1) downto 0);
		address_value_x : out STD_LOGIC_VECTOR((size_number_of_support_elements - 1) downto 0);
		address_value_acc : out STD_LOGIC_VECTOR((size_number_of_support_elements - 1) downto 0);
		address_value_message : out STD_LOGIC_VECTOR((size_number_of_support_elements - 1) downto 0);
		address_new_value_message : out STD_LOGIC_VECTOR((size_number_of_support_elements - 1) downto 0);
		address_new_value_acc : out STD_LOGIC_VECTOR((size_number_of_support_elements - 1) downto 0);
		address_new_value_syndrome : out STD_LOGIC_VECTOR((size_number_of_errors) downto 0);
		address_value_error : out STD_LOGIC_VECTOR((size_number_of_support_elements - 1) downto 0);
		write_enable_new_value_acc : out STD_LOGIC;
		write_enable_new_value_syndrome : out STD_LOGIC;
		write_enable_new_value_message : out STD_LOGIC;
		write_enable_value_error : out STD_LOGIC;
		new_value_syndrome : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_acc : out STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		new_value_message : out STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
		value_error : out STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0)
	);
end polynomial_syndrome_computing_n_v2;

architecture RTL of polynomial_syndrome_computing_n_v2 is

component pipeline_polynomial_calc_v4
	Generic (
		gf_2_m : integer range 1 to 20;
		size : integer
	);
	Port (
		value_x : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_polynomial : in STD_LOGIC_VECTOR((((gf_2_m)*size) - 1) downto 0);
		value_acc : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		reg_x_rst : in STD_LOGIC_VECTOR((size - 1) downto 0);
		mode_polynomial_syndrome : in STD_LOGIC;
		clk : in STD_LOGIC;
		new_value_syndrome : out STD_LOGIC_VECTOR((((gf_2_m)*size) - 1) downto 0);
		new_value_acc : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end component;

component pow2_gf_2_m
	Generic(
		gf_2_m : integer range 1 to 20
	);
	Port(
		a : in STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0)
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

component counter_decrement_rst_nbits
	Generic (
		size : integer;
		decrement_value : integer
	);
	Port (
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component counter_increment_decrement_load_rst_nbits
	Generic (
		size : integer;
		increment_value : integer;
		decrement_value : integer
	);
	Port (
		d : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in STD_LOGIC;
		ce : in STD_LOGIC;
		load : in STD_LOGIC;
		increment_decrement : in STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component controller_polynomial_syndrome_computing
	Port(
		clk : in  STD_LOGIC;
		rst : in STD_LOGIC;
		mode_polynomial_syndrome : in STD_LOGIC;
		last_load_x_values : in STD_LOGIC;
		last_store_x_values : in STD_LOGIC;
		limit_polynomial_degree : in STD_LOGIC;
		last_syndrome_value : in STD_LOGIC;
		final_syndrome_evaluation : in STD_LOGIC;
		pipeline_ready : in STD_LOGIC;
		evaluation_data_in : out STD_LOGIC;
		reg_write_enable_rst : out STD_LOGIC;
		ctr_load_x_address_ce : out STD_LOGIC;
		ctr_load_x_address_rst : out STD_LOGIC;
		ctr_store_x_address_ce : out STD_LOGIC;
		ctr_store_x_address_rst : out STD_LOGIC;
		reg_first_values_ce : out STD_LOGIC;
		reg_first_values_rst : out STD_LOGIC;
		ctr_address_polynomial_syndrome_ce : out STD_LOGIC;
		ctr_address_polynomial_syndrome_load : out STD_LOGIC;
		ctr_address_polynomial_syndrome_increment_decrement : out STD_LOGIC;
		ctr_address_polynomial_syndrome_rst : out STD_LOGIC;
		reg_x_rst_rst : out STD_LOGIC;
		reg_store_temporary_syndrome_ce : out STD_LOGIC;
		reg_final_syndrome_evaluation_ce : out STD_LOGIC;
		reg_final_syndrome_evaluation_rst : out STD_LOGIC;
		shift_polynomial_ce_ce : out STD_LOGIC;
		shift_polynomial_ce_rst : out STD_LOGIC;
		shift_syndrome_mode_data_in : out STD_LOGIC;
		shift_syndrome_mode_rst : out STD_LOGIC;
		write_enable_new_value_syndrome : out STD_LOGIC;
		finalize_syndrome : out STD_LOGIC;
		last_coefficients : out STD_LOGIC;
		computation_finalized : out STD_LOGIC		
	);
end component;

signal pipeline_value_acc : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal pipeline_value_polynomial : STD_LOGIC_VECTOR(((gf_2_m)*(pipeline_size)*(number_of_pipelines) - 1) downto 0);

signal square_value_h : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);

signal new_value_intermediate_syndrome : STD_LOGIC_VECTOR(((gf_2_m)*(pipeline_size)*(number_of_pipelines) - 1) downto 0);

constant coefficient_zero : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(0, gf_2_m));

constant first_acc : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(0, gf_2_m));
constant first_x_pow : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(1, gf_2_m));

signal reg_polynomial_coefficients_d : STD_LOGIC_VECTOR((((gf_2_m)*pipeline_size) - 1) downto 0);
signal reg_polynomial_coefficients_ce : STD_LOGIC_VECTOR((pipeline_size - 1) downto 0);
signal reg_polynomial_coefficients_q : STD_LOGIC_VECTOR((((gf_2_m)*pipeline_size) - 1) downto 0);

signal reg_x_rst_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_x_rst_ce : STD_LOGIC_VECTOR((pipeline_size - 1) downto 0);
signal reg_x_rst_rst : STD_LOGIC;
signal reg_x_rst_q : STD_LOGIC_VECTOR((pipeline_size - 1) downto 0);

signal reg_x_rst : STD_LOGIC_VECTOR((pipeline_size - 1) downto 0);

signal shift_polynomial_ce_data_in : STD_LOGIC;
signal shift_polynomial_ce_ce : STD_LOGIC;
signal shift_polynomial_ce_rst : STD_LOGIC;
constant shift_polynomial_ce_rst_value : STD_LOGIC_VECTOR(pipeline_size downto 0) := std_logic_vector(to_unsigned(1, pipeline_size+1));
signal shift_polynomial_ce_q : STD_LOGIC_VECTOR(pipeline_size downto 0);

signal finalize_syndrome : STD_LOGIC;

signal shift_syndrome_mode_data_in : STD_LOGIC;
signal shift_syndrome_mode_rst : STD_LOGIC;
constant shift_syndrome_mode_rst_value : STD_LOGIC_VECTOR((pipeline_size - 1) downto 0) := std_logic_vector(to_unsigned(1, pipeline_size));
signal shift_syndrome_mode_q : STD_LOGIC_VECTOR((pipeline_size - 1) downto 0);

signal ctr_load_x_address_ce : STD_LOGIC;
signal ctr_load_x_address_rst : STD_LOGIC;
constant ctr_load_x_address_rst_value : STD_LOGIC_VECTOR((size_number_of_support_elements - 1) downto 0) := std_logic_vector(to_unsigned(0, size_number_of_support_elements));
signal ctr_load_x_address_q : STD_LOGIC_VECTOR((size_number_of_support_elements - 1) downto 0);

signal ctr_store_x_address_ce : STD_LOGIC;
signal ctr_store_x_address_rst : STD_LOGIC;
constant ctr_store_x_address_rst_value : STD_LOGIC_VECTOR((size_number_of_support_elements - 1) downto 0) := std_logic_vector(to_unsigned(0, size_number_of_support_elements));
signal ctr_store_x_address_q : STD_LOGIC_VECTOR((size_number_of_support_elements - 1) downto 0);

signal ctr_address_polynomial_syndrome_d : STD_LOGIC_VECTOR ((size_number_of_errors) downto 0);
signal ctr_address_polynomial_syndrome_ce : STD_LOGIC;
signal ctr_address_polynomial_syndrome_load : STD_LOGIC;
signal ctr_address_polynomial_syndrome_increment_decrement : STD_LOGIC;
signal ctr_address_polynomial_syndrome_rst : STD_LOGIC;
signal ctr_address_polynomial_syndrome_rst_value : STD_LOGIC_VECTOR ((size_number_of_errors) downto 0) := std_logic_vector(to_unsigned(number_of_errors*2, size_number_of_errors+1));
signal ctr_address_polynomial_syndrome_q : STD_LOGIC_VECTOR ((size_number_of_errors) downto 0);

signal reg_store_temporary_syndrome_d : STD_LOGIC_VECTOR ((size_number_of_errors) downto 0);
signal reg_store_temporary_syndrome_ce : STD_LOGIC;
signal reg_store_temporary_syndrome_q : STD_LOGIC_VECTOR ((size_number_of_errors) downto 0);

signal reg_first_values_ce : STD_LOGIC;
signal reg_first_values_rst : STD_LOGIC;
constant reg_first_values_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "1";
signal reg_first_values_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_final_syndrome_evaluation_ce : STD_LOGIC;
signal reg_final_syndrome_evaluation_rst : STD_LOGIC;
constant reg_final_syndrome_evaluation_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_final_syndrome_evaluation_q : STD_LOGIC_VECTOR(0 downto 0);

signal evaluation_data_in : STD_LOGIC;
signal evaluation_data_out : STD_LOGIC;

signal reg_write_enable_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_write_enable_rst : STD_LOGIC;
constant reg_write_enable_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_write_enable_q : STD_LOGIC_VECTOR(0 downto 0);

signal pipeline_ready : STD_LOGIC;
signal limit_polynomial_degree : STD_LOGIC;
signal last_syndrome_value : STD_LOGIC;
signal final_syndrome_evaluation : STD_LOGIC;
signal last_coefficients : STD_LOGIC;
signal last_load_x_values : STD_LOGIC;
signal last_store_x_values : STD_LOGIC;

signal value_evaluated : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);

signal last_evaluations : STD_LOGIC;

signal is_error_position : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);

constant error_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');

signal message_data_in : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
signal message_data_q : STD_LOGIC_VECTOR((((number_of_pipelines)*(pipeline_size+1)) - 1) downto 0);
signal message_data_out : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);

signal poly_reg_polynomial_coefficients_d : STD_LOGIC_VECTOR(((gf_2_m)*(pipeline_size) - 1) downto 0);

constant ctr_address_polynomial_rst_value : STD_LOGIC_VECTOR ((size_number_of_errors) downto 0) := std_logic_vector(to_unsigned(number_of_errors, size_number_of_errors+1));

signal synd_reg_polynomial_coefficients_d : STD_LOGIC_VECTOR(((gf_2_m)*(pipeline_size) - 1) downto 0);

constant ctr_address_syndrome_rst_value : STD_LOGIC_VECTOR ((size_number_of_errors) downto 0) := std_logic_vector(to_unsigned(number_of_errors*2, size_number_of_errors+1));

begin

pipelines : for I in 0 to (number_of_pipelines - 1) generate

square_I : entity work.pow2_gf_2_m(Software_POLYNOMIAL)
	Generic Map(gf_2_m => gf_2_m)
	Port Map(
		a => value_h(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))),
		o => square_value_h(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I)))
	);

pipeline_I : pipeline_polynomial_calc_v4
	Generic Map (
		gf_2_m => gf_2_m,
		size => pipeline_size
	)
	Port Map(
		value_x => value_x(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))),
		value_polynomial => pipeline_value_polynomial((((gf_2_m)*pipeline_size*(I + 1)) - 1) downto (((gf_2_m)*pipeline_size*(I)))),
		value_acc => pipeline_value_acc(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))),
		reg_x_rst => reg_x_rst,
		mode_polynomial_syndrome => mode_polynomial_syndrome,
		clk => clk,
		new_value_acc => value_evaluated(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))),
		new_value_syndrome => new_value_intermediate_syndrome((((gf_2_m)*pipeline_size*(I + 1)) - 1) downto (((gf_2_m)*pipeline_size*(I))))
	);
	
pipeline_value_acc(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) <= value_acc(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) when (reg_first_values_q(0) = '0') else 
																						  square_value_h(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) when (mode_polynomial_syndrome = '1' and value_message(I) = '1') else 
																						  first_acc;
shift_message : shift_register_nbits
	Generic Map(size => pipeline_size + 1)
	Port Map(
		data_in => message_data_in(I),
		clk => clk,
		ce => '1',
		q => message_data_q(((pipeline_size + 1)*(I + 1) - 1) downto ((pipeline_size + 1)*(I))),
		data_out => message_data_out(I)
	);

is_error_position(I) <= '1' when value_evaluated(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) = error_value else '0';

message_data_in(I) <= value_message(I);
new_value_message(I) <= (not message_data_out(I)) when is_error_position(I) = '1' else message_data_out(I);
value_error(I) <= is_error_position(I);

first_case : if I = 0 generate

pipeline_value_polynomial((((gf_2_m)*pipeline_size*(I+1)) - 1) downto (((gf_2_m)*pipeline_size*I))) <= reg_polynomial_coefficients_q;

end generate first_case;

other_cases : if I > 0 generate

pipeline_value_polynomial((((gf_2_m)*pipeline_size*(I+1)) - 1) downto (((gf_2_m)*pipeline_size*I))) <= new_value_intermediate_syndrome((((gf_2_m)*pipeline_size*(I)) - 1) downto (((gf_2_m)*pipeline_size*(I - 1)))) when mode_polynomial_syndrome = '1' else
																																reg_polynomial_coefficients_q;
end generate other_cases;

end generate;

polynomial : for I in 0 to (pipeline_size - 1) generate

reg_polynomial_coefficients_I : register_nbits
	Generic Map (size => gf_2_m)
	Port Map(
		d => reg_polynomial_coefficients_d(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))),
		clk => clk,
		ce => reg_polynomial_coefficients_ce(I),
		q => reg_polynomial_coefficients_q(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I)))
	);
	
reg_x_rst_I : register_rst_nbits
	Generic Map (size => 1)
	Port Map(
		d => reg_x_rst_d,
		clk => clk,
		ce => reg_x_rst_ce(I),
		rst => reg_x_rst_rst,
		rst_value => "0",
		q => reg_x_rst_q(I downto I)
	);
	
reg_x_rst(I) <= (reg_x_rst_q(I) or (limit_polynomial_degree and shift_polynomial_ce_q(I)));

poly_reg_polynomial_coefficients_d(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) <= coefficient_zero when (last_coefficients = '1') else
											value_polynomial;

first_case : if I = 0 generate

synd_reg_polynomial_coefficients_d(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) <= coefficient_zero when (shift_polynomial_ce_q(I) = '1') else
																												new_value_intermediate_syndrome(((number_of_pipelines-1)*(pipeline_size)*(gf_2_m)+(gf_2_m)*(I + 1) - 1) downto ((number_of_pipelines-1)*(pipeline_size)*(gf_2_m)+(gf_2_m)*(I)));

end generate first_case;

other_cases : if I > 0 generate

synd_reg_polynomial_coefficients_d(((gf_2_m)*(I + 1) - 1) downto ((gf_2_m)*(I))) <= coefficient_zero when (shift_polynomial_ce_q(I) = '1') else
																												reg_polynomial_coefficients_q(((gf_2_m)*(I) - 1) downto ((gf_2_m)*(I - 1))) when (shift_syndrome_mode_q(I) = '0') else
																												new_value_intermediate_syndrome(((number_of_pipelines-1)*(pipeline_size)*(gf_2_m)+(gf_2_m)*(I + 1) - 1) downto ((number_of_pipelines-1)*(pipeline_size)*(gf_2_m)+(gf_2_m)*(I)));
end generate other_cases;

reg_polynomial_coefficients_ce(I) <= ((shift_syndrome_mode_q(I)) or finalize_syndrome) when mode_polynomial_syndrome = '1' else
												shift_polynomial_ce_q(I);

end generate;

controller : controller_polynomial_syndrome_computing
	Port Map(
		clk => clk,
		rst => rst,
		mode_polynomial_syndrome => mode_polynomial_syndrome,
		last_load_x_values => last_load_x_values,
		last_store_x_values => last_store_x_values,
		limit_polynomial_degree => limit_polynomial_degree,
		last_syndrome_value => last_syndrome_value,
		final_syndrome_evaluation => final_syndrome_evaluation,
		pipeline_ready => pipeline_ready,
		evaluation_data_in => evaluation_data_in,
		reg_write_enable_rst => reg_write_enable_rst,
		ctr_load_x_address_ce => ctr_load_x_address_ce,
		ctr_load_x_address_rst => ctr_load_x_address_rst,
		ctr_store_x_address_ce => ctr_store_x_address_ce,
		ctr_store_x_address_rst => ctr_store_x_address_rst,
		reg_first_values_ce => reg_first_values_ce,
		reg_first_values_rst => reg_first_values_rst,
		ctr_address_polynomial_syndrome_ce => ctr_address_polynomial_syndrome_ce,
		ctr_address_polynomial_syndrome_load => ctr_address_polynomial_syndrome_load,
		ctr_address_polynomial_syndrome_increment_decrement => ctr_address_polynomial_syndrome_increment_decrement,
		ctr_address_polynomial_syndrome_rst => ctr_address_polynomial_syndrome_rst,
		reg_x_rst_rst => reg_x_rst_rst,
		reg_store_temporary_syndrome_ce => reg_store_temporary_syndrome_ce,
		reg_final_syndrome_evaluation_ce => reg_final_syndrome_evaluation_ce,
		reg_final_syndrome_evaluation_rst => reg_final_syndrome_evaluation_rst,
		shift_polynomial_ce_ce => shift_polynomial_ce_ce,
		shift_polynomial_ce_rst => shift_polynomial_ce_rst,
		shift_syndrome_mode_data_in => shift_syndrome_mode_data_in,
		shift_syndrome_mode_rst => shift_syndrome_mode_rst,
		write_enable_new_value_syndrome => write_enable_new_value_syndrome,
		finalize_syndrome => finalize_syndrome,
		last_coefficients => last_coefficients,
		computation_finalized => computation_finalized	
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

shift_syndrome_mode : shift_register_rst_nbits
	Generic Map(
		size => pipeline_size
	)
	Port Map(
		data_in => shift_syndrome_mode_data_in,
		clk => clk,
		ce => '1',
		rst => shift_syndrome_mode_rst,
		rst_value => shift_syndrome_mode_rst_value,
		q => shift_syndrome_mode_q,
		data_out => open
	);	

evaluation : shift_register_nbits
	Generic Map(
		size => pipeline_size
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
	
ctr_address_polynomial_syndrome : counter_increment_decrement_load_rst_nbits
	Generic Map(
		size => size_number_of_errors+1,
		increment_value => 1,
		decrement_value => 1
	)
	Port Map(
		d => ctr_address_polynomial_syndrome_d,
		clk => clk,
		ce => ctr_address_polynomial_syndrome_ce,
		load => ctr_address_polynomial_syndrome_load,
		increment_decrement => ctr_address_polynomial_syndrome_increment_decrement,
		rst => ctr_address_polynomial_syndrome_rst,
		rst_value => ctr_address_polynomial_syndrome_rst_value,
		q => ctr_address_polynomial_syndrome_q
	);
	
reg_store_temporary_syndrome : register_nbits
	Generic Map(
		size => size_number_of_errors+1
	)
	Port Map(
		d => reg_store_temporary_syndrome_d,
		clk => clk,
		ce => reg_store_temporary_syndrome_ce,
		q => reg_store_temporary_syndrome_q
	);
	
ctr_load_x_address : counter_rst_nbits
	Generic Map(
		size => size_number_of_support_elements,
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
		size => size_number_of_support_elements,
		increment_value => number_of_pipelines
	)
	Port Map(	
		clk => clk,
		ce => ctr_store_x_address_ce,
		rst => ctr_store_x_address_rst,
		rst_value => ctr_store_x_address_rst_value,
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
	
reg_final_syndrome_evaluation : register_rst_nbits
	Generic Map(size => 1)
	Port Map(
		d => "1",
		clk => clk,
		ce => reg_final_syndrome_evaluation_ce,
		rst => reg_final_syndrome_evaluation_rst,
		rst_value => reg_final_syndrome_evaluation_rst_value,
		q  => reg_final_syndrome_evaluation_q
	);
	
new_value_acc <= value_evaluated;
	
reg_x_rst_d(0) <= limit_polynomial_degree;
reg_x_rst_ce <= shift_polynomial_ce_q((pipeline_size - 1) downto 0);

reg_polynomial_coefficients_d <= synd_reg_polynomial_coefficients_d when mode_polynomial_syndrome = '1' else
											poly_reg_polynomial_coefficients_d;
											
ctr_address_polynomial_syndrome_rst_value <= ctr_address_syndrome_rst_value when mode_polynomial_syndrome = '1' else
															ctr_address_polynomial_rst_value;

address_value_polynomial <= ctr_address_polynomial_syndrome_q((size_number_of_errors - 1) downto 0);

address_value_x <= ctr_load_x_address_q;
address_value_acc <= ctr_load_x_address_q;

address_value_message <= ctr_load_x_address_q;

address_new_value_acc <= ctr_store_x_address_q;

address_new_value_message <= ctr_store_x_address_q;
address_value_error <= ctr_store_x_address_q;

address_new_value_syndrome <= ctr_address_polynomial_syndrome_q;

reg_store_temporary_syndrome_d <= ctr_address_polynomial_syndrome_q;
ctr_address_polynomial_syndrome_d <= reg_store_temporary_syndrome_q;

pipeline_ready <= shift_polynomial_ce_q(pipeline_size-1);
limit_polynomial_degree <= '1' when (signed(ctr_address_polynomial_syndrome_q) = to_signed(-1, ctr_address_polynomial_syndrome_q'length)) else '0';
last_syndrome_value <= '1' when (ctr_address_polynomial_syndrome_q = std_logic_vector(to_signed(0, ctr_address_polynomial_syndrome_q'Length))) else '0';
last_evaluations <= limit_polynomial_degree and shift_polynomial_ce_q(pipeline_size);

final_syndrome_evaluation <= reg_final_syndrome_evaluation_q(0);

reg_write_enable_d(0) <= evaluation_data_out;

new_value_syndrome <= reg_polynomial_coefficients_q(((gf_2_m)*(pipeline_size) - 1) downto ((gf_2_m)*(pipeline_size - 1)));

write_enable_new_value_acc <= reg_write_enable_q(0);

write_enable_new_value_message <= '0' when mode_polynomial_syndrome = '1' else
											reg_write_enable_q(0) and last_evaluations;
write_enable_value_error <= '0' when mode_polynomial_syndrome = '1' else
									reg_write_enable_q(0) and last_evaluations;

last_load_x_values <= '1' when ctr_load_x_address_q = std_logic_vector(to_unsigned(((number_of_support_elements - 1)/number_of_pipelines)*number_of_pipelines, ctr_load_x_address_q'Length)) else '0';
last_store_x_values <= '1' when ctr_store_x_address_q = std_logic_vector(to_unsigned(((number_of_support_elements - 1)/number_of_pipelines)*number_of_pipelines, ctr_load_x_address_q'Length)) else '0';

end RTL;