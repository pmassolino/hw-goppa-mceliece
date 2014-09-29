----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Syndrome_Calculator_N
-- Module Name:    Syndrome_Calculator_N
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 1st step in Goppa Code Decoding. 
-- 
-- This circuit computes the syndrome from the ciphertext, support elements and
-- inverted evaluation of support elements into polynomial g, aka g(L)^(-1).
-- This circuit works by computing the syndrome of only the positions where the ciphertext
-- has value 1.
--
-- This is the second version with a variable number of computation units, but no pipeline.
-- A optimized version that computes the syndrome with a pipeline was made called 
-- syndrome_calculator_n_pipe.
--
-- The circuits parameters
--
-- number_of_units :
--
-- The number of units that compute each syndrome at the same time.
-- This number must be 1 or greater. 
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
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD_ALL;
--
-- controller_syndrome_calculator_2 Rev 1.0
-- register_nbits Rev 1.0
-- register_rst_nbits Rev 1.0
-- counter_rst_nbits Rev 1.0
-- shift_register_rst_nbits Rev 1.0
-- mult_gf_2_m Rev 1.0
-- adder_gf_2_m Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity syndrome_calculator_n is
	Generic(
				
		-- GOPPA [2048, 1751, 27, 11] --

--		number_of_units : integer := 32;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		length_syndrome : integer := 54;
--		size_syndrome : integer := 6

		-- GOPPA [2048, 1498, 50, 11] --

--		number_of_units : integer := 32;
--		gf_2_m : integer range 1 to 20 := 11;
--		length_codeword : integer := 2048;
--		size_codeword : integer := 11;
--		length_syndrome : integer := 100;
--		size_syndrome : integer := 7

		-- QD-GOPPA [2528, 2144, 32, 12] --

		number_of_units : integer := 16;
		gf_2_m : integer range 1 to 20 := 12;
		length_codeword : integer := 2528;
		size_codeword : integer := 12;
		length_syndrome : integer := 64;
		size_syndrome : integer := 7

		-- QD-GOPPA [2816, 2048, 64, 12] --

--		number_of_units : integer := 32;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 2816;
--		size_codeword : integer := 12;
--		length_syndrome : integer := 128;
--		size_syndrome : integer := 7

		-- QD-GOPPA [3328, 2560, 64, 12] --

--		number_of_units : integer := 32;
--		gf_2_m : integer range 1 to 20 := 12;
--		length_codeword : integer := 3328;
--		size_codeword : integer := 12;
--		length_syndrome : integer := 128;
--		size_syndrome : integer := 7

		-- QD-GOPPA [7296, 5632, 128, 13] --

--		number_of_units : integer := 32;
--		gf_2_m : integer range 1 to 20 := 13;
--		length_codeword : integer := 7296;
--		size_codeword : integer := 13;
--		length_syndrome : integer := 256;
--		size_syndrome : integer := 8

	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		value_h : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_L : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_syndrome : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_codeword : in STD_LOGIC_VECTOR(0 downto 0);
		syndrome_finalized : out STD_LOGIC;
		write_enable_new_syndrome : out STD_LOGIC;
		new_value_syndrome : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		address_h : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
		address_L : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
		address_codeword : out STD_LOGIC_VECTOR((size_codeword - 1) downto 0);
		address_syndrome : out STD_LOGIC_VECTOR((size_syndrome - 1) downto 0)
	);
end syndrome_calculator_n;

architecture Behavioral of syndrome_calculator_n is

