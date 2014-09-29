----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Syndrome_Calculator_N_Pipe_v3
-- Module Name:    Syndrome_Calculator_N_Pipe_v3
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 1st step in Goppa Code Decoding. 
-- 
-- This circuit computes the syndrome from the ciphertext, support elements and
-- inverted evaluation of support elements into polynomial g, aka g(L)^(-1).
-- This circuit works by computing the syndrome of only the positions where the ciphertext
-- has value 1.
--
-- This is circuit version with a variable number of computation units, pipeline and 
-- a variable number of pipelines. This circuit is the master and the variable is done through
-- the slaves circuits.
--
-- The circuits parameters
--
--	number_of_syndrome_calculators :
--
-- The number of pipelines that compute parts of syndrome from 
-- different parts of the ciphertext. This number must be 1 or greater. 
--
--	syndrome_calculator_size :
--
-- The number of units that compute each syndrome at the same time
-- from the same ciphertext. This number must be 1 or greater. 
--
--	gf_2_m : 
--
-- The size of the field used in this circuit. This parameter depends of the 
-- Goppa code used.
--
--	length_codeword :
--
-- The length of the codeword or in this case the ciphertext. Both the codeword
-- and ciphertext has the same size.
--
--	size_codeword :
--
-- The number of bits necessary to hold the ciphertext/codeword.
-- This is ceil(log2(length_codeword)).
--
--	length_syndrome :
--
-- The size of the syndrome array. This parameter depends of the 
-- Goppa code used.
--
--	size_syndrome :
--
-- The number of bits necessary to hold the array syndrome.
-- This is ceil(log2(length_syndrome)).
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- syndrome_calculator_n_pipe_v3_slave Rev 1.0 
-- controller_syndrome_calculator_2_pipe_v3_master Rev 1.0
-- register_nbits Rev 1.0
-- register_rst_nbits Rev 1.0
-- counter_rst_nbits Rev 1.0
-- counter_decrement_rst_nbits Rev 1.0
-- shift_register_rst_nbits Rev 1.0
-- mult_gf_2_m Rev 1.0
-- adder_gf_2_m Rev 1.0
-- and_reduce Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity syndrome_calculator_n_pipe_v3 is
	Generic(
	
		-- GOPPA [2048, 1751, 27, 11] --

--		number_of_syndrome_calculators : integer := 1;
--		syndrome_calculator_size : integer := 32;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		length_syndrome : integer := 54;
--		size_syndrome : integer := 6

		-- GOPPA [2048, 1498, 50, 11] --

--		number_of_syndrome_calculators : integer := 1;
--		syndrome_calculator_size : integer := 32;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		length_syndrome : integer := 100;
--		size_syndrome : integer := 7

		-- GOPPA [3307, 2515, 66, 12] --

--		number_of_syndrome_calculators : integer := 1;
--		syndrome_calculator_size : integer := 32;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3307;
--		size_codeword : integer := 12;
--		length_syndrome : integer := 132;
--		size_syndrome : integer := 8

		-- QD-GOPPA [2528, 2144, 32, 12] --

--		number_of_syndrome_calculators : integer := 1;
--		syndrome_calculator_size : integer := 32;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2528;
--		size_codeword : integer := 12;
--		length_syndrome : integer := 64;
--		size_syndrome : integer := 6

		-- QD-GOPPA [2816, 2048, 64, 12] --

--		number_of_syndrome_calculators : integer := 1;
--		syndrome_calculator_size : integer := 32;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		length_syndrome : integer := 128;
--		size_syndrome : integer := 7

		-- QD-GOPPA [3328, 2560, 64, 12] --

--		number_of_syndrome_calculators : integer := 1;
--		syndrome_calculator_size : integer := 32;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3200;
--		size_codeword : integer := 12;
--		length_syndrome : integer := 256;
--		size_syndrome : integer := 8

		-- QD-GOPPA [7296, 5632, 128, 13] --
		
		number_of_syndrome_calculators : integer := 1;
		syndrome_calculator_size : integer := 32;
		gf_2_m : integer range 1 to 20 := 15;
		length_codeword : integer := 8320;
		size_codeword : integer := 14;
		length_syndrome : integer := 256;
		size_syndrome : integer := 8

	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		value_h : in STD_LOGIC_VECTOR(((number_of_syndrome_calculators)*(gf_2_m) - 1) downto 0);
		value_L : in STD_LOGIC_VECTOR(((number_of_syndrome_calculators)*(gf_2_m) - 1) downto 0);
		value_syndrome : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_codeword : in STD_LOGIC_VECTOR((number_of_syndrome_calculators - 1) downto 0);
		syndrome_finalized : out STD_LOGIC;
		write_enable_new_syndrome : out STD_LOGIC;
		new_value_syndrome : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		address_h : out STD_LOGIC_VECTOR(((number_of_syndrome_calculators)*(size_codeword) - 1) downto 0);
		address_L : out STD_LOGIC_VECTOR(((number_of_syndrome_calculators)*(size_codeword) - 1) downto 0);
		address_codeword : out STD_LOGIC_VECTOR(((number_of_syndrome_calculators)*(size_codeword) - 1) downto 0);
		address_syndrome : out STD_LOGIC_VECTOR((size_syndrome - 1) downto 0);
		address_new_syndrome : out STD_LOGIC_VECTOR((size_syndrome - 1) downto 0)
	);
