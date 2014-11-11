----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Tb_McEliece_QD-Goppa_Decrypt_v2
-- Module Name:    Tb_McEliece_QD-Goppa_Decrypt_v2
-- Project Name:   McEliece Goppa Decryption
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This test bench tests mceliece_qd_goppa_decrypt_v2 circuit.
-- The test is done only for one value loaded into memories, and in the end the output
-- memories are verified.
--
-- The circuits parameters
--
-- PERIOD : 
--
-- Input clock period to be applied on the test.
--
--	number_of_polynomial_evaluator_syndrome_pipelines :
--
-- The number of pipelines in polynomial_syndrome_computing_n circuit.
-- This number can be 1 or greater.
--
--	polynomial_evaluator_syndrome_pipeline_size : 
--
-- This is the number of stages on polynomial_syndrome_computing_n circuit.
-- This number can be 2 or greater.
--
--	polynomial_evaluator_syndrome_size_pipeline_size : 
--
-- The number of bits necessary to hold the number of stages on the pipeline.
-- This is ceil(log2(polynomial_evaluator_syndrome_pipeline_size))
--
--	gf_2_m : 
--
-- The size of the finite field extension used in this circuit.
-- This values depends of the Goppa code used. 
--
--	length_codeword : 
--
-- The length of the codeword in this Goppa code.
-- This values depends of the Goppa code used. 
--
--	size_codeword : 
--
-- The number of bits necessary to store an array of codeword lengths.
-- This is ceil(log2(length_codeword))
--
--	number_of_errors : 
--
-- The number of errors the Goppa code is able to decode.
-- This values depends of the Goppa code used. 
--
--	size_number_of_errors : 
--
-- The number of bits necessary to store an array of number of errors + 1 length.
-- This is ceil(log2(number_of_errors+1))
--
--	file_memory_L :
--
-- This file stores the private key, support elements L.
--
--	file_memory_h : 
--
-- This file stores the private key, the inverted evaluation of all support elements L
-- into polynomial g, aka g(L)^(-1)
--
--	file_memory_codeword : 
--
-- This file stores the ciphertext that will be decrypted.
--
--	file_memory_message : 
--
-- This file stores the plaintext obtained by decrypting the ciphertext.
-- This is necessary to verify if the circuit decrypted correctly the ciphertext.
--
--	file_memory_error : 
--
-- This file stores the error array added to the codeword to transform into the ciphertext.
-- This is necessary to verify if the circuit decrypted correctly the ciphertext.
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- mceliece_qd_goppa_decrypt_v2 Rev 1.0
-- ram Rev 1.0
-- ram_double Rev 1.0
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

