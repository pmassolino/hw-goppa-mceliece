----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    McEliece_QD-Goppa_Decrypt_With_mem_v4
-- Module Name:    McEliece_QD-Goppa_Decrypt_With_mem_v4
-- Project Name:   McEliece Goppa Decryption
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This circuit implements a McEliece decryption algorithm for binary Goppa codes with
-- all necessary memories.
-- This circuit only supplies the necessary memories for mceliece_qd_goppa_decrypt_v4.
-- Because of how mceliece_qd_goppa_decrypt_v4 circuit handles the memories, it
-- is possible to implement efficiently for values of 
-- number_of_polynomial_evaluator_syndrome_pipelines which are not power of 2.
--
-- The circuits parameters
--
--	number_of_polynomial_evaluator_syndrome_pipelines :
--
-- The number of pipelines in polynomial_syndrome_computing_n_v2 circuit.
-- This number can be 1 or greater, but only power of 2.
--
-- log2_number_of_polynomial_evaluator_syndrome_pipelines :
--
-- This is the log2 of the number_of_polynomial_evaluator_syndrome_pipelines.
-- This is ceil(log2(number_of_polynomial_evaluator_syndrome_pipelines))
--
--	polynomial_evaluator_syndrome_pipeline_size : 
--
-- This is the number of stages on polynomial_syndrome_computing_n_v2 circuit.
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
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- mceliece_qd_goppa_decrypt_v4_with_mem Rev 1.0
-- register_nbits Rev 1.0
-- synth_ram Rev 1.0
-- synth_double_ram Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mceliece_qd_goppa_decrypt_v4_with_mem is
	Generic(
			-- GOPPA [2048, 1751, 27, 11] --
	
		number_of_polynomial_evaluator_syndrome_pipelines : integer := 16;
		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 4;
		polynomial_evaluator_syndrome_pipeline_size : integer := 3;
		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
		gf_2_m : integer range 1 to 20 := 11;
		length_codeword : integer := 2048;
		size_codeword : integer := 11;
		number_of_errors : integer := 27;
		size_number_of_errors : integer := 5
	
		-- GOPPA [2048, 1498, 50, 11] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		number_of_errors : integer := 50;
--		size_number_of_errors : integer := 6

		-- GOPPA [3307, 2515, 66, 12] --
		
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3307;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 66;
--		size_number_of_errors : integer := 7

		-- QD-GOPPA [2528, 2144, 32, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2528;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 32;
--		size_number_of_errors : integer := 6

		-- QD-GOPPA [2816, 2048, 64, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 64;
--		size_number_of_errors : integer := 7

		-- QD-GOPPA [3328, 2560, 64, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
-- 	log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3328;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 64;
--		size_number_of_errors : integer := 7

		-- QD-GOPPA [7296, 5632, 128, 13] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 16;
--		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 4;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 3;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 13;
--		length_codeword : integer := 7296;
--		size_codeword : integer := 13;
--		number_of_errors : integer := 128;
--		size_number_of_errors : integer := 8
	
	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		load_address_mem : in STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		load_sel_mem : in STD_LOGIC_VECTOR(1 downto 0);
		load_write_value_mem : in STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		load_write_enable_mem : in STD_LOGIC;
		load_read_value_mem : out STD_LOGIC_VECTOR((2*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		syndrome_generation_finalized : out STD_LOGIC;
		key_equation_finalized : out STD_LOGIC;
		decryption_finalized : out STD_LOGIC
	);
end mceliece_qd_goppa_decrypt_v4_with_mem;

architecture Behavioral of mceliece_qd_goppa_decrypt_v4_with_mem is

component register_nbits
	Generic (
		size : integer
	);
	Port (
		d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component synth_ram
	Generic (
		ram_address_size : integer;
		ram_word_size : integer
	);
	Port (
		data_in : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		rw : in STD_LOGIC;
		clk : in STD_LOGIC;
		address : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		data_out : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
	);
end component;

component synth_double_ram
	Generic (
		ram_address_size : integer;
		ram_word_size : integer
	);
	Port (
		data_in_a : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_in_b : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		rw_a : in STD_LOGIC;
		rw_b : in STD_LOGIC;
		clk : in STD_LOGIC;
		address_a : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		address_b : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		data_out_a : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out_b : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
	);
end component;

component mceliece_qd_goppa_decrypt_v4
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
		value_s : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_v : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_sigma : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_sigma_evaluated : in STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
		syndrome_generation_finalized : out STD_LOGIC;
		key_equation_finalized : out STD_LOGIC;
		decryption_finalized : out STD_LOGIC;
		address_value_h : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		address_value_L : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		address_value_syndrome : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_codeword : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		address_value_s : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_v : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_sigma : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_sigma_evaluated : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		new_value_syndrome : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_s : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_v : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_sigma : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_message : out STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		new_value_error : out STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		new_value_sigma_evaluated : out STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
		write_enable_new_value_syndrome : out STD_LOGIC;
		write_enable_new_value_s : out STD_LOGIC;
		write_enable_new_value_v : out STD_LOGIC; 
		write_enable_new_value_sigma : out STD_LOGIC;
		write_enable_new_value_message : out STD_LOGIC;
		write_enable_new_value_error : out STD_LOGIC;
		write_enable_new_value_sigma_evaluated : out STD_LOGIC;
		address_new_value_syndrome : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_new_value_s : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_new_value_v : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_new_value_sigma : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_new_value_message : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		address_new_value_error : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
		address_new_value_sigma_evaluated : out STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0)
	);
end component;

signal value_h : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
signal value_L : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
signal value_syndrome : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_codeword : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines) - 1) downto 0);
signal value_s : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_v : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_sigma : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_sigma_evaluated : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
signal address_value_h : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal address_value_L : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal address_value_syndrome : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_value_codeword : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal address_value_s : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_value_v : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_value_sigma : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_value_sigma_evaluated : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal new_value_syndrome : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_s : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_v : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_sigma : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_message : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines) - 1) downto 0);
signal new_value_error : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines) - 1) downto 0);
signal new_value_sigma_evaluated : STD_LOGIC_VECTOR(((number_of_polynomial_evaluator_syndrome_pipelines)*(gf_2_m) - 1) downto 0);
signal write_enable_new_value_syndrome : STD_LOGIC;
signal write_enable_new_value_s : STD_LOGIC;
signal write_enable_new_value_v : STD_LOGIC; 
signal write_enable_new_value_sigma : STD_LOGIC;
signal write_enable_new_value_message : STD_LOGIC;
signal write_enable_new_value_error : STD_LOGIC;
signal write_enable_new_value_sigma_evaluated : STD_LOGIC;
signal address_new_value_syndrome : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_new_value_s : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_new_value_v : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_new_value_sigma : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal address_new_value_message : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal address_new_value_error : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal address_new_value_sigma_evaluated : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);

