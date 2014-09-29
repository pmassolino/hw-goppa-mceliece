----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Solving_Key_Equation_1
-- Module Name:    Solving_Key_Equation_1
-- Project Name:   McEliece QD-Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
-- 
-- The 2nd step in Goppa Code Decoding.
--
-- This circuit solves the polynomial key equation sigma with the polynomial syndrome.
-- To solve the key equation, this circuit employs a modified extended euclidean algorithm
-- The modification is made to stop the algorithm when polynomial, represented here as G, has 
-- degree less or equal than the polynomial key equation sigma desired degree.
-- The syndrome is the input and expected to be of degree 2*final_degree, and after computations
-- polynomial C, will hold sigma with degree less or equal to final_degree.
--
-- This is the first circuit version. It is a non pipeline version of the algorithm, 
-- each coefficient takes more than 1 cycle to be computed.
-- A more optimized version, still non pipeline was made called solving_key_equation_1_v2
-- This improved version, has new address resolution logic and internal degree counters.
--
-- Parameters 
--
-- gf_2_m :
--
-- The size of the field used in this circuit. This parameter depends of the 
-- Goppa code used.
--
--	final_degree :
--
-- The final degree size expected for polynomial sigma to have. This parameter depends
-- of the Goppa code used. 
--
--	size_final_degree :
--
-- The number of bits necessary to hold the polynomial with degree of final_degree, which
-- has final_degree + 1  coefficients. This is ceil(log2(final_degree+1)).
--
-- Dependencies: 
--
-- VHDL-93
--
-- controller_solving_key_equation_1 Rev 1.0
-- register_nbits Rev 1.0
-- register_rst_nbits Rev 1.0
-- counter_decrement_rst_nbits Rev 1.0
-- mult_gf_2_m Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity solving_key_equation_1 is
	Generic(
		-- GOPPA [2048, 1751, 27, 11] --
		
		gf_2_m : integer range 1 to 20 := 11;
		final_degree : integer := 27;
		size_final_degree : integer := 5

		-- GOPPA [2048, 1498, 50, 11] --
		
--		gf_2_m : integer range 1 to 20 := 11;
--		final_degree : integer := 50;
--		size_final_degree : integer := 6

		-- GOPPA [3307, 2515, 66, 12] --
		
--		gf_2_m : integer range 1 to 20 := 11;
--		final_degree : integer := 50;
--		size_final_degree : integer := 6

		-- QD-GOPPA [2528, 2144, 32, 12] --

--		gf_2_m : integer range 1 to 20 := 12;
--		final_degree : integer := 32;
--		size_final_degree : integer := 5

		-- QD-GOPPA [2816, 2048, 64, 12] --

--		gf_2_m : integer range 1 to 20 := 12;
--		final_degree : integer := 64;
--		size_final_degree : integer := 6

		-- QD-GOPPA [3328, 2560, 64, 12] --

--		gf_2_m : integer range 1 to 20 := 12;
--		final_degree : integer := 64;
--		size_final_degree : integer := 6

		-- QD-GOPPA [7296, 5632, 128, 13] --

--		gf_2_m : integer range 1 to 20 := 13;
--		final_degree : integer := 128;
--		size_final_degree : integer := 7
	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		ready_inv : in STD_LOGIC;
		value_FB : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_GC : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_inv : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		signal_inv : out STD_LOGIC;
		key_equation_found : out STD_LOGIC;
		write_enable_FB : out STD_LOGIC;
		write_enable_GC : out STD_LOGIC;
		new_value_inv : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_FB : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_GC : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		address_FB : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_GC : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0)
	);
end solving_key_equation_1;

architecture Behavioral of solving_key_equation_1 is

