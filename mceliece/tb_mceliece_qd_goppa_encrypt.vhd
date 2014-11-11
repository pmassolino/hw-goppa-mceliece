----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Tb_McEliece_QD-Goppa_Encrypt
-- Module Name:    Tb_McEliece_QD-Goppa_Encrypt
-- Project Name:   McEliece QD-Goppa Encryption
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This test bench tests mceliece_qd_goppa_encrypt circuit.
-- The test is done only for one value loaded into memories, and in the end the output
-- memories are verified.
--
-- The circuits parameters
--
-- PERIOD :
--
-- Input clock period to be applied on the test. 
--
--	number_of_units :
--
-- The square root of total number of units the codeword_generator will have and the total
-- units the error adder has.
-- The codeword generator has a total number of units = number_of_units^2.
-- This number must be a power of 2 and equal or greater than 1.
--
-- length_message :
--
-- Length in bits of message size and also part of matrix size.
--
-- size_message :
--
-- The number of bits necessary to store the message. The ceil(log2(lenght_message))
--
-- length_codeword :
--
-- Length in bits of codeword size and also part of matrix size.
--
--	size_codeword : 
--
-- The number of bits necessary to store the codeword. The ceil(log2(legth_codeword))
--
--	size_dyadic_matrix :
--
-- The number of bits necessary to store one row of the dyadic matrix.
-- It is also the ceil(log2(number of errors in the code))
--
-- number_dyadic_matrices :
-- 
-- The number of dyadic matrices present in matrix A.
--
-- size_number_dyadic_matrices :
--
-- The number of bits necessary to store the number of dyadic matrices.
-- The ceil(log2(number_dyadic_matrices))
--
--	message_memory_file : 
--
-- File that stores the plaintext that will become the ciphertext.
--
--	error_memory_file :  
--
-- File that stores the error array that will be added to the ciphertext.
--
--	generator_matrix_memory_file : 
--
-- File that holds the public key, matrix A, in a reduced form.
--
--	ciphertext_memory_file : 
--
-- File that holds the expected ciphertext output.
-- This is done so it can be compared in the end with the output 
--
--	dump_ciphertext_memory_file : 
--
-- File that will hold the ciphertext computed by this circuit.
-- 
-- Dependencies: 
--
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- mceliece_qd_goppa_encrypt Rev 1.0
-- ram Rev 1.0
-- ram_bank Rev 1.0
-- ram_double_bank Rev 1.0
--
-- Revision: 
-- Revision 1.00 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_mceliece_qd_goppa_encrypt is
	Generic(
		PERIOD : time := 10 ns;
	
		-- QD-GOPPA [52, 28, 4, 6] --
		
--		number_of_units : integer := 2;
--		length_message : integer := 28;
--		size_message : integer := 5;
--		length_codeword : integer := 52;
--		size_codeword : integer := 6;
--		size_number_of_errors : integer := 2;
--		number_dyadic_matrices : integer := 42;
--		size_number_dyadic_matrices : integer := 6;
--		message_memory_file : string := "mceliece/data_tests/message_qdgoppa_52_28_4_6.dat";
--		error_memory_file : string := "mceliece/data_tests/error_qdgoppa_52_28_4_6.dat";
--		generator_matrix_memory_file : string := "mceliece/data_tests/generator_matrix_qdgoppa_52_28_4_6.dat";
--		ciphertext_memory_file : string := "mceliece/data_tests/ciphertext_qdgoppa_52_28_4_6.dat";
--		dump_ciphertext_memory_file : string := "mceliece/data_tests/dump_ciphertext_qdgoppa_52_28_4_6.dat"
		
	
		-- QD-GOPPA [2528, 2144, 32, 12] --
		
		number_of_units : integer := 32;
		length_message : integer := 2144;
		size_message : integer := 12;
		length_codeword : integer := 2528;
		size_codeword : integer := 12;
		size_number_of_errors : integer := 5;
		number_dyadic_matrices : integer := 804;
		size_number_dyadic_matrices : integer := 10;
		message_memory_file : string := "mceliece/data_tests/message_qdgoppa_2528_2144_32_12.dat";
		error_memory_file : string := "mceliece/data_tests/error_qdgoppa_2528_2144_32_12.dat";
		generator_matrix_memory_file : string := "mceliece/data_tests/generator_matrix_qdgoppa_2528_2144_32_12.dat";
		ciphertext_memory_file : string := "mceliece/data_tests/ciphertext_qdgoppa_2528_2144_32_12.dat";
		dump_ciphertext_memory_file : string := "mceliece/data_tests/dump_ciphertext_qdgoppa_2528_2144_32_12.dat"
		
		-- QD-GOPPA [2816, 2048, 64, 12] --
		
--		number_of_units : integer := 64; 
--		length_message : integer := 2048;
--		size_message : integer := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		size_number_of_errors : integer := 6;
--		number_dyadic_matrices : integer := 384;
--		size_number_dyadic_matrices : integer := 9;
--		message_memory_file : string := "mceliece/data_tests/message_qdgoppa_2816_2048_64_12.dat";
--		error_memory_file : string := "emceliece_data_tests/rror_qdgoppa_2816_2048_64_12.dat";
--		generator_matrix_memory_file : string := "mceliece/data_tests/generator_matrix_qdgoppa_2816_2048_64_12.dat";
--		ciphertext_memory_file : string := "mceliece/data_tests/ciphertext_qdgoppa_2816_2048_64_12.dat";
--		dump_ciphertext_memory_file : string := "mceliece/data_tests/dump_ciphertext_qdgoppa_2816_2048_64_12.dat"

		-- QD-GOPPA [3328, 2560, 64, 12] --
		
--		number_of_units : integer := 8; 
--		length_message : integer := 2560;
--		size_message : integer := 12;
--		length_codeword : integer := 3328;
--		size_codeword : integer := 12;
--		size_number_of_errors : integer := 6;
--		number_dyadic_matrices : integer := 480;
--		size_number_dyadic_matrices : integer := 9;
--		message_memory_file : string := "mceliece/data_tests/message_qdgoppa_3328_2560_64_12.dat";
--		error_memory_file : string := "mceliece/data_tests/error_qdgoppa_3328_2560_64_12.dat";
--		generator_matrix_memory_file : string := "mceliece/data_tests/generator_matrix_qdgoppa_3328_2560_64_12.dat";
--		ciphertext_memory_file : string := "mceliece/data_tests/ciphertext_qdgoppa_3328_2560_64_12.dat";
--		dump_ciphertext_memory_file : string := "mceliece/data_tests/dump_ciphertext_qdgoppa_3328_2560_64_12.dat"

		-- QD-GOPPA [7296, 5632, 128, 13] --
		
--		number_of_units : integer := 64; 
--		length_message : integer := 5632;
--		size_message : integer := 13;
--		length_codeword : integer := 7296;
--		size_codeword : integer := 13;
--		size_number_of_errors : integer := 7;
--		number_dyadic_matrices : integer := 572;
--		size_number_dyadic_matrices : integer := 10;
--		message_memory_file : string := "mceliece/data_tests/message_qdgoppa_7296_5632_128_13.dat";
--		error_memory_file : string := "mceliece/data_tests/error_qdgoppa_7296_5632_128_13.dat";
--		generator_matrix_memory_file : string := "mceliece/data_tests/generator_matrix_qdgoppa_7296_5632_128_13.dat";
--		ciphertext_memory_file : string := "mceliece/data_tests/ciphertext_qdgoppa_7296_5632_128_13.dat";
--		dump_ciphertext_memory_file : string := "mceliece/data_tests/dump_ciphertext_qdgoppa_7296_5632_128_13.dat"
		
	);
