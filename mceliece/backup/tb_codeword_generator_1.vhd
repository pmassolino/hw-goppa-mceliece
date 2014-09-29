----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Tb_Codeword Generator 1
-- Module Name:    Tb_Codeword_Generator_1
-- Project Name:   McEliece QD-Goppa Encoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Test bench for codeword_generator_1 circuit.
--
-- The circuits parameters
--
-- PERIOD : 
--
-- Input clock period to be applied on the test. 
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
-- The number of bits necessary to store the codeword. The ceil(log2(length_codeword))
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
-- message_memory_file : 
--
-- File that holds the message to be encoded.
--
--	codeword_memory_file : 
--
-- File that holds the encoded message.
-- This will be used to verify if the circuit worked correctly.
--
--	generator_matrix_memory_file : 
--
-- File that holds the public key, matrix A, in a reduced form.
--
--	dump_test_codeword_file : 
--
-- File that will hold the encoded message computed by the circuit.
--
-- 
-- Dependencies: 
--
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- codeword_generator_1 Rev 1.0
-- ram Rev 1.0
--
-- Revision: 
-- Revision 1.00 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_codeword_generator_1 is
Generic (
		PERIOD : time := 10 ns;
		
		-- QD-GOPPA [52, 28, 4, 6] --

--		length_message : integer := 28;
--		size_message : integer := 5;
--		length_codeword : integer := 52;
--		size_codeword : integer := 6;
--		size_dyadic_matrix : integer := 2;
--		number_dyadic_matrices : integer := 42;
--		size_number_dyadic_matrices : integer := 6;
--		message_memory_file : string := "mceliece\data_tests\message_qdgoppa_52_28_4_6.dat";
--		codeword_memory_file : string := "mceliece\data_tests\plaintext_qdgoppa_52_28_4_6.dat";
--		generator_matrix_memory_file : string := "mceliece\data_tests\generator_matrix_qdgoppa_52_28_4_6.dat";
--		dump_test_codeword_file : string := "mceliece\data_tests\dump_plaintext_qdgoppa_52_28_4_6.dat"
		
		-- QD-GOPPA [2528, 2144, 32, 12] --
		
		length_message : integer := 2144;
		size_message : integer := 12;
		length_codeword : integer := 2528;
		size_codeword : integer := 12;
		size_dyadic_matrix : integer := 5;
		number_dyadic_matrices : integer := 804;
		size_number_dyadic_matrices : integer := 10;
		message_memory_file : string := "mceliece\data_tests\message_qdgoppa_2528_2144_32_12.dat";
		codeword_memory_file : string := "mceliece\data_tests\plaintext_qdgoppa_2528_2144_32_12.dat";
		generator_matrix_memory_file : string := "mceliece\data_tests\generator_matrix_qdgoppa_2528_2144_32_12.dat";
		dump_test_codeword_file : string := "mceliece\data_tests\dump_plaintext_qdgoppa_2528_2144_32_12.dat"

		-- QD-GOPPA [2816, 2048, 64, 12] --
		
--		length_message : integer := 2048;
--		size_message : integer := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		size_dyadic_matrix : integer := 6;
--		number_dyadic_matrices : integer := 384;
--		size_number_dyadic_matrices : integer := 9;
--		message_memory_file : string := "mceliece\data_tests\message_qdgoppa_2816_2048_64_12.dat";
--		codeword_memory_file : string := "mceliece\data_tests\plaintext_qdgoppa_2816_2048_64_12.dat";
--		generator_matrix_memory_file : string := "mceliece\data_tests\generator_matrix_qdgoppa_2816_2048_64_12.dat";
--		dump_test_codeword_file : string := "mceliece\data_tests\dump_plaintext_qdgoppa_2816_2048_64_12.dat"

		-- QD-GOPPA [3328, 2560, 64, 12] --
		
--		length_message : integer := 2560;
--		size_message : integer := 12;
--		length_codeword : integer := 3328;
--		size_codeword : integer := 12;
--		size_dyadic_matrix : integer := 6;
--		number_dyadic_matrices : integer := 480;
--		size_number_dyadic_matrices : integer := 9;
--		message_memory_file : string := "mceliece\data_tests\message_qdgoppa_3328_2560_64_12.dat";
--		codeword_memory_file : string := "mceliece\data_tests\plaintext_qdgoppa_3328_2560_64_12.dat";
--		generator_matrix_memory_file : string := "mceliece\data_tests\generator_matrix_qdgoppa_3328_2560_64_12.dat";
--		dump_test_codeword_file : string := "mceliece\data_tests\dump_plaintext_qdgoppa_3328_2560_64_12.dat"

		-- QD-GOPPA [7296, 5632, 128, 13] --
 
--		length_message : integer := 5632;
--		size_message : integer := 13;
--		length_codeword : integer := 7296;
--		size_codeword : integer := 13;
--		size_dyadic_matrix : integer := 7;
--		number_dyadic_matrices : integer := 572;
--		size_number_dyadic_matrices : integer := 10;
--		message_memory_file : string := "mceliece\data_tests\message_qdgoppa_7296_5632_128_13.dat";
--		codeword_memory_file : string := "mceliece\data_tests\plaintext_qdgoppa_7296_5632_128_13.dat";
--		generator_matrix_memory_file : string := "mceliece\data_tests\generator_matrix_qdgoppa_7296_5632_128_13.dat";
--		dump_test_codeword_file : string := "mceliece\data_tests\dump_plaintext_qdgoppa_7296_5632_128_13.dat"


);
end tb_codeword_generator_1;

