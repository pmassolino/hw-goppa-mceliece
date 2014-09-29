----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    McEliece_QD-Goppa_Encrypt
-- Module Name:    McEliece_QD-Goppa_Encrypt
-- Project Name:   McEliece QD-Goppa Encryption
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This circuit does the McEliece encryption with two circuits.
-- First circuit, codeword_generator_n_m_v3, computes the codeword from a given message.
-- Second circuit, error_adder, computes the ciphertext from a given error and codeword.
-- Where the codeword is generated by the previously circuit.
-- Both circuits work independently, but the entire circuit cannot work as a pipeline,
-- where is possible to compute a different codeword and adding the error in previously one.
--
-- The circuits parameters
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
-- Dependencies: 
--
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- codeword_generator_n_m_v3 Rev 1.0
-- error_adder Rev 1.0
--
-- Revision: 
-- Revision 1.00 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mceliece_qd_goppa_encrypt is
	Generic(
	
		-- QD-GOPPA [2528, 2144, 32, 12] --
		
--		number_of_units : integer := 32;
--		length_message : integer := 2144;
--		size_message : integer := 12;
--		length_codeword : integer := 2528;
--		size_codeword : integer := 12;
--		size_number_of_errors : integer := 5;
--		number_dyadic_matrices : integer := 804;
--		size_number_dyadic_matrices : integer := 10
		
		-- QD-GOPPA [2816, 2048, 64, 12] --
		
--		number_of_units : integer := 1; 
--		length_message : integer := 2048;
--		size_message : integer := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		size_number_of_errors : integer := 6;
--		number_dyadic_matrices : integer := 384;
--		size_number_dyadic_matrices : integer := 9

		-- QD-GOPPA [3328, 2560, 64, 12] --
		
--		number_of_units : integer := 1; 
--		length_message : integer := 2560;
--		size_message : integer := 12;
--		length_codeword : integer := 3328;
--		size_codeword : integer := 12;
--		size_number_of_errors : integer := 6;
--		number_dyadic_matrices : integer := 480;
--		size_number_dyadic_matrices : integer := 9

		-- QD-GOPPA [7296, 5632, 128, 13] --
		
		number_of_units : integer := 2; 
		length_message : integer := 5632;
		size_message : integer := 13;
		length_codeword : integer := 7296;
		size_codeword : integer := 13;
		size_number_of_errors : integer := 7;
		number_dyadic_matrices : integer := 572;
		size_number_dyadic_matrices : integer := 10

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
end mceliece_qd_goppa_encrypt;

architecture RTL of mceliece_qd_goppa_encrypt is

component codeword_generator_n_m_v3
	Generic(
		number_of_multipliers_per_acc : integer;
		number_of_accs : integer; 
		length_vector : integer;
		size_vector : integer;
		length_acc : integer;
		size_acc : integer;
		size_dyadic_matrix : integer;
		number_dyadic_matrices : integer;
		size_number_dyadic_matrices : integer
	);
	Port(
		acc : in STD_LOGIC_VECTOR((number_of_accs - 1) downto 0);
		matrix : in STD_LOGIC_VECTOR((2**size_dyadic_matrix - 1) downto 0);
		vector : in STD_LOGIC_VECTOR((number_of_multipliers_per_acc - 1) downto 0);
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		new_acc : out STD_LOGIC_VECTOR((number_of_accs - 1) downto 0);
		new_acc_copy : out STD_LOGIC_VECTOR((number_of_accs - 1) downto 0);
		write_enable_new_acc : out STD_LOGIC;
		write_enable_new_acc_copy : out STD_LOGIC;
		codeword_finalized : out STD_LOGIC;
		address_acc : out STD_LOGIC_VECTOR((size_acc - 1) downto 0);
		address_new_acc_copy : out STD_LOGIC_VECTOR((size_acc - 1) downto 0);
		address_vector : out STD_LOGIC_VECTOR((size_vector - 1) downto 0);
		address_matrix : out STD_LOGIC_VECTOR((size_dyadic_matrix + size_number_dyadic_matrices - 1) downto 0)
	);
end component;

component error_adder
	Generic(
		number_of_units : integer; 
		length_codeword : integer;
		size_codeword : integer
	);
	Port(
		codeword : in STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
		error : in STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		error_added : out STD_LOGIC;
		write_enable_ciphertext : out STD_LOGIC;
		ciphertext : out STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
		address_codeword : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
		address_error : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
		address_ciphertext : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0)
	);