component controller_syndrome_calculator_2
	Port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		almost_units_ready : in STD_LOGIC;
		empty_units : in STD_LOGIC;
		limit_ctr_codeword_q : in STD_LOGIC;
		limit_ctr_syndrome_q : in STD_LOGIC;
		reg_first_syndrome_q : in STD_LOGIC_VECTOR(0 downto 0);
		reg_codeword_q : in STD_LOGIC_VECTOR(0 downto 0);
		syndrome_finalized : out STD_LOGIC;
		write_enable_new_syndrome : out STD_LOGIC;
		control_units_ce : out STD_LOGIC;
		control_units_rst : out STD_LOGIC;
		int_reg_L_ce : out STD_LOGIC;
		int_square_h : out STD_LOGIC;
		int_reg_h_ce : out STD_LOGIC;
		int_reg_h_rst : out STD_LOGIC;
		int_sel_reg_h : out STD_LOGIC;
		reg_syndrome_ce : out STD_LOGIC;
		reg_syndrome_rst : out STD_LOGIC;
		reg_codeword_ce : out STD_LOGIC;
		reg_first_syndrome_ce : out STD_LOGIC;
		reg_first_syndrome_rst : out STD_LOGIC;
		ctr_syndrome_ce : out STD_LOGIC;
		ctr_syndrome_rst : out STD_LOGIC;
		ctr_codeword_ce : out STD_LOGIC;
		ctr_codeword_rst : out STD_LOGIC
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

component shift_register_rst_nbits
	Generic (size : integer);
	Port (
		data_in : in STD_LOGIC;
		clk : in STD_LOGIC;
		ce : in STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR((size - 1) downto 0);
		q : out STD_LOGIC_VECTOR((size - 1) downto 0);
		data_out : out STD_LOGIC
	);
end component;

component mult_gf_2_m
	Generic (gf_2_m : integer range 1 to 20 := 11);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		b: in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);

end component;