architecture Behavioral of tb_codeword_generator_1 is

component codeword_generator_1
	Generic(
		length_message : integer;
		size_message : integer;
		length_codeword : integer;
		size_codeword : integer;
		size_dyadic_matrix : integer;
		number_dyadic_matrices : integer;
		size_number_dyadic_matrices : integer
	);
	Port(
		codeword : in STD_LOGIC;
		matrix : in STD_LOGIC;
		message : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		new_codeword : out STD_LOGIC;
		write_enable_new_codeword : out STD_LOGIC;
		codeword_finalized : out STD_LOGIC;
		address_codeword : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
		address_message : out STD_LOGIC_VECTOR((size_message - 1) downto 0);
		address_matrix : out STD_LOGIC_VECTOR((size_dyadic_matrix + size_number_dyadic_matrices  - 1) downto 0)
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

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC;

signal codeword : STD_LOGIC;
signal matrix : STD_LOGIC;
signal message : STD_LOGIC;
signal new_codeword : STD_LOGIC;
signal write_enable_new_codeword : STD_LOGIC;
signal codeword_finalized : STD_LOGIC;
signal address_codeword : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal address_message : STD_LOGIC_VECTOR((size_message - 1) downto 0);
signal address_matrix : STD_LOGIC_VECTOR((size_dyadic_matrix + size_number_dyadic_matrices  - 1) downto 0);

signal test_address_acc : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal final_address_acc : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal true_acc : STD_LOGIC;
signal error : STD_LOGIC;
signal dump_test_codeword : STD_LOGIC;

signal test_bench_finish : STD_LOGIC := '0';
signal cycle_count : integer range 0 to 2000000000 := 0;

for message_memory : ram use entity work.ram(file_load); 
for generator_matrix_memory : ram use entity work.ram(file_load); 
for test_codeword_memory : ram use entity work.ram(simple); 
for true_codeword_memory : ram use entity work.ram(file_load); 

begin

test : codeword_generator_1
	Generic Map(
		length_message => length_message,
		size_message => size_message,
		length_codeword => length_codeword,
		size_codeword => size_codeword,
		size_dyadic_matrix => size_dyadic_matrix,
		number_dyadic_matrices => number_dyadic_matrices,
		size_number_dyadic_matrices => size_number_dyadic_matrices
	)
	Port Map(
		codeword => codeword,
		matrix => matrix,
		message => message,
		clk => clk,
		rst => rst,
		new_codeword => new_codeword,
		write_enable_new_codeword => write_enable_new_codeword,
		codeword_finalized => codeword_finalized,
		address_codeword => address_codeword,
		address_message => address_message,
		address_matrix => address_matrix
	);
	
message_memory : ram
	Generic Map(
		ram_address_size => size_message,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => message_memory_file,
		dump_file_name => ""
	)
	Port Map(
		data_in => "0",
		rw  => '0',
		clk  => clk,
		rst  => rst,
		dump  => '0',
		address  => address_message,
		rst_value  => "0",
		data_out(0)  => message
	);
	
generator_matrix_memory : ram
		Generic Map(
		ram_address_size => size_dyadic_matrix + size_number_dyadic_matrices,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => generator_matrix_memory_file,
		dump_file_name => ""
	)
	Port Map(
		data_in => "0",
		rw  => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => address_matrix,
		rst_value => "0",
		data_out(0) => matrix
	);

test_codeword_memory : ram
	Generic Map(
		ram_address_size => size_codeword,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => "",
		dump_file_name => dump_test_codeword_file
	)
	Port Map(
		data_in(0) => new_codeword,
		rw => write_enable_new_codeword,
		clk => clk,
		rst => rst,
		dump => dump_test_codeword,
		address => final_address_acc,
		rst_value => "0",
		data_out(0) => codeword
	);

true_codeword_memory : ram
	Generic Map(
		ram_address_size => size_codeword,
		ram_word_size => 1,
		file_ram_word_size => 1,
		load_file_name => codeword_memory_file,
		dump_file_name => ""
	)
	Port Map(
		data_in => "0",
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => final_address_acc,
		rst_value => "0",
		data_out(0) => true_acc
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

final_address_acc <= address_codeword when codeword_finalized = '0' else test_address_acc;

process
	variable i : integer; 
	begin
		test_address_acc <= (others => '0');
		rst <= '1';
		error <= '0';
		dump_test_codeword <= '0';
		wait for PERIOD*2;
		rst <= '0';
		wait until codeword_finalized = '1';
		report "Circuit finish = " & integer'image(cycle_count/2) & " cycles";
		wait for PERIOD;
		i := 0;
		while (i < (length_codeword)) loop
			test_address_acc <= std_logic_vector(to_unsigned(i, test_address_acc'Length));
			wait for PERIOD*2;
			if (true_acc = codeword) then
				error <= '0';
			else
				error <= '1';
				report "Computed values do not match expected ones";
			end if;
			wait for PERIOD;
			error <= '0';
			wait for PERIOD;
			i := i + 1;
		end loop;
		dump_test_codeword <= '1';
		wait for PERIOD;
		dump_test_codeword <= '0';
		test_bench_finish <= '1';
		wait;
end process;

end Behavioral;