signal mem_L_data_in : STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_L_rw : STD_LOGIC;
signal mem_L_address : STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_L_data_out : STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);

signal mem_h_data_in : STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_h_rw : STD_LOGIC;
signal mem_h_address : STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_h_data_out : STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
	
signal mem_codeword_data_in : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_codeword_rw : STD_LOGIC;
signal mem_codeword_address : STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_codeword_data_out : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
	
signal mem_sigma_evaluated_data_in_a : STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_sigma_evaluated_data_in_b : STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_sigma_evaluated_rw_a : STD_LOGIC;
signal mem_sigma_evaluated_rw_b : STD_LOGIC;
signal mem_sigma_evaluated_address_a : STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_sigma_evaluated_address_b : STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_sigma_evaluated_data_out_a : STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_sigma_evaluated_data_out_b : STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
	
signal mem_message_data_in : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_message_rw : STD_LOGIC;
signal mem_message_address : STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_message_data_out : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
	
signal mem_error_data_in : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_error_rw : STD_LOGIC;
signal mem_error_address : STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal mem_error_data_out : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);

signal mem_syndrome_data_in_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_syndrome_data_in_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_syndrome_rw_a : STD_LOGIC;
signal mem_syndrome_rw_b : STD_LOGIC;
signal mem_syndrome_address_a : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal mem_syndrome_address_b : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal mem_syndrome_data_out_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_syndrome_data_out_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
	
signal mem_F_data_in_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_F_data_in_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_F_rw_a : STD_LOGIC;
signal mem_F_rw_b : STD_LOGIC;
signal mem_F_address_a : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal mem_F_address_b : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal mem_F_data_out_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_F_data_out_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
	
signal mem_B_data_in_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_B_data_in_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_B_rw_a : STD_LOGIC;
signal mem_B_rw_b : STD_LOGIC;
signal mem_B_address_a : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal mem_B_address_b : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal mem_B_data_out_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_B_data_out_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal mem_sigma_data_in_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_sigma_data_in_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_sigma_rw_a : STD_LOGIC;
signal mem_sigma_rw_b : STD_LOGIC;
signal mem_sigma_address_a : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal mem_sigma_address_b : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal mem_sigma_data_out_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mem_sigma_data_out_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);


