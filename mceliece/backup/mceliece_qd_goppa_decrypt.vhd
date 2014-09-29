----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    McEliece_QD-Goppa_Decrypt
-- Module Name:    McEliece_QD-Goppa_Decrypt
-- Project Name:   McEliece Goppa Decryption
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This circuit implements McEliece decryption algorithm for binary Goppa codes.
-- The circuit is divided into 3 phases : Syndrome computation, Solving Key Equation and
-- Finding Roots.
-- Each circuits waits for the next one to begin computation. All circuits share some
-- input and output memories, therefore is not possible to make a pipeline of this 3 phases.
-- First circuit, syndrome_calculator_n_pipe_v3, computes the syndrome from the ciphertext
-- and private keys, support L and polynomial g(x) (In this case g(L)^-1).
-- Second circuit, solving_key_equation_4, computes polynomial sigma through
-- the syndrome computed by first circuit.
-- Third circuit, find_and_correct_errors_n and polynomial_evaluator_n_v2, find the roots
-- of polynomial sigma and correct respective errors in the ciphertext and obtains
-- plaintext array.
-- Inversion circuit, inv_gf_2_m_pipeline, is only used during solving_key_equation_4.
-- This circuit was made outside of solving_key_equation_4 so it can be used by other circuits.
--
-- The circuits parameters
--
--	number_of_syndrome_and_find_units :
--
-- The number of pipelines in find_correct_errors_n, polynomial_evaluator_n_v2 and
-- syndrome_calculator_n_pipe_v3 circuits. The number of pipelines is shared between the root
-- finding process and syndrome computation. This happens because of how shared memories.
-- This number can be 1 or greater, however, tests for this unit were only made for 1 and 2.
--
--	syndrome_calculator_units : 
--
-- The number of units inside of each syndrome pipeline computational unit.
-- This number can be 1 or greater.
--
--	find_correct_errors_pipeline_size : 
--
-- This is the number of stages on the find_correct_errors_n and polynomial_evaluator_n_v2
-- circuits. This number can be 2 or greater.
--
--	find_correct_errors_size_pipeline_size : 
--
-- The number of bits necessary to hold the number of stages on the pipeline.
-- This is ceil(log2(find_correct_errors_pipeline_size))
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
-- syndrome_calculator_n_pipe_v3 Rev 1.0
-- solving_key_equation_4 Rev 1.0
-- find_and_correct_errors_n Rev 1.0
-- polynomial_evaluator_n_v2 Rev 1.0
-- inv_gf_2_m_pipeline Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mceliece_qd_goppa_decrypt is
	Generic(
	
		-- GOPPA [2048, 1751, 27, 11] --
	
--		number_of_syndrome_and_find_units : integer := 1;
--		syndrome_calculator_units : integer := 2;
--		find_correct_errors_pipeline_size : integer := 2;
--		find_correct_errors_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		number_of_errors : integer := 27;
--		size_number_of_errors : integer := 5
	
		-- GOPPA [2048, 1498, 50, 11] --
	
--		number_of_syndrome_and_find_units : integer := 1;
--		syndrome_calculator_units : integer := 2;
--		find_correct_errors_pipeline_size : integer := 2;
--		find_correct_errors_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		number_of_errors : integer := 50;
--		size_number_of_errors : integer := 6

		-- GOPPA [3307, 2515, 66, 12] --
		
--		number_of_syndrome_and_find_units : integer := 1;
--		syndrome_calculator_units : integer := 2;
--		find_correct_errors_pipeline_size : integer := 2;
--		find_correct_errors_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3307;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 66;
--		size_number_of_errors : integer := 7

		-- QD-GOPPA [2528, 2144, 32, 12] --
	
--		number_of_syndrome_and_find_units : integer := 1;
--		syndrome_calculator_units : integer := 2;
--		find_correct_errors_pipeline_size : integer := 2;
--		find_correct_errors_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2528;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 32;
--		size_number_of_errors : integer := 6

		-- QD-GOPPA [2816, 2048, 64, 12] --
	
--		number_of_syndrome_and_find_units : integer := 2;
--		syndrome_calculator_units : integer := 1;
--		find_correct_errors_pipeline_size : integer := 2;
--		find_correct_errors_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 64;
--		size_number_of_errors : integer := 7

		-- QD-GOPPA [3328, 2560, 64, 12] --
	
		number_of_syndrome_and_find_units : integer := 2;
		syndrome_calculator_units : integer := 2;
		find_correct_errors_pipeline_size : integer := 17;
		find_correct_errors_size_pipeline_size : integer := 5;
		gf_2_m : integer range 1 to 20 := 12;
		length_codeword : integer := 3328;
		size_codeword : integer := 12;
		number_of_errors : integer := 64;
		size_number_of_errors : integer := 7

		-- QD-GOPPA [7296, 5632, 128, 13] --
	
--		number_of_syndrome_and_find_units : integer := 1;
--		syndrome_calculator_units : integer := 2;
--		find_correct_errors_pipeline_size : integer := 2;
--		find_correct_errors_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 13;
--		length_codeword : integer := 7296;
--		size_codeword : integer := 13;
--		number_of_errors : integer := 128;
--		size_number_of_errors : integer := 8

	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		value_h : in STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(gf_2_m) - 1) downto 0);
		value_L : in STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(gf_2_m) - 1) downto 0);
		value_syndrome : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_codeword : in STD_LOGIC_VECTOR((number_of_syndrome_and_find_units - 1) downto 0);
		value_G : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_B : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_sigma : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_sigma_evaluated : in STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(gf_2_m) - 1) downto 0);
		syndrome_generation_finalized : out STD_LOGIC;
		key_equation_finalized : out STD_LOGIC;
		decryption_finalized : out STD_LOGIC;
		address_value_h : out STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
		address_value_L : out STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
		address_value_syndrome : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_codeword : out STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
		address_value_G : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_B : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_sigma : out STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
		address_value_sigma_evaluated : out STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
		new_value_syndrome : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_G : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_B : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_sigma : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_message : out STD_LOGIC_VECTOR((number_of_syndrome_and_find_units - 1) downto 0);
		new_value_error : out STD_LOGIC_VECTOR((number_of_syndrome_and_find_units - 1) downto 0);
		new_value_sigma_evaluated : out STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(gf_2_m) - 1) downto 0);
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
		address_new_value_message : out STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
		address_new_value_error : out STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
		address_new_value_sigma_evaluated : out STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0)
	);
