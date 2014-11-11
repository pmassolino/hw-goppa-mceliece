----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Tb_Syndrome_Calculator_n_pipe_v5
-- Module Name:    Tb_Syndrome_Calculator_n_pipe_v5
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Test bench for polynomial_syndrome_computing_n_v2 circuit.
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
-- The number of stages the pipeline has. More stages means more values of value_sigma 
-- are tested at once.
--
-- size_pipeline_size :
--
-- The number of bits necessary to store the pipeline_size.
-- This number is ceil(log2(pipeline_size))
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
--	file_memory_L : 
--
-- The file that holds all support elements L. 
-- This is part of the private key of the cryptosystem.
--
-- file_memory_h : 
--
-- The file that holds all inverted evaluations of support elements L in polynomial g.
-- Therefore, g(L)^-1.
-- This is part of the private key of the cryptosystem.
--
-- file_memory_codeword : 
--
-- The file that holds the received ciphertext necessary for computing the syndrome. 
--
-- file_memory_syndrome : 
--
-- The file that holds the syndrome previously computed.
-- This is necessary to be compared with circuit computed syndrome to verify if it worked.
--
-- dump_file_memory_syndrome : 
--
-- The file that will hold the computed syndrome by the circuit.
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- polynomial_syndrome_computing_n_v2 Rev 1.0
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

entity tb_syndrome_calculator_n_pipe_v5 is
	Generic(
		PERIOD : time := 10 ns;

		-- QD-GOPPA [52, 28, 4, 6] --

--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 8;
--		size_pipeline_size : integer := 3;
--		gf_2_m : integer range 1 to 20 := 6;
--		length_codeword : integer := 52;
--		size_codeword : integer := 6;
--		length_syndrome : integer := 8;
--		size_syndrome : integer := 3;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_52_28_4_6.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_52_28_4_6.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_52_28_4_6.dat";
--		file_memory_syndrome : string := "mceliece/data_tests/syndrome_qdgoppa_52_28_4_6.dat";
--		file_memory_g_polynomial : string := "mceliece/data_tests/g_polynomial_qdgoppa_52_28_4_6.dat";
--		dump_file_memory_syndrome : string := "mceliece/data_tests/dump_syndrome_qdgoppa_52_28_4_6.dat"
				
		-- GOPPA [2048, 1751, 27, 11] --

--		number_of_pipelines : integer := 2;
--		pipeline_size : integer := 20;
--		size_pipeline_size : integer := 6;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		length_syndrome : integer := 54;
--		size_syndrome : integer := 6;
--		file_memory_L : string := "mceliece/data_tests/L_goppa_2048_1751_27_11.dat";
--		file_memory_h : string := "mceliece/data_tests/h_goppa_2048_1751_27_11.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_goppa_2048_1751_27_11.dat";
--		file_memory_syndrome : string := "mceliece/data_tests/syndrome_goppa_2048_1751_27_11.dat";
--		file_memory_g_polynomial : string := "mceliece/data_tests/g_polynomial_goppa_2048_1751_27_11.dat";
--		dump_file_memory_syndrome : string := "mceliece/data_tests/dump_syndrome_goppa_2048_1751_27_11.dat"

		-- GOPPA [2048, 1498, 50, 11] --

--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 100;
--		size_pipeline_size : integer := 7;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		length_syndrome : integer := 100;
--		size_syndrome : integer := 7;
--		file_memory_L : string := "mceliece/data_tests/L_goppa_2048_1498_50_11.dat";
--		file_memory_h : string := "mceliece/data_tests/h_goppa_2048_1498_50_11.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_goppa_2048_1498_50_11.dat";
--		file_memory_syndrome : string := "mceliece/data_tests/syndrome_goppa_2048_1498_50_11.dat";
--		file_memory_g_polynomial : string := "mceliece/data_tests/g_polynomial_goppa_2048_1498_50_11.dat";
--		dump_file_memory_syndrome : string := "mceliece/data_tests/dump_syndrome_goppa_2048_1498_50_11.dat"

		-- GOPPA [3307, 2515, 66, 12] --

--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 132;
--		size_pipeline_size : integer := 8;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		length_syndrome : integer := 100;
--		size_syndrome : integer := 7;
--		file_memory_L : string := "mceliece/data_tests/L_goppa_2048_1498_50_11.dat";
--		file_memory_h : string := "mceliece/data_tests/h_goppa_2048_1498_50_11.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_goppa_2048_1498_50_11.dat";
--		file_memory_syndrome : string := "mceliece/data_tests/syndrome_goppa_2048_1498_50_11.dat";
--		file_memory_g_polynomial : string := "mceliece/data_tests/g_polynomial_goppa_2048_1498_50_11.dat";
--		dump_file_memory_syndrome : string := "mceliece/data_tests/dump_syndrome_goppa_2048_1498_50_11.dat"

		-- QD-GOPPA [2528, 2144, 32, 12] --

		number_of_pipelines : integer := 2;
		pipeline_size : integer := 22;
		size_pipeline_size : integer := 6;
		gf_2_m : integer range 1 to 20 := 12;
		length_codeword : integer := 2528;
		size_codeword : integer := 12;
		length_syndrome : integer := 64;
		size_syndrome : integer := 7;
		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_2528_2144_32_12.dat";
		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_2528_2144_32_12.dat";
		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_2528_2144_32_12.dat";
		file_memory_syndrome : string := "mceliece/data_tests/syndrome_qdgoppa_2528_2144_32_12.dat";
		file_memory_g_polynomial : string := "mceliece/data_tests/g_polynomial_qdgoppa_2528_2144_32_12.dat";
		dump_file_memory_syndrome : string := "mceliece/data_tests/dump_syndrome_qdgoppa_2528_2144_32_12.dat"

		-- QD-GOPPA [2816, 2048, 64, 12] --

--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 128;
--		size_pipeline_size : integer := 7;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		length_syndrome : integer := 128;
--		size_syndrome : integer := 7;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_2816_2048_64_12.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_2816_2048_64_12.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_2816_2048_64_12.dat";
--		file_memory_syndrome : string := "mceliece/data_tests/syndrome_qdgoppa_2816_2048_64_12.dat";
--		file_memory_g_polynomial : string := "mceliece/data_tests/g_polynomial_qdgoppa_2816_2048_64_12.dat";
--		dump_file_memory_syndrome : string := "mceliece/data_tests/dump_syndrome_qdgoppa_2816_2048_64_12.dat"

		-- QD-GOPPA [3328, 2560, 64, 12] --

--		number_of_pipelines : integer := 1;
-- 	pipeline_size : integer := 128;
-- 	size_pipeline_size : integer := 7;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3328;
--		size_codeword : integer := 12;
--		length_syndrome : integer := 128;
--		size_syndrome : integer := 7;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_3328_2560_64_12.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_3328_2560_64_12.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_3328_2560_64_12.dat";
--		file_memory_syndrome : string := "mceliece/data_tests/syndrome_qdgoppa_3328_2560_64_12.dat";
--		file_memory_g_polynomial : string := "mceliece/data_tests/g_polynomial_qdgoppa_3328_2560_64_12.dat";
--		dump_file_memory_syndrome : string := "mceliece/data_tests/dump_syndrome_qdgoppa_3328_2560_64_12.dat"

		-- QD-GOPPA [7296, 5632, 128, 13] --

--		number_of_pipelines : integer := 1;
--		pipeline_size : integer := 256;
--		size_pipeline_size : integer := 8;
--		gf_2_m : integer range 1 to 20 := 13;
--		length_codeword : integer := 7296;
--		size_codeword : integer := 13;
--		length_syndrome : integer := 256;
--		size_syndrome : integer := 8;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_7296_5632_128_13.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_7296_5632_128_13.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_7296_5632_128_13.dat";
--		file_memory_syndrome : string := "mceliece/data_tests/syndrome_qdgoppa_7296_5632_128_13.dat";
--		file_memory_g_polynomial : string := "mceliece/data_tests/g_polynomial_qdgoppa_7296_5632_128_13.dat";
--		dump_file_memory_syndrome : string := "mceliece/data_tests/dump_syndrome_qdgoppa_7296_5632_128_13.dat"
	);