component adder_gf_2_m
	Generic(
		gf_2_m : integer := 1;
		number_of_elements : integer range 2 to integer'high := 2
	);
	Port(
		a : in STD_LOGIC_VECTOR(((gf_2_m)*(number_of_elements) - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end component;

signal reg_L_d : STD_LOGIC_VECTOR(((number_of_units)*gf_2_m - 1) downto 0);
signal reg_L_ce : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal reg_L_q : STD_LOGIC_VECTOR(((number_of_units)*gf_2_m - 1) downto 0);

signal reg_h_d :STD_LOGIC_VECTOR(((number_of_units)*gf_2_m - 1) downto 0);
signal reg_h_ce : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal reg_h_rst : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
constant reg_h_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');
signal reg_h_q : STD_LOGIC_VECTOR(((number_of_units)*gf_2_m - 1) downto 0);

signal sel_reg_h : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);
signal square_h : STD_LOGIC_VECTOR((number_of_units - 1) downto 0);

signal reg_syndrome_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_syndrome_ce : STD_LOGIC;
signal reg_syndrome_rst : STD_LOGIC;
constant reg_syndrome_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(0, gf_2_m));
signal reg_syndrome_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_codeword_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_codeword_ce : STD_LOGIC;
signal reg_codeword_q : STD_LOGIC_VECTOR(0 downto 0);
	
signal reg_first_syndrome_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_first_syndrome_ce : STD_LOGIC;
signal reg_first_syndrome_rst : STD_LOGIC;
constant reg_first_syndrome_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "1";
signal reg_first_syndrome_q : STD_LOGIC_VECTOR(0 downto 0);

signal mult_a : STD_LOGIC_VECTOR(((number_of_units)*gf_2_m - 1) downto 0);
signal mult_b : STD_LOGIC_VECTOR(((number_of_units)*gf_2_m - 1) downto 0);
signal mult_o : STD_LOGIC_VECTOR(((number_of_units)*gf_2_m - 1) downto 0);

signal adder_a : STD_LOGIC_VECTOR(((number_of_units+1)*gf_2_m - 1) downto 0);
signal adder_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal ctr_syndrome_ce : STD_LOGIC;
signal ctr_syndrome_rst : STD_LOGIC;
constant ctr_syndrome_rst_value : STD_LOGIC_VECTOR((size_syndrome - 1) downto 0) := std_logic_vector(to_unsigned(0, size_syndrome));
signal ctr_syndrome_q : STD_LOGIC_VECTOR((size_syndrome - 1) downto 0);
	
signal ctr_codeword_ce : STD_LOGIC;
signal ctr_codeword_rst : STD_LOGIC;
constant ctr_codeword_rst_value : STD_LOGIC_VECTOR((size_codeword - 1) downto 0) := std_logic_vector(to_unsigned(0, size_codeword));
signal ctr_codeword_q : STD_LOGIC_VECTOR((size_codeword - 1) downto 0);

signal control_units_ce : STD_LOGIC;
signal control_units_rst : STD_LOGIC;
constant control_units_rst_value0 : STD_LOGIC_VECTOR((number_of_units - 1) downto 0) := (others => '0');
constant control_units_rst_value1 : STD_LOGIC_VECTOR((number_of_units) downto (number_of_units)) := "1";
constant control_units_rst_value : STD_LOGIC_VECTOR((number_of_units) downto 0) := control_units_rst_value1 & control_units_rst_value0;
signal control_units_q : STD_LOGIC_VECTOR((number_of_units) downto 0);
signal control_units_data_out : STD_LOGIC;

signal int_reg_L_ce : STD_LOGIC;
signal int_square_h : STD_LOGIC;
signal int_reg_h_ce : STD_LOGIC;
signal int_reg_h_rst : STD_LOGIC;
signal int_sel_reg_h : STD_LOGIC;

signal almost_units_ready : STD_LOGIC;
signal empty_units : STD_LOGIC;
signal limit_ctr_codeword_q : STD_LOGIC;
signal limit_ctr_syndrome_q : STD_LOGIC;

begin

controller : controller_syndrome_calculator_2
	Port Map(
		clk => clk,
		rst => rst,
		almost_units_ready => almost_units_ready,
		empty_units => empty_units,
		limit_ctr_codeword_q => limit_ctr_codeword_q,
		limit_ctr_syndrome_q => limit_ctr_syndrome_q,
		reg_first_syndrome_q => reg_first_syndrome_q,
		reg_codeword_q => reg_codeword_q,
		syndrome_finalized => syndrome_finalized,
		write_enable_new_syndrome => write_enable_new_syndrome,
		control_units_ce => control_units_ce,
		control_units_rst => control_units_rst,
		int_reg_L_ce => int_reg_L_ce,
		int_square_h => int_square_h,
		int_reg_h_ce => int_reg_h_ce,
		int_reg_h_rst => int_reg_h_rst,
		int_sel_reg_h => int_sel_reg_h,
		reg_syndrome_ce => reg_syndrome_ce,
		reg_syndrome_rst => reg_syndrome_rst,
		reg_codeword_ce => reg_codeword_ce,
		reg_first_syndrome_ce => reg_first_syndrome_ce,
		reg_first_syndrome_rst => reg_first_syndrome_rst,
		ctr_syndrome_ce => ctr_syndrome_ce,
		ctr_syndrome_rst => ctr_syndrome_rst,
		ctr_codeword_ce => ctr_codeword_ce,
		ctr_codeword_rst => ctr_codeword_rst
	);

calculator_units : for I in 0 to (number_of_units - 1) generate

reg_L_I : register_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_L_d(((I + 1)*gf_2_m - 1) downto I*gf_2_m),
		clk => clk,
		ce => reg_L_ce(I),
		q => reg_L_q(((I + 1)*gf_2_m - 1) downto I*gf_2_m)
	);

reg_h_I : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_h_d(((I + 1)*gf_2_m - 1) downto I*gf_2_m),
		clk => clk,
		ce => reg_h_ce(I),
		rst => reg_h_rst(I),
		rst_value => reg_h_rst_value,
		q => reg_h_q(((I + 1)*gf_2_m - 1) downto I*gf_2_m)
	);
	
mult_I : mult_gf_2_m
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => mult_a(((I + 1)*gf_2_m - 1) downto I*gf_2_m),
		b => mult_b(((I + 1)*gf_2_m - 1) downto I*gf_2_m),
		o => mult_o(((I + 1)*gf_2_m - 1) downto I*gf_2_m)
	);
	
reg_L_d(((I + 1)*gf_2_m - 1) downto I*gf_2_m) <= value_L;