component controller_solving_key_equation_1
	Port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		ready_inv : in STD_LOGIC;
		FB_equal_zero : in STD_LOGIC;
		i_equal_zero : in STD_LOGIC;
		i_minus_j_less_than_zero : in STD_LOGIC;
		degree_G_less_equal_final_degree : in STD_LOGIC;
		degree_F_less_than_degree_G : in STD_LOGIC;
		degree_B_equal_degree_C_plus_j : in STD_LOGIC;
		degree_B_less_than_degree_C_plus_j : in STD_LOGIC;
		reg_looking_degree_q : in STD_LOGIC_VECTOR(0 downto 0);
		key_equation_found : out STD_LOGIC;
		signal_inv : out STD_LOGIC;
		write_enable_FB : out STD_LOGIC;
		write_enable_GC : out STD_LOGIC;
		sel_base_mul : out STD_LOGIC;
		reg_h_ce : out STD_LOGIC;
		ctr_i_ce : out STD_LOGIC;
		ctr_i_rst : out STD_LOGIC;
		sel_ctr_i_rst_value : out STD_LOGIC_VECTOR(1 downto 0);
		reg_j_ce : out STD_LOGIC;
		reg_FB_ce : out STD_LOGIC;
		reg_FB_rst : out STD_LOGIC;
		sel_reg_FB : out STD_LOGIC;
		reg_GC_ce : out STD_LOGIC;
		reg_GC_rst : out STD_LOGIC;
		sel_reg_GC : out STD_LOGIC;
		reg_degree_F_ce : out STD_LOGIC;
		reg_degree_F_rst : out STD_LOGIC;
		sel_reg_degree_F : out STD_LOGIC;
		reg_degree_G_ce : out STD_LOGIC;
		reg_degree_G_rst : out STD_LOGIC;
		reg_degree_B_ce : out STD_LOGIC;
		reg_degree_B_rst : out STD_LOGIC;
		sel_reg_degree_B : out STD_LOGIC_VECTOR(1 downto 0);
		reg_degree_C_ce : out STD_LOGIC;
		reg_degree_C_rst : out STD_LOGIC;
		reg_looking_degree_d : out STD_LOGIC_VECTOR(0 downto 0);
		reg_looking_degree_ce : out STD_LOGIC;
		reg_swap_ce : out STD_LOGIC;
		reg_swap_rst : out STD_LOGIC;
		sel_int_new_value_FB : out STD_LOGIC;
		sel_address_FB : out STD_LOGIC;
		sel_address_GC : out STD_LOGIC_VECTOR(1 downto 0);
		BC_calculation : out STD_LOGIC;
		enable_external_swap : out STD_LOGIC
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

component counter_decrement_rst_nbits
	Generic (
		size : integer;
		decrement_value : integer
	);
	Port (
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

component mult_gf_2_m
	Generic (gf_2_m : integer range 1 to 20 := 11);
	Port (
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		b: in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);

end component;

signal base_mult_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal base_mult_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal base_mult_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal sel_base_mul : STD_LOGIC;

signal reg_h_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_h_ce : STD_LOGIC;
signal reg_h_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_inv_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_inv_ce : STD_LOGIC;
signal reg_inv_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal ctr_i_ce : STD_LOGIC;
signal ctr_i_rst : STD_LOGIC;
signal ctr_i_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_i_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal sel_ctr_i_rst_value : STD_LOGIC_VECTOR(1 downto 0);

constant ctr_i_rst_value_F : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(2*final_degree - 1,size_final_degree + 2));
constant ctr_i_rst_value_B : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(final_degree,size_final_degree + 2));

signal reg_j_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_j_ce : STD_LOGIC;
signal reg_j_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_FB_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_FB_ce : STD_LOGIC;
signal reg_FB_rst : STD_LOGIC;
constant reg_FB_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_FB_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal sel_reg_FB : STD_LOGIC;

signal reg_GC_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_GC_ce : STD_LOGIC;
signal reg_GC_rst : STD_LOGIC;
constant reg_GC_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_GC_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal sel_reg_GC : STD_LOGIC;

signal reg_degree_F_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_degree_F_ce : STD_LOGIC;
signal reg_degree_F_rst : STD_LOGIC;
constant reg_degree_F_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(2*final_degree - 1,size_final_degree + 2));
signal reg_degree_F_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal sel_reg_degree_F : STD_LOGIC;

signal reg_degree_G_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_degree_G_ce : STD_LOGIC;
signal reg_degree_G_rst : STD_LOGIC;
constant reg_degree_G_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(2*final_degree,size_final_degree + 2));
signal reg_degree_G_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_degree_B_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_degree_B_ce : STD_LOGIC;
signal reg_degree_B_rst : STD_LOGIC;
constant reg_degree_B_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(0,size_final_degree + 2));
signal reg_degree_B_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal sel_reg_degree_B : STD_LOGIC_VECTOR(1 downto 0);