end tb_syndrome_calculator_n_pipe_v5;

architecture Behavioral of tb_syndrome_calculator_n_pipe_v5 is

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
		new_value_syndrome : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_acc : out STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
		new_value_message : out STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
		value_error : out STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0)
	);
end component;

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

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC;

signal value_x : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal value_acc : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal value_polynomial : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_message : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
signal value_h : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal mode_polynomial_syndrome : STD_LOGIC;
signal computation_finalized : STD_LOGIC;
signal address_value_polynomial : STD_LOGIC_VECTOR((size_syndrome - 2) downto 0);
signal address_value_x : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal address_value_acc : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal address_value_message : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal address_new_value_message : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal address_new_value_acc : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal address_new_value_syndrome : STD_LOGIC_VECTOR((size_syndrome - 1) downto 0);
signal address_value_error : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal write_enable_new_value_acc : STD_LOGIC;
signal write_enable_new_value_syndrome : STD_LOGIC;
signal write_enable_new_value_message : STD_LOGIC;
signal write_enable_value_error : STD_LOGIC;
signal new_value_syndrome : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_acc : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_pipelines) - 1) downto 0);
signal new_value_message : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);
signal value_error : STD_LOGIC_VECTOR((number_of_pipelines - 1) downto 0);

signal true_address_syndrome : STD_LOGIC_VECTOR((size_syndrome - 1) downto 0);