end syndrome_calculator_n_pipe_v3;

architecture Behavioral of syndrome_calculator_n_pipe_v3 is

component syndrome_calculator_n_pipe_v3_slave
	Generic(
		initial_address : integer;
		increment_address : integer;
 		syndrome_calculator_size : integer;
		gf_2_m : integer range 1 to 20;
		length_codeword : integer;
		size_codeword : integer;
		length_syndrome : integer;
		size_syndrome : integer
	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		value_h : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_L : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_codeword : in STD_LOGIC_VECTOR(0 downto 0);
		start_calculation : in STD_LOGIC;
		last_syndrome : in STD_LOGIC;
		ready_calculation : out STD_LOGIC;
		finished_calculation : out STD_LOGIC;
		new_value_syndrome : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		address_h : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
		address_L : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
		address_codeword : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0)
	);
end component;

component controller_syndrome_calculator_2_pipe_v3_master
	Port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		almost_units_ready : in STD_LOGIC;
		empty_units : in STD_LOGIC;
		limit_ctr_codeword_q : in STD_LOGIC;
		limit_ctr_syndrome_q : in STD_LOGIC;
		reg_first_syndrome_q : in STD_LOGIC_VECTOR(0 downto 0);
		reg_codeword_q : in STD_LOGIC_VECTOR(0 downto 0);
		start_calculation : in STD_LOGIC;
		slaves_finished : in STD_LOGIC;
		ready_calculation : out STD_LOGIC;
		finished_calculation : out STD_LOGIC;
		write_enable_new_syndrome : out STD_LOGIC;
		control_units_ce : out STD_LOGIC;
		control_units_rst : out STD_LOGIC;
		int_reg_L_ce : out STD_LOGIC;
		square_h : out STD_LOGIC;
		int_reg_h_ce : out STD_LOGIC;
		int_reg_h_rst : out STD_LOGIC;
		int_sel_reg_h : out STD_LOGIC;
		reg_load_L_ce : out STD_LOGIC;
		reg_load_h_ce : out STD_LOGIC;
		reg_load_h_rst : out STD_LOGIC;
		reg_load_syndrome_ce : out STD_LOGIC;
		reg_load_syndrome_rst : out STD_LOGIC;
		reg_new_value_syndrome_ce : out STD_LOGIC;
		reg_new_value_master_syndrome_ce : out STD_LOGIC;
		reg_codeword_ce : out STD_LOGIC;
		reg_first_syndrome_ce : out STD_LOGIC;
		reg_first_syndrome_rst : out STD_LOGIC;
		ctr_load_address_syndrome_ce : out STD_LOGIC;
		ctr_load_address_syndrome_rst : out STD_LOGIC;
		ctr_store_address_syndrome_ce : out STD_LOGIC;
		ctr_store_address_syndrome_rst : out STD_LOGIC;
		ctr_load_address_codeword_ce : out STD_LOGIC;
		ctr_load_address_codeword_rst : out STD_LOGIC;
		reg_load_limit_codeword_rst : out STD_LOGIC;
		reg_load_limit_codeword_ce : out STD_LOGIC;
		reg_calc_limit_codeword_rst : out STD_LOGIC;
		reg_calc_limit_codeword_ce : out STD_LOGIC
	);
