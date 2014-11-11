----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    McEliece_QD-Goppa_Decrypt_v4
-- Module Name:    McEliece_QD-Goppa_Decrypt_v4
-- Project Name:   McEliece Goppa Decryption
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This circuit implements McEliece decryption algorithm for binary Goppa codes.
-- The circuit is divided into 3 phases : Syndrome computation, Solving Key Equation and
-- Finding Root.
-- Each circuits waits for the next one to begin computation. All circuits share some
-- input and output memories, therefore is not possible to make a pipeline of this 3 phases.
-- First circuit, polynomial_syndrome_computing_n_v2, computes the syndrome from the ciphertext
-- and private keys, support L and polynomial g(x) (In this case g(L)^-1).
-- Second circuit, solving_key_equation_5, computes polynomial sigma through
-- the syndrome computed by first circuit.
-- Third circuit, polynomial_syndrome_computing_n_v2, find the roots of polynomial sigma
-- and correct respective errors in the ciphertext and obtains plaintext array.
-- Inversion circuit, inv_gf_2_m_pipeline, is only used during solving_key_equation_5.
-- This circuit was made outside of solving_key_equation_5 so it can be used by other circuits.
--
-- The circuits parameters
--
--	number_of_polynomial_evaluator_syndrome_pipelines :
--
-- The number of pipelines in polynomial_syndrome_computing_n_v2 circuit.
-- This number can be 1 or greater.
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
-- polynomial_syndrome_computing_n_v2 Rev 1.0
-- solving_key_equation_5 Rev 1.0
-- inv_gf_2_m_pipeline Rev 1.0
-- register_rst_nbits Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mceliece_qd_goppa_decrypt_v4 is
	Generic(
	
		-- GOPPA [2048, 1751, 27, 11] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 4;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 28;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 5;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		number_of_errors : integer := 27;
--		size_number_of_errors : integer := 5
	
		-- GOPPA [2048, 1498, 50, 11] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		number_of_errors : integer := 50;
--		size_number_of_errors : integer := 6

		-- GOPPA [3307, 2515, 66, 12] --
		
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3307;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 66;
--		size_number_of_errors : integer := 7

		-- QD-GOPPA [2528, 2144, 32, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2528;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 32;
--		size_number_of_errors : integer := 6

		-- QD-GOPPA [2816, 2048, 64, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 64;
--		size_number_of_errors : integer := 7

		-- QD-GOPPA [3328, 2560, 64, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3328;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 64;
--		size_number_of_errors : integer := 7

		-- QD-GOPPA [7296, 5632, 128, 13] --
	
		number_of_polynomial_evaluator_syndrome_pipelines : integer := 4;
		polynomial_evaluator_syndrome_pipeline_size : integer := 7;
		polynomial_evaluator_syndrome_size_pipeline_size : integer := 3;
		gf_2_m : integer range 1 to 20 := 13;
		length_codeword : integer := 7296;
		size_codeword : integer := 13;
		number_of_errors : integer := 128;
		size_number_of_errors : integer := 8

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
end mceliece_qd_goppa_decrypt_v4;

architecture Behavioral of mceliece_qd_goppa_decrypt_v4 is

component polynomial_syndrome_computing_n_v2
	Generic (
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
		new_value_syndrome : out STD_LOGIC_VECTOR(((gf_2_m) - 1) downto 0);
		new_value_acc : out STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		new_value_message : out STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
		value_error : out STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0)
	);
end component;

component solving_key_equation_5
	Generic(
		gf_2_m : integer range 1 to 20;
		final_degree : integer;
		size_final_degree : integer
	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		ready_inv : in STD_LOGIC;
		value_s : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_r : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_v : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_u : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_inv : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		signal_inv : out STD_LOGIC;
		key_equation_found : out STD_LOGIC;
		write_enable_s : out STD_LOGIC;
		write_enable_r : out STD_LOGIC;
		write_enable_v : out STD_LOGIC;
		write_enable_u : out STD_LOGIC;
		new_value_inv : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_s : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_v : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_r : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_u : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		address_value_s : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_r : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_v : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_u : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_s : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_r : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_v : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_u : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0)
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

component register_rst_nbits
	Generic(size : integer);
	Port(
		d : in STD_LOGIC_VECTOR((size - 1) downto 0);
		clk : in STD_LOGIC;
		ce : in STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR((size - 1) downto 0);
		q : out STD_LOGIC_VECTOR((size - 1) downto 0)
	);
end component;

signal polynomial_evaluator_syndrome_value_x : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_polynomial_evaluator_syndrome_pipelines) - 1) downto 0);
signal polynomial_evaluator_syndrome_value_acc : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_polynomial_evaluator_syndrome_pipelines) - 1) downto 0);
signal polynomial_evaluator_syndrome_value_polynomial : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal polynomial_evaluator_syndrome_value_message : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal polynomial_evaluator_syndrome_value_h : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_polynomial_evaluator_syndrome_pipelines) - 1) downto 0);
signal polynomial_evaluator_syndrome_mode_polynomial_syndrome : STD_LOGIC;
signal polynomial_evaluator_syndrome_rst : STD_LOGIC;
signal polynomial_evaluator_syndrome_computation_finalized : STD_LOGIC;
signal polynomial_evaluator_syndrome_address_value_polynomial : STD_LOGIC_VECTOR((size_number_of_errors - 1) downto 0);
signal polynomial_evaluator_syndrome_address_value_x : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal polynomial_evaluator_syndrome_address_value_acc : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal polynomial_evaluator_syndrome_address_value_message : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal polynomial_evaluator_syndrome_address_new_value_message : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal polynomial_evaluator_syndrome_address_new_value_acc : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal polynomial_evaluator_syndrome_address_new_value_syndrome : STD_LOGIC_VECTOR((size_number_of_errors) downto 0);
signal polynomial_evaluator_syndrome_address_value_error : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal polynomial_evaluator_syndrome_write_enable_new_value_acc : STD_LOGIC;
signal polynomial_evaluator_syndrome_write_enable_new_value_syndrome : STD_LOGIC;
signal polynomial_evaluator_syndrome_write_enable_new_value_message : STD_LOGIC;
signal polynomial_evaluator_syndrome_write_enable_value_error : STD_LOGIC;
signal polynomial_evaluator_syndrome_new_value_syndrome : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal polynomial_evaluator_syndrome_new_value_acc : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_polynomial_evaluator_syndrome_pipelines) - 1) downto 0);
signal polynomial_evaluator_syndrome_new_value_message : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal polynomial_evaluator_syndrome_value_error : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);