signal reg_degree_C_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_degree_C_ce : STD_LOGIC;
signal reg_degree_C_rst : STD_LOGIC;
constant reg_degree_C_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(0,size_final_degree + 2));
signal reg_degree_C_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal reg_looking_degree_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_looking_degree_ce : STD_LOGIC;
signal reg_looking_degree_q : STD_LOGIC_VECTOR(0 downto 0);
	
signal reg_swap_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_swap_ce : STD_LOGIC;
signal reg_swap_rst : STD_LOGIC;
constant reg_swap_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_swap_q : STD_LOGIC_VECTOR(0 downto 0);

signal i_minus_j : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal degree_C_plus_j : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal int_value_FB : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal int_value_GC : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal sel_int_new_value_FB : STD_LOGIC;

signal int_new_value_FB : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal int_new_value_GC : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal int_write_enable_FB : STD_LOGIC;
signal int_write_enable_GC : STD_LOGIC;

signal int_address_FB : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal int_address_GC : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal address_i_FB : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_degree_FB_FB : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0); 

signal address_i_GC : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_degree_GC_GC : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_i_minus_j_GC : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal sel_address_FB : STD_LOGIC;
signal sel_address_GC : STD_LOGIC_VECTOR(1 downto 0);

signal BC_calculation : STD_LOGIC;

signal enable_external_swap : STD_LOGIC;

signal FB_equal_zero : STD_LOGIC;
signal i_equal_zero : STD_LOGIC;
signal i_minus_j_less_than_zero : STD_LOGIC;
signal degree_G_less_equal_final_degree : STD_LOGIC;
signal degree_F_less_than_degree_G : STD_LOGIC;
signal degree_B_equal_degree_C_plus_j : STD_LOGIC;
signal degree_B_less_than_degree_C_plus_j : STD_LOGIC;

begin

controller : controller_solving_key_equation_1
	Port Map(
		clk => clk,
		rst => rst,
		ready_inv => ready_inv,
		FB_equal_zero => FB_equal_zero,
		i_equal_zero => i_equal_zero,
		i_minus_j_less_than_zero => i_minus_j_less_than_zero,
		degree_G_less_equal_final_degree => degree_G_less_equal_final_degree,
		degree_F_less_than_degree_G => degree_F_less_than_degree_G,
		degree_B_equal_degree_C_plus_j => degree_B_equal_degree_C_plus_j,
		degree_B_less_than_degree_C_plus_j => degree_B_less_than_degree_C_plus_j,
		reg_looking_degree_q => reg_looking_degree_q,
		key_equation_found => key_equation_found,
		signal_inv => signal_inv,
		write_enable_FB => int_write_enable_FB,
		write_enable_GC => int_write_enable_GC,
		sel_base_mul => sel_base_mul,
		reg_h_ce => reg_h_ce,
		ctr_i_ce => ctr_i_ce,
		ctr_i_rst => ctr_i_rst,
		sel_ctr_i_rst_value => sel_ctr_i_rst_value,
		reg_j_ce => reg_j_ce,
		reg_FB_ce => reg_FB_ce,
		reg_FB_rst => reg_FB_rst,
		sel_reg_FB => sel_reg_FB,
		reg_GC_ce => reg_GC_ce,
		reg_GC_rst => reg_GC_rst,
		sel_reg_GC => sel_reg_GC,
		reg_degree_F_ce => reg_degree_F_ce,
		reg_degree_F_rst => reg_degree_F_rst,
		sel_reg_degree_F => sel_reg_degree_F,
		reg_degree_G_ce => reg_degree_G_ce,
		reg_degree_G_rst => reg_degree_G_rst,
		reg_degree_B_ce => reg_degree_B_ce,
		reg_degree_B_rst => reg_degree_B_rst,
		sel_reg_degree_B => sel_reg_degree_B,
		reg_degree_C_ce => reg_degree_C_ce,
		reg_degree_C_rst => reg_degree_C_rst,
		reg_looking_degree_d => reg_looking_degree_d,		
		reg_looking_degree_ce => reg_looking_degree_ce,
		reg_swap_ce => reg_swap_ce,
		reg_swap_rst => reg_swap_rst,
		sel_int_new_value_FB => sel_int_new_value_FB,
		sel_address_FB => sel_address_FB,
		sel_address_GC => sel_address_GC,
		BC_calculation => BC_calculation,
		enable_external_swap => enable_external_swap
	);

