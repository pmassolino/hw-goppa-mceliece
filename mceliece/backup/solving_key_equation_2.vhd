----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Solving_Key_Equation_2
-- Module Name:    Solving_Key_Equation_2
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
-- This is pipeline circuit version.
-- A bigger area version with 2 computational pipelines was made called solving_key_equation_4,
-- this new version occupies more area, but it can process four polynomials instead of two at
-- the same time.
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
-- controller_solving_key_equation_2 Rev 1.0
-- register_nbits Rev 1.0
-- register_rst_nbits Rev 1.0
-- counter_decrement_load_nbits Rev 1.0
-- counter_decrement_load_rst_nbits Rev 1.0
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

entity solving_key_equation_2 is
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
		address_value_FB : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_GC : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_FB : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_GC : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0)
	);
end solving_key_equation_2;

architecture Behavioral of solving_key_equation_2 is

component controller_solving_key_equation_2
	Port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
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
		ctr_i_load : out STD_LOGIC;
		ctr_i_rst : out STD_LOGIC;
		sel_ctr_i_rst_value : out STD_LOGIC;
		sel_ctr_i_d : out STD_LOGIC;
		reg_j_ce : out STD_LOGIC;
		reg_j_rst : out STD_LOGIC;
		reg_FB_ce : out STD_LOGIC;
		reg_FB_rst : out STD_LOGIC;
		reg_new_value_FB_ce : out STD_LOGIC;
		reg_new_value_FB_rst : out STD_LOGIC;
		sel_reg_new_value_FB : out STD_LOGIC;
		sel_load_new_value_FB : out STD_LOGIC;
		reg_GC_ce : out STD_LOGIC;
		reg_GC_rst : out STD_LOGIC;
		reg_new_value_GC_ce : out STD_LOGIC;
		reg_new_value_GC_rst : out STD_LOGIC;
		sel_reg_new_value_GC : out STD_LOGIC;
		ctr_degree_F_ce : out STD_LOGIC;
		ctr_degree_F_load : out STD_LOGIC;
		ctr_degree_F_rst : out STD_LOGIC;
		reg_degree_G_ce : out STD_LOGIC;
		reg_degree_G_rst : out STD_LOGIC;
		ctr_degree_B_ce : out STD_LOGIC;
		ctr_degree_B_load : out STD_LOGIC;
		ctr_degree_B_rst : out STD_LOGIC;
		sel_ctr_degree_B : out STD_LOGIC;
		reg_degree_C_ce : out STD_LOGIC;
		reg_degree_C_rst : out STD_LOGIC;
		reg_looking_degree_d : out STD_LOGIC_VECTOR(0 downto 0);
		reg_looking_degree_ce : out STD_LOGIC;
		reg_swap_ce : out STD_LOGIC;
		reg_swap_rst : out STD_LOGIC;
		sel_address_FB : out STD_LOGIC;
		sel_address_GC : out STD_LOGIC;
		ctr_load_address_FB_ce : out STD_LOGIC;
		ctr_load_address_FB_load : out STD_LOGIC;
		ctr_load_address_FB_rst : out STD_LOGIC;
		ctr_load_address_GC_ce : out STD_LOGIC;
		ctr_load_address_GC_load : out STD_LOGIC;
		ctr_load_address_GC_rst : out STD_LOGIC;
		reg_bus_address_FB_ce : out STD_LOGIC;
		reg_bus_address_GC_ce : out STD_LOGIC;
		reg_calc_address_FB_ce : out STD_LOGIC;
		reg_calc_address_GC_ce : out STD_LOGIC;
		reg_store_address_FB_ce : out STD_LOGIC;
		reg_store_address_GC_ce : out STD_LOGIC;
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

component counter_decrement_load_rst_nbits
	Generic (
		size : integer;
		decrement_value : integer
	);
	Port (
		d : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		load : in STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR((size - 1) downto 0);
		q : out  STD_LOGIC_VECTOR((size - 1) downto 0)
	);
end component;