entity tb_mceliece_qd_goppa_decrypt_v2 is
	Generic(
		PERIOD : time := 10 ns;
		
		-- QD-GOPPA [52, 28, 4, 6] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 18;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 6;
--		length_codeword : integer := 52;
--		size_codeword : integer := 6;
--		number_of_errors : integer := 4;
--		size_number_of_errors : integer := 3;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_52_28_4_6.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_52_28_4_6.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_52_28_4_6.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_qdgoppa_52_28_4_6.dat";
--		file_memory_error : string := "mceliece/data_tests/error_qdgoppa_52_28_4_6.dat"
	
		-- GOPPA [2048, 1751, 27, 11] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 2;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 8;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 4;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		number_of_errors : integer := 27;
--		size_number_of_errors : integer := 5;
--		file_memory_L : string := "mceliece/data_tests/L_goppa_2048_1751_27_11.dat";
--		file_memory_h : string := "mceliece/data_tests/h_goppa_2048_1751_27_11.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_goppa_2048_1751_27_11.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_goppa_2048_1751_27_11.dat";
--		file_memory_error : string := "mceliece/data_tests/error_goppa_2048_1751_27_11.dat"
	
		-- GOPPA [2048, 1498, 50, 11] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 18;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		number_of_errors : integer := 50;
--		size_number_of_errors : integer := 6;
--		file_memory_L : string := "mceliece/data_tests/L_goppa_2048_1498_50_11.dat";
--		file_memory_h : string := "mceliece/data_tests/h_goppa_2048_1498_50_11.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_goppa_2048_1498_50_11.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_goppa_2048_1498_50_11.dat";
--		file_memory_error : string := "mceliece/data_tests/error_goppa_2048_1498_50_11.dat"

		-- GOPPA [3307, 2515, 66, 12] --
		
		number_of_polynomial_evaluator_syndrome_pipelines : integer := 2;
		polynomial_evaluator_syndrome_pipeline_size : integer := 17;
		polynomial_evaluator_syndrome_size_pipeline_size : integer := 5;
		gf_2_m : integer range 1 to 20 := 12;
		length_codeword : integer := 3307;
		size_codeword : integer := 12;
		number_of_errors : integer := 66;
		size_number_of_errors : integer := 7;
		file_memory_L : string := "mceliece/data_tests/L_goppa_3307_2515_66_12.dat";
		file_memory_h : string := "mceliece/data_tests/h_goppa_3307_2515_66_12.dat";
		file_memory_codeword : string := "mceliece/data_tests/ciphertext_goppa_3307_2515_66_12.dat";
		file_memory_message : string := "mceliece/data_tests/plaintext_goppa_3307_2515_66_12.dat";
		file_memory_error : string := "mceliece/data_tests/error_goppa_3307_2515_66_12.dat"
		

		-- QD-GOPPA [2528, 2144, 32, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2528;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 32;
--		size_number_of_errors : integer := 6;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_2528_2144_32_12.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_2528_2144_32_12.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_2528_2144_32_12.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_qdgoppa_2528_2144_32_12.dat";
--		file_memory_error : string := "mceliece/data_tests/error_qdgoppa_2528_2144_32_12.dat"

		-- QD-GOPPA [2816, 2048, 64, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 18;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 64;
--		size_number_of_errors : integer := 7;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_2816_2048_64_12.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_2816_2048_64_12.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_2816_2048_64_12.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_qdgoppa_2816_2048_64_12.dat";
--		file_memory_error : string := "mceliece/data_tests/error_qdgoppa_2816_2048_64_12.dat"

		-- QD-GOPPA [3328, 2560, 64, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 18;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3328;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 64;
--		size_number_of_errors : integer := 7;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_3328_2560_64_12.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_3328_2560_64_12.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_3328_2560_64_12.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_qdgoppa_3328_2560_64_12.dat";
--		file_memory_error : string := "mceliece/data_tests/error_qdgoppa_3328_2560_64_12.dat"

		-- QD-GOPPA [7296, 5632, 128, 13] --
		
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 2;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 18;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 13;
--		length_codeword : integer := 7296;
--		size_codeword : integer := 13;
--		number_of_errors : integer := 128;
--		size_number_of_errors : integer := 8;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_7296_5632_128_13.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_7296_5632_128_13.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_7296_5632_128_13.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_qdgoppa_7296_5632_128_13.dat";
--		file_memory_error : string := "mceliece/data_tests/error_qdgoppa_7296_5632_128_13.dat"
	
	);
end tb_mceliece_qd_goppa_decrypt_v2;

architecture Behavioral of tb_mceliece_qd_goppa_decrypt_v2 is

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

component ram_double
	Generic (
		ram_address_size : integer;
		ram_word_size : integer;
		file_ram_word_size : integer;
		load_file_name : string := "ram.dat";
		dump_file_name : string := "ram.dat"
	);
	Port (
		data_in_a : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_in_b : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		rw_a : in STD_LOGIC;
		rw_b : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		dump : in STD_LOGIC; 
		address_a : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		address_b : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		rst_value : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out_a : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out_b : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
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

component mceliece_qd_goppa_decrypt_v2
	Generic(
		number_of_polynomial_evaluator_syndrome_pipelines : integer;
		polynomial_evaluator_syndrome_pipeline_size : integer;
		polynomial_evaluator_syndrome_size_pipeline_size : integer;
		gf_2_m : integer range 1 to 20;
		length_codeword : integer;
		size_codeword : integer;
		number_of_errors : integer;
		size_number_of_errors : integer
	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		value_h : in STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
		value_L : in STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
		value_syndrome : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_codeword : in STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		value_G : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_B : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_sigma : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_sigma_evaluated : in STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
		syndrome_generation_finalized : out STD_LOGIC;
		key_equation_finalized : out STD_LOGIC;
		decryption_finalized : out STD_LOGIC;
		address_value_h : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		address_value_L : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		address_value_syndrome : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_codeword : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		address_value_G : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_B : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_sigma : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_sigma_evaluated : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		new_value_syndrome : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_G : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_B : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_sigma : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_message : out STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		new_value_error : out STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		new_value_sigma_evaluated : out STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
		write_enable_new_value_syndrome : out STD_LOGIC;
		write_enable_new_value_G : out STD_LOGIC;
		write_enable_new_value_B : out STD_LOGIC; 
		write_enable_new_value_sigma : out STD_LOGIC;
		write_enable_new_value_message : out STD_LOGIC;
		write_enable_new_value_error : out STD_LOGIC;
		write_enable_new_value_sigma_evaluated : out STD_LOGIC;
		address_new_value_syndrome : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_new_value_G : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_new_value_B : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_new_value_sigma : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_new_value_message : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		address_new_value_error : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		address_new_value_sigma_evaluated : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0)
	);
end component;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC;
signal value_h : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
signal value_L : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
signal value_syndrome : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_codeword : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines) - 1) downto 0);
signal value_G : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_B : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_sigma : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_sigma_evaluated : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
signal syndrome_generation_finalized : STD_LOGIC;
signal key_equation_finalized : STD_LOGIC;
signal decryption_finalized : STD_LOGIC;
signal address_value_h : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal address_value_L : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal address_value_syndrome : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_value_codeword : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal address_value_G : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_value_B : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_value_sigma : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_value_sigma_evaluated : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal new_value_syndrome : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_G : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_B : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_sigma : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_message : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines) - 1) downto 0);
signal new_value_error : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines) - 1) downto 0);
signal new_value_sigma_evaluated : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
signal write_enable_new_value_syndrome : STD_LOGIC;
signal write_enable_new_value_G : STD_LOGIC;
signal write_enable_new_value_B : STD_LOGIC; 
signal write_enable_new_value_sigma : STD_LOGIC;
signal write_enable_new_value_message : STD_LOGIC;
signal write_enable_new_value_error : STD_LOGIC;
signal write_enable_new_value_sigma_evaluated : STD_LOGIC;
signal address_new_value_syndrome : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_new_value_G : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_new_value_B : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_new_value_sigma : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_new_value_message : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal address_new_value_error : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal address_new_value_sigma_evaluated : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);