end component;

signal rst_error : STD_LOGIC;

signal generator_ciphertext_1 : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal generator_ciphertext_2 : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal generator_write_enable_ciphertext_1 : STD_LOGIC;
signal generator_write_enable_ciphertext_2 : STD_LOGIC;
signal codeword_finalized : STD_LOGIC;
signal generator_address_codeword : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal generator_address_ciphertext_2 : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal generator_address_message : STD_LOGIC_VECTOR((size_message - 1) downto 0);
signal generator_address_matrix : STD_LOGIC_VECTOR((size_number_of_errors + size_number_dyadic_matrices - 1) downto 0);

signal error_added : STD_LOGIC;
signal error_write_enable_ciphertext : STD_LOGIC;
signal error_ciphertext_2 : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal error_address_codeword : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal error_address_error : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal error_address_ciphertext_2 : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);

begin

generator : codeword_generator_n_m_v3
	Generic Map(
		number_of_multipliers_per_acc => number_of_units,
		number_of_accs => number_of_units,
		length_vector => length_message,
		size_vector => size_message,
		length_acc => length_codeword,
		size_acc => size_codeword,
		size_dyadic_matrix => size_number_of_errors,
		number_dyadic_matrices => number_dyadic_matrices,
		size_number_dyadic_matrices => size_number_dyadic_matrices
	)
	Port Map(
		acc => codeword,
		matrix => matrix,
		vector => message,
		clk => clk,
		rst => rst,
		new_acc => generator_ciphertext_1,
		new_acc_copy => generator_ciphertext_2,
		write_enable_new_acc => generator_write_enable_ciphertext_1,
		write_enable_new_acc_copy => generator_write_enable_ciphertext_2,
		codeword_finalized => codeword_finalized,
		address_acc => generator_address_codeword,
		address_new_acc_copy => generator_address_ciphertext_2,
		address_vector => generator_address_message,
		address_matrix => generator_address_matrix
	);
	
error_add : error_adder
	Generic Map(
		number_of_units => number_of_units,
		length_codeword => length_codeword,
		size_codeword => size_codeword
	)
	Port Map(
		codeword => codeword,
		error => error,
		clk => clk,
		rst => rst_error,
		error_added => error_added,
		write_enable_ciphertext => error_write_enable_ciphertext,
		ciphertext => error_ciphertext_2,
		address_codeword => error_address_codeword,
		address_error => error_address_error,
		address_ciphertext => error_address_ciphertext_2
	);
	
rst_error <= not codeword_finalized;

encryption_finalized <= error_added and codeword_finalized;

write_enable_ciphertext_1 <= '0' when codeword_finalized = '1' else
							 generator_write_enable_ciphertext_1;
write_enable_ciphertext_2 <= error_write_enable_ciphertext when codeword_finalized = '1' else
							 generator_write_enable_ciphertext_2;
ciphertext_1 <= generator_ciphertext_1;
ciphertext_2 <= error_ciphertext_2 when codeword_finalized = '1' else
				generator_ciphertext_2;
address_matrix <= generator_address_matrix;
address_message <= generator_address_message;
address_codeword <= error_address_codeword when codeword_finalized = '1' else
				generator_address_codeword;
address_error <= error_address_error;
address_ciphertext_2 <= error_address_ciphertext_2 when codeword_finalized = '1' else
				generator_address_ciphertext_2;

end RTL;