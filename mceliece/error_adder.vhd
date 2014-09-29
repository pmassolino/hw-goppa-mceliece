----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Error_Adder 
-- Module Name:    Error_Adder
-- Project Name:   McEliece QD-Goppa Encryption
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This circuit process the final step on McEliece encryption algorithm.
-- This circuit adds error array into codeword generating the respective ciphertext.
-- This circuit does not generate error array and it should be generated previously.
-- For being very simple no optimizations were made, however this circuit could be easily
-- embedded into codeword generator. 
--
-- The circuits parameters
--
--	number_of_units :
--
-- The number of codewords calculated at once.
--
-- length_codeword :
--
-- Length in bits of codeword.
--
--	size_codeword : 
--
-- The number of bits necessary to store the codeword. The ceil(log2(legth_codeword))
-- 
-- Dependencies: 
--
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- controller_error_adder Rev 1.0
-- register_nbits Rev 1.0
-- counter_rst_nbits Rev 1.0
--
-- Revision: 
-- Revision 1.00
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity error_adder is
	Generic(
	
		-- 80 --
		
		number_of_units : integer := 32;
		length_codeword : integer := 2528;
		size_codeword : integer := 12
		
		-- 112 --
		
--		number_of_units : integer := 64; 
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12

		-- 128 --
		
--		number_of_units : integer := 2; 
--		length_codeword : integer := 3328;
--		size_codeword : integer := 12

		-- 192 --
		
--		number_of_units : integer := 16; 
--		length_codeword : integer := 5376;
--		size_codeword : integer := 13

		-- 256 --
		
--		number_of_units : integer := 1; 
--		length_codeword : integer := 7296;
--		size_codeword : integer := 13

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
end error_adder;

architecture RTL of error_adder is

component controller_error_adder
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		limit_ctr_address_codeword_q : in STD_LOGIC;
		reg_codeword_ce : out STD_LOGIC;
		reg_error_ce : out STD_LOGIC;
		ctr_address_codeword_ce : out STD_LOGIC;
		ctr_address_codeword_rst : out STD_LOGIC;
		ctr_address_ciphertext_ce : out STD_LOGIC;
		ctr_address_ciphertext_rst : out STD_LOGIC;
		write_enable_ciphertext : out STD_LOGIC;
		error_added : out STD_LOGIC
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

signal reg_codeword_d : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal reg_codeword_ce : STD_LOGIC;
signal reg_codeword_q : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
	
signal reg_error_d : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal reg_error_ce : STD_LOGIC;
signal reg_error_q : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);

signal ctr_address_codeword_ce : STD_LOGIC;
signal ctr_address_codeword_rst : STD_LOGIC;	
constant ctr_address_codeword_rst_value : STD_LOGIC_VECTOR((size_codeword - 1) downto 0) := (others => '0');
signal ctr_address_codeword_q : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
signal ctr_address_ciphertext_ce : STD_LOGIC;
signal ctr_address_ciphertext_rst : STD_LOGIC;
constant ctr_address_ciphertext_rst_value : STD_LOGIC_VECTOR((size_codeword - 1) downto 0) := (others => '0');
signal ctr_address_ciphertext_q : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);

signal limit_ctr_address_codeword_q : STD_LOGIC;

begin

controller : controller_error_adder
	Port Map(
		clk => clk,
		rst => rst,
		limit_ctr_address_codeword_q => limit_ctr_address_codeword_q,
		reg_codeword_ce => reg_codeword_ce, 
		reg_error_ce => reg_error_ce, 
		ctr_address_codeword_ce => ctr_address_codeword_ce,
		ctr_address_codeword_rst => ctr_address_codeword_rst,
		ctr_address_ciphertext_ce => ctr_address_ciphertext_ce,
		ctr_address_ciphertext_rst => ctr_address_ciphertext_rst,
		write_enable_ciphertext => write_enable_ciphertext,
		error_added => error_added
	);
	
reg_codeword : register_nbits
	Generic Map (size => number_of_units)
	Port Map(
		d => reg_codeword_d,
		clk => clk,
		ce => reg_codeword_ce,
		q => reg_codeword_q
	);
	
reg_error : register_nbits
	Generic Map (size => number_of_units)
	Port Map(
		d => reg_error_d,
		clk => clk,
		ce => reg_error_ce,
		q => reg_error_q
	);

ctr_address_acc : counter_rst_nbits
	Generic Map(
		size => size_codeword,
		increment_value => number_of_units
	)
	Port Map(
		clk => clk,
		ce =>	ctr_address_codeword_ce,
		rst => ctr_address_codeword_rst,	
		rst_value => ctr_address_codeword_rst_value,
		q => ctr_address_codeword_q
	);
	
ctr_address_ciphertext : counter_rst_nbits
	Generic Map(
		size => size_codeword,
		increment_value => number_of_units
	)
	Port Map(
		clk => clk,
		ce =>	ctr_address_ciphertext_ce,
		rst => ctr_address_ciphertext_rst,	
		rst_value => ctr_address_ciphertext_rst_value,
		q => ctr_address_ciphertext_q
	);
	
reg_codeword_d <= codeword;
reg_error_d <= error;

ciphertext <= reg_codeword_q xor reg_error_q;

address_codeword <= ctr_address_codeword_q;
address_error <= ctr_address_codeword_q;
address_ciphertext <= ctr_address_ciphertext_q;

limit_ctr_address_codeword_q <= '1' when ctr_address_codeword_q = std_logic_vector(to_unsigned(length_codeword - number_of_units, size_codeword)) else '0';

end RTL;