end component;

component register_nbits
	Generic (size : integer);
	Port (
		d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component register_rst_nbits
	Generic (size : integer);
	Port (
		d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
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
		q : out  STD_LOGIC_VECTOR((size - 1) downto 0)
	);
end component;

component shift_register_rst_nbits
	Generic (size : integer);
	Port (
		data_in : in STD_LOGIC;
		clk : in STD_LOGIC;
		ce : in STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR((size - 1) downto 0);
		q : out STD_LOGIC_VECTOR((size - 1) downto 0);
		data_out : out STD_LOGIC
	);
end component;

component mult_gf_2_m
	Generic (gf_2_m : integer range 1 to 20 := 11);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		b: in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);

end component;

component adder_gf_2_m
	Generic(
		gf_2_m : integer := 1;
		number_of_elements : integer range 2 to integer'high := 2
	);
	Port(
		a : in STD_LOGIC_VECTOR(((gf_2_m)*(number_of_elements) - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end component;

component and_reduce
	Generic(
		vector_size : integer := 1;
		number_of_vectors : integer range 2 to integer'high := 2
	);
	Port(
		a : in STD_LOGIC_VECTOR(((vector_size)*(number_of_vectors) - 1) downto 0);
		o : out STD_LOGIC_VECTOR((vector_size - 1) downto 0)
	);
end component;

signal reg_L_d : STD_LOGIC_VECTOR(((syndrome_calculator_size)*gf_2_m - 1) downto 0);
signal reg_L_ce : STD_LOGIC_VECTOR((syndrome_calculator_size - 1) downto 0);
signal reg_L_q : STD_LOGIC_VECTOR(((syndrome_calculator_size)*gf_2_m - 1) downto 0);

signal reg_h_d :STD_LOGIC_VECTOR(((syndrome_calculator_size)*gf_2_m - 1) downto 0);
signal reg_h_ce : STD_LOGIC_VECTOR((syndrome_calculator_size - 1) downto 0);
signal reg_h_rst : STD_LOGIC_VECTOR((syndrome_calculator_size - 1) downto 0);
constant reg_h_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');
signal reg_h_q : STD_LOGIC_VECTOR(((syndrome_calculator_size)*gf_2_m - 1) downto 0);

signal sel_reg_h : STD_LOGIC_VECTOR((syndrome_calculator_size - 1) downto 0);
signal square_h : STD_LOGIC;

signal reg_load_L_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_load_L_ce : STD_LOGIC;
signal reg_load_L_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_load_h_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_load_h_ce : STD_LOGIC;
signal reg_load_h_rst : STD_LOGIC;
constant reg_load_h_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(0, gf_2_m));
signal reg_load_h_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_load_syndrome_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_load_syndrome_ce : STD_LOGIC;
signal reg_load_syndrome_rst : STD_LOGIC;
constant reg_load_syndrome_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(0, gf_2_m));
signal reg_load_syndrome_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_new_value_master_syndrome_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_master_syndrome_ce : STD_LOGIC;
signal reg_new_value_master_syndrome_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal new_value_intermediate_syndrome : STD_LOGIC_VECTOR(((number_of_syndrome_calculators)*gf_2_m - 1) downto 0);

signal reg_new_value_syndrome_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_syndrome_ce : STD_LOGIC;
signal reg_new_value_syndrome_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_codeword_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_codeword_ce : STD_LOGIC;
signal reg_codeword_q : STD_LOGIC_VECTOR(0 downto 0);
	
signal reg_first_syndrome_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_first_syndrome_ce : STD_LOGIC;
signal reg_first_syndrome_rst : STD_LOGIC;
constant reg_first_syndrome_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "1";
signal reg_first_syndrome_q : STD_LOGIC_VECTOR(0 downto 0);

signal mult_a : STD_LOGIC_VECTOR(((syndrome_calculator_size)*gf_2_m - 1) downto 0);
signal mult_b : STD_LOGIC_VECTOR(((syndrome_calculator_size)*gf_2_m - 1) downto 0);
signal mult_o : STD_LOGIC_VECTOR(((syndrome_calculator_size)*gf_2_m - 1) downto 0);

signal adder_a : STD_LOGIC_VECTOR(((syndrome_calculator_size+1)*gf_2_m - 1) downto 0);
signal adder_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal final_adder_a : STD_LOGIC_VECTOR(((number_of_syndrome_calculators)*gf_2_m - 1) downto 0);
signal final_adder_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal ctr_load_address_syndrome_ce : STD_LOGIC;
signal ctr_load_address_syndrome_rst : STD_LOGIC;
constant ctr_load_address_syndrome_rst_value : STD_LOGIC_VECTOR((size_syndrome - 1) downto 0) := std_logic_vector(to_unsigned(length_syndrome - 1, size_syndrome));
signal ctr_load_address_syndrome_q : STD_LOGIC_VECTOR((size_syndrome - 1) downto 0);

signal ctr_store_address_syndrome_ce : STD_LOGIC;
signal ctr_store_address_syndrome_rst : STD_LOGIC;
constant ctr_store_address_syndrome_rst_value : STD_LOGIC_VECTOR((size_syndrome - 1) downto 0) := std_logic_vector(to_unsigned(length_syndrome - 1, size_syndrome));
signal ctr_store_address_syndrome_q : STD_LOGIC_VECTOR((size_syndrome - 1) downto 0);

signal ctr_load_address_codeword_ce : STD_LOGIC;
signal ctr_load_address_codeword_rst : STD_LOGIC;
constant ctr_load_address_codeword_rst_value : STD_LOGIC_VECTOR((size_codeword - 1) downto 0) := std_logic_vector(to_unsigned(0, size_codeword));
signal ctr_load_address_codeword_q : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);

