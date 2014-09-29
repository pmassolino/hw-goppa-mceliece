----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Codeword Generator 1
-- Module Name:    Codeword_Generator_1
-- Project Name:   McEliece QD-Goppa Encoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The first and only step in QD-Goppa Code encoding. 
-- This circuit transforms an k-bit message into a valid n-bit codeword.
-- The transformation is an multiplication of a message of k-bits by the 
-- Generator matrix G. The Generator matrix is composed of Identity Matrix and
-- another matrix A. For this reason the first k bits of the codeword are equal 
-- to the message, only the last n-k bits are computed. This circuit works only
-- only for QD-Goppa codes, where matrix A is composed of dyadic matrices and
-- can be stored only by the first row of each dyadic matrix.
-- Matrix A is supposed to be stored with a word of 1 bit and each dyadic matrix row
-- followed by each one, in a row-wise pattern.
--
-- This circuit process one bit at time, each is more than 1 cycle.
-- This circuit is inefficient and only a proof of concept for n_m version.
--
-- The circuits parameters
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
-- Dependencies: 
--
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- controller_codeword_generator_1 Rev 1.0
-- register_nbits Rev 1.0
-- register_rst_nbits Rev 1.0
-- counter_rst_nbits Rev 1.0
-- counter_rst_set_nbits Rev 1.0
--
-- Revision: 
-- Revision 1.00 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity codeword_generator_1 is
	Generic(

		-- QD-GOPPA [2528, 2144, 32, 12] --
		
		length_message : integer := 2144;
		size_message : integer := 12;
		length_codeword : integer := 2528;
		size_codeword : integer := 12;
		size_dyadic_matrix : integer := 5;
		number_dyadic_matrices : integer := 804;
		size_number_dyadic_matrices : integer := 10
		
		-- QD-GOPPA [2816, 2048, 64, 12] --
		
--		length_message : integer := 2048;
--		size_message : integer := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		size_dyadic_matrix : integer := 6;
--		number_dyadic_matrices : integer := 384;
--		size_number_dyadic_matrices : integer := 9

		-- QD-GOPPA [3328, 2560, 64, 12] --
		
--		length_message : integer := 2560;
--		size_message : integer := 12;
--		length_codeword : integer := 3328;
--		size_codeword : integer := 12;
--		size_dyadic_matrix : integer := 6;
--		number_dyadic_matrices : integer := 480;
--		size_number_dyadic_matrices : integer := 9

		-- QD-GOPPA [7296, 5632, 128, 13] --
		
--		length_message : integer := 5632;
--		size_message : integer := 13;
--		length_codeword : integer := 7296;
--		size_codeword : integer := 13;
--		size_dyadic_matrix : integer := 7;
--		number_dyadic_matrices : integer := 572;
--		size_number_dyadic_matrices : integer := 10	

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
end codeword_generator_1;

architecture Behavioral of codeword_generator_1 is

component controller_codeword_generator_1
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		limit_ctr_dyadic_column_q : in STD_LOGIC;
		limit_ctr_dyadic_row_q : in STD_LOGIC;
		limit_ctr_address_message_q : in STD_LOGIC;
		limit_ctr_address_codeword_q : in STD_LOGIC;
		write_enable_new_codeword : out STD_LOGIC;
		message_into_new_codeword : out STD_LOGIC;
		reg_codeword_ce : out STD_LOGIC;
		reg_codeword_rst : out STD_LOGIC;
		reg_message_ce : out STD_LOGIC;
		reg_matrix_ce : out STD_LOGIC;
		ctr_dyadic_column_ce : out STD_LOGIC;
		ctr_dyadic_column_rst : out STD_LOGIC;	
		ctr_dyadic_row_ce : out STD_LOGIC;
		ctr_dyadic_row_rst : out STD_LOGIC;
		ctr_dyadic_matrices_ce : out STD_LOGIC;
		ctr_dyadic_matrices_rst : out STD_LOGIC;
		ctr_address_base_message_ce : out STD_LOGIC;
		ctr_address_base_message_rst : out STD_LOGIC;	
		ctr_address_base_codeword_ce : out STD_LOGIC;
		ctr_address_base_codeword_rst : out STD_LOGIC;
		ctr_address_base_codeword_set : out STD_LOGIC;
		internal_codeword : out STD_LOGIC;
		codeword_finalized : out STD_LOGIC
	);
end component;