component counter_decrement_load_nbits
	Generic (
		size : integer;
		decrement_value : integer
	);
	Port (
		d : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		load : in STD_LOGIC;
		q : out  STD_LOGIC_VECTOR((size - 1) downto 0)
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

signal ctr_i_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_i_ce : STD_LOGIC;
signal ctr_i_load : STD_LOGIC;
signal ctr_i_rst : STD_LOGIC;
signal ctr_i_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_i_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal sel_ctr_i_d : STD_LOGIC;
signal sel_ctr_i_rst_value : STD_LOGIC;

constant ctr_i_rst_value_F : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(2*final_degree - 1,size_final_degree + 2));
constant ctr_i_rst_value_B : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(final_degree,size_final_degree + 2));

signal reg_j_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_j_ce : STD_LOGIC;
signal reg_j_rst : STD_LOGIC;
constant reg_j_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(0,size_final_degree + 2));
signal reg_j_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_FB_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_FB_ce : STD_LOGIC;
signal reg_FB_rst : STD_LOGIC;
constant reg_FB_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_FB_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_GC_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_GC_ce : STD_LOGIC;
signal reg_GC_rst : STD_LOGIC;
constant reg_GC_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_GC_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_new_value_FB_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_FB_ce : STD_LOGIC;
signal reg_new_value_FB_rst : STD_LOGIC;
constant reg_new_value_FB_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');
signal reg_new_value_FB_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal sel_reg_new_value_FB : STD_LOGIC;

signal reg_new_value_GC_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_GC_ce : STD_LOGIC;
signal reg_new_value_GC_rst : STD_LOGIC;
constant reg_new_value_GC_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_new_value_GC_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal sel_reg_new_value_GC : STD_LOGIC;

signal ctr_degree_F_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_degree_F_ce : STD_LOGIC;
signal ctr_degree_F_load : STD_LOGIC;
signal ctr_degree_F_rst : STD_LOGIC;
constant ctr_degree_F_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(2*final_degree - 1,size_final_degree + 2));
signal ctr_degree_F_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_degree_G_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_degree_G_ce : STD_LOGIC;
signal reg_degree_G_rst : STD_LOGIC;
constant reg_degree_G_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(2*final_degree,size_final_degree + 2));
signal reg_degree_G_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal ctr_degree_B_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_degree_B_ce : STD_LOGIC;
signal ctr_degree_B_load : STD_LOGIC;
signal ctr_degree_B_rst : STD_LOGIC;
constant ctr_degree_B_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(0,size_final_degree + 2));
signal ctr_degree_B_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal sel_ctr_degree_B : STD_LOGIC;

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

signal sel_load_new_value_FB : STD_LOGIC;

signal int_write_enable_FB : STD_LOGIC;
signal int_write_enable_GC : STD_LOGIC;

signal address_degree_F : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0); 
signal address_degree_C_plus_J : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal address_degree_G : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_degree_C : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal sel_address_FB : STD_LOGIC;
signal sel_address_GC : STD_LOGIC;

signal ctr_load_address_FB_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_load_address_FB_ce : STD_LOGIC;
signal ctr_load_address_FB_load : STD_LOGIC;
signal ctr_load_address_FB_rst : STD_LOGIC;
constant ctr_load_address_FB_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(3*final_degree + 1,size_final_degree + 2));
signal ctr_load_address_FB_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal ctr_load_address_GC_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_load_address_GC_ce : STD_LOGIC;
signal ctr_load_address_GC_load : STD_LOGIC;
signal ctr_load_address_GC_rst : STD_LOGIC;
constant ctr_load_address_GC_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(3*final_degree + 1,size_final_degree + 2));
signal ctr_load_address_GC_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_bus_address_FB_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_bus_address_FB_ce : STD_LOGIC;
signal reg_bus_address_FB_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal reg_bus_address_GC_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_bus_address_GC_ce : STD_LOGIC;
signal reg_bus_address_GC_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_calc_address_FB_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_calc_address_FB_ce : STD_LOGIC;
signal reg_calc_address_FB_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal reg_calc_address_GC_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_calc_address_GC_ce : STD_LOGIC;
signal reg_calc_address_GC_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_store_address_FB_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_store_address_FB_ce : STD_LOGIC;
signal reg_store_address_FB_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal reg_store_address_GC_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_store_address_GC_ce : STD_LOGIC;
signal reg_store_address_GC_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal enable_external_swap : STD_LOGIC;

