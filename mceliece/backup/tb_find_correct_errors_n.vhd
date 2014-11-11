----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Tb_Find_Correct_Errors_N
-- Module Name:    Tb_Find_Correct_Errors_N
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Test bench for find_correct_errors_n and polynomial_evaluator_n circuits.
-- 
-- The circuits parameters
--
-- PERIOD : 
--
-- Input clock period to be applied on the test. 
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
-- size_pipeline_size : 
--
-- The number of bits necessary to store the size of the pipeline.
-- This is ceil(log2(pipeline_size))
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
--	x_memory_file : 
--
-- File that holds the values to be evaluated on the polynomial. Support elements L.
--
--	sigma_memory_file : 
--
-- File that holds polynomial sigma coefficients.
--
--	resp_memory_file : 
--
-- File that holds all evaluations of support L on polynomial sigma.
-- This file holds the output of the circuit,
-- it is needed to detect if polynomial evaluator circuit worked properly.
--
--	dump_acc_memory_file : 
--
-- File that will hold the output of all support L evaluations on polynomial sigma,
-- that were done by the circuit.
--
--	codeword_memory_file : 
--
-- File that holds the ciphertext that will be corrected according to the polynomial
-- sigma roots that were found.
--
--	message_memory_file : 
--
-- File that holds the ciphertext already corrected.
-- This file is necessary to detect
-- if the ciphertext correction was performed correctly by the circuit.
--
--	dump_codeword_memory_file : 
--
-- File that will hold the ciphertext corrected by the circuit.
--
--	dump_error_memory_file : 
--
-- File that will hold the errors found on the ciphertext by the circuit.
--
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- find_and_correct_errors_n Rev 1.0
-- polynomial_evaluator_n Rev 1.0
-- ram Rev 1.0
-- ram_bank Rev 1.0
-- ram_double_bank Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_find_correct_errors_n is
Generic(
		PERIOD : time := 10 ns;
		
		-- QD-GOPPA [52, 28, 4, 6] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 6;
--		sigma_degree : integer := 4; 
--		size_sigma_degree : integer := 2;
--		length_support_elements: integer := 52;
--		size_support_elements : integer := 6;
--		x_memory_file : string := "mceliece/data_tests/L_qdgoppa_52_28_4_6.dat";
--		sigma_memory_file : string := "mceliece/data_tests/sigma_qdgoppa_52_28_4_6.dat";
--		resp_memory_file : string := "mceliece/data_tests/sigma(L)_qdgoppa_52_28_4_6.dat";
--		dump_acc_memory_file : string := "mceliece/data_tests/dump_sigma(L)_qdgoppa_52_28_4_6.dat";
--		codeword_memory_file : string := "mceliece/data_tests/ciphertext_qdgoppa_52_28_4_6.dat";
--		message_memory_file : string := "mceliece/data_tests/plaintext_qdgoppa_52_28_4_6.dat";
--		dump_codeword_memory_file : string := "mceliece/data_tests/dump_ciphertext_qdgoppa_52_28_4_6.dat";
--		dump_error_memory_file : string := "mceliece/data_tests/dump_error_qdgoppa_52_28_4_6.dat"
		
		-- GOPPA [2048, 1751, 27, 11] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 11;
--		sigma_degree : integer := 27; 
--		size_sigma_degree : integer := 5;
--		length_support_elements: integer := 2048;
--		size_support_elements : integer := 11;
--		x_memory_file : string := "mceliece/data_tests/L_goppa_2048_1751_27_11.dat";
--		sigma_memory_file : string := "mceliece/data_tests/sigma_goppa_2048_1751_27_11.dat";
--		resp_memory_file : string := "mceliece/data_tests/sigma(L)_goppa_2048_1751_27_11.dat";
--		dump_acc_memory_file : string := "mceliece/data_tests/dump_sigma(L)_goppa_2048_1751_27_11.dat";
--		codeword_memory_file : string := "mceliece/data_tests/ciphertext_goppa_2048_1751_27_11.dat";
--		message_memory_file : string := "mceliece/data_tests/plaintext_goppa_2048_1751_27_11.dat";
--		dump_codeword_memory_file : string := "mceliece/data_tests/dump_ciphertext_goppa_2048_1751_27_11.dat";
--		dump_error_memory_file : string := "mceliece/data_tests/dump_error_goppa_2048_1751_27_11.dat"
		
		-- GOPPA [2048, 1498, 50, 11] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 11;
--		sigma_degree : integer := 50; 
--		size_sigma_degree : integer := 6;
--		length_support_elements: integer := 2048;
--		size_support_elements : integer := 11;
--		x_memory_file : string := "mceliece/data_tests/L_goppa_2048_1498_50_11.dat";
--		sigma_memory_file : string := "mceliece/data_tests/sigma_goppa_2048_1498_50_11.dat";
--		resp_memory_file : string := "mceliece/data_tests/sigma(L)_goppa_2048_1498_50_11.dat";
--		dump_acc_memory_file : string := "mceliece/data_tests/dump_sigma(L)_goppa_2048_1498_50_11.dat";
--		codeword_memory_file : string := "mceliece/data_tests/ciphertext_goppa_2048_1498_50_11.dat";
--		message_memory_file : string := "mceliece/data_tests/plaintext_goppa_2048_1498_50_11.dat";
--		dump_codeword_memory_file : string := "mceliece/data_tests/dump_ciphertext_goppa_2048_1498_50_11.dat";
--		dump_error_memory_file : string := "mceliece/data_tests/dump_error_goppa_2048_1498_50_11.dat"

		-- GOPPA [3307, 2515, 66, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 12;
--		sigma_degree : integer := 66; 
--		size_sigma_degree : integer := 7;
--		length_support_elements: integer := 3307;
--		size_support_elements : integer := 12;
--		x_memory_file : string := "mceliece/data_tests/L_goppa_3307_2515_66_12.dat";
--		sigma_memory_file : string := "mceliece/data_tests/sigma_goppa_3307_2515_66_12.dat";
--		resp_memory_file : string := "mceliece/data_tests/sigma(L)_goppa_3307_2515_66_12.dat";
--		dump_acc_memory_file : string := "mceliece/data_tests/dump_sigma(L)_goppa_3307_2515_66_12.dat";
--		codeword_memory_file : string := "mceliece/data_tests/ciphertext_goppa_3307_2515_66_12.dat";
--		message_memory_file : string := "mceliece/data_tests/plaintext_goppa_3307_2515_66_12.dat";
--		dump_codeword_memory_file : string := "mceliece/data_tests/dump_ciphertext_goppa_3307_2515_66_12.dat";
--		dump_error_memory_file : string := "mceliece/data_tests/dump_error_goppa_3307_2515_66_12.dat"		
		
		-- QD-GOPPA [2528, 2144, 32, 12] --
		
		number_of_pipelines : integer := 1;
		pipeline_size : integer := 33;
		size_pipeline_size : integer := 5;
		gf_2_m : integer range 1 to 20 := 12;
		sigma_degree : integer := 32; 
		size_sigma_degree : integer := 6;
		length_support_elements: integer := 2528;
		size_support_elements : integer := 12;
		x_memory_file : string := "mceliece/data_tests/L_qdgoppa_2528_2144_32_12.dat";
		sigma_memory_file : string := "mceliece/data_tests/sigma_qdgoppa_2528_2144_32_12.dat";
		resp_memory_file : string := "mceliece/data_tests/sigma(L)_qdgoppa_2528_2144_32_12.dat";
		dump_acc_memory_file : string := "mceliece/data_tests/dump_sigma(L)_qdgoppa_2528_2144_32_12.dat";
		codeword_memory_file : string := "mceliece/data_tests/ciphertext_qdgoppa_2528_2144_32_12.dat";
		message_memory_file : string := "mceliece/data_tests/plaintext_qdgoppa_2528_2144_32_12.dat";
		dump_codeword_memory_file : string := "mceliece/data_tests/dump_ciphertext_qdgoppa_2528_2144_32_12.dat";
		dump_error_memory_file : string := "mceliece/data_tests/dump_error_qdgoppa_2528_2144_32_12.dat"
		
		-- QD-GOPPA [2816, 2048, 64, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 12;
--		sigma_degree : integer := 64; 
--		size_sigma_degree : integer := 6;
--		length_support_elements: integer := 2816;
--		size_support_elements : integer := 12;
--		x_memory_file : string := "mceliece/data_tests/L_qdgoppa_2816_2048_64_12.dat";
--		sigma_memory_file : string := "mceliece/data_tests/sigma_qdgoppa_2816_2048_64_12.dat";
--		resp_memory_file : string := "mceliece/data_tests/sigma(L)_qdgoppa_2816_2048_64_12.dat";
--		dump_acc_memory_file : string := "mceliece/data_tests/dump_sigma(L)_qdgoppa_2816_2048_64_12.dat";
--		codeword_memory_file : string := "mceliece/data_tests/ciphertext_qdgoppa_2816_2048_64_12.dat";
--		message_memory_file : string := "mceliece/data_tests/plaintext_qdgoppa_2816_2048_64_12.dat";
--		dump_codeword_memory_file : string := "mceliece/data_tests/dump_ciphertext_qdgoppa_2816_2048_64_12.dat";
--		dump_error_memory_file : string := "mceliece/data_tests/dump_error_qdgoppa_2816_2048_64_12.dat"
		
		-- QD-GOPPA [3328, 2560, 64, 12] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 12;
--		sigma_degree : integer := 128; 
--		size_sigma_degree : integer := 7;
--		length_support_elements: integer := 3200;
--		size_support_elements : integer := 12;
--		x_memory_file : string := "mceliece/data_tests/L_qdgoppa_3328_2560_64_12.dat";
--		sigma_memory_file : string := "mceliece/data_tests/sigma_qdgoppa_3328_2560_64_12.dat";
--		resp_memory_file : string := "mceliece/data_tests/sigma(L)_qdgoppa_3328_2560_64_12.dat";
--		dump_acc_memory_file : string := "mceliece/data_tests/dump_sigma(L)_qdgoppa_3328_2560_64_12.dat";
--		codeword_memory_file : string := "mceliece/data_tests/ciphertext_qdgoppa_3328_2560_64_12.dat";
--		message_memory_file : string := "mceliece/data_tests/plaintext_qdgoppa_3328_2560_64_12.dat";
--		dump_codeword_memory_file : string := "mceliece/data_tests/dump_ciphertext_qdgoppa_3328_2560_64_12.dat";
--		dump_error_memory_file : string := "mceliece/data_tests/dump_error_qdgoppa_3328_2560_64_12.dat"
		
		-- QD-GOPPA [7296, 5632, 128, 13] --
		
--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 2;
--		size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 15;
--		sigma_degree : integer := 128; 
--		size_sigma_degree : integer := 7;
--		length_support_elements: integer := 8320;
--		size_support_elements : integer := 14;
--		x_memory_file : string := "mceliece/data_tests/L_qdgoppa_7296_5632_128_13.dat";
--		sigma_memory_file : string := "mceliece/data_tests/sigma_qdgoppa_7296_5632_128_13.dat";
--		resp_memory_file : string := "mceliece/data_tests/sigma(L)_qdgoppa_7296_5632_128_13.dat";
--		dump_acc_memory_file : string := "mceliece/data_tests/dump_sigma(L)_qdgoppa_7296_5632_128_13.dat";
--		codeword_memory_file : string := "mceliece/data_tests/ciphertext_qdgoppa_7296_5632_128_13.dat";
--		message_memory_file : string := "mceliece/data_tests/plaintext_qdgoppa_7296_5632_128_13.dat";
--		dump_codeword_memory_file : string := "mceliece/data_tests/dump_ciphertext_qdgoppa_7296_5632_128_13.dat";
--		dump_error_memory_file : string := "mceliece/data_tests/dump_error_qdgoppa_7296_5632_128_13.dat"
		
);
end tb_find_correct_errors_n;

architecture Behavioral of tb_find_correct_errors_n is

component ram
	Generic (
		ram_address_size : integer;
		ram_word_size : integer;
		file_ram_word_size : integer;
		load_file_name : string := "ram.dat";
		dump_file_name : string := "ram.dat"
	);
	Port (
		data_in : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		rw : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		dump : in STD_LOGIC; 
		address : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		rst_value : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
	);
end component;

component ram_bank
	Generic (
		number_of_memories : integer;
		ram_address_size : integer;
		ram_word_size : integer;
		file_ram_word_size : integer;
		load_file_name : string := "ram.dat";
		dump_file_name : string := "ram.dat"
	);
	Port (
		data_in : in STD_LOGIC_VECTOR (((ram_word_size)*(number_of_memories) - 1) downto 0);
		rw : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		dump : in STD_LOGIC; 
		address : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		rst_value : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out : out STD_LOGIC_VECTOR (((ram_word_size)*(number_of_memories) - 1) downto 0)
	);
end component;

component ram_double_bank
	Generic (
		number_of_memories : integer;
		ram_address_size : integer;
		ram_word_size : integer;
		file_ram_word_size : integer;
		load_file_name : string := "ram.dat";
		dump_file_name : string := "ram.dat"
	);
	Port (
		data_in_a : in STD_LOGIC_VECTOR (((ram_word_size)*(number_of_memories) - 1) downto 0);
		data_in_b : in STD_LOGIC_VECTOR (((ram_word_size)*(number_of_memories) - 1) downto 0);
		rw_a : in STD_LOGIC;
		rw_b : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		dump : in STD_LOGIC;
		address_a : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		address_b : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		rst_value : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out_a : out STD_LOGIC_VECTOR (((ram_word_size)*(number_of_memories) - 1) downto 0);
		data_out_b : out STD_LOGIC_VECTOR (((ram_word_size)*(number_of_memories) - 1) downto 0)
	);
end component;

component find_correct_errors_n
	Generic (	
		number_of_pipelines : integer := 1;
		gf_2_m : integer range 1 to 20 := 11;
		pipeline_size : integer := 28;
		length_support_elements: integer := 2048;
		size_support_elements : integer := 11
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
end component;

component polynomial_evaluator_n
	Generic (	
		number_of_values_x : integer := 2048;
		size_number_of_values_x : integer := 11;
		polynomial_degree : integer := 27;
		number_of_pipelines : integer := 1;
		gf_2_m : integer range 1 to 20 := 11;
		pipeline_size : integer := 28;
		size_polynomial_degree : integer := 5;
		size_pipeline_size : integer := 5
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
end component;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC;

signal value_message : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
signal value_evaluated : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal address_value_evaluated : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
signal enable_correction : STD_LOGIC;
signal correction_finalized : STD_LOGIC;
signal address_new_value_message : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
signal address_value_error : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
signal write_enable_new_value_message : STD_LOGIC;
signal write_enable_value_error : STD_LOGIC;
signal new_value_message : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
signal value_error : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);

signal value_x :  STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal value_acc : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal value_x_pow : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal value_polynomial : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal last_evaluations : STD_LOGIC;
signal evaluation_finalized : STD_LOGIC;
signal address_value_polynomial : STD_LOGIC_VECTOR((size_sigma_degree - 1) downto 0);
signal address_value_x : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
signal address_value_acc : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
signal address_value_x_pow : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
signal address_new_value_acc : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
signal address_new_value_x_pow : STD_LOGIC_VECTOR((size_support_elements - 1) downto 0);
signal write_enable_new_value_acc : STD_LOGIC;
signal write_enable_new_value_x_pow : STD_LOGIC;
signal new_value_acc : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal new_value_x_pow : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);

constant test_codeword_rst_value : std_logic_vector(0 downto 0) := (others => '0');
constant true_codeword_rst_value : std_logic_vector(0 downto 0) := (others => '0');
constant error_rst_value : std_logic_vector(0 downto 0) := (others => '0');
constant x_rst_value : std_logic_vector((gf_2_m - 1) downto 0) := (others => '0');
constant sigma_rst_value : std_logic_vector((gf_2_m - 1) downto 0) := (others => '0');
constant true_acc_rst_value : std_logic_vector((gf_2_m - 1) downto 0) := (others => '0');
constant test_acc_rst_value : std_logic_vector((gf_2_m - 1) downto 0) := (others => '0');
constant x_pow_rst_value : std_logic_vector((gf_2_m - 1) downto 0) := (others => '0');

signal test_codeword_dump : std_logic := '0';
signal true_codeword_dump : std_logic := '0';
signal x_dump : std_logic := '0';
signal sigma_dump : std_logic := '0';
signal true_acc_dump : std_logic := '0';
signal test_acc_dump : std_logic := '0';
signal x_pow_dump : std_logic := '0';
signal error_dump : std_logic := '0';

signal test_acc_address : STD_LOGIC_VECTOR ((size_support_elements - 1) downto 0);
signal true_acc_address : STD_LOGIC_VECTOR ((size_support_elements - 1) downto 0);
signal true_codeword_address : STD_LOGIC_VECTOR ((size_support_elements - 1) downto 0);
signal test_codeword_address : STD_LOGIC_VECTOR ((size_support_elements - 1) downto 0);
signal true_acc_value : STD_LOGIC_VECTOR (((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal true_codeword_value : STD_LOGIC_VECTOR ((number_of_pipelines - 1) downto 0);
signal error_acc : STD_LOGIC;
signal error_message : STD_LOGIC;

signal test_bench_finish : STD_LOGIC := '0';
signal cycle_count : integer range 0 to 2000000000 := 0;

for true_codeword : ram_bank use entity work.ram_bank(file_load); 
for test_codeword : ram_double_bank use entity work.ram_double_bank(file_load); 
for x : ram_bank use entity work.ram_bank(file_load); 
for sigma : ram use entity work.ram(file_load); 
for true_acc : ram_bank use entity work.ram_bank(file_load);
for test_acc : ram_double_bank use entity work.ram_double_bank(simple);
for x_pow : ram_double_bank use entity work.ram_double_bank(simple);
for error : ram_bank use entity work.ram_bank(simple);

begin

test_codeword : ram_double_bank
	Generic Map (
		number_of_memories => number_of_pipelines,
		ram_address_size => size_support_elements,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => codeword_memory_file,
		dump_file_name => dump_codeword_memory_file
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_message,
		rw_a => '0',
		rw_b => write_enable_new_value_message,
		clk => clk,
		rst => rst,
		dump => test_codeword_dump,
		address_a => test_codeword_address,
		address_b => address_new_value_message,
		rst_value => test_codeword_rst_value,
		data_out_a => value_message,
		data_out_b => open
	);
	
error : ram_bank
	Generic Map (
		number_of_memories => number_of_pipelines,
		ram_address_size => size_support_elements,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => "",
		dump_file_name => dump_error_memory_file
	)
	Port Map(
		data_in => value_error,
		rw => write_enable_value_error,
		clk => clk,
		rst => rst,
		dump => error_dump,
		address => address_value_error,
		rst_value => error_rst_value,
		data_out => open
	);
	
true_codeword : ram_bank
	Generic Map (
		number_of_memories => number_of_pipelines,
		ram_address_size => size_support_elements,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => message_memory_file,
		dump_file_name => ""
	)
	Port Map (
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => true_codeword_dump,
		address => true_codeword_address,
		rst_value => true_codeword_rst_value,
		data_out => true_codeword_value
	);

x : ram_bank
	Generic Map (
		number_of_memories => number_of_pipelines,
		ram_address_size => size_support_elements,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => x_memory_file,
		dump_file_name => ""
	)
	Port Map (
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => x_dump,
		address => address_value_x,
		rst_value => x_rst_value,
		data_out => value_x
	);
	
true_acc : ram_bank
	Generic Map (
		number_of_memories => number_of_pipelines,
		ram_address_size => size_support_elements,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => resp_memory_file,
		dump_file_name => ""
	)
	Port Map (
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => true_acc_dump,
		address => true_acc_address,
		rst_value => true_acc_rst_value,
		data_out => true_acc_value
	);

test_acc : ram_double_bank
	Generic Map(
		number_of_memories => number_of_pipelines,
		ram_address_size => size_support_elements,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => dump_acc_memory_file
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_acc,
		rw_a => '0',
		rw_b => write_enable_new_value_acc,
		clk => clk,
		rst => rst,
		dump => test_acc_dump,
		address_a => test_acc_address,
		address_b => address_new_value_acc,
		rst_value => test_acc_rst_value,
		data_out_a => value_acc,
		data_out_b => open
	);

x_pow : ram_double_bank
	Generic Map(
		number_of_memories => number_of_pipelines,
		ram_address_size => size_support_elements,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => ""
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_x_pow,
		rw_a => '0',
		rw_b => write_enable_new_value_x_pow,
		clk => clk,
		rst => rst,
		dump => x_pow_dump,
		address_a => address_value_x_pow,
		address_b => address_new_value_x_pow,
		rst_value => x_pow_rst_value,
		data_out_a => value_x_pow,
		data_out_b => open
	);
	
sigma : ram
	Generic Map (
		ram_address_size => size_sigma_degree,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => sigma_memory_file,
		dump_file_name => ""
	)
	Port Map (
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => sigma_dump,
		address => address_value_polynomial,
		rst_value => sigma_rst_value,
		data_out => value_polynomial
	);

test : find_correct_errors_n
	Generic Map(	
		number_of_pipelines => number_of_pipelines,
		gf_2_m => gf_2_m,
		pipeline_size => pipeline_size,
		length_support_elements => length_support_elements,
		size_support_elements => size_support_elements
	)
	Port Map(
		value_message => value_message,
		value_evaluated => value_evaluated,
		address_value_evaluated => address_value_evaluated,
		enable_correction => enable_correction,
		evaluation_finalized => evaluation_finalized,
		clk => clk,
		rst => rst,
		correction_finalized => correction_finalized,
		address_new_value_message => address_new_value_message,
		address_value_error => address_value_error,
		write_enable_new_value_message => write_enable_new_value_message,
		write_enable_value_error => write_enable_value_error,
		new_value_message => new_value_message,
		value_error => value_error
	);

poly : polynomial_evaluator_n
	Generic Map(	
		number_of_values_x => length_support_elements,
		size_number_of_values_x => size_support_elements,
		polynomial_degree => sigma_degree,
		number_of_pipelines => number_of_pipelines,
		gf_2_m => gf_2_m,
		pipeline_size => pipeline_size,
		size_polynomial_degree => size_sigma_degree,
		size_pipeline_size => size_pipeline_size
	)
	Port Map(
		value_x => value_x,
		value_acc => value_acc,
		value_x_pow => value_x_pow,
		value_polynomial => value_polynomial,
		clk => clk,
		rst => rst,
		last_evaluations => last_evaluations,
		evaluation_finalized => evaluation_finalized,
		address_value_polynomial => address_value_polynomial,
		address_value_x => address_value_x,
		address_value_acc => address_value_acc,
		address_value_x_pow => address_value_x_pow,
		address_new_value_acc => address_new_value_acc,
		address_new_value_x_pow => address_new_value_x_pow,
		write_enable_new_value_acc => write_enable_new_value_acc,
		write_enable_new_value_x_pow => write_enable_new_value_x_pow,
		new_value_acc => new_value_acc,
		new_value_x_pow => new_value_x_pow
	);

value_evaluated <= new_value_acc;
address_value_evaluated <= address_new_value_acc;
enable_correction <= last_evaluations;

clock : process
begin
while ( test_bench_finish /= '1') loop
	clk <= not clk;
	wait for PERIOD/2;
	cycle_count <= cycle_count+1;
end loop;
wait;
end process;

test_acc_address <= address_value_acc when correction_finalized = '0' else
	true_acc_address;

test_codeword_address <= address_value_x when correction_finalized = '0' else
	true_codeword_address;

process
	variable i : integer; 
	begin
		true_acc_address <= (others => '0');
		true_codeword_address <= (others => '0');
		rst <= '1';
		error_acc <= '0';
		error_message <= '0';
		wait for PERIOD*2;
		rst <= '0';
		wait until correction_finalized = '1';
		report "Circuit finish = " & integer'image((cycle_count - 2)/2) & " cycles";
		wait for PERIOD;
		i := 0;
		while (i < (length_support_elements)) loop
			error_message <= '0';
			error_acc <= '0';
			true_acc_address <= std_logic_vector(to_unsigned(i, true_acc_address'Length));
			true_codeword_address <= std_logic_vector(to_unsigned(i, true_codeword_address'Length));
			wait for PERIOD*2;
			if (true_acc_value = value_acc) then
				error_acc <= '0';
			else
				error_acc <= '1';
				report "Computed values do not match expected ones";
			end if;
			if (true_codeword_value = value_message) then
				error_message <= '0';
			else
				error_message <= '1';
				report "Computed values do not match expected ones";
			end if;
			wait for PERIOD;
			error_acc <= '0';
			error_message <= '0';
			wait for PERIOD;
			i := i + number_of_pipelines;
		end loop;
		error_message <= '0';
		error_acc <= '0';
		test_acc_dump <= '1';
		test_codeword_dump <= '1';
		wait for PERIOD;
		test_acc_dump <= '0';
		test_codeword_dump <= '0';
		test_bench_finish <= '1';
		wait;
end process;


end Behavioral;