signal reg_rst_q : STD_LOGIC;	
signal reg_load_address_mem_q : STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal reg_load_sel_mem_q : STD_LOGIC_VECTOR(1 downto 0);
signal reg_load_write_value_mem_q : STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal reg_load_write_enable_mem_q : STD_LOGIC;	
signal reg_load_read_value_mem_d : STD_LOGIC_VECTOR((2*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal reg_syndrome_generation_finalized_d : STD_LOGIC;
signal reg_key_equation_finalized_d : STD_LOGIC;
signal reg_decryption_finalized_d : STD_LOGIC;




begin

reg_rst : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d(0) => rst,
		clk => clk,
		ce => '1',
		q(0) => reg_rst_q
	);
	
reg_load_address_mem : register_nbits
	Generic Map(
		size => size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines
	)
	Port Map(
		d => load_address_mem,
		clk => clk,
		ce => '1',
		q => reg_load_address_mem_q
	);
	
reg_load_sel_mem : register_nbits
	Generic Map(
		size => 2
	)
	Port Map(
		d => load_sel_mem,
		clk => clk,
		ce => '1',
		q => reg_load_sel_mem_q
	);
	
reg_load_write_value_mem : register_nbits
	Generic Map(
		size => gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines
	)
	Port Map(
		d => load_write_value_mem,
		clk => clk,
		ce => '1',
		q => reg_load_write_value_mem_q
	);
	
reg_load_write_enable_mem : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d(0) => load_write_enable_mem,
		clk => clk,
		ce => '1',
		q(0) => reg_load_write_enable_mem_q
	);

reg_load_read_value_mem : register_nbits
	Generic Map(
		size => 2*number_of_polynomial_evaluator_syndrome_pipelines
	)
	Port Map(
		d => reg_load_read_value_mem_d,
		clk => clk,
		ce => '1',
		q => load_read_value_mem
	);

reg_syndrome_generation_finalized : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d(0) => reg_syndrome_generation_finalized_d,
		clk => clk,
		ce => '1',
		q(0) => syndrome_generation_finalized
	);

reg_key_equation_finalized : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d(0) => reg_key_equation_finalized_d,
		clk => clk,
		ce => '1',
		q(0) => key_equation_finalized
	);

reg_decryption_finalized : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d(0) => reg_decryption_finalized_d,
		clk => clk,
		ce => '1',
		q(0) => decryption_finalized
	);


mceliece : mceliece_qd_goppa_decrypt_v4
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
		rst => reg_rst_q,
		value_h => value_h,
		value_L => value_L,
		value_syndrome => value_syndrome,
		value_codeword => value_codeword,
		value_s => value_s,
		value_v => value_v,
		value_sigma => value_sigma,
		value_sigma_evaluated => value_sigma_evaluated,
		syndrome_generation_finalized => reg_syndrome_generation_finalized_d,
		key_equation_finalized => reg_key_equation_finalized_d,
		decryption_finalized => reg_decryption_finalized_d,
		address_value_h => address_value_h,
		address_value_L => address_value_L,
		address_value_syndrome => address_value_syndrome,
		address_value_codeword => address_value_codeword,
		address_value_s => address_value_s,
		address_value_v => address_value_v,
		address_value_sigma => address_value_sigma,
		address_value_sigma_evaluated => address_value_sigma_evaluated,
		new_value_syndrome => new_value_syndrome,
		new_value_s => new_value_s,
		new_value_v => new_value_v,
		new_value_sigma => new_value_sigma,
		new_value_message => new_value_message,
		new_value_error => new_value_error,
		new_value_sigma_evaluated => new_value_sigma_evaluated,
		write_enable_new_value_syndrome => write_enable_new_value_syndrome,
		write_enable_new_value_s => write_enable_new_value_s,
		write_enable_new_value_v => write_enable_new_value_v,
		write_enable_new_value_sigma => write_enable_new_value_sigma,
		write_enable_new_value_message => write_enable_new_value_message,
		write_enable_new_value_error => write_enable_new_value_error,
		write_enable_new_value_sigma_evaluated => write_enable_new_value_sigma_evaluated,
		address_new_value_syndrome => address_new_value_syndrome,
		address_new_value_s => address_new_value_s,
		address_new_value_v => address_new_value_v,
		address_new_value_sigma => address_new_value_sigma,
		address_new_value_message => address_new_value_message,
		address_new_value_error => address_new_value_error,
		address_new_value_sigma_evaluated => address_new_value_sigma_evaluated	
	);
	