signal FB_equal_zero : STD_LOGIC;
signal i_equal_zero : STD_LOGIC;
signal i_minus_j_less_than_zero : STD_LOGIC;
signal degree_G_less_equal_final_degree : STD_LOGIC;
signal degree_F_less_than_degree_G : STD_LOGIC;
signal degree_B_equal_degree_C_plus_j : STD_LOGIC;
signal degree_B_less_than_degree_C_plus_j : STD_LOGIC;

begin

controller : controller_solving_key_equation_2
	Port Map(
		clk => clk,
		rst => rst,
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
		ctr_i_load => ctr_i_load,
		ctr_i_rst => ctr_i_rst,
		sel_ctr_i_rst_value => sel_ctr_i_rst_value,
		sel_ctr_i_d => sel_ctr_i_d,
		reg_j_ce => reg_j_ce,
		reg_j_rst => reg_j_rst,
		reg_FB_ce => reg_FB_ce,
		reg_FB_rst => reg_FB_rst,
		reg_new_value_FB_ce => reg_new_value_FB_ce,
		reg_new_value_FB_rst => reg_new_value_FB_rst,
		sel_reg_new_value_FB => sel_reg_new_value_FB,
		sel_load_new_value_FB => sel_load_new_value_FB,
		reg_GC_ce => reg_GC_ce,
		reg_GC_rst => reg_GC_rst,
		reg_new_value_GC_ce => reg_new_value_GC_ce,
		reg_new_value_GC_rst => reg_new_value_GC_rst,
		sel_reg_new_value_GC => sel_reg_new_value_GC,
		ctr_degree_F_ce => ctr_degree_F_ce,
		ctr_degree_F_load => ctr_degree_F_load,
		ctr_degree_F_rst => ctr_degree_F_rst,
		reg_degree_G_ce => reg_degree_G_ce,
		reg_degree_G_rst => reg_degree_G_rst,
		ctr_degree_B_ce => ctr_degree_B_ce,
		ctr_degree_B_load => ctr_degree_B_load,
		ctr_degree_B_rst => ctr_degree_B_rst,
		sel_ctr_degree_B => sel_ctr_degree_B,
		reg_degree_C_ce => reg_degree_C_ce,
		reg_degree_C_rst => reg_degree_C_rst,
		reg_looking_degree_d => reg_looking_degree_d,		
		reg_looking_degree_ce => reg_looking_degree_ce,
		reg_swap_ce => reg_swap_ce,
		reg_swap_rst => reg_swap_rst,
		sel_address_FB => sel_address_FB,
		sel_address_GC => sel_address_GC,
		ctr_load_address_FB_ce => ctr_load_address_FB_ce,
		ctr_load_address_FB_load => ctr_load_address_FB_load,
		ctr_load_address_FB_rst => ctr_load_address_FB_rst,
		ctr_load_address_GC_ce => ctr_load_address_GC_ce,
		ctr_load_address_GC_load => ctr_load_address_GC_load,
		ctr_load_address_GC_rst => ctr_load_address_GC_rst,
		reg_bus_address_FB_ce => reg_bus_address_FB_ce,
		reg_bus_address_GC_ce => reg_bus_address_GC_ce,
		reg_calc_address_FB_ce => reg_calc_address_FB_ce,
		reg_calc_address_GC_ce => reg_calc_address_GC_ce,
		reg_store_address_FB_ce => reg_store_address_FB_ce,
		reg_store_address_GC_ce => reg_store_address_GC_ce,
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

ctr_i : counter_decrement_load_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_i_d,
		clk => clk,
		ce => ctr_i_ce,
		load => ctr_i_load,
		rst => ctr_i_rst,
		rst_value => ctr_i_rst_value,
		q => ctr_i_q
	);