end tb_mceliece_qd_goppa_encrypt;

architecture Behavioral of tb_mceliece_qd_goppa_encrypt is

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

component mceliece_qd_goppa_encrypt
	Generic(
		number_of_units : integer; 
		length_message : integer;
		size_message : integer;
		length_codeword : integer;
		size_codeword : integer;
		size_number_of_errors : integer;
		number_dyadic_matrices : integer;
		size_number_dyadic_matrices : integer
	);
	Port(
		message : in STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
		matrix : in STD_LOGIC_VECTOR((2**size_number_of_errors - 1) downto 0);
		codeword : in STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
		error : in STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		encryption_finalized : out STD_LOGIC;
		write_enable_ciphertext_1 : out STD_LOGIC;
		write_enable_ciphertext_2 : out STD_LOGIC;
		ciphertext_1 : out STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
		ciphertext_2 : out STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
		address_matrix : out STD_LOGIC_VECTOR((size_number_of_errors + size_number_dyadic_matrices - 1) downto 0);
		address_message : out STD_LOGIC_VECTOR((size_message - 1) downto 0);
		address_codeword : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
		address_error : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
		address_ciphertext_2 : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0)
	);
end component;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC;

signal message : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal matrix : STD_LOGIC_VECTOR((2**size_number_of_errors - 1) downto 0);
signal test_codeword : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal error : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal encryption_finalized : STD_LOGIC;
signal test_write_enable_ciphertext_1 : STD_LOGIC;
signal test_write_enable_ciphertext_2 : STD_LOGIC;
signal test_ciphertext_1 : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal test_ciphertext_2 : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal address_matrix : STD_LOGIC_VECTOR((size_number_of_errors + size_number_dyadic_matrices - 1) downto 0);
signal address_message : STD_LOGIC_VECTOR((size_message - 1) downto 0);
signal test_address_codeword : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal address_error : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal test_address_ciphertext_2 : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);