signal reg_load_limit_codeword_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_load_limit_codeword_ce : STD_LOGIC;
signal reg_load_limit_codeword_rst : STD_LOGIC;
constant reg_load_limit_codeword_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_load_limit_codeword_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_calc_limit_codeword_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_calc_limit_codeword_ce : STD_LOGIC;
signal reg_calc_limit_codeword_rst : STD_LOGIC;
constant reg_calc_limit_codeword_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_calc_limit_codeword_q : STD_LOGIC_VECTOR(0 downto 0);

signal control_units_ce : STD_LOGIC;
signal control_units_rst : STD_LOGIC;
constant control_units_rst_value0 : STD_LOGIC_VECTOR((syndrome_calculator_size - 1) downto 0) := (others => '0');
constant control_units_rst_value1 : STD_LOGIC_VECTOR((syndrome_calculator_size) downto (syndrome_calculator_size)) := "1";
constant control_units_rst_value : STD_LOGIC_VECTOR((syndrome_calculator_size) downto 0) := control_units_rst_value1 & control_units_rst_value0;
signal control_units_q : STD_LOGIC_VECTOR((syndrome_calculator_size) downto 0);
signal control_units_data_out : STD_LOGIC;

signal int_reg_L_ce : STD_LOGIC;
signal int_reg_h_ce : STD_LOGIC;
signal int_reg_h_rst: STD_LOGIC;
signal int_sel_reg_h : STD_LOGIC;

signal almost_units_ready : STD_LOGIC;
signal empty_units : STD_LOGIC;
signal limit_ctr_codeword_q : STD_LOGIC;
signal limit_ctr_syndrome_q : STD_LOGIC;

signal start_calculation : STD_LOGIC;
signal last_syndrome : STD_LOGIC;
signal slaves_finished : STD_LOGIC;
signal ready_calculation : STD_LOGIC_VECTOR((number_of_syndrome_calculators - 1) downto 0);
signal finished_calculation : STD_LOGIC_VECTOR((number_of_syndrome_calculators - 1) downto 0);

begin