mem_L : synth_ram
	Generic Map(
		ram_address_size => size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines,
		ram_word_size => gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines
	)
	Port Map(
		data_in => mem_L_data_in,
		rw => mem_L_rw,
		clk => clk,
		address => mem_L_address,
		data_out => mem_L_data_out
	);

mem_h : synth_ram
	Generic Map(
		ram_address_size => size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines,
		ram_word_size => gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines
	)
	Port Map(
		data_in => mem_h_data_in,
		rw => mem_h_rw,
		clk => clk,
		address => mem_h_address,
		data_out => mem_h_data_out
	);
	
mem_codeword : synth_ram
	Generic Map(
		ram_address_size => size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines,
		ram_word_size => number_of_polynomial_evaluator_syndrome_pipelines
	)
	Port Map(
		data_in => mem_codeword_data_in,
		rw => mem_codeword_rw,
		clk => clk,
		address => mem_codeword_address,
		data_out => mem_codeword_data_out
	);
	
mem_sigma_evaluated : synth_double_ram
	Generic Map(
		ram_address_size => size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines,
		ram_word_size => gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines
	)
	Port Map(
		data_in_a => mem_sigma_evaluated_data_in_a,
		data_in_b => mem_sigma_evaluated_data_in_b,
		rw_a => mem_sigma_evaluated_rw_a,
		rw_b => mem_sigma_evaluated_rw_b,
		clk => clk,
		address_a => mem_sigma_evaluated_address_a,
		address_b => mem_sigma_evaluated_address_b,
		data_out_a => mem_sigma_evaluated_data_out_a,
		data_out_b => mem_sigma_evaluated_data_out_b
	);
	
mem_message : synth_ram
	Generic Map(
		ram_address_size => size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines,
		ram_word_size => number_of_polynomial_evaluator_syndrome_pipelines
	)
	Port Map(
		data_in => mem_message_data_in,
		rw => mem_message_rw,
		clk => clk,
		address => mem_message_address,
		data_out => mem_message_data_out
	);
	
mem_error : synth_ram
	Generic Map(
		ram_address_size => size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines,
		ram_word_size => number_of_polynomial_evaluator_syndrome_pipelines
	)
	Port Map(
		data_in => mem_error_data_in,
		rw => mem_error_rw,
		clk => clk,
		address => mem_error_address,
		data_out => mem_error_data_out
	);

mem_syndrome : synth_double_ram
	Generic Map(
		ram_address_size => size_number_of_errors + 2,
		ram_word_size => gf_2_m
	)
	Port Map(
		data_in_a => mem_syndrome_data_in_a,
		data_in_b => mem_syndrome_data_in_b,
		rw_a => mem_syndrome_rw_a,
		rw_b => mem_syndrome_rw_b,
		clk => clk,
		address_a => mem_syndrome_address_a,
		address_b => mem_syndrome_address_b,
		data_out_a => mem_syndrome_data_out_a,
		data_out_b => mem_syndrome_data_out_b
	);
	
mem_F : synth_double_ram
	Generic Map(
		ram_address_size => size_number_of_errors + 2,
		ram_word_size => gf_2_m
	)
	Port Map(
		data_in_a => mem_F_data_in_a,
		data_in_b => mem_F_data_in_b,
		rw_a => mem_F_rw_a,
		rw_b => mem_F_rw_b,
		clk => clk,
		address_a => mem_F_address_a,
		address_b => mem_F_address_b,
		data_out_a => mem_F_data_out_a,
		data_out_b => mem_F_data_out_b
	);
	
mem_B : synth_double_ram
	Generic Map(
		ram_address_size => size_number_of_errors + 2,
		ram_word_size => gf_2_m
	)
	Port Map(
		data_in_a => mem_B_data_in_a,
		data_in_b => mem_B_data_in_b,
		rw_a => mem_B_rw_a,
		rw_b => mem_B_rw_b,
		clk => clk,
		address_a => mem_B_address_a,
		address_b => mem_B_address_b,
		data_out_a => mem_B_data_out_a,
		data_out_b => mem_B_data_out_b
	);
	
mem_sigma : synth_double_ram
	Generic Map(
		ram_address_size => size_number_of_errors + 2,
		ram_word_size => gf_2_m
	)
	Port Map(
		data_in_a => mem_sigma_data_in_a,
		data_in_b => mem_sigma_data_in_b,
		rw_a => mem_sigma_rw_a,
		rw_b => mem_sigma_rw_b,
		clk => clk,
		address_a => mem_sigma_address_a,
		address_b => mem_sigma_address_b,
		data_out_a => mem_sigma_data_out_a,
		data_out_b => mem_sigma_data_out_b
	);