signal true_address_new_value_message : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal true_value_message : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal test_value_message : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);

signal true_address_new_value_error : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal true_value_error : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal test_value_error : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);

signal error_value_message : STD_LOGIC;
signal error_value_error : STD_LOGIC;

signal test_bench_finish : STD_LOGIC := '0';
signal cycle_count : integer range 0 to 2000000000 := 0;

begin

test : mceliece_qd_goppa_decrypt_v2
	Generic Map(	
		number_of_polynomial_evaluator_syndrome_pipelines => number_of_polynomial_evaluator_syndrome_pipelines,
		polynomial_evaluator_syndrome_pipeline_size => polynomial_evaluator_syndrome_pipeline_size,
		polynomial_evaluator_syndrome_size_pipeline_size => polynomial_evaluator_syndrome_size_pipeline_size,
		gf_2_m => gf_2_m,
		length_codeword => length_codeword,
		size_codeword => size_codeword,
		number_of_errors => number_of_errors,
		size_number_of_errors => size_number_of_errors
	)
	Port Map(
		clk => clk,
		rst => rst,
		value_h => value_h,
		value_L => value_L,
		value_syndrome => value_syndrome,
		value_codeword => value_codeword,
		value_G => value_G,
		value_B => value_B,
		value_sigma => value_sigma,
		value_sigma_evaluated => value_sigma_evaluated,
		syndrome_generation_finalized => syndrome_generation_finalized,
		key_equation_finalized => key_equation_finalized,
		decryption_finalized => decryption_finalized,
		address_value_h => address_value_h,
		address_value_L => address_value_L,
		address_value_syndrome => address_value_syndrome,
		address_value_codeword => address_value_codeword,
		address_value_G => address_value_G,
		address_value_B => address_value_B,
		address_value_sigma => address_value_sigma,
		address_value_sigma_evaluated => address_value_sigma_evaluated,
		new_value_syndrome => new_value_syndrome,
		new_value_G => new_value_G,
		new_value_B => new_value_B,
		new_value_sigma => new_value_sigma,
		new_value_message => new_value_message,
		new_value_error => new_value_error,
		new_value_sigma_evaluated => new_value_sigma_evaluated,
		write_enable_new_value_syndrome => write_enable_new_value_syndrome,
		write_enable_new_value_G => write_enable_new_value_G,
		write_enable_new_value_B => write_enable_new_value_B,
		write_enable_new_value_sigma => write_enable_new_value_sigma,
		write_enable_new_value_message => write_enable_new_value_message,
		write_enable_new_value_error => write_enable_new_value_error,
		write_enable_new_value_sigma_evaluated => write_enable_new_value_sigma_evaluated,
		address_new_value_syndrome => address_new_value_syndrome,
		address_new_value_G => address_new_value_G,
		address_new_value_B => address_new_value_B,
		address_new_value_sigma => address_new_value_sigma,
		address_new_value_message => address_new_value_message,
		address_new_value_error => address_new_value_error,
		address_new_value_sigma_evaluated => address_new_value_sigma_evaluated
	);
	