controller : controller_syndrome_calculator_2_pipe_v3_master
	Port Map(
		clk => clk,
		rst => rst,
		almost_units_ready => almost_units_ready,
		empty_units => empty_units,
		limit_ctr_codeword_q => reg_calc_limit_codeword_q(0),
		limit_ctr_syndrome_q => limit_ctr_syndrome_q,
		reg_first_syndrome_q => reg_first_syndrome_q,
		reg_codeword_q => reg_codeword_q,
		start_calculation => start_calculation,
		slaves_finished => slaves_finished,
		ready_calculation => ready_calculation(0),
		finished_calculation => finished_calculation(0),
		write_enable_new_syndrome => write_enable_new_syndrome,
		control_units_ce => control_units_ce,
		control_units_rst => control_units_rst,
		int_reg_L_ce => int_reg_L_ce,
		square_h => square_h,
		int_reg_h_ce => int_reg_h_ce,
		int_reg_h_rst => int_reg_h_rst,
		int_sel_reg_h => int_sel_reg_h,
		reg_load_L_ce => reg_load_L_ce,
		reg_load_h_ce => reg_load_h_ce,
		reg_load_h_rst => reg_load_h_rst,
		reg_load_syndrome_ce => reg_load_syndrome_ce,
		reg_load_syndrome_rst => reg_load_syndrome_rst,
		reg_new_value_master_syndrome_ce => reg_new_value_master_syndrome_ce,
		reg_new_value_syndrome_ce => reg_new_value_syndrome_ce,
		reg_codeword_ce => reg_codeword_ce,
		reg_first_syndrome_ce => reg_first_syndrome_ce,
		reg_first_syndrome_rst => reg_first_syndrome_rst,
		ctr_load_address_syndrome_ce => ctr_load_address_syndrome_ce,
		ctr_load_address_syndrome_rst => ctr_load_address_syndrome_rst,
		ctr_store_address_syndrome_ce => ctr_store_address_syndrome_ce,
		ctr_store_address_syndrome_rst => ctr_store_address_syndrome_rst,
		ctr_load_address_codeword_ce => ctr_load_address_codeword_ce,
		ctr_load_address_codeword_rst => ctr_load_address_codeword_rst,
		reg_load_limit_codeword_ce => reg_load_limit_codeword_ce,
		reg_load_limit_codeword_rst => reg_load_limit_codeword_rst,
		reg_calc_limit_codeword_ce => reg_calc_limit_codeword_ce,
		reg_calc_limit_codeword_rst => reg_calc_limit_codeword_rst
	);

calculator_units : for I in 0 to (syndrome_calculator_size - 1) generate

reg_L_I : register_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_L_d(((I + 1)*gf_2_m - 1) downto I*gf_2_m),
		clk => clk,
		ce => reg_L_ce(I),
		q => reg_L_q(((I + 1)*gf_2_m - 1) downto I*gf_2_m)
	);

reg_h_I : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_h_d(((I + 1)*gf_2_m - 1) downto I*gf_2_m),
		clk => clk,
		ce => reg_h_ce(I),
		rst => reg_h_rst(I),
		rst_value => reg_h_rst_value,
		q => reg_h_q(((I + 1)*gf_2_m - 1) downto I*gf_2_m)
	);
	
mult_I : mult_gf_2_m
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => mult_a(((I + 1)*gf_2_m - 1) downto I*gf_2_m),
		b => mult_b(((I + 1)*gf_2_m - 1) downto I*gf_2_m),
		o => mult_o(((I + 1)*gf_2_m - 1) downto I*gf_2_m)
	);
	
reg_L_d(((I + 1)*gf_2_m - 1) downto I*gf_2_m) <= reg_load_L_q;

reg_h_d(((I + 1)*gf_2_m - 1) downto I*gf_2_m) <= mult_o(((I + 1)*gf_2_m - 1) downto I*gf_2_m) when sel_reg_h(I) = '1' else
			reg_load_h_q;
			
mult_a(((I + 1)*gf_2_m - 1) downto I*gf_2_m) <= reg_h_q(((I + 1)*gf_2_m - 1) downto I*gf_2_m) when square_h = '1' else 
			reg_L_q(((I + 1)*gf_2_m - 1) downto I*gf_2_m);
mult_b(((I + 1)*gf_2_m - 1) downto I*gf_2_m) <= reg_h_q(((I + 1)*gf_2_m - 1) downto I*gf_2_m);

reg_L_ce(I) <= int_reg_L_ce and control_units_q(I);
reg_h_ce(I) <= int_reg_h_ce and (control_units_q(I) or int_sel_reg_h);
reg_h_rst(I) <= int_reg_h_rst and control_units_q(I);
sel_reg_h(I) <= int_sel_reg_h;
	
end generate;

more_than_1 : if(number_of_syndrome_calculators > 1) generate
slave_units : for I in 1 to (number_of_syndrome_calculators - 1) generate