signal address_codeword : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal true_address_ciphertext : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal true_ciphertext : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);

signal test_error : STD_LOGIC;

signal dump_test_ciphertext : STD_LOGIC;

signal test_bench_finish : STD_LOGIC := '0';
signal cycle_count : integer range 0 to 2000000000 := 0;

for message_mem : ram_bank use entity work.ram_bank(file_load);
for error_mem : ram_bank use entity work.ram_bank(file_load);
for test_ciphertext_mem : ram_double_bank use entity work.ram_double_bank(simple);
for true_ciphertext_mem : ram_bank use entity work.ram_bank(file_load);
for generator_matrix : ram_bank use entity work.ram_bank(file_load);

begin

encrypt : mceliece_qd_goppa_encrypt
	Generic Map(
		number_of_units => number_of_units,
		length_message => length_message,
		size_message => size_message,
		length_codeword => length_codeword,
		size_codeword => size_codeword,
		size_number_of_errors => size_number_of_errors,
		number_dyadic_matrices => number_dyadic_matrices,
		size_number_dyadic_matrices => size_number_dyadic_matrices
	)
	Port Map(
		message => message,
		matrix => matrix,
		codeword => test_codeword,
		error => error,
		clk => clk,
		rst => rst,
		encryption_finalized => encryption_finalized,
		write_enable_ciphertext_1 => test_write_enable_ciphertext_1,
		write_enable_ciphertext_2 => test_write_enable_ciphertext_2,
		ciphertext_1 => test_ciphertext_1,
		ciphertext_2 => test_ciphertext_2,
		address_matrix => address_matrix, 
		address_message => address_message,
		address_codeword => test_address_codeword,
		address_error => address_error,
		address_ciphertext_2 => test_address_ciphertext_2
	);
	
message_mem : ram_bank
	Generic Map(
		number_of_memories => number_of_units,
		ram_address_size => size_message,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => message_memory_file,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw  => '0',
		clk  => clk,
		rst  => rst,
		dump  => '0',
		address  => address_message,
		rst_value  => "0",
		data_out  => message
	);
	
error_mem : ram_bank
	Generic Map(
		number_of_memories => number_of_units,
		ram_address_size => size_codeword,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => error_memory_file,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => address_error,
		rst_value => "0",
		data_out => error
	);

test_ciphertext_mem : ram_double_bank
	Generic Map(
		number_of_memories => number_of_units,
		ram_address_size => size_codeword,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => "",
		dump_file_name => dump_ciphertext_memory_file
	)
	Port Map(
		data_in_a => test_ciphertext_1,
		data_in_b => test_ciphertext_2,
		rw_a => test_write_enable_ciphertext_1,
		rw_b => test_write_enable_ciphertext_2,
		clk => clk,
		rst => rst,
		dump => dump_test_ciphertext,
		address_a => address_codeword,
		address_b => test_address_ciphertext_2,
		rst_value => "0",
		data_out_a => test_codeword,
		data_out_b => open
	);
	
true_ciphertext_mem : ram_bank
	Generic Map(
		number_of_memories => number_of_units,
		ram_address_size => size_codeword,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => ciphertext_memory_file,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => true_address_ciphertext,
		rst_value => "0",
		data_out => true_ciphertext
	);
	
generator_matrix : ram_bank
	Generic Map(
		number_of_memories => 2**size_number_of_errors,
		ram_address_size => size_number_of_errors + size_number_dyadic_matrices,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => generator_matrix_memory_file,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => address_matrix,
		rst_value => "0",
		data_out => matrix
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
	
address_codeword <= true_address_ciphertext when encryption_finalized = '1' else test_address_codeword;
	
process
	variable i : integer; 
	begin
		true_address_ciphertext <= (others => '0');
		rst <= '1';
		test_error <= '0';
		dump_test_ciphertext <= '0';
		wait for PERIOD*2;
		rst <= '0';
		wait until encryption_finalized = '1';
		report "Circuit finish = " & integer'image((cycle_count - 2)/2) & " cycles";
		wait for PERIOD;
		i := 0;
		while (i < (length_codeword)) loop
			true_address_ciphertext <= std_logic_vector(to_unsigned(i, true_address_ciphertext'Length));
			wait for PERIOD*2;
			if (true_ciphertext = test_codeword) then
				test_error <= '0';
			else
				test_error <= '1';
				report "Computed values do not match expected ones";
			end if;
			wait for PERIOD;
			test_error <= '0';
			wait for PERIOD;
			i := i + number_of_units;
		end loop;
		dump_test_ciphertext <= '1';
		wait for PERIOD;
		dump_test_ciphertext <= '0';
		test_bench_finish <= '1';
		wait;
end process;

end Behavioral;

