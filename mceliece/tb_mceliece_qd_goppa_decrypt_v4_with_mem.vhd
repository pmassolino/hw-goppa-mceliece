----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Tb_McEliece_QD-Goppa_Decrypt_v4
-- Module Name:    Tb_McEliece_QD-Goppa_Decrypt_v4
-- Project Name:   McEliece Goppa Decryption
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This test bench tests mceliece_qd_goppa_decrypt_v4 circuit.
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
-- This number can be 1 or greater, but only power of 2.
--
-- log2_number_of_polynomial_evaluator_syndrome_pipelines :
--
-- This is the log2 of the number_of_polynomial_evaluator_syndrome_pipelines.
-- This is ceil(log2(number_of_polynomial_evaluator_syndrome_pipelines))
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
-- mceliece_qd_goppa_decrypt_with_mem_v4 Rev 1.0
-- ram_bank Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.TEXTIO.ALL;

entity tb_mceliece_qd_goppa_decrypt_v4_with_mem is
	Generic(
		PERIOD : time := 10 ns;
		
		-- QD-GOPPA [52, 28, 4, 6] --
	
		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
		gf_2_m : integer range 1 to 20 := 6;
		length_codeword : integer := 52;
		size_codeword : integer := 6;
		number_of_errors : integer := 4;
		size_number_of_errors : integer := 3;
		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_52_28_4_6.dat";
		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_52_28_4_6.dat";
		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_52_28_4_6.dat";
		file_memory_message : string := "mceliece/data_tests/plaintext_qdgoppa_52_28_4_6.dat";
		file_memory_error : string := "mceliece/data_tests/error_qdgoppa_52_28_4_6.dat"
	
		-- GOPPA [2048, 1751, 27, 11] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
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
--      log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
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
		
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--    log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3307;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 66;
--		size_number_of_errors : integer := 7;
--		file_memory_L : string := "mceliece/data_tests/L_goppa_3307_2515_66_12.dat";
--		file_memory_h : string := "mceliece/data_tests/h_goppa_3307_2515_66_12.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_goppa_3307_2515_66_12.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_goppa_3307_2515_66_12.dat";
--		file_memory_error : string := "mceliece/data_tests/error_goppa_3307_2515_66_12.dat"
		
		-- QD-GOPPA [2528, 2144, 32, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
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

		-- QD-GOPPA [1792, 1088, 64, 11] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--    log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 1792;
--		size_codeword : integer := 11;
--		number_of_errors : integer := 64;
--		size_number_of_errors : integer := 7;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_1792_1088_64_11.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_1792_1088_64_11.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_1792_1088_64_11.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_qdgoppa_1792_1088_64_11.dat";
--		file_memory_error : string := "mceliece/data_tests/error_qdgoppa_1792_1088_64_11.dat"

		-- QD-GOPPA [2816, 2048, 64, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--    log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
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

		-- QD-GOPPA [4096, 2048, 128, 16] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--    log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 16;
--		length_codeword : integer := 4096;
--		size_codeword : integer := 12;
--		number_of_errors : integer := 128;
--		size_number_of_errors : integer := 8;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_4096_2048_128_16.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_4096_2048_128_16.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_4096_2048_128_16.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_qdgoppa_4096_2048_128_16.dat";
--		file_memory_error : string := "mceliece/data_tests/error_qdgoppa_4096_2048_128_16.dat"

		-- QD-GOPPA [3328, 2560, 64, 12] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--    log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
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

		-- QD-GOPPA [6144, 2560, 256, 14] --
	
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
--		gf_2_m : integer range 1 to 20 := 14;
--		length_codeword : integer := 6144;
--		size_codeword : integer := 13;
--		number_of_errors : integer := 256;
--		size_number_of_errors : integer := 9;
--		file_memory_L : string := "mceliece/data_tests/L_qdgoppa_6144_2560_256_14.dat";
--		file_memory_h : string := "mceliece/data_tests/h_qdgoppa_6144_2560_256_14.dat";
--		file_memory_codeword : string := "mceliece/data_tests/ciphertext_qdgoppa_6144_2560_256_14.dat";
--		file_memory_message : string := "mceliece/data_tests/plaintext_qdgoppa_6144_2560_256_14.dat";
--		file_memory_error : string := "mceliece/data_tests/error_qdgoppa_6144_2560_256_14.dat"

		-- QD-GOPPA [7296, 5632, 128, 13] --
		
--		number_of_polynomial_evaluator_syndrome_pipelines : integer := 1;
--    log2_number_of_polynomial_evaluator_syndrome_pipelines : integer := 0;
--		polynomial_evaluator_syndrome_pipeline_size : integer := 2;
--		polynomial_evaluator_syndrome_size_pipeline_size : integer := 2;
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
end tb_mceliece_qd_goppa_decrypt_v4_with_mem;

architecture Behavioral of tb_mceliece_qd_goppa_decrypt_v4_with_mem is

component mceliece_qd_goppa_decrypt_v4_with_mem
	Generic(
		number_of_polynomial_evaluator_syndrome_pipelines : integer;
		log2_number_of_polynomial_evaluator_syndrome_pipelines : integer;
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
		load_address_mem : in STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		load_sel_mem : in STD_LOGIC_VECTOR(1 downto 0);
		load_write_value_mem : in STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		load_write_enable_mem : in STD_LOGIC;
		load_read_value_mem : out STD_LOGIC_VECTOR((2*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
		syndrome_generation_finalized : out STD_LOGIC;
		key_equation_finalized : out STD_LOGIC;
		decryption_finalized : out STD_LOGIC
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

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC;
signal load_address_mem : STD_LOGIC_VECTOR((size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal load_sel_mem : STD_LOGIC_VECTOR(1 downto 0);
signal load_write_value_mem : STD_LOGIC_VECTOR((gf_2_m*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal load_write_enable_mem : STD_LOGIC;
signal load_read_value_mem : STD_LOGIC_VECTOR((2*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal syndrome_generation_finalized : STD_LOGIC;
signal key_equation_finalized : STD_LOGIC;
signal decryption_finalized : STD_LOGIC;

signal true_value_error : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal true_value_message : STD_LOGIC_VECTOR((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);
signal true_address_value_error_message : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal true_value_error_message : STD_LOGIC_VECTOR((2*number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0);

signal error_value_error_message : STD_LOGIC;

signal test_bench_finish : STD_LOGIC := '0';
signal cycle_count : integer range 0 to 2000000000 := 0;

pure function read_value_file (file memory_file : text; constant word_size : integer; constant number_of_words : integer) return STD_LOGIC_VECTOR is                                                   
	variable line_n : line;                                 
	variable value_buffer : std_logic_vector((number_of_words*word_size - 1) downto 0);
	variable file_read_buffer : std_logic_vector((word_size - 1) downto 0);
	variable value_buffer_amount : integer;
   begin                                 
		value_buffer_amount := 0;
		while ((value_buffer_amount /= (word_size*number_of_words)) and (not endfile(memory_file))) loop
			readline (memory_file, line_n);                             
			read (line_n, file_read_buffer);
			value_buffer((value_buffer_amount + word_size - 1) downto value_buffer_amount) := file_read_buffer;
			value_buffer_amount := value_buffer_amount + word_size;
		end loop;
		while (value_buffer_amount /= (word_size*number_of_words)) loop	
			value_buffer((value_buffer_amount + word_size - 1) downto value_buffer_amount) := (others => '0');
			value_buffer_amount := value_buffer_amount + word_size;
		end loop;
		return value_buffer;
end function; 

begin

test : mceliece_qd_goppa_decrypt_v4_with_mem
	Generic Map(
		number_of_polynomial_evaluator_syndrome_pipelines => number_of_polynomial_evaluator_syndrome_pipelines,
		log2_number_of_polynomial_evaluator_syndrome_pipelines => log2_number_of_polynomial_evaluator_syndrome_pipelines,
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
		load_address_mem => load_address_mem,
		load_sel_mem => load_sel_mem,
		load_write_value_mem => load_write_value_mem,
		load_write_enable_mem => load_write_enable_mem,
		load_read_value_mem => load_read_value_mem,
		syndrome_generation_finalized => syndrome_generation_finalized,
		key_equation_finalized => key_equation_finalized,
		decryption_finalized => decryption_finalized
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
		address => true_address_value_error_message,
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
		address => true_address_value_error_message,
		rst_value => (others => '0'),
		data_out => true_value_error
	);
	
true_value_error_message <= true_value_error & true_value_message;
	
clock : process
begin
while ( test_bench_finish /= '1') loop
	clk <= not clk;
	wait for PERIOD/2;
	cycle_count <= cycle_count+1;
end loop;
wait;
end process;

process
	FILE memory_L : text is in file_memory_L;
	FILE memory_h : text is in file_memory_h;
	FILE memory_codeword : text is in file_memory_codeword;
	variable i : integer; 
	variable loading_cycle_count : integer range 0 to 2000000000 := 0;
	variable syndrome_cycle_count : integer range 0 to 2000000000 := 0;
	variable key_equation_cycle_count : integer range 0 to 2000000000 := 0;
	variable correct_errors_cycle_count : integer range 0 to 2000000000 := 0;
	begin
		true_address_value_error_message <= (others => '0');
		rst <= '1';
		error_value_error_message <= '0';
		wait for PERIOD*2;
		i := 0;
		load_sel_mem <= "00"; -- Load private key L
		while (i < (length_codeword)) loop 
			load_address_mem <= std_logic_vector(to_unsigned(i/number_of_polynomial_evaluator_syndrome_pipelines, size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines));
			load_write_value_mem <= read_value_file(memory_L, gf_2_m, number_of_polynomial_evaluator_syndrome_pipelines);
			load_write_enable_mem <= '0';
			wait for PERIOD;
			load_write_enable_mem <= '1';
			i := i + number_of_polynomial_evaluator_syndrome_pipelines;
			wait for PERIOD;
		end loop;
		load_write_enable_mem <= '0';
		file_close(memory_L);
		wait for PERIOD*2;
		i := 0;
		load_sel_mem <= "01"; -- Load private key h
		while (i < (length_codeword)) loop 
			load_address_mem <= std_logic_vector(to_unsigned(i/number_of_polynomial_evaluator_syndrome_pipelines, size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines));
			load_write_value_mem <= read_value_file(memory_h, gf_2_m, number_of_polynomial_evaluator_syndrome_pipelines);
			load_write_enable_mem <= '0';
			wait for PERIOD;
			load_write_enable_mem <= '1';
			i := i + number_of_polynomial_evaluator_syndrome_pipelines;
			wait for PERIOD;
		end loop;
		load_write_enable_mem <= '0';
		file_close(memory_h);
		wait for PERIOD*2;
		i := 0;
		load_write_value_mem <= (others => '0');
		load_sel_mem <= "10"; -- Load ciphertext
		while (i < (length_codeword)) loop 
			load_address_mem <= std_logic_vector(to_unsigned(i/number_of_polynomial_evaluator_syndrome_pipelines, size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines));
			load_write_value_mem((number_of_polynomial_evaluator_syndrome_pipelines - 1) downto 0) <= read_value_file(memory_codeword, 1, number_of_polynomial_evaluator_syndrome_pipelines);
			load_write_enable_mem <= '0';
			wait for PERIOD;
			load_write_enable_mem <= '1';
			i := i + number_of_polynomial_evaluator_syndrome_pipelines;
			wait for PERIOD;
		end loop;
		load_write_enable_mem <= '0';
		file_close(memory_codeword);
		wait for PERIOD*2;
		rst <= '0';
		loading_cycle_count := cycle_count;
		wait until syndrome_generation_finalized = '1';
		syndrome_cycle_count := cycle_count - loading_cycle_count;
		report "Circuit finish Syndrome = " & integer'image(syndrome_cycle_count/2) & " cycles";
		wait until key_equation_finalized = '1';
		key_equation_cycle_count := cycle_count - syndrome_cycle_count - loading_cycle_count;
		report "Circuit finish Key Equation = " & integer'image(key_equation_cycle_count/2) & " cycles";
		wait until decryption_finalized = '1';
		correct_errors_cycle_count := cycle_count - key_equation_cycle_count - syndrome_cycle_count - loading_cycle_count;
		report "Circuit finish Correct Errors = " & integer'image(correct_errors_cycle_count/2) & " cycles";
		report "Circuit finish = " & integer'image((cycle_count - loading_cycle_count)/2) & " cycles";
		wait for PERIOD;
		i := 0;
		load_sel_mem <= "11";
		rst <= '1';
		wait for PERIOD;
		while (i < (length_codeword)) loop
			true_address_value_error_message(size_codeword - 1 downto 0) <= std_logic_vector(to_unsigned(i, size_codeword));
			load_address_mem <= std_logic_vector(to_unsigned(i/number_of_polynomial_evaluator_syndrome_pipelines, size_codeword - log2_number_of_polynomial_evaluator_syndrome_pipelines));
			wait for (PERIOD*3);
			if (true_value_error_message = load_read_value_mem) then
				error_value_error_message <= '0';
			else
				error_value_error_message <= '1';
				report "Computed values do not match expected ones";
			end if;
			wait for PERIOD;
			error_value_error_message <= '0';
			wait for PERIOD;
			i := i + number_of_polynomial_evaluator_syndrome_pipelines;
		end loop;
		wait for PERIOD;
		test_bench_finish <= '1';
	wait;
end process;

end Behavioral;