slave_I : syndrome_calculator_n_pipe_v3_slave
	Generic Map(
		initial_address => I,
		increment_address => number_of_syndrome_calculators,
 		syndrome_calculator_size => syndrome_calculator_size,
		gf_2_m => gf_2_m,
		length_codeword => length_codeword,
		size_codeword => size_codeword,
		length_syndrome => length_syndrome,
		size_syndrome => size_syndrome
	)
	Port Map(
		clk => clk,
		rst => rst,
		value_h => value_h(((I+1)*(gf_2_m) - 1) downto (I)*(gf_2_m)),
		value_L => value_L(((I+1)*(gf_2_m) - 1) downto (I)*(gf_2_m)),
		value_codeword => value_codeword(I downto I),
		start_calculation => start_calculation,
		last_syndrome => last_syndrome,
		ready_calculation => ready_calculation(I),
		finished_calculation => finished_calculation(I),
		new_value_syndrome => new_value_intermediate_syndrome(((I+1)*(gf_2_m) - 1) downto (I)*(gf_2_m)),
		address_h => address_h(((I+1)*(size_codeword) - 1) downto (I)*(size_codeword)),
		address_L => address_L(((I+1)*(size_codeword) - 1) downto (I)*(size_codeword)),
		address_codeword => address_codeword(((I+1)*(size_codeword) - 1) downto (I)*(size_codeword))
	);
	
end generate;

everyone_ready : and_reduce
	Generic Map(
		vector_size => 1,
		number_of_vectors => number_of_syndrome_calculators
	)
	Port Map(
		a => ready_calculation,
		o(0) => start_calculation
	);

final_adder : adder_gf_2_m
	Generic Map(
		gf_2_m => gf_2_m,
		number_of_elements => number_of_syndrome_calculators
	)
	Port Map(
		a => final_adder_a,
		o => final_adder_o
	);
	
final_adder_a <= new_value_intermediate_syndrome;

reg_new_value_syndrome_d <= final_adder_o;

syndrome_finalized <= slaves_finished and finished_calculation(0);

one_slave : if(number_of_syndrome_calculators = 2) generate

slaves_finished <= finished_calculation(1);

end generate;

more_than_one_slave : if(number_of_syndrome_calculators > 2) generate

all_slaves_finished : and_reduce
	Generic Map(
		vector_size => 1,
		number_of_vectors => number_of_syndrome_calculators - 1
	)
	Port Map(
		a => finished_calculation((number_of_syndrome_calculators - 1) downto 1),
		o(0) => slaves_finished
	);

end generate;

end generate;

just_master : if(number_of_syndrome_calculators = 1) generate

slaves_finished <= '1';

reg_new_value_syndrome_d <= new_value_intermediate_syndrome((gf_2_m - 1) downto 0);

start_calculation <= ready_calculation(0);

syndrome_finalized <= finished_calculation(0);

end generate;

control_units : shift_register_rst_nbits
	Generic Map(
		size => syndrome_calculator_size+1
	)
	Port Map(
		data_in => control_units_data_out,
		clk => clk,
		ce => control_units_ce,
		rst => control_units_rst,
		rst_value => control_units_rst_value,
		q => control_units_q,
		data_out => control_units_data_out
	);

adder : adder_gf_2_m
	Generic Map(
		gf_2_m => gf_2_m,
		number_of_elements => syndrome_calculator_size+1
	)
	Port Map(
		a => adder_a,
		o => adder_o
	);

reg_load_L : register_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_load_L_d,
		clk => clk,
		ce => reg_load_L_ce,
		q => reg_load_L_q
	);
	
reg_load_h : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_load_h_d,
		clk => clk,
		ce => reg_load_h_ce,
		rst => reg_load_h_rst,
		rst_value => reg_load_h_rst_value,
		q => reg_load_h_q
	);
	
reg_load_syndrome : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_load_syndrome_d,
		clk => clk,
		ce => reg_load_syndrome_ce,
		rst => reg_load_syndrome_rst,
		rst_value => reg_load_syndrome_rst_value,
		q => reg_load_syndrome_q
	);
	
reg_new_value_master_syndrome : register_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_master_syndrome_d,
		clk => clk,
		ce => reg_new_value_master_syndrome_ce,
		q => reg_new_value_master_syndrome_q
	);
	