signal syndrome_finalized : STD_LOGIC;

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

signal inv_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal inv_flag : STD_LOGIC;
signal inv_oflag : STD_LOGIC;
signal inv_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

begin

polynomial_evaluator_syndrome : polynomial_syndrome_computing_n_v2
	Generic Map(
		number_of_pipelines => number_of_polynomial_evaluator_syndrome_pipelines,
		pipeline_size => polynomial_evaluator_syndrome_pipeline_size,
		size_pipeline_size => polynomial_evaluator_syndrome_size_pipeline_size,
		gf_2_m => gf_2_m,
		number_of_errors => number_of_errors,
		size_number_of_errors => size_number_of_errors,
		number_of_support_elements => length_codeword,
		size_number_of_support_elements => size_codeword
	)
	Port Map(
		value_x => polynomial_evaluator_syndrome_value_x,
		value_acc => polynomial_evaluator_syndrome_value_acc,
		value_polynomial => polynomial_evaluator_syndrome_value_polynomial,
		value_message => polynomial_evaluator_syndrome_value_message,
		value_h => polynomial_evaluator_syndrome_value_h,
		mode_polynomial_syndrome => polynomial_evaluator_syndrome_mode_polynomial_syndrome,
		clk => clk,
		rst => polynomial_evaluator_syndrome_rst,
		computation_finalized => polynomial_evaluator_syndrome_computation_finalized,
		address_value_polynomial => polynomial_evaluator_syndrome_address_value_polynomial,
		address_value_x => polynomial_evaluator_syndrome_address_value_x,
		address_value_acc => polynomial_evaluator_syndrome_address_value_acc,
		address_value_message => polynomial_evaluator_syndrome_address_value_message,
		address_new_value_message => polynomial_evaluator_syndrome_address_new_value_message,
		address_new_value_acc => polynomial_evaluator_syndrome_address_new_value_acc,
		address_new_value_syndrome => polynomial_evaluator_syndrome_address_new_value_syndrome,
		address_value_error => polynomial_evaluator_syndrome_address_value_error,
		write_enable_new_value_acc => polynomial_evaluator_syndrome_write_enable_new_value_acc,
		write_enable_new_value_syndrome => polynomial_evaluator_syndrome_write_enable_new_value_syndrome,
		write_enable_new_value_message => polynomial_evaluator_syndrome_write_enable_new_value_message,
		write_enable_value_error => polynomial_evaluator_syndrome_write_enable_value_error,
		new_value_syndrome => polynomial_evaluator_syndrome_new_value_syndrome,
		new_value_acc => polynomial_evaluator_syndrome_new_value_acc,
		new_value_message => polynomial_evaluator_syndrome_new_value_message,
		value_error => polynomial_evaluator_syndrome_value_error
	);