end mceliece_qd_goppa_decrypt;

architecture Behavioral of mceliece_qd_goppa_decrypt is

component syndrome_calculator_n_pipe_v3
	Generic(
		number_of_syndrome_calculators : integer;
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
end component;

component solving_key_equation_4
	Generic(
		gf_2_m : integer range 1 to 20;
		final_degree : integer;
		size_final_degree : integer
	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		ready_inv : in STD_LOGIC;
		value_F : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_G : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_B : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_C : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_inv : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		signal_inv : out STD_LOGIC;
		key_equation_found : out STD_LOGIC;
		write_enable_F : out STD_LOGIC;
		write_enable_G : out STD_LOGIC;
		write_enable_B : out STD_LOGIC;
		write_enable_C : out STD_LOGIC;
		new_value_inv : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_F : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_B : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_G : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_C : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		address_value_F : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_G : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_B : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_C : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_F : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_G : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_B : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_C : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0)
	);
end component;

component find_correct_errors_n
	Generic (	
		number_of_pipelines : integer;
		pipeline_size : integer;
		gf_2_m : integer range 1 to 20;
		length_support_elements: integer;
		size_support_elements : integer
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

component inv_gf_2_m_pipeline
	Generic(gf_2_m : integer range 1 to 20 := 13);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		flag : in STD_LOGIC;
		clk : in STD_LOGIC;
		oflag : out STD_LOGIC;
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end component;

component polynomial_evaluator_n_v2
	Generic (	
		number_of_pipelines : integer;
		pipeline_size : integer;
		size_pipeline_size : integer;
		gf_2_m : integer range 1 to 20;
		polynomial_degree : integer;
		size_polynomial_degree : integer;
		number_of_values_x: integer;
		size_number_of_values_x : integer
	);
	Port(
		value_x : in  STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		value_acc : in  STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		value_polynomial : in  STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		clk : in  STD_LOGIC;
		rst : in STD_LOGIC;
		last_evaluations : out STD_LOGIC;
		evaluation_finalized : out STD_LOGIC;
		address_value_polynomial : out STD_LOGIC_VECTOR((size_polynomial_degree - 1) downto 0);
		address_value_x : out STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0);
		address_value_acc : out STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0);
		address_new_value_acc : out STD_LOGIC_VECTOR((size_number_of_values_x - 1) downto 0);
		write_enable_new_value_acc : out STD_LOGIC;
		new_value_acc : out STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0)
	);