component register_nbits
	Generic (size : integer);
	Port (
		d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component register_rst_nbits
	Generic (size : integer);
	Port (
		d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component counter_rst_nbits
	Generic (
		size : integer;
		increment_value : integer
	);
	Port (
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component counter_rst_set_nbits
	Generic (
		size : integer;
		increment_value : integer
	);
	Port (
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		set : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		set_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

signal reg_codeword_d : STD_LOGIC;
signal reg_codeword_ce : STD_LOGIC;
signal reg_codeword_rst : STD_LOGIC;
constant reg_codeword_rst_value : STD_LOGIC := '0';
signal reg_codeword_q : STD_LOGIC;

signal reg_message_d : STD_LOGIC;
signal reg_message_ce : STD_LOGIC;
signal reg_message_q : STD_LOGIC;
		
signal reg_matrix_d : STD_LOGIC;
signal reg_matrix_ce : STD_LOGIC;
signal reg_matrix_q : STD_LOGIC;
		
signal ctr_dyadic_column_ce : STD_LOGIC;
signal ctr_dyadic_column_rst : STD_LOGIC;	
constant ctr_dyadic_column_rst_value : STD_LOGIC_VECTOR((size_dyadic_matrix - 1) downto 0) := (others => '0');
signal ctr_dyadic_column_q : STD_LOGIC_VECTOR((size_dyadic_matrix - 1) downto 0);

signal limit_ctr_dyadic_column_q : STD_LOGIC;
	
signal ctr_dyadic_row_ce : STD_LOGIC;
signal ctr_dyadic_row_rst : STD_LOGIC;
constant ctr_dyadic_row_rst_value : STD_LOGIC_VECTOR((size_dyadic_matrix - 1) downto 0) := (others => '0');
signal ctr_dyadic_row_q : STD_LOGIC_VECTOR((size_dyadic_matrix - 1) downto 0);

signal limit_ctr_dyadic_row_q : STD_LOGIC;

signal ctr_dyadic_matrices_ce : STD_LOGIC;
signal ctr_dyadic_matrices_rst : STD_LOGIC;
constant ctr_dyadic_matrices_rst_value : STD_LOGIC_VECTOR((size_number_dyadic_matrices - 1) downto 0) := (others => '0');
signal ctr_dyadic_matrices_q : STD_LOGIC_VECTOR((size_number_dyadic_matrices - 1) downto 0);

signal limit_ctr_dyadic_matrices_q : STD_LOGIC;

signal ctr_address_base_message_ce : STD_LOGIC;
signal ctr_address_base_message_rst : STD_LOGIC;	
constant ctr_address_base_message_rst_value : STD_LOGIC_VECTOR((size_message - size_dyadic_matrix - 1) downto 0) := (others => '0');
signal ctr_address_base_message_q : STD_LOGIC_VECTOR((size_message - size_dyadic_matrix - 1) downto 0);

signal limit_ctr_address_message_q : STD_LOGIC;

signal ctr_address_base_codeword_ce : STD_LOGIC;
signal ctr_address_base_codeword_rst : STD_LOGIC;
signal ctr_address_base_codeword_set : STD_LOGIC;
constant ctr_address_base_codeword_rst_value : STD_LOGIC_VECTOR((size_codeword - size_dyadic_matrix - 1) downto 0) := (others => '0');
constant ctr_address_base_codeword_set_value : STD_LOGIC_VECTOR((size_codeword - size_dyadic_matrix - 1) downto 0) := std_logic_vector(to_unsigned(length_message/2**size_dyadic_matrix, size_codeword - size_dyadic_matrix));
signal ctr_address_base_codeword_q : STD_LOGIC_VECTOR((size_codeword - size_dyadic_matrix - 1) downto 0);

signal limit_ctr_address_codeword_q : STD_LOGIC;

signal internal_address_codeword : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal internal_address_message : STD_LOGIC_VECTOR((size_message - 1) downto 0);
signal internal_codeword : STD_LOGIC;
signal internal_new_codeword : STD_LOGIC;

signal message_into_new_codeword : STD_LOGIC;

begin

controller : controller_codeword_generator_1
	Port Map(
		clk => clk,
		rst => rst,
		limit_ctr_dyadic_column_q => limit_ctr_dyadic_column_q,
		limit_ctr_dyadic_row_q => limit_ctr_dyadic_row_q,
		limit_ctr_address_message_q => limit_ctr_address_message_q,
		limit_ctr_address_codeword_q => limit_ctr_address_codeword_q,
		write_enable_new_codeword => write_enable_new_codeword,
		message_into_new_codeword => message_into_new_codeword, 
		reg_codeword_ce => reg_codeword_ce,
		reg_codeword_rst => reg_codeword_rst,
		reg_message_ce => reg_message_ce,
		reg_matrix_ce => reg_matrix_ce,
		ctr_dyadic_column_ce => ctr_dyadic_column_ce,
		ctr_dyadic_column_rst => ctr_dyadic_column_rst,
		ctr_dyadic_row_ce => ctr_dyadic_row_ce,
		ctr_dyadic_row_rst => ctr_dyadic_row_rst,
		ctr_dyadic_matrices_ce => ctr_dyadic_matrices_ce,
		ctr_dyadic_matrices_rst => ctr_dyadic_matrices_rst,
		ctr_address_base_message_ce => ctr_address_base_message_ce,
		ctr_address_base_message_rst => ctr_address_base_message_rst,
		ctr_address_base_codeword_ce => ctr_address_base_codeword_ce,
		ctr_address_base_codeword_rst => ctr_address_base_codeword_rst,
		ctr_address_base_codeword_set => ctr_address_base_codeword_set,
		internal_codeword => internal_codeword,
		codeword_finalized => codeword_finalized
	);

reg_acc : register_rst_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d(0) => reg_codeword_d,
		clk => clk,
		ce => reg_codeword_ce,
		rst => reg_codeword_rst,
		rst_value(0) => reg_codeword_rst_value,
		q(0) => reg_codeword_q
	);

reg_vector : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d(0) => reg_message_d,
		clk => clk,
		ce => reg_message_ce,
		q(0) => reg_message_q
	);
	
reg_matrix : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d(0) => reg_matrix_d,
		clk => clk,
		ce => reg_matrix_ce,
		q(0) => reg_matrix_q
	);
	
ctr_dyadic_column : counter_rst_nbits
	Generic Map(
		size => size_dyadic_matrix,
		increment_value => 1
	)
	Port Map(
		clk => clk,
		ce =>	ctr_dyadic_column_ce,
		rst => ctr_dyadic_column_rst,	
		rst_value => ctr_dyadic_column_rst_value,
		q => ctr_dyadic_column_q
	);
	
ctr_dyadic_row : counter_rst_nbits
	Generic Map(
		size => size_dyadic_matrix,
		increment_value => 1
	)
	Port Map(
		clk => clk,
		ce =>	ctr_dyadic_row_ce,
		rst => ctr_dyadic_row_rst,	
		rst_value => ctr_dyadic_row_rst_value,
		q => ctr_dyadic_row_q
	);
	
ctr_dyadic_matrices : counter_rst_nbits
	Generic Map(
		size => size_number_dyadic_matrices,
		increment_value => 1
	)
	Port Map(
		clk => clk,
		ce =>	ctr_dyadic_matrices_ce,
		rst => ctr_dyadic_matrices_rst,	
		rst_value => ctr_dyadic_matrices_rst_value,
		q => ctr_dyadic_matrices_q
	);

ctr_address_base_vector : counter_rst_nbits
	Generic Map(
		size => size_message - size_dyadic_matrix,
		increment_value => 1
	)
	Port Map(
		clk => clk,
		ce =>	ctr_address_base_message_ce,
		rst => ctr_address_base_message_rst,	
		rst_value => ctr_address_base_message_rst_value,
		q => ctr_address_base_message_q
	);

ctr_address_base_acc : counter_rst_set_nbits
	Generic Map(
		size => size_codeword - size_dyadic_matrix,
		increment_value => 1
	)
	Port Map(
		clk => clk,
		ce =>	ctr_address_base_codeword_ce,
		set => ctr_address_base_codeword_set,	
		rst => ctr_address_base_codeword_rst,	
		set_value => ctr_address_base_codeword_set_value,
		rst_value => ctr_address_base_codeword_rst_value,
		q => ctr_address_base_codeword_q
	);
	
internal_new_codeword <= (reg_message_q and reg_matrix_q) xor reg_codeword_q;

new_codeword <= reg_message_q when message_into_new_codeword  = '1' else
internal_new_codeword;

reg_codeword_d <= internal_new_codeword when internal_codeword = '1' else
	codeword;
	
reg_message_d <= message;

reg_matrix_d <= matrix;

internal_address_codeword <= ctr_address_base_codeword_q & ctr_dyadic_column_q;
internal_address_message <= ctr_address_base_message_q & ctr_dyadic_row_q;

address_codeword <= internal_address_codeword;
address_message <= internal_address_message;
address_matrix <= ctr_dyadic_matrices_q & (ctr_dyadic_column_q xor ctr_dyadic_row_q);

limit_ctr_dyadic_column_q <= '1' when ctr_dyadic_column_q = std_logic_vector(to_unsigned(2**size_dyadic_matrix - 1, ctr_dyadic_column_q'length)) else '0';
limit_ctr_dyadic_row_q <= '1' when ctr_dyadic_row_q = std_logic_vector(to_unsigned(2**size_dyadic_matrix - 1, ctr_dyadic_row_q'length)) else '0';
limit_ctr_address_message_q <= '1' when internal_address_message = std_logic_vector(to_unsigned(length_message - 1, internal_address_message'length)) else '0';
limit_ctr_address_codeword_q <= '1' when internal_address_codeword = std_logic_vector(to_unsigned(length_codeword - 1, internal_address_codeword'length)) else '0';

end Behavioral;