solving_key_equation : solving_key_equation_5
	Generic Map(
		gf_2_m => gf_2_m,
		final_degree => number_of_errors,
		size_final_degree => size_number_of_errors
	)
	Port Map(
		clk => clk,
		rst => solving_key_equation_rst,
		ready_inv => inv_oflag,
		value_s => solving_key_equation_value_F,
		value_r => solving_key_equation_value_G,
		value_v => solving_key_equation_value_B,
		value_u => solving_key_equation_value_C,
		value_inv => inv_o,
		signal_inv => inv_flag,
		key_equation_found => solving_key_equation_key_equation_found,
		write_enable_s => solving_key_equation_write_enable_F,
		write_enable_r => solving_key_equation_write_enable_G,
		write_enable_v => solving_key_equation_write_enable_B,
		write_enable_u => solving_key_equation_write_enable_C,
		new_value_inv => inv_a,
		new_value_s => solving_key_equation_new_value_F,
		new_value_v => solving_key_equation_new_value_B,
		new_value_r => solving_key_equation_new_value_G,
		new_value_u => solving_key_equation_new_value_C,
		address_value_s => solving_key_equation_address_value_F,
		address_value_r => solving_key_equation_address_value_G,
		address_value_v => solving_key_equation_address_value_B,
		address_value_u => solving_key_equation_address_value_C,
		address_new_value_s => solving_key_equation_address_new_value_F,
		address_new_value_r => solving_key_equation_address_new_value_G,
		address_new_value_v => solving_key_equation_address_new_value_B,
		address_new_value_u => solving_key_equation_address_new_value_C
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
	
reg_syndrome_finalized : register_rst_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => "1",
		clk => clk,
		ce => polynomial_evaluator_syndrome_computation_finalized,
		rst => rst,
		rst_value => "0",
		q(0) => syndrome_finalized
	);
	
polynomial_evaluator_syndrome_value_x <= value_L;
polynomial_evaluator_syndrome_value_acc <= value_sigma_evaluated;
polynomial_evaluator_syndrome_value_polynomial <= value_sigma;
polynomial_evaluator_syndrome_value_message <= value_codeword;
polynomial_evaluator_syndrome_value_h <= value_h;
polynomial_evaluator_syndrome_mode_polynomial_syndrome <= not syndrome_finalized;
polynomial_evaluator_syndrome_rst <= ( (rst) or (syndrome_finalized and (not solving_key_equation_key_equation_found)));

solving_key_equation_rst <= not syndrome_finalized;
solving_key_equation_value_G <= value_syndrome;
solving_key_equation_value_F <= value_s;
solving_key_equation_value_B <= value_v;
solving_key_equation_value_C <= value_sigma;

syndrome_generation_finalized <= syndrome_finalized or polynomial_evaluator_syndrome_computation_finalized;
key_equation_finalized <= solving_key_equation_key_equation_found;
decryption_finalized <= polynomial_evaluator_syndrome_computation_finalized and solving_key_equation_key_equation_found;

address_value_h <= polynomial_evaluator_syndrome_address_value_acc;
address_value_L <= polynomial_evaluator_syndrome_address_value_x;
address_value_syndrome <= solving_key_equation_address_value_G when syndrome_finalized = '1' else 
									"0" & polynomial_evaluator_syndrome_address_new_value_syndrome;
address_value_codeword <= polynomial_evaluator_syndrome_address_value_message;
address_value_s <= solving_key_equation_address_value_F;
address_value_v <= solving_key_equation_address_value_B;
address_value_sigma <= "00" & polynomial_evaluator_syndrome_address_value_polynomial when solving_key_equation_key_equation_found = '1' else
								solving_key_equation_address_value_C;
address_value_sigma_evaluated <= polynomial_evaluator_syndrome_address_value_acc;

new_value_syndrome <= solving_key_equation_new_value_G when syndrome_finalized = '1' else
								polynomial_evaluator_syndrome_new_value_syndrome;
new_value_s <= solving_key_equation_new_value_F;
new_value_v <= solving_key_equation_new_value_B;
new_value_sigma <= solving_key_equation_new_value_C;
new_value_message <= polynomial_evaluator_syndrome_new_value_message;
new_value_error <= polynomial_evaluator_syndrome_value_error;
new_value_sigma_evaluated <= polynomial_evaluator_syndrome_new_value_acc;

write_enable_new_value_syndrome <= solving_key_equation_write_enable_G when syndrome_finalized = '1' else
								polynomial_evaluator_syndrome_write_enable_new_value_syndrome;
write_enable_new_value_s <= solving_key_equation_write_enable_F;
write_enable_new_value_v <= solving_key_equation_write_enable_B;
write_enable_new_value_sigma <= solving_key_equation_write_enable_C;
write_enable_new_value_message <= polynomial_evaluator_syndrome_write_enable_new_value_message;
write_enable_new_value_error <= polynomial_evaluator_syndrome_write_enable_value_error;
write_enable_new_value_sigma_evaluated <= polynomial_evaluator_syndrome_write_enable_new_value_acc;

address_new_value_syndrome <= solving_key_equation_address_new_value_G when syndrome_finalized = '1' else
									"0" & polynomial_evaluator_syndrome_address_new_value_syndrome;
address_new_value_s <= solving_key_equation_address_new_value_F;
address_new_value_v <= solving_key_equation_address_new_value_B;
address_new_value_sigma <= solving_key_equation_address_new_value_C;
address_new_value_message <= polynomial_evaluator_syndrome_address_new_value_message;
address_new_value_error <= polynomial_evaluator_syndrome_address_value_error;
address_new_value_sigma_evaluated <= polynomial_evaluator_syndrome_address_new_value_acc;

end Behavioral;