end component;

signal syndrome_calculator_rst : STD_LOGIC;
signal syndrome_calculator_value_h : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(gf_2_m) - 1) downto 0);
signal syndrome_calculator_value_L : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(gf_2_m) - 1) downto 0);
signal syndrome_calculator_value_syndrome : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal syndrome_calculator_value_codeword : STD_LOGIC_VECTOR((number_of_syndrome_and_find_units - 1) downto 0);
signal syndrome_calculator_syndrome_finalized : STD_LOGIC;
signal syndrome_calculator_write_enable_new_syndrome : STD_LOGIC;
signal syndrome_calculator_new_value_syndrome : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal syndrome_calculator_address_h : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
signal syndrome_calculator_address_L : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
signal syndrome_calculator_address_codeword : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
signal syndrome_calculator_address_syndrome : STD_LOGIC_VECTOR((size_number_of_errors) downto 0);
signal syndrome_calculator_address_new_syndrome : STD_LOGIC_VECTOR((size_number_of_errors) downto 0);

signal solving_key_equation_rst : STD_LOGIC;
signal solving_key_equation_value_F : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal solving_key_equation_value_G : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal solving_key_equation_value_B : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal solving_key_equation_value_C : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal solving_key_equation_key_equation_found : STD_LOGIC;
signal solving_key_equation_write_enable_F : STD_LOGIC;
signal solving_key_equation_write_enable_G : STD_LOGIC;
signal solving_key_equation_write_enable_B : STD_LOGIC;
signal solving_key_equation_write_enable_C : STD_LOGIC;
signal solving_key_equation_new_value_F : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal solving_key_equation_new_value_B : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal solving_key_equation_new_value_G : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal solving_key_equation_new_value_C : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal solving_key_equation_address_value_F : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal solving_key_equation_address_value_G : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal solving_key_equation_address_value_B : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal solving_key_equation_address_value_C : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal solving_key_equation_address_new_value_F : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal solving_key_equation_address_new_value_G : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal solving_key_equation_address_new_value_B : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);
signal solving_key_equation_address_new_value_C : STD_LOGIC_VECTOR((size_number_of_errors + 1) downto 0);

signal find_correct_errors_value_message : STD_LOGIC_VECTOR((number_of_syndrome_and_find_units - 1) downto 0);
signal find_correct_errors_value_evaluated : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(gf_2_m) - 1) downto 0);
signal find_correct_errors_address_value_evaluated : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal find_correct_errors_enable_correction : STD_LOGIC;
signal find_correct_errors_evaluation_finalized : STD_LOGIC;
signal find_correct_errors_correction_finalized : STD_LOGIC;
signal find_correct_errors_rst : STD_LOGIC;
signal find_correct_errors_address_new_value_message : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal find_correct_errors_address_new_value_message_complete : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
signal find_correct_errors_address_value_error : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal find_correct_errors_address_value_error_complete : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
signal find_correct_errors_write_enable_new_value_message : STD_LOGIC;
signal find_correct_errors_write_enable_value_error : STD_LOGIC;
signal find_correct_errors_new_value_message : STD_LOGIC_VECTOR((number_of_syndrome_and_find_units - 1) downto 0);
signal find_correct_errors_value_error : STD_LOGIC_VECTOR((number_of_syndrome_and_find_units - 1) downto 0);