reg_j : register_rst_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_j_d,
		clk => clk,
		ce => reg_j_ce,
		rst => reg_j_rst,
		rst_value => reg_j_rst_value,
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
	
reg_new_value_FB : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_FB_d,
		clk => clk,
		ce => reg_new_value_FB_ce,
		rst => reg_new_value_FB_rst,
		rst_value => reg_new_value_FB_rst_value,
		q => reg_new_value_FB_q
	);

reg_new_value_GC : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_GC_d,
		clk => clk,
		ce => reg_new_value_GC_ce,
		rst => reg_new_value_GC_rst,
		rst_value => reg_new_value_GC_rst_value,
		q => reg_new_value_GC_q
	);

ctr_degree_F : counter_decrement_load_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_degree_F_d,
		clk => clk,
		ce => ctr_degree_F_ce,
		load => ctr_degree_F_load,
		rst => ctr_degree_F_rst,
		rst_value => ctr_degree_F_rst_value,
		q => ctr_degree_F_q
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

ctr_degree_B : counter_decrement_load_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_degree_B_d,
		clk => clk,
		ce => ctr_degree_B_ce,
		load => ctr_degree_B_load,
		rst => ctr_degree_B_rst,
		rst_value => ctr_degree_B_rst_value,
		q => ctr_degree_B_q
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
	
ctr_load_address_FB : counter_decrement_load_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_load_address_FB_d,
		clk => clk,
		ce => ctr_load_address_FB_ce,
		load => ctr_load_address_FB_load,
		rst => ctr_load_address_FB_rst,
		rst_value => ctr_load_address_FB_rst_value, 
		q => ctr_load_address_FB_q
	);	
	
ctr_load_address_GC : counter_decrement_load_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_load_address_GC_d,
		clk => clk,
		ce => ctr_load_address_GC_ce,
		load => ctr_load_address_GC_load,
		rst => ctr_load_address_GC_rst,
		rst_value => ctr_load_address_GC_rst_value,
		q => ctr_load_address_GC_q
	);

reg_bus_address_FB : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_bus_address_FB_d,
		clk => clk,
		ce => reg_bus_address_FB_ce,
		q => reg_bus_address_FB_q
	);	
	
reg_bus_address_GC : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_bus_address_GC_d,
		clk => clk,
		ce => reg_bus_address_GC_ce,
		q => reg_bus_address_GC_q
	);
	
reg_calc_address_FB : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_calc_address_FB_d,
		clk => clk,
		ce => reg_calc_address_FB_ce,
		q => reg_calc_address_FB_q
	);	
	
reg_calc_address_GC : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_calc_address_GC_d,
		clk => clk,
		ce => reg_calc_address_GC_ce,
		q => reg_calc_address_GC_q
	);
	
reg_store_address_FB : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_store_address_FB_d,
		clk => clk,
		ce => reg_store_address_FB_ce,
		q => reg_store_address_FB_q
	);	
	
reg_store_address_GC : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_store_address_GC_d,
		clk => clk,
		ce => reg_store_address_GC_ce,
		q => reg_store_address_GC_q
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

ctr_i_d <= ctr_degree_F_q when sel_ctr_i_d = '1' else
			degree_C_plus_j;

ctr_i_rst_value <= ctr_i_rst_value_F when sel_ctr_i_rst_value = '1' else
						 ctr_i_rst_value_B;

reg_j_d <= std_logic_vector(unsigned(ctr_degree_F_q) - unsigned(reg_degree_G_q));
	
reg_FB_d <= int_value_FB;
	
reg_GC_d <= int_value_GC;

ctr_degree_F_d <= reg_degree_G_q;
						
reg_degree_G_d <= ctr_degree_F_q;

ctr_degree_B_d <= degree_C_plus_j when sel_ctr_degree_B = '1' else
					reg_degree_C_q;
		