value_h <= mem_h_data_out;
value_L <= mem_L_data_out;
value_codeword <= mem_codeword_data_out;
value_syndrome <= mem_syndrome_data_out_a;
value_s <= mem_F_data_out_a;
value_v <= mem_B_data_out_a;
value_sigma <= mem_sigma_data_out_a;
value_sigma_evaluated <= mem_sigma_evaluated_data_out_a;

mem_L_data_in <= reg_load_write_value_mem_q;
mem_L_rw <= reg_load_write_enable_mem_q when(reg_rst_q = '1' and reg_load_sel_mem_q = "00") else
				'0';
mem_L_address <= reg_load_address_mem_q when(reg_rst_q = '1' and reg_load_sel_mem_q = "00") else
						address_value_L((size_codeword - 1) downto log2_number_of_polynomial_evaluator_syndrome_pipelines); 

mem_h_data_in <= reg_load_write_value_mem_q;
mem_h_rw <= reg_load_write_enable_mem_q when(reg_rst_q = '1' and reg_load_sel_mem_q = "01") else
				'0';
mem_h_address <= reg_load_address_mem_q when(reg_rst_q = '1' and reg_load_sel_mem_q = "01") else
						address_value_h((size_codeword - 1) downto log2_number_of_polynomial_evaluator_syndrome_pipelines);

mem_codeword_data_in <= reg_load_write_value_mem_q((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
mem_codeword_rw <= reg_load_write_enable_mem_q when(reg_rst_q = '1' and reg_load_sel_mem_q = "10") else
				'0';
mem_codeword_address <= reg_load_address_mem_q when(reg_rst_q = '1' and reg_load_sel_mem_q = "10") else
						address_value_codeword((size_codeword - 1) downto log2_number_of_polynomial_evaluator_syndrome_pipelines);

mem_sigma_evaluated_data_in_a <= (others => '0');
mem_sigma_evaluated_data_in_b <= new_value_sigma_evaluated;
mem_sigma_evaluated_rw_a <= '0';
mem_sigma_evaluated_rw_b <= write_enable_new_value_sigma_evaluated;
mem_sigma_evaluated_address_a <= address_value_sigma_evaluated((size_codeword - 1) downto log2_number_of_polynomial_evaluator_syndrome_pipelines);
mem_sigma_evaluated_address_b <= address_new_value_sigma_evaluated((size_codeword - 1) downto log2_number_of_polynomial_evaluator_syndrome_pipelines);

mem_message_data_in <= new_value_message;
mem_message_rw <= '0' when reg_rst_q = '1' else
						write_enable_new_value_message;
mem_message_address <= reg_load_address_mem_q when reg_rst_q = '1' else
								address_new_value_message((size_codeword - 1) downto log2_number_of_polynomial_evaluator_syndrome_pipelines);

mem_error_data_in <= new_value_error;
mem_error_rw <= '0' when reg_rst_q = '1' else
					write_enable_new_value_error;
mem_error_address <= reg_load_address_mem_q when reg_rst_q = '1' else
							address_new_value_error((size_codeword - 1) downto log2_number_of_polynomial_evaluator_syndrome_pipelines);

mem_syndrome_data_in_a <= (others => '0');
mem_syndrome_data_in_b <= new_value_syndrome;
mem_syndrome_rw_a <= '0';
mem_syndrome_rw_b <= write_enable_new_value_syndrome;
mem_syndrome_address_a <= address_value_syndrome;
mem_syndrome_address_b <= address_new_value_syndrome;

mem_F_data_in_a <= (others => '0');
mem_F_data_in_b <= new_value_s;
mem_F_rw_a <= '0';
mem_F_rw_b <= write_enable_new_value_s;
mem_F_address_a <= address_value_s;
mem_F_address_b <= address_new_value_s;
	
mem_B_data_in_a <= (others => '0');
mem_B_data_in_b <= new_value_v;
mem_B_rw_a <= '0';
mem_B_rw_b <= write_enable_new_value_v;
mem_B_address_a <= address_value_v;
mem_B_address_b <= address_new_value_v;

mem_sigma_data_in_a <= (others => '0');
mem_sigma_data_in_b <= new_value_sigma;
mem_sigma_rw_a <= '0';
mem_sigma_rw_b <= write_enable_new_value_sigma;
mem_sigma_address_a <= address_value_sigma;
mem_sigma_address_b <= address_new_value_sigma;

reg_load_read_value_mem_d <= mem_error_data_out & mem_message_data_out;

end Behavioral;