signal inv_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal inv_flag : STD_LOGIC;
signal inv_oflag : STD_LOGIC;
signal inv_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal polynomial_evaluator_value_x : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(gf_2_m) - 1) downto 0);
signal polynomial_evaluator_value_acc : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(gf_2_m) - 1) downto 0);
signal polynomial_evaluator_value_polynomial : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal polynomial_evaluator_rst : STD_LOGIC;
signal polynomial_evaluator_last_evaluations : STD_LOGIC;
signal polynomial_evaluator_evaluation_finalized : STD_LOGIC;
signal polynomial_evaluator_address_value_polynomial : STD_LOGIC_VECTOR((size_number_of_errors - 1) downto 0);
signal polynomial_evaluator_address_value_x : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal polynomial_evaluator_address_value_x_complete : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
signal polynomial_evaluator_address_value_acc : STD_LOGIC_VECTOR(((size_codeword) - 1) downto 0);
signal polynomial_evaluator_address_value_acc_complete : STD_LOGIC_VECTOR((((number_of_syndrome_and_find_units)*(size_codeword)) - 1) downto 0);
signal polynomial_evaluator_address_new_value_acc : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal polynomial_evaluator_address_new_value_acc_complete : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(size_codeword) - 1) downto 0);
signal polynomial_evaluator_write_enable_new_value_acc : STD_LOGIC;
signal polynomial_evaluator_new_value_acc : STD_LOGIC_VECTOR(((number_of_syndrome_and_find_units)*(gf_2_m) - 1) downto 0);

begin

syndrome_calculator : syndrome_calculator_n_pipe_v3
	Generic Map(
		number_of_syndrome_calculators => number_of_syndrome_and_find_units,
		syndrome_calculator_size => syndrome_calculator_units,
		gf_2_m => gf_2_m,
		length_codeword => length_codeword,
		size_codeword => size_codeword,
		length_syndrome => 2*number_of_errors,
		size_syndrome => size_number_of_errors + 1
	)
	Port Map(
		clk => clk,
		rst => syndrome_calculator_rst,
		value_h => syndrome_calculator_value_h,
		value_L => syndrome_calculator_value_L,
		value_syndrome => syndrome_calculator_value_syndrome,
		value_codeword => syndrome_calculator_value_codeword,
		syndrome_finalized => syndrome_calculator_syndrome_finalized,
		write_enable_new_syndrome => syndrome_calculator_write_enable_new_syndrome,
		new_value_syndrome => syndrome_calculator_new_value_syndrome,
		address_h => syndrome_calculator_address_h,
		address_L => syndrome_calculator_address_L,
		address_codeword => syndrome_calculator_address_codeword,
		address_syndrome => syndrome_calculator_address_syndrome,
		address_new_syndrome => syndrome_calculator_address_new_syndrome
	);

solving_key_equation : solving_key_equation_4
	Generic Map(
		gf_2_m => gf_2_m,
		final_degree => number_of_errors,
		size_final_degree => size_number_of_errors
	)
	Port Map(
		clk => clk,
		rst => solving_key_equation_rst,
		ready_inv => inv_oflag,
		value_F => solving_key_equation_value_F,
		value_G => solving_key_equation_value_G,
		value_B => solving_key_equation_value_B,
		value_C => solving_key_equation_value_C,
		value_inv => inv_o,
		signal_inv => inv_flag,
		key_equation_found => solving_key_equation_key_equation_found,
		write_enable_F => solving_key_equation_write_enable_F,
		write_enable_G => solving_key_equation_write_enable_G,
		write_enable_B => solving_key_equation_write_enable_B,
		write_enable_C => solving_key_equation_write_enable_C,
		new_value_inv => inv_a,
		new_value_F => solving_key_equation_new_value_F,
		new_value_B => solving_key_equation_new_value_B,
		new_value_G => solving_key_equation_new_value_G,
		new_value_C => solving_key_equation_new_value_C,
		address_value_F => solving_key_equation_address_value_F,
		address_value_G => solving_key_equation_address_value_G,
		address_value_B => solving_key_equation_address_value_B,
		address_value_C => solving_key_equation_address_value_C,
		address_new_value_F => solving_key_equation_address_new_value_F,
		address_new_value_G => solving_key_equation_address_new_value_G,
		address_new_value_B => solving_key_equation_address_new_value_B,
		address_new_value_C => solving_key_equation_address_new_value_C
	);