degree_C_plus_j <= std_logic_vector(unsigned(reg_degree_C_q) + unsigned(reg_j_q));

i_minus_j <= std_logic_vector(unsigned(ctr_i_q) - unsigned(reg_j_q));

reg_degree_C_d <= ctr_degree_B_q;

reg_swap_d <= not reg_swap_q;

reg_new_value_FB_d <= (base_mult_o xor reg_FB_q) when sel_load_new_value_FB = '1' else
							std_logic_vector(to_unsigned(1, reg_FB_d'length)) when sel_reg_new_value_FB = '1' else 
							reg_FB_q;
reg_new_value_GC_d <= std_logic_vector(to_unsigned(1, reg_GC_d'length)) when sel_reg_new_value_GC = '1' else
							reg_GC_q;

int_value_FB <= value_GC when reg_swap_q = "1" else value_FB;
int_value_GC <= value_FB when reg_swap_q = "1" else value_GC;

new_value_inv <= reg_new_value_FB_q;

new_value_FB <= reg_new_value_GC_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_new_value_FB_q;
new_value_GC <= reg_new_value_FB_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_new_value_GC_q;

write_enable_FB <= int_write_enable_GC when (reg_swap_q(0) and enable_external_swap) = '1' else int_write_enable_FB;
write_enable_GC <= int_write_enable_FB when (reg_swap_q(0) and enable_external_swap) = '1' else int_write_enable_GC;

address_degree_F <= ctr_degree_F_q;
address_degree_C_plus_j <= std_logic_vector(to_unsigned(2*final_degree + 1, address_degree_C_plus_j'length) + unsigned(degree_C_plus_j));

address_degree_G <= reg_degree_G_q;
address_degree_C <= std_logic_vector(to_unsigned(2*final_degree + 1, address_degree_C'length) + unsigned(reg_degree_C_q));

ctr_load_address_FB_d <= address_degree_F when sel_address_FB = '1' else 
						address_degree_C_plus_j;
						
ctr_load_address_GC_d <= address_degree_G when sel_address_GC = '1' else 
							address_degree_C;

reg_bus_address_FB_d <= ctr_load_address_FB_q;
reg_bus_address_GC_d <= ctr_load_address_GC_q;

reg_calc_address_FB_d <= reg_bus_address_FB_q;
reg_calc_address_GC_d <= reg_bus_address_GC_q;

reg_store_address_FB_d <= reg_calc_address_FB_q;
reg_store_address_GC_d <= reg_calc_address_GC_q;

address_value_FB <= ctr_load_address_GC_q when reg_swap_q(0) = '1' else ctr_load_address_FB_q;
address_value_GC <= ctr_load_address_FB_q when reg_swap_q(0) = '1' else ctr_load_address_GC_q;

address_new_value_FB <= reg_store_address_GC_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_store_address_FB_q;
address_new_value_GC <= reg_store_address_FB_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_store_address_GC_q;

FB_equal_zero <= '1' when (reg_new_value_FB_q = std_logic_vector(to_unsigned(0,reg_FB_q'length))) else '0';
i_equal_zero <= '1' when (ctr_i_q = std_logic_vector(to_unsigned(0,ctr_i_q'length))) else '0';
i_minus_j_less_than_zero <= '1' when (signed(i_minus_j) < to_signed(0,i_minus_j'length)) else '0';
degree_G_less_equal_final_degree <= '1' when (unsigned(reg_degree_G_q) <= to_unsigned(final_degree-1,reg_degree_G_q'length)) else '0'; 
degree_F_less_than_degree_G <= '1' when (unsigned(ctr_degree_F_q) < unsigned(reg_degree_G_q)) else '0';
degree_B_equal_degree_C_plus_j <= '1' when (ctr_degree_B_q = degree_C_plus_j) else '0';
degree_B_less_than_degree_C_plus_j <= '1' when (unsigned(ctr_degree_B_q) < unsigned(degree_C_plus_j)) else '0';

end Behavioral;