reg_new_value_syndrome : register_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_syndrome_d,
		clk => clk,
		ce => reg_new_value_syndrome_ce,
		q => reg_new_value_syndrome_q
	);

reg_codeword : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_codeword_d,
		clk => clk,
		ce => reg_codeword_ce,
		q => reg_codeword_q
	);
	
reg_first_syndrome : register_rst_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_first_syndrome_d,
		clk => clk,
		ce => reg_first_syndrome_ce,
		rst => reg_first_syndrome_rst,
		rst_value => reg_first_syndrome_rst_value,
		q => reg_first_syndrome_q
	);

ctr_load_address_syndrome : counter_decrement_rst_nbits
	Generic Map(
		size => size_syndrome,
		decrement_value => 1
	)
	Port Map(
		clk => clk,
		ce => ctr_load_address_syndrome_ce,
		rst => ctr_load_address_syndrome_rst,
		rst_value => ctr_load_address_syndrome_rst_value,
		q => ctr_load_address_syndrome_q
	);
	
ctr_store_address_syndrome : counter_decrement_rst_nbits
	Generic Map(
		size => size_syndrome,
		decrement_value => 1
	)
	Port Map(
		clk => clk,
		ce => ctr_store_address_syndrome_ce,
		rst => ctr_store_address_syndrome_rst,
		rst_value => ctr_store_address_syndrome_rst_value,
		q => ctr_store_address_syndrome_q
	);

ctr_load_address_codeword : counter_rst_nbits
	Generic Map(
		size => size_codeword,
		increment_value => number_of_syndrome_calculators
	)
	Port Map(
		clk => clk,
		ce => ctr_load_address_codeword_ce,
		rst => ctr_load_address_codeword_rst,
		rst_value => ctr_load_address_codeword_rst_value,
		q => ctr_load_address_codeword_q
	);
	
reg_load_limit_codeword : register_rst_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_load_limit_codeword_d,
		clk => clk,
		ce => reg_load_limit_codeword_ce,
		rst => reg_load_limit_codeword_rst,
		rst_value => reg_load_limit_codeword_rst_value,
		q => reg_load_limit_codeword_q
	);
	
reg_calc_limit_codeword : register_rst_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_calc_limit_codeword_d,
		clk => clk,
		ce => reg_calc_limit_codeword_ce,
		rst => reg_calc_limit_codeword_rst,
		rst_value => reg_calc_limit_codeword_rst_value,
		q => reg_calc_limit_codeword_q
	);
	
reg_load_limit_codeword_d(0) <= limit_ctr_codeword_q;
reg_calc_limit_codeword_d <= reg_load_limit_codeword_q;

adder_a <= reg_h_q & reg_load_syndrome_q;
	
reg_load_L_d <= value_L((gf_2_m - 1) downto 0);	

reg_load_h_d <= value_h((gf_2_m - 1) downto 0);

reg_load_syndrome_d <= value_syndrome;

reg_codeword_d <= value_codeword(0 downto 0);	

reg_first_syndrome_d <= "0";

reg_new_value_master_syndrome_d <= adder_o;

new_value_intermediate_syndrome((gf_2_m - 1) downto 0) <= reg_new_value_master_syndrome_q;

new_value_syndrome <= reg_new_value_syndrome_q;

address_h((size_codeword - 1) downto 0) <= ctr_load_address_codeword_q;
address_L((size_codeword - 1) downto 0) <= ctr_load_address_codeword_q;
address_codeword((size_codeword - 1) downto 0) <= ctr_load_address_codeword_q;
address_syndrome <= ctr_load_address_syndrome_q;
address_new_syndrome <= ctr_store_address_syndrome_q;

almost_units_ready <= control_units_q(syndrome_calculator_size - 1);
empty_units <= control_units_q(0);
limit_ctr_codeword_q <= '1' when (unsigned(ctr_load_address_codeword_q) >= (to_unsigned(length_codeword - number_of_syndrome_calculators, ctr_load_address_codeword_q'length))) else '0';
limit_ctr_syndrome_q <= '1' when (ctr_store_address_syndrome_q = std_logic_vector(to_unsigned(0, ctr_load_address_syndrome_q'length))) else '0';
last_syndrome <= limit_ctr_syndrome_q;

end Behavioral;