base_mult : mult_gf_2_m
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => base_mult_a,
		b => base_mult_b,
		o => base_mult_o
	);

reg_h : register_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_h_d,
		clk => clk,
		ce => reg_h_ce,
		q => reg_h_q
	);

reg_inv : register_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_inv_d,
		clk => clk,
		ce => reg_inv_ce,
		q => reg_inv_q
	);

ctr_i : counter_decrement_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		clk => clk,
		ce => ctr_i_ce,
		rst => ctr_i_rst,
		rst_value => ctr_i_rst_value,
		q => ctr_i_q
	);

reg_j : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_j_d,
		clk => clk,
		ce => reg_j_ce,
		q => reg_j_q
	);

reg_FB : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_FB_d,
		clk => clk,
		rst => reg_FB_rst,
		rst_value => reg_FB_rst_value,
		ce => reg_FB_ce,
		q => reg_FB_q
	);

reg_GC : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_GC_d,
		clk => clk,
		rst => reg_GC_rst,
		rst_value => reg_GC_rst_value,
		ce => reg_GC_ce,
		q => reg_GC_q
	);

reg_degree_F : register_rst_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_degree_F_d,
		clk => clk,
		rst => reg_degree_F_rst,
		rst_value => reg_degree_F_rst_value,
		ce => reg_degree_F_ce,
		q => reg_degree_F_q
	);

reg_degree_G : register_rst_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_degree_G_d,
		clk => clk,
		rst => reg_degree_G_rst,
		rst_value => reg_degree_G_rst_value,
		ce => reg_degree_G_ce,
		q => reg_degree_G_q
	);

reg_degree_B : register_rst_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_degree_B_d,
		clk => clk,
		rst => reg_degree_B_rst,
		rst_value => reg_degree_B_rst_value,
		ce => reg_degree_B_ce,
		q => reg_degree_B_q
	);

reg_degree_C : register_rst_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_degree_C_d,
		clk => clk,
		rst => reg_degree_C_rst,
		rst_value => reg_degree_C_rst_value,
		ce => reg_degree_C_ce,
		q => reg_degree_C_q
	);
	
reg_looking_degree : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_looking_degree_d,
		clk => clk,
		ce => reg_looking_degree_ce,
		q => reg_looking_degree_q
	);
	
reg_swap : register_rst_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_swap_d,
		clk => clk,
		ce => reg_swap_ce,
		rst => reg_swap_rst,
		rst_value => reg_swap_rst_value,
		q => reg_swap_q
	);

base_mult_a <= reg_inv_q when sel_base_mul = '1' else
					reg_h_q;
base_mult_b <= reg_FB_q when sel_base_mul = '1' else
					reg_GC_q;

reg_h_d <= base_mult_o;

reg_inv_d <= value_inv;
reg_inv_ce <= ready_inv;

ctr_i_rst_value <= reg_degree_F_q when sel_ctr_i_rst_value = "11" else
						 degree_C_plus_j when sel_ctr_i_rst_value = "10" else
						 ctr_i_rst_value_F when sel_ctr_i_rst_value = "01" else
						 ctr_i_rst_value_B;

reg_j_d <= std_logic_vector(unsigned(reg_degree_F_q) - unsigned(reg_degree_G_q));
	