reg_h_d(((I + 1)*gf_2_m - 1) downto I*gf_2_m) <= mult_o(((I + 1)*gf_2_m - 1) downto I*gf_2_m) when sel_reg_h(I) = '1' else
			value_h;
			
mult_a(((I + 1)*gf_2_m - 1) downto I*gf_2_m) <= reg_h_q(((I + 1)*gf_2_m - 1) downto I*gf_2_m) when square_h(I) = '1' else 
			reg_L_q(((I + 1)*gf_2_m - 1) downto I*gf_2_m);
mult_b(((I + 1)*gf_2_m - 1) downto I*gf_2_m) <= reg_h_q(((I + 1)*gf_2_m - 1) downto I*gf_2_m);

reg_L_ce(I) <= int_reg_L_ce and control_units_q(I);
square_h(I) <= int_square_h and control_units_q(I);
reg_h_ce(I) <= int_reg_h_ce and (control_units_q(I) or (int_sel_reg_h and (not int_square_h)));
reg_h_rst(I) <= int_reg_h_rst and (control_units_q(I));
sel_reg_h(I) <= int_sel_reg_h;
	
end generate;

control_units : shift_register_rst_nbits
	Generic Map(
		size => number_of_units+1
	)
	Port Map(
		data_in => control_units_data_out,
		clk => clk,
		ce => control_units_ce,
		rst => control_units_rst,
		rst_value => control_units_rst_value,
		q => control_units_q,
		data_out => control_units_data_out
	);

adder : adder_gf_2_m
	Generic Map(
		gf_2_m => gf_2_m,
		number_of_elements => number_of_units+1
	)
	Port Map(
		a => adder_a,
		o => adder_o
	);
	
reg_syndrome : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_syndrome_d,
		clk => clk,
		ce => reg_syndrome_ce,
		rst => reg_syndrome_rst,
		rst_value => reg_syndrome_rst_value,
		q => reg_syndrome_q
	);

reg_codeword : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_codeword_d,
		clk => clk,
		ce => reg_codeword_ce,
		q => reg_codeword_q
	);
	
reg_first_syndrome : register_rst_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_first_syndrome_d,
		clk => clk,
		ce => reg_first_syndrome_ce,
		rst => reg_first_syndrome_rst,
		rst_value => reg_first_syndrome_rst_value,
		q => reg_first_syndrome_q
	);

ctr_syndrome : counter_rst_nbits
	Generic Map(
		size => size_syndrome,
		increment_value => 1
	)
	Port Map(
		clk => clk,
		ce => ctr_syndrome_ce,
		rst => ctr_syndrome_rst,
		rst_value => ctr_syndrome_rst_value,
		q => ctr_syndrome_q
	);
	
ctr_codeword : counter_rst_nbits
	Generic Map(
		size => size_codeword,
		increment_value => 1
	)
	Port Map(
		clk => clk,
		ce => ctr_codeword_ce,
		rst => ctr_codeword_rst,
		rst_value => ctr_codeword_rst_value,
		q => ctr_codeword_q
	);
	
adder_a <= reg_h_q & reg_syndrome_q;
	
reg_syndrome_d <= value_syndrome;

reg_codeword_d <= value_codeword;

reg_first_syndrome_d <= "0";

new_value_syndrome <= adder_o;
		
address_h <= ctr_codeword_q;
address_L <= ctr_codeword_q;
address_codeword <= ctr_codeword_q;
address_syndrome <= std_logic_vector(to_unsigned(length_syndrome - 1, ctr_syndrome_q'length) - unsigned(ctr_syndrome_q));

almost_units_ready <= control_units_q(number_of_units - 1);
empty_units <= control_units_q(0);
limit_ctr_codeword_q <= '1' when (ctr_codeword_q = std_logic_vector(to_unsigned(length_codeword - 1, ctr_codeword_q'length))) else '0';
limit_ctr_syndrome_q <= '1' when (ctr_syndrome_q = std_logic_vector(to_unsigned(length_syndrome - 1, ctr_syndrome_q'length))) else '0';

end Behavioral;