find_correct_errors : find_correct_errors_n
	Generic Map(	
		number_of_pipelines => number_of_syndrome_and_find_units,
		pipeline_size => find_correct_errors_pipeline_size,
		gf_2_m => gf_2_m,
		length_support_elements => length_codeword,
		size_support_elements => size_codeword
	)
	Port Map(
		value_message => find_correct_errors_value_message,
		value_evaluated => find_correct_errors_value_evaluated,
		address_value_evaluated => find_correct_errors_address_value_evaluated,
		enable_correction => find_correct_errors_enable_correction,
		evaluation_finalized => find_correct_errors_evaluation_finalized,
		clk => clk,
		rst => find_correct_errors_rst,
		correction_finalized => find_correct_errors_correction_finalized,
		address_new_value_message => find_correct_errors_address_new_value_message,
		address_value_error => find_correct_errors_address_value_error,
		write_enable_new_value_message => find_correct_errors_write_enable_new_value_message,
		write_enable_value_error => find_correct_errors_write_enable_value_error,
		new_value_message => find_correct_errors_new_value_message,
		value_error => find_correct_errors_value_error
	);

inverter : inv_gf_2_m_pipeline
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => inv_a,
		flag => inv_flag,
		clk => clk,
		oflag => inv_oflag,
		o => inv_o
	);

polynomial_evaluator : polynomial_evaluator_n_v2
	Generic Map(	
		number_of_pipelines => number_of_syndrome_and_find_units,
		pipeline_size => find_correct_errors_pipeline_size,
		size_pipeline_size => find_correct_errors_size_pipeline_size,
		gf_2_m => gf_2_m,
		polynomial_degree => number_of_errors, 
		size_polynomial_degree => size_number_of_errors,
		number_of_values_x => length_codeword,
		size_number_of_values_x => size_codeword
	)
	Port Map(
		value_x => polynomial_evaluator_value_x,
		value_acc => polynomial_evaluator_value_acc,
		value_polynomial => polynomial_evaluator_value_polynomial,
		clk => clk,
		rst => polynomial_evaluator_rst,
		last_evaluations => polynomial_evaluator_last_evaluations,
		evaluation_finalized => polynomial_evaluator_evaluation_finalized,
		address_value_polynomial => polynomial_evaluator_address_value_polynomial,
		address_value_x => polynomial_evaluator_address_value_x,
		address_value_acc => polynomial_evaluator_address_value_acc,
		address_new_value_acc => polynomial_evaluator_address_new_value_acc,
		write_enable_new_value_acc => polynomial_evaluator_write_enable_new_value_acc,
		new_value_acc => polynomial_evaluator_new_value_acc
	);
	
syndrome_calculator_rst <= rst;
syndrome_calculator_value_h <= value_h;
syndrome_calculator_value_L <= value_L;
syndrome_calculator_value_syndrome <= value_syndrome;
syndrome_calculator_value_codeword <= value_codeword;

solving_key_equation_rst <= not syndrome_calculator_syndrome_finalized;
solving_key_equation_value_F <= value_syndrome;
solving_key_equation_value_G <= value_G;
solving_key_equation_value_B <= value_B;
solving_key_equation_value_C <= value_sigma;

find_correct_errors_rst <= not solving_key_equation_key_equation_found;
find_correct_errors_value_message <= value_codeword;
find_correct_errors_value_evaluated <= polynomial_evaluator_new_value_acc;
find_correct_errors_address_value_evaluated <= polynomial_evaluator_address_new_value_acc;
find_correct_errors_enable_correction <= polynomial_evaluator_last_evaluations;
find_correct_errors_evaluation_finalized <= polynomial_evaluator_evaluation_finalized;

polynomial_evaluator_rst <= not solving_key_equation_key_equation_found;
polynomial_evaluator_value_x <= value_L;
polynomial_evaluator_value_acc <= value_sigma_evaluated;
polynomial_evaluator_value_polynomial <= value_sigma;
	
syndrome_generation_finalized <= syndrome_calculator_syndrome_finalized;
key_equation_finalized <= solving_key_equation_key_equation_found;
decryption_finalized <= syndrome_calculator_syndrome_finalized and solving_key_equation_key_equation_found and find_correct_errors_correction_finalized;