reg_FB_d <= std_logic_vector(to_unsigned(1, reg_FB_d'length)) when sel_reg_FB = '1' else 
				int_value_FB;
	
reg_GC_d <= std_logic_vector(to_unsigned(1, reg_GC_d'length)) when sel_reg_GC = '1' else
				int_value_GC;

reg_degree_F_d <= std_logic_vector((unsigned(reg_degree_F_q) - to_unsigned(1, reg_degree_F_q'length))) when sel_reg_degree_F = '1' else
						reg_degree_G_q;
						
reg_degree_G_d <= reg_degree_F_q;

reg_degree_B_d <= degree_C_plus_j when sel_reg_degree_B = "10" else
					std_logic_vector(unsigned(reg_degree_B_q) - to_unsigned(1, reg_degree_B_q'length)) when sel_reg_degree_B = "01" else
					reg_degree_C_q when sel_reg_degree_B = "00" else
					(others => '-');
		
degree_C_plus_j <= std_logic_vector(unsigned(reg_degree_C_q) + unsigned(reg_j_q));

i_minus_j <= std_logic_vector(unsigned(ctr_i_q) - unsigned(reg_j_q));

reg_degree_C_d <= reg_degree_B_q;

reg_swap_d <= not reg_swap_q;

int_new_value_FB <= (base_mult_o xor reg_FB_q) when sel_int_new_value_FB = '1' else
							reg_FB_q;
int_new_value_GC <= reg_GC_q;

int_value_FB <= value_GC when reg_swap_q = "1" else value_FB;
int_value_GC <= value_FB when reg_swap_q = "1" else value_GC;

new_value_inv <= int_new_value_GC;

new_value_FB <= int_new_value_GC when (reg_swap_q(0) and enable_external_swap) = '1' else int_new_value_FB;
new_value_GC <= int_new_value_FB when (reg_swap_q(0) and enable_external_swap) = '1' else int_new_value_GC;

write_enable_FB <= int_write_enable_GC when (reg_swap_q(0) and enable_external_swap) = '1' else int_write_enable_FB;
write_enable_GC <= int_write_enable_FB when (reg_swap_q(0) and enable_external_swap) = '1' else int_write_enable_GC;

address_i_FB <= std_logic_vector(to_unsigned(2*final_degree + 1, address_i_FB'length) + unsigned(ctr_i_q)) when BC_calculation = '1' else
					ctr_i_q;
address_degree_FB_FB <= std_logic_vector(to_unsigned(2*final_degree + 1, address_degree_FB_FB'length) + unsigned(reg_degree_B_q)) when BC_calculation = '1' else
					reg_degree_F_q;

address_i_GC <= std_logic_vector(to_unsigned(2*final_degree + 1, address_i_GC'length) + unsigned(ctr_i_q)) when BC_calculation = '1' else
					ctr_i_q;
address_degree_GC_GC <= std_logic_vector(to_unsigned(2*final_degree + 1, address_degree_GC_GC'length) + unsigned(reg_degree_C_q)) when BC_calculation = '1' else
					reg_degree_G_q;
address_i_minus_j_GC <= std_logic_vector(to_unsigned(2*final_degree + 1, address_i_minus_j_GC'length) + unsigned(i_minus_j)) when BC_calculation = '1' else
					i_minus_j;

int_address_FB <= address_degree_FB_FB when sel_address_FB = '1' else 
						address_i_FB;
						
int_address_GC <= address_i_minus_j_GC when sel_address_GC = "10" else 
						address_degree_GC_GC when sel_address_GC = "01" else 
						address_i_GC when sel_address_GC = "00" else 
						(others => '-');

address_FB <= int_address_GC when (reg_swap_q(0) and enable_external_swap) = '1' else int_address_FB;
address_GC <= int_address_FB when (reg_swap_q(0) and enable_external_swap) = '1' else int_address_GC;

FB_equal_zero <= '1' when (int_new_value_FB = std_logic_vector(to_unsigned(0,reg_FB_q'length))) else '0';
i_equal_zero <= '1' when (ctr_i_q = std_logic_vector(to_unsigned(0,ctr_i_q'length))) else '0';
i_minus_j_less_than_zero <= '1' when (signed(i_minus_j) < to_signed(0,i_minus_j'length)) else '0';
degree_G_less_equal_final_degree <= '1' when (unsigned(reg_degree_G_q) <= to_unsigned(final_degree-1,reg_degree_G_q'length)) else '0'; 
degree_F_less_than_degree_G <= '1' when (unsigned(reg_degree_F_q) < unsigned(reg_degree_G_q)) else '0';
degree_B_equal_degree_C_plus_j <= '1' when (reg_degree_B_q = degree_C_plus_j) else '0';
degree_B_less_than_degree_C_plus_j <= '1' when (unsigned(reg_degree_B_q) < unsigned(degree_C_plus_j)) else '0';

end Behavioral;