mem_L : entity work.ram_bank(file_load)
	Generic Map(
		number_of_memories => number_of_polynomial_evaluator_syndrome_pipelines,
		ram_address_size => size_codeword,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => file_memory_L,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => address_value_L,
		rst_value => (others => '0'),
		data_out => value_L
	);

mem_h : entity work.ram_bank(file_load)
	Generic Map(
		number_of_memories => number_of_polynomial_evaluator_syndrome_pipelines,
		ram_address_size => size_codeword,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => file_memory_h,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => address_value_h,
		rst_value => (others => '0'),
		data_out => value_h
	);
	
mem_codeword : entity work.ram_bank(file_load)
	Generic Map(
		number_of_memories => number_of_polynomial_evaluator_syndrome_pipelines,
		ram_address_size => size_codeword,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => file_memory_codeword,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => address_value_codeword,
		rst_value => (others => '0'),
		data_out => value_codeword
	);
	
mem_sigma_evaluated : entity work.ram_double_bank(simple)
	Generic Map(
		number_of_memories => number_of_polynomial_evaluator_syndrome_pipelines,
		ram_address_size => size_codeword,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => ""
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_sigma_evaluated,
		rw_a => '0',
		rw_b => write_enable_new_value_sigma_evaluated,
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_value_sigma_evaluated,
		address_b => address_new_value_sigma_evaluated,
		rst_value => (others => '0'),
		data_out_a => value_sigma_evaluated,
		data_out_b => open
	);
	
test_mem_message : entity work.ram_double_bank(simple)
	Generic Map(
		number_of_memories => number_of_polynomial_evaluator_syndrome_pipelines,
		ram_address_size => size_codeword,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => "",
		dump_file_name => ""
	)
	Port Map(
		data_in_a => new_value_message,
		data_in_b => (others => '0'),
		rw_a => write_enable_new_value_message,
		rw_b => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_new_value_message,
		address_b => true_address_new_value_message,
		rst_value => (others => '0'),
		data_out_a => open,
		data_out_b => test_value_message
	);
	
test_mem_error : entity work.ram_double_bank(simple)
	Generic Map(
		number_of_memories => number_of_polynomial_evaluator_syndrome_pipelines,
		ram_address_size => size_codeword,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => "",
		dump_file_name => ""
	)
	Port Map(
		data_in_a => new_value_error,
		data_in_b => (others => '0'),
		rw_a => write_enable_new_value_error,
		rw_b => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_new_value_error,
		address_b => true_address_new_value_error,
		rst_value => (others => '0'),
		data_out_a => open,
		data_out_b => test_value_error
	);
	
true_mem_message : entity work.ram_bank(file_load)
	Generic Map(
		number_of_memories => number_of_polynomial_evaluator_syndrome_pipelines,
		ram_address_size => size_codeword,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => file_memory_message,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => true_address_new_value_message,
		rst_value => (others => '0'),
		data_out => true_value_message
	);
	
true_mem_error : entity work.ram_bank(file_load)
	Generic Map(
		number_of_memories => number_of_polynomial_evaluator_syndrome_pipelines,
		ram_address_size => size_codeword,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => file_memory_error,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => true_address_new_value_error,
		rst_value => (others => '0'),
		data_out => true_value_error
	);