signal value_syndrome : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal true_value_syndrome : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal error_syndrome : STD_LOGIC;
signal test_syndrome_dump : STD_LOGIC;

signal test_bench_finish : STD_LOGIC := '0';
signal cycle_count : integer range 0 to 2000000000 := 0;

for test_syndrome : ram_double use entity work.ram_double(simple); 
for true_syndrome : ram use entity work.ram(file_load); 

begin

test : polynomial_syndrome_computing_n_v2
	Generic Map(
		number_of_pipelines => number_of_pipelines,
		pipeline_size => pipeline_size,
		size_pipeline_size => size_pipeline_size,
		gf_2_m => gf_2_m,
		number_of_errors => length_syndrome/2,
		size_number_of_errors => size_syndrome - 1,
		number_of_support_elements => length_codeword,
		size_number_of_support_elements => size_codeword
	)
	Port Map(
		value_x => value_x,
		value_acc => value_acc,
		value_polynomial => value_polynomial,
		value_message => value_message,
		value_h => value_h,
		mode_polynomial_syndrome => mode_polynomial_syndrome,
		clk => clk,
		rst => rst,
		computation_finalized => computation_finalized,
		address_value_polynomial => address_value_polynomial,
		address_value_x => address_value_x,
		address_value_acc => address_value_acc,
		address_value_message => address_value_message,
		address_new_value_message => address_new_value_message,
		address_new_value_acc => address_new_value_acc,
		address_new_value_syndrome => address_new_value_syndrome,
		address_value_error => address_value_error,
		write_enable_new_value_acc => write_enable_new_value_acc,
		write_enable_new_value_syndrome => write_enable_new_value_syndrome,
		write_enable_new_value_message => write_enable_new_value_message,
		write_enable_value_error => write_enable_value_error,
		new_value_syndrome => new_value_syndrome,
		new_value_acc => new_value_acc,
		new_value_message => new_value_message,
		value_error => value_error
	);
	
mem_L : entity work.ram_bank(file_load)
	Generic Map(
		number_of_memories => number_of_pipelines, 
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
		address => address_value_x,
		rst_value => (others => '0'),
		data_out => value_x
	);

mem_h : entity work.ram_bank(file_load)
	Generic Map(
		number_of_memories => number_of_pipelines,
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
		address => address_value_acc,
		rst_value => (others => '0'),
		data_out => value_h
	);

mem_acc : entity work.ram_double_bank(simple)
	Generic Map(
		number_of_memories => number_of_pipelines,
		ram_address_size => size_codeword,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => ""
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_acc,
		rw_a => '0',
		rw_b => write_enable_new_value_acc,
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_value_acc,
		address_b => address_new_value_acc,
		rst_value => (others => '0'),
		data_out_a => value_acc,
		data_out_b => open
	);

	
mem_codeword : entity work.ram_bank(file_load)
	Generic Map(
		number_of_memories => number_of_pipelines,
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
		address => address_value_message,
		rst_value => (others => '0'),
		data_out => value_message
	);
	
test_syndrome : ram_double
	Generic Map(
		ram_address_size => size_syndrome,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => dump_file_memory_syndrome
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_syndrome,
		rw_a => '0',
		rw_b => write_enable_new_value_syndrome,
		clk => clk,
		rst => rst,
		dump => test_syndrome_dump,
		address_a => true_address_syndrome,
		address_b => address_new_value_syndrome,
		rst_value => (others => '0'),
		data_out_a => value_syndrome,
		data_out_b => open
	);
	
true_syndrome : ram
	Generic Map(
		ram_address_size => size_syndrome,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => file_memory_syndrome,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => true_address_syndrome,
		rst_value => (others => '0'),
		data_out => true_value_syndrome
	);
	
mode_polynomial_syndrome <= '1';

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
	begin
		true_address_syndrome <= (others => '0');
		rst <= '1';
		error_syndrome <= '0';
		test_syndrome_dump <= '0';
		wait for PERIOD*2;
		rst <= '0';
		wait until computation_finalized = '1';
		report "Circuit finish = " & integer'image((cycle_count - 2)/2) & " cycles";
		wait for PERIOD;
		i := 0;
		while (i < (length_syndrome)) loop
			true_address_syndrome <= std_logic_vector(to_unsigned(i, true_address_syndrome'Length));
			wait for PERIOD*2;
			if (true_value_syndrome = value_syndrome) then
				error_syndrome <= '0';
			else
				error_syndrome <= '1';
				report "Computed values do not match expected ones";
			end if;
			wait for PERIOD;
			error_syndrome <= '0';
			wait for PERIOD;
			i := i + 1;
		end loop;
		wait for PERIOD;
		test_syndrome_dump <= '1';
		wait for PERIOD;
		test_syndrome_dump <= '0';
		test_bench_finish <= '1';
		wait;
end process;

end Behavioral;