address_value_h <= syndrome_calculator_address_h;
address_value_L <= polynomial_evaluator_address_value_x_complete when syndrome_calculator_syndrome_finalized = '1' else 
						syndrome_calculator_address_h;
address_value_syndrome <= solving_key_equation_address_value_F when syndrome_calculator_syndrome_finalized = '1' else 
									"0" & syndrome_calculator_address_syndrome;
address_value_codeword <= polynomial_evaluator_address_value_x_complete when syndrome_calculator_syndrome_finalized = '1' else 
									syndrome_calculator_address_codeword;
address_value_G <= solving_key_equation_address_value_G;
address_value_B <= solving_key_equation_address_value_B;
address_value_sigma <= "00" & polynomial_evaluator_address_value_polynomial when solving_key_equation_key_equation_found = '1' else
								solving_key_equation_address_value_C;
address_value_sigma_evaluated <= polynomial_evaluator_address_value_acc_complete;

new_value_syndrome <= solving_key_equation_new_value_F when syndrome_calculator_syndrome_finalized = '1' else
								syndrome_calculator_new_value_syndrome;
new_value_G <= solving_key_equation_new_value_G;
new_value_B <= solving_key_equation_new_value_B;
new_value_sigma <= solving_key_equation_new_value_C;
new_value_message <= find_correct_errors_new_value_message;
new_value_error <= find_correct_errors_value_error;
new_value_sigma_evaluated <= polynomial_evaluator_new_value_acc;

write_enable_new_value_syndrome <= solving_key_equation_write_enable_F when syndrome_calculator_syndrome_finalized = '1' else
								syndrome_calculator_write_enable_new_syndrome;
write_enable_new_value_G <= solving_key_equation_write_enable_G;
write_enable_new_value_B <= solving_key_equation_write_enable_B;
write_enable_new_value_sigma <= solving_key_equation_write_enable_C;
write_enable_new_value_message <= find_correct_errors_write_enable_new_value_message;
write_enable_new_value_error <= find_correct_errors_write_enable_value_error;
write_enable_new_value_sigma_evaluated <= polynomial_evaluator_write_enable_new_value_acc;

address_new_value_syndrome <= solving_key_equation_address_new_value_F when syndrome_calculator_syndrome_finalized = '1' else
									"0" & syndrome_calculator_address_new_syndrome;
address_new_value_G <= solving_key_equation_address_new_value_G;
address_new_value_B <= solving_key_equation_address_new_value_B;
address_new_value_sigma <= solving_key_equation_address_new_value_C;
address_new_value_message <= find_correct_errors_address_new_value_message_complete;
address_new_value_error <= find_correct_errors_address_value_error_complete;
address_new_value_sigma_evaluated <= polynomial_evaluator_address_new_value_acc_complete;

resolve_address : for I in 0 to (number_of_syndrome_and_find_units - 1) generate

polynomial_evaluator_address_value_x_complete(((I+1)*size_codeword - 1) downto (I*size_codeword)) <= std_logic_vector(unsigned(polynomial_evaluator_address_value_x) + to_unsigned(I, size_codeword));
polynomial_evaluator_address_value_acc_complete(((I+1)*size_codeword - 1) downto (I*size_codeword)) <= std_logic_vector(unsigned(polynomial_evaluator_address_value_acc) + to_unsigned(I, size_codeword));
find_correct_errors_address_new_value_message_complete(((I+1)*size_codeword - 1) downto (I*size_codeword)) <= std_logic_vector(unsigned(find_correct_errors_address_new_value_message) + to_unsigned(I, size_codeword));
find_correct_errors_address_value_error_complete(((I+1)*size_codeword - 1) downto (I*size_codeword)) <= std_logic_vector(unsigned(find_correct_errors_address_value_error) + to_unsigned(I, size_codeword));
polynomial_evaluator_address_new_value_acc_complete(((I+1)*size_codeword - 1) downto (I*size_codeword)) <= std_logic_vector(unsigned(polynomial_evaluator_address_new_value_acc) + to_unsigned(I, size_codeword));

end generate;

end Behavioral;