mem_syndrome : entity work.ram_double(simple)
	Generic Map(
		ram_address_size => size_number_of_errors + 2,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => ""
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_syndrome,
		rw_a => '0',
		rw_b => write_enable_new_value_syndrome,
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_value_syndrome,
		address_b => address_new_value_syndrome,
		rst_value => (others => '0'),
		data_out_a => value_syndrome,
		data_out_b => open
	);
	
mem_G : entity work.ram_double(simple)
	Generic Map(
		ram_address_size => size_number_of_errors + 2,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => ""
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_G,
		rw_a => '0',
		rw_b => write_enable_new_value_G,
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_value_G,
		address_b => address_new_value_G,
		rst_value => (others => '0'),
		data_out_a => value_G,
		data_out_b => open
	);
	
mem_B : entity work.ram_double(simple)
	Generic Map(
		ram_address_size => size_number_of_errors + 2,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => ""
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_B,
		rw_a => '0',
		rw_b => write_enable_new_value_B,
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_value_B,
		address_b => address_new_value_B,
		rst_value => (others => '0'),
		data_out_a => value_B,
		data_out_b => open
	);
	
mem_sigma : entity work.ram_double(simple)
	Generic Map(
		ram_address_size => size_number_of_errors + 2,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => ""
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_sigma,
		rw_a => '0',
		rw_b => write_enable_new_value_sigma,
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_value_sigma,
		address_b => address_new_value_sigma,
		rst_value => (others => '0'),
		data_out_a => value_sigma,
		data_out_b => open
	);

clock : process
begin
while ( test_bench_finish /= '1') loop
	clk <= not clk;
	wait for PERIOD/2;
	cycle_count <= cycle_count+1;
end loop;
wait;
end process;
	
--clk <= not clk after PERIOD/2;

process
	variable i : integer; 
	variable syndrome_cycle_count : integer range 0 to 2000000000 := 0;
	variable key_equation_cycle_count : integer range 0 to 2000000000 := 0;
	variable correct_errors_cycle_count : integer range 0 to 2000000000 := 0;
	begin
		true_address_new_value_message <= (others => '0');
		true_address_new_value_error <= (others => '0');
		rst <= '1';
		error_value_message <= '0';
		error_value_error <= '0';
		wait for PERIOD*2;
		rst <= '0';
		wait until syndrome_generation_finalized = '1';
		syndrome_cycle_count := cycle_count - 2;
		report "Circuit finish Syndrome = " & integer'image(syndrome_cycle_count/2) & " cycles";
		wait until key_equation_finalized = '1';
		key_equation_cycle_count := cycle_count - syndrome_cycle_count;
		report "Circuit finish Key Equation = " & integer'image(key_equation_cycle_count/2) & " cycles";
		wait until decryption_finalized = '1';
		correct_errors_cycle_count := cycle_count - key_equation_cycle_count - syndrome_cycle_count;
		report "Circuit finish Correct Errors = " & integer'image(correct_errors_cycle_count/2) & " cycles";
		report "Circuit finish = " & integer'image(cycle_count/2) & " cycles";
		wait for PERIOD;
		i := 0;
		while (i < (length_codeword)) loop
			true_address_new_value_message(size_codeword - 1 downto 0) <= std_logic_vector(to_unsigned(i, size_codeword));
			true_address_new_value_error(size_codeword - 1 downto 0) <= std_logic_vector(to_unsigned(i, size_codeword));
			wait for PERIOD*2;
			if (true_value_message(0) = test_value_message(0)) then
				error_value_message <= '0';
			else
				error_value_message <= '1';
				report "Computed values do not match expected ones";
			end if;
			if (true_value_error(0) = test_value_error(0)) then
				error_value_error <= '0';
			else
				error_value_error <= '1';
				report "Computed values do not match expected ones";
			end if;
			wait for PERIOD;
			error_value_message <= '0';
			error_value_error <= '0';
			wait for PERIOD;
			i := i + number_of_polynomial_evaluator_syndrome_pipelines;
		end loop;
		wait for PERIOD;
		test_bench_finish <= '1';
		wait;
end process;

end Behavioral;