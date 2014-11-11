----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Solving_Key_Equation_4
-- Module Name:    Solving_Key_Equation_4
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
-- This is pipeline circuit version that can operate all four polynomials at the same time.
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
-- controller_FG_solving_key_equation_4 Rev 1.0
-- controller_BC_solving_key_equation_4 Rev 1.0
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

entity solving_key_equation_4 is
	Generic(
	
		-- GOPPA [2048, 1751, 27, 11] --
		
--		gf_2_m : integer range 1 to 20 := 11;
--		final_degree : integer := 27;
--		size_final_degree : integer := 5

		-- GOPPA [2048, 1498, 50, 11] --
		
--		gf_2_m : integer range 1 to 20 := 11;
--		final_degree : integer := 50;
--		size_final_degree : integer := 6

		-- GOPPA [3307, 2515, 66, 12] --
		
--		gf_2_m : integer range 1 to 20 := 12;
--		final_degree : integer := 66;
--		size_final_degree : integer := 7

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

		gf_2_m : integer range 1 to 20 := 13;
		final_degree : integer := 128;
		size_final_degree : integer := 7

	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		ready_inv : in STD_LOGIC;
		value_F : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_G : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_B : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_C : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_inv : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		signal_inv : out STD_LOGIC;
		key_equation_found : out STD_LOGIC;
		write_enable_F : out STD_LOGIC;
		write_enable_G : out STD_LOGIC;
		write_enable_B : out STD_LOGIC;
		write_enable_C : out STD_LOGIC;
		new_value_inv : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_F : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_B : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_G : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_C : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		address_value_F : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_G : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_B : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_C : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_F : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_G : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_B : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_C : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0)
	);
end solving_key_equation_4;

architecture Behavioral of solving_key_equation_4 is

component controller_FG_solving_key_equation_4
	Port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		F_equal_zero : in STD_LOGIC;
		i_FG_equal_zero : in STD_LOGIC;
		i_FG_minus_j_less_than_zero : in STD_LOGIC;
		degree_G_less_equal_final_degree : in STD_LOGIC;
		degree_F_less_than_degree_G : in STD_LOGIC;
		reg_looking_degree_FG_q : in STD_LOGIC_VECTOR(0 downto 0);
		ready_controller_BC : in STD_LOGIC;
		ready_controller_FG : out STD_LOGIC;
		key_equation_found : out STD_LOGIC;
		signal_inv : out STD_LOGIC;
		write_enable_F : out STD_LOGIC;
		write_enable_G : out STD_LOGIC;
		sel_base_mul_FG : out STD_LOGIC;
		reg_h_ce : out STD_LOGIC;
		ctr_i_FG_ce : out STD_LOGIC;
		ctr_i_FG_load : out STD_LOGIC;
		ctr_i_FG_rst : out STD_LOGIC;
		reg_j_ce : out STD_LOGIC;
		reg_j_rst : out STD_LOGIC;
		reg_F_ce : out STD_LOGIC;
		reg_F_rst : out STD_LOGIC;
		reg_new_value_F_ce : out STD_LOGIC;
		reg_new_value_F_rst : out STD_LOGIC;
		sel_load_new_value_F : out STD_LOGIC;
		reg_G_ce : out STD_LOGIC;
		reg_G_rst : out STD_LOGIC;
		reg_new_value_G_ce : out STD_LOGIC;
		reg_new_value_G_rst : out STD_LOGIC;
		sel_reg_new_value_G : out STD_LOGIC;
		ctr_degree_F_ce : out STD_LOGIC;
		ctr_degree_F_load : out STD_LOGIC;
		ctr_degree_F_rst : out STD_LOGIC;
		reg_degree_G_ce : out STD_LOGIC;
		reg_degree_G_rst : out STD_LOGIC;
		reg_looking_degree_FG_d : out STD_LOGIC_VECTOR(0 downto 0);
		reg_looking_degree_FG_ce : out STD_LOGIC;
		reg_swap_ce : out STD_LOGIC;
		reg_swap_rst : out STD_LOGIC;
		ctr_load_address_F_ce : out STD_LOGIC;
		ctr_load_address_F_load : out STD_LOGIC;
		ctr_load_address_G_ce : out STD_LOGIC;
		ctr_load_address_G_load : out STD_LOGIC;
		reg_bus_address_F_ce : out STD_LOGIC;
		reg_bus_address_G_ce : out STD_LOGIC;
		reg_calc_address_F_ce : out STD_LOGIC;
		reg_calc_address_G_ce : out STD_LOGIC;
		reg_store_address_F_ce : out STD_LOGIC;
		reg_store_address_F_rst : out STD_LOGIC;
		reg_store_address_G_ce : out STD_LOGIC;
		reg_store_address_G_rst : out STD_LOGIC;
		enable_external_swap : out STD_LOGIC
	);
end component;

component controller_BC_solving_key_equation_4
	Port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		B_equal_zero : in STD_LOGIC;
		i_BC_equal_zero : in STD_LOGIC;
		i_BC_minus_j_less_than_zero : in STD_LOGIC;
		degree_G_less_equal_final_degree : in STD_LOGIC;
		degree_F_less_than_degree_G : in STD_LOGIC;
		degree_B_equal_degree_C_plus_j : in STD_LOGIC;
		degree_B_less_than_degree_C_plus_j : in STD_LOGIC;
		reg_looking_degree_BC_q : in STD_LOGIC_VECTOR(0 downto 0);
		ready_controller_FG : in STD_LOGIC;
		ready_controller_BC : out STD_LOGIC;		
		write_enable_B : out STD_LOGIC;
		write_enable_C : out STD_LOGIC;
		ctr_i_BC_ce : out STD_LOGIC;
		ctr_i_BC_load : out STD_LOGIC;
		ctr_i_BC_rst : out STD_LOGIC;
		reg_B_ce : out STD_LOGIC;
		reg_B_rst : out STD_LOGIC;
		reg_new_value_B_ce : out STD_LOGIC;
		reg_new_value_B_rst : out STD_LOGIC;
		sel_reg_new_value_B : out STD_LOGIC;
		sel_load_new_value_B : out STD_LOGIC;
		reg_C_ce : out STD_LOGIC;
		reg_C_rst : out STD_LOGIC;
		reg_new_value_C_ce : out STD_LOGIC;
		reg_new_value_C_rst : out STD_LOGIC;
		ctr_degree_B_ce : out STD_LOGIC;
		ctr_degree_B_load : out STD_LOGIC;
		ctr_degree_B_rst : out STD_LOGIC;
		sel_ctr_degree_B : out STD_LOGIC;
		reg_degree_C_ce : out STD_LOGIC;
		reg_degree_C_rst : out STD_LOGIC;
		reg_looking_degree_BC_d : out STD_LOGIC_VECTOR(0 downto 0);
		reg_looking_degree_BC_ce : out STD_LOGIC;
		ctr_load_address_B_ce : out STD_LOGIC;
		ctr_load_address_B_load : out STD_LOGIC;
		ctr_load_address_B_rst : out STD_LOGIC;
		ctr_load_address_C_ce : out STD_LOGIC;
		ctr_load_address_C_load : out STD_LOGIC;
		ctr_load_address_C_rst : out STD_LOGIC;
		reg_bus_address_B_ce : out STD_LOGIC;
		reg_bus_address_C_ce : out STD_LOGIC;
		reg_calc_address_B_ce : out STD_LOGIC;
		reg_calc_address_C_ce : out STD_LOGIC;
		reg_store_address_B_ce : out STD_LOGIC;
		reg_store_address_B_rst : out STD_LOGIC;
		reg_store_address_C_ce : out STD_LOGIC;
		reg_store_address_C_rst : out STD_LOGIC
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

signal base_mult_FG_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal base_mult_FG_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal base_mult_FG_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal base_mult_BC_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal base_mult_BC_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal base_mult_BC_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal sel_base_mul_FG : STD_LOGIC;

signal reg_h_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_h_ce : STD_LOGIC;
signal reg_h_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_inv_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_inv_ce : STD_LOGIC;
signal reg_inv_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal ctr_i_FG_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_i_FG_ce : STD_LOGIC;
signal ctr_i_FG_load : STD_LOGIC;
signal ctr_i_FG_rst : STD_LOGIC;
constant ctr_i_FG_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(2*final_degree - 1,size_final_degree + 2));
signal ctr_i_FG_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal ctr_i_BC_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_i_BC_ce : STD_LOGIC;
signal ctr_i_BC_load : STD_LOGIC;
signal ctr_i_BC_rst : STD_LOGIC;
constant ctr_i_BC_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(final_degree,size_final_degree + 2));
signal ctr_i_BC_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_j_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_j_ce : STD_LOGIC;
signal reg_j_rst : STD_LOGIC;
constant reg_j_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(0,size_final_degree + 2));
signal reg_j_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_F_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_F_ce : STD_LOGIC;
signal reg_F_rst : STD_LOGIC;
constant reg_F_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_F_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_G_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_G_ce : STD_LOGIC;
signal reg_G_rst : STD_LOGIC;
constant reg_G_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_G_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_B_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_B_ce : STD_LOGIC;
signal reg_B_rst : STD_LOGIC;
constant reg_B_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_B_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_C_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_C_ce : STD_LOGIC;
signal reg_C_rst : STD_LOGIC;
constant reg_C_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_C_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_new_value_F_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_F_ce : STD_LOGIC;
signal reg_new_value_F_rst : STD_LOGIC;
constant reg_new_value_F_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');
signal reg_new_value_F_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_new_value_G_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_G_ce : STD_LOGIC;
signal reg_new_value_G_rst : STD_LOGIC;
constant reg_new_value_G_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_new_value_G_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal sel_reg_new_value_G : STD_LOGIC;

signal reg_new_value_B_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_B_ce : STD_LOGIC;
signal reg_new_value_B_rst : STD_LOGIC;
constant reg_new_value_B_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');
signal reg_new_value_B_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal sel_reg_new_value_B : STD_LOGIC;

signal reg_new_value_C_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_C_ce : STD_LOGIC;
signal reg_new_value_C_rst : STD_LOGIC;
constant reg_new_value_C_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others=> '0');
signal reg_new_value_C_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

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
	
signal reg_looking_degree_FG_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_looking_degree_FG_ce : STD_LOGIC;
signal reg_looking_degree_FG_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_looking_degree_BC_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_looking_degree_BC_ce : STD_LOGIC;
signal reg_looking_degree_BC_q : STD_LOGIC_VECTOR(0 downto 0);
	
signal reg_swap_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_swap_ce : STD_LOGIC;
signal reg_swap_rst : STD_LOGIC;
constant reg_swap_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_swap_q : STD_LOGIC_VECTOR(0 downto 0);

signal i_FG_minus_j : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal i_BC_minus_j : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal degree_C_plus_j : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal int_value_F : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal int_value_G : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal int_value_B : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal int_value_C : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal sel_load_new_value_F : STD_LOGIC;
signal sel_load_new_value_B : STD_LOGIC;

signal int_write_enable_F : STD_LOGIC;
signal int_write_enable_G : STD_LOGIC;
signal int_write_enable_B : STD_LOGIC;
signal int_write_enable_C : STD_LOGIC;

signal address_degree_F : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0); 
signal address_degree_C_plus_J : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal address_degree_G : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_degree_C : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal ctr_load_address_F_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_load_address_F_ce : STD_LOGIC;
signal ctr_load_address_F_load : STD_LOGIC;
signal ctr_load_address_F_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal ctr_load_address_G_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_load_address_G_ce : STD_LOGIC;
signal ctr_load_address_G_load : STD_LOGIC;
signal ctr_load_address_G_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal ctr_load_address_B_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_load_address_B_ce : STD_LOGIC;
signal ctr_load_address_B_load : STD_LOGIC;
signal ctr_load_address_B_rst : STD_LOGIC;
constant ctr_load_address_B_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(final_degree,size_final_degree + 2));
signal ctr_load_address_B_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal ctr_load_address_C_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal ctr_load_address_C_ce : STD_LOGIC;
signal ctr_load_address_C_load : STD_LOGIC;
signal ctr_load_address_C_rst : STD_LOGIC;
constant ctr_load_address_C_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(final_degree,size_final_degree + 2));
signal ctr_load_address_C_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_bus_address_F_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_bus_address_F_ce : STD_LOGIC;
signal reg_bus_address_F_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal reg_bus_address_G_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_bus_address_G_ce : STD_LOGIC;
signal reg_bus_address_G_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_bus_address_B_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_bus_address_B_ce : STD_LOGIC;
signal reg_bus_address_B_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal reg_bus_address_C_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_bus_address_C_ce : STD_LOGIC;
signal reg_bus_address_C_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_calc_address_F_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_calc_address_F_ce : STD_LOGIC;
signal reg_calc_address_F_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal reg_calc_address_G_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_calc_address_G_ce : STD_LOGIC;
signal reg_calc_address_G_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_calc_address_B_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_calc_address_B_ce : STD_LOGIC;
signal reg_calc_address_B_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal reg_calc_address_C_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_calc_address_C_ce : STD_LOGIC;
signal reg_calc_address_C_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_store_address_F_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_store_address_F_ce : STD_LOGIC;
signal reg_store_address_F_rst : STD_LOGIC;
constant reg_store_address_F_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := (others => '0');
signal reg_store_address_F_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal reg_store_address_G_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_store_address_G_ce : STD_LOGIC;
signal reg_store_address_G_rst : STD_LOGIC;
constant reg_store_address_G_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := (others => '0');
signal reg_store_address_G_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_store_address_B_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_store_address_B_ce : STD_LOGIC;
signal reg_store_address_B_rst : STD_LOGIC;
constant reg_store_address_B_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := (others => '0');
signal reg_store_address_B_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
	
signal reg_store_address_C_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_store_address_C_ce : STD_LOGIC;
signal reg_store_address_C_rst : STD_LOGIC;
constant reg_store_address_C_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := (others => '0');
signal reg_store_address_C_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal ready_controller_BC : STD_LOGIC;
signal ready_controller_FG : STD_LOGIC;

signal enable_external_swap : STD_LOGIC;

signal F_equal_zero : STD_LOGIC;
signal B_equal_zero : STD_LOGIC;
signal i_FG_equal_zero : STD_LOGIC;
signal i_BC_equal_zero : STD_LOGIC;
signal i_FG_minus_j_less_than_zero : STD_LOGIC;
signal i_BC_minus_j_less_than_zero : STD_LOGIC;
signal degree_G_less_equal_final_degree : STD_LOGIC;
signal degree_F_less_than_degree_G : STD_LOGIC;
signal degree_B_equal_degree_C_plus_j : STD_LOGIC;
signal degree_B_less_than_degree_C_plus_j : STD_LOGIC;

begin

controller_FG : controller_FG_solving_key_equation_4
	Port Map(
		clk => clk,
		rst => rst,
		F_equal_zero => F_equal_zero,
		i_FG_equal_zero => i_FG_equal_zero,
		i_FG_minus_j_less_than_zero => i_FG_minus_j_less_than_zero,
		degree_G_less_equal_final_degree => degree_G_less_equal_final_degree,
		degree_F_less_than_degree_G => degree_F_less_than_degree_G,
		reg_looking_degree_FG_q => reg_looking_degree_FG_q,
		ready_controller_BC => ready_controller_BC,
		ready_controller_FG => ready_controller_FG,
		key_equation_found => key_equation_found,
		signal_inv => signal_inv,
		write_enable_F => int_write_enable_F,
		write_enable_G => int_write_enable_G,
		sel_base_mul_FG => sel_base_mul_FG,
		reg_h_ce => reg_h_ce,
		ctr_i_FG_ce => ctr_i_FG_ce,
		ctr_i_FG_load => ctr_i_FG_load,
		ctr_i_FG_rst => ctr_i_FG_rst,
		reg_j_ce => reg_j_ce,
		reg_j_rst => reg_j_rst,
		reg_F_ce => reg_F_ce,
		reg_F_rst => reg_F_rst,
		reg_new_value_F_ce => reg_new_value_F_ce,
		reg_new_value_F_rst => reg_new_value_F_rst,
		sel_load_new_value_F => sel_load_new_value_F,
		reg_G_ce => reg_G_ce,
		reg_G_rst => reg_G_rst,
		reg_new_value_G_ce => reg_new_value_G_ce,
		reg_new_value_G_rst => reg_new_value_G_rst,
		sel_reg_new_value_G => sel_reg_new_value_G,
		ctr_degree_F_ce => ctr_degree_F_ce,
		ctr_degree_F_load => ctr_degree_F_load,
		ctr_degree_F_rst => ctr_degree_F_rst,
		reg_degree_G_ce => reg_degree_G_ce,
		reg_degree_G_rst => reg_degree_G_rst,
		reg_looking_degree_FG_d => reg_looking_degree_FG_d,
		reg_looking_degree_FG_ce => reg_looking_degree_FG_ce,
		reg_swap_ce => reg_swap_ce,
		reg_swap_rst => reg_swap_rst,
		ctr_load_address_F_ce => ctr_load_address_F_ce,
		ctr_load_address_F_load => ctr_load_address_F_load,
		ctr_load_address_G_ce => ctr_load_address_G_ce,
		ctr_load_address_G_load => ctr_load_address_G_load,
		reg_bus_address_F_ce => reg_bus_address_F_ce,
		reg_bus_address_G_ce => reg_bus_address_G_ce,
		reg_calc_address_F_ce => reg_calc_address_F_ce,
		reg_calc_address_G_ce => reg_calc_address_G_ce,
		reg_store_address_F_ce => reg_store_address_F_ce,
		reg_store_address_F_rst => reg_store_address_F_rst,
		reg_store_address_G_ce => reg_store_address_G_ce,
		reg_store_address_G_rst => reg_store_address_G_rst,
		enable_external_swap => enable_external_swap
	);
	
controller_BC : controller_BC_solving_key_equation_4
	Port Map(
		clk => clk,
		rst => rst,
		B_equal_zero => B_equal_zero,
		i_BC_equal_zero => i_BC_equal_zero,
		i_BC_minus_j_less_than_zero => i_BC_minus_j_less_than_zero,
		degree_G_less_equal_final_degree => degree_G_less_equal_final_degree,
		degree_F_less_than_degree_G => degree_F_less_than_degree_G,
		degree_B_equal_degree_C_plus_j => degree_B_equal_degree_C_plus_j,
		degree_B_less_than_degree_C_plus_j => degree_B_less_than_degree_C_plus_j,
		reg_looking_degree_BC_q => reg_looking_degree_BC_q,
		ready_controller_FG => ready_controller_FG,
		ready_controller_BC => ready_controller_BC,		
		write_enable_B => int_write_enable_B,
		write_enable_C => int_write_enable_C,
		ctr_i_BC_ce => ctr_i_BC_ce,
		ctr_i_BC_load => ctr_i_BC_load,
		ctr_i_BC_rst => ctr_i_BC_rst,
		reg_B_ce => reg_B_ce,
		reg_B_rst => reg_B_rst,
		reg_new_value_B_ce => reg_new_value_B_ce,
		reg_new_value_B_rst => reg_new_value_B_rst,
		sel_reg_new_value_B => sel_reg_new_value_B,
		sel_load_new_value_B => sel_load_new_value_B,
		reg_C_ce => reg_C_ce,
		reg_C_rst => reg_C_rst,
		reg_new_value_C_ce => reg_new_value_C_ce,
		reg_new_value_C_rst => reg_new_value_C_rst,
		ctr_degree_B_ce => ctr_degree_B_ce,
		ctr_degree_B_load => ctr_degree_B_load,
		ctr_degree_B_rst => ctr_degree_B_rst,
		sel_ctr_degree_B => sel_ctr_degree_B,
		reg_degree_C_ce => reg_degree_C_ce,
		reg_degree_C_rst => reg_degree_C_rst,
		reg_looking_degree_BC_d => reg_looking_degree_BC_d,
		reg_looking_degree_BC_ce => reg_looking_degree_BC_ce,
		ctr_load_address_B_ce => ctr_load_address_B_ce,
		ctr_load_address_B_load => ctr_load_address_B_load,
		ctr_load_address_B_rst => ctr_load_address_B_rst,
		ctr_load_address_C_ce => ctr_load_address_C_ce,
		ctr_load_address_C_load => ctr_load_address_C_load,
		ctr_load_address_C_rst => ctr_load_address_C_rst,
		reg_bus_address_B_ce => reg_bus_address_B_ce,
		reg_bus_address_C_ce => reg_bus_address_C_ce,
		reg_calc_address_B_ce => reg_calc_address_B_ce,
		reg_calc_address_C_ce => reg_calc_address_C_ce,
		reg_store_address_B_ce => reg_store_address_B_ce,
		reg_store_address_B_rst => reg_store_address_B_rst,
		reg_store_address_C_ce => reg_store_address_C_ce,
		reg_store_address_C_rst => reg_store_address_C_rst
	);

base_mult_FG : mult_gf_2_m
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => base_mult_FG_a,
		b => base_mult_FG_b,
		o => base_mult_FG_o
	);
	
base_mult_BC : mult_gf_2_m
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => base_mult_BC_a,
		b => base_mult_BC_b,
		o => base_mult_BC_o
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

ctr_i_FG : counter_decrement_load_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_i_FG_d,
		clk => clk,
		ce => ctr_i_FG_ce,
		load => ctr_i_FG_load,
		rst => ctr_i_FG_rst,
		rst_value => ctr_i_FG_rst_value,
		q => ctr_i_FG_q
	);
	
ctr_i_BC : counter_decrement_load_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_i_BC_d,
		clk => clk,
		ce => ctr_i_BC_ce,
		load => ctr_i_BC_load,
		rst => ctr_i_BC_rst,
		rst_value => ctr_i_BC_rst_value,
		q => ctr_i_BC_q
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

reg_F : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_F_d,
		clk => clk,
		rst => reg_F_rst,
		rst_value => reg_F_rst_value,
		ce => reg_F_ce,
		q => reg_F_q
	);

reg_G : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_G_d,
		clk => clk,
		rst => reg_G_rst,
		rst_value => reg_G_rst_value,
		ce => reg_G_ce,
		q => reg_G_q
	);
	
reg_B : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_B_d,
		clk => clk,
		rst => reg_B_rst,
		rst_value => reg_B_rst_value,
		ce => reg_B_ce,
		q => reg_B_q
	);

reg_C : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_C_d,
		clk => clk,
		rst => reg_C_rst,
		rst_value => reg_C_rst_value,
		ce => reg_C_ce,
		q => reg_C_q
	);
	
reg_new_value_F : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_F_d,
		clk => clk,
		ce => reg_new_value_F_ce,
		rst => reg_new_value_F_rst,
		rst_value => reg_new_value_F_rst_value,
		q => reg_new_value_F_q
	);

reg_new_value_G : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_G_d,
		clk => clk,
		ce => reg_new_value_G_ce,
		rst => reg_new_value_G_rst,
		rst_value => reg_new_value_G_rst_value,
		q => reg_new_value_G_q
	);
	
reg_new_value_B : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_B_d,
		clk => clk,
		ce => reg_new_value_B_ce,
		rst => reg_new_value_B_rst,
		rst_value => reg_new_value_B_rst_value,
		q => reg_new_value_B_q
	);

reg_new_value_C : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_C_d,
		clk => clk,
		ce => reg_new_value_C_ce,
		rst => reg_new_value_C_rst,
		rst_value => reg_new_value_C_rst_value,
		q => reg_new_value_C_q
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
	
ctr_load_address_F : counter_decrement_load_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_load_address_F_d,
		clk => clk,
		ce => ctr_load_address_F_ce,
		load => ctr_load_address_F_load,
		q => ctr_load_address_F_q
	);	
	
ctr_load_address_G : counter_decrement_load_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_load_address_G_d,
		clk => clk,
		ce => ctr_load_address_G_ce,
		load => ctr_load_address_G_load,
		q => ctr_load_address_G_q
	);
	
ctr_load_address_B : counter_decrement_load_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_load_address_B_d,
		clk => clk,
		ce => ctr_load_address_B_ce,
		load => ctr_load_address_B_load,
		rst => ctr_load_address_B_rst,
		rst_value => ctr_load_address_B_rst_value, 
		q => ctr_load_address_B_q
	);	
	
ctr_load_address_C : counter_decrement_load_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		decrement_value => 1
	)
	Port Map(
		d => ctr_load_address_C_d,
		clk => clk,
		ce => ctr_load_address_C_ce,
		load => ctr_load_address_C_load,
		rst => ctr_load_address_C_rst,
		rst_value => ctr_load_address_C_rst_value,
		q => ctr_load_address_C_q
	);

reg_bus_address_F : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_bus_address_F_d,
		clk => clk,
		ce => reg_bus_address_F_ce,
		q => reg_bus_address_F_q
	);	
	
reg_bus_address_G : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_bus_address_G_d,
		clk => clk,
		ce => reg_bus_address_G_ce,
		q => reg_bus_address_G_q
	);
	
reg_bus_address_B : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_bus_address_B_d,
		clk => clk,
		ce => reg_bus_address_B_ce,
		q => reg_bus_address_B_q
	);	
	
reg_bus_address_C : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_bus_address_C_d,
		clk => clk,
		ce => reg_bus_address_C_ce,
		q => reg_bus_address_C_q
	);
	
reg_calc_address_F : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_calc_address_F_d,
		clk => clk,
		ce => reg_calc_address_F_ce,
		q => reg_calc_address_F_q
	);	
	
reg_calc_address_G : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_calc_address_G_d,
		clk => clk,
		ce => reg_calc_address_G_ce,
		q => reg_calc_address_G_q
	);
	
reg_calc_address_B : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_calc_address_B_d,
		clk => clk,
		ce => reg_calc_address_B_ce,
		q => reg_calc_address_B_q
	);	
	
reg_calc_address_C : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_calc_address_C_d,
		clk => clk,
		ce => reg_calc_address_C_ce,
		q => reg_calc_address_C_q
	);
	
reg_store_address_F : register_rst_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_store_address_F_d,
		clk => clk,
		ce => reg_store_address_F_ce,
		rst => reg_store_address_F_rst,
		rst_value => reg_store_address_F_rst_value,
		q => reg_store_address_F_q
	);	
	
reg_store_address_G : register_rst_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_store_address_G_d,
		clk => clk,
		ce => reg_store_address_G_ce,
		rst => reg_store_address_G_rst,
		rst_value => reg_store_address_G_rst_value,
		q => reg_store_address_G_q
	);
	
reg_store_address_B : register_rst_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_store_address_B_d,
		clk => clk,
		ce => reg_store_address_B_ce,
		rst => reg_store_address_B_rst,
		rst_value => reg_store_address_B_rst_value,
		q => reg_store_address_B_q
	);	
	
reg_store_address_C : register_rst_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_store_address_C_d,
		clk => clk,
		ce => reg_store_address_C_ce,
		rst => reg_store_address_C_rst,
		rst_value => reg_store_address_C_rst_value,
		q => reg_store_address_C_q
	);

reg_looking_degree_FG : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_looking_degree_FG_d,
		clk => clk,
		ce => reg_looking_degree_FG_ce,
		q => reg_looking_degree_FG_q
	);
	
reg_looking_degree_BC : register_nbits
	Generic Map(
		size => 1
	)
	Port Map(
		d => reg_looking_degree_BC_d,
		clk => clk,
		ce => reg_looking_degree_BC_ce,
		q => reg_looking_degree_BC_q
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

base_mult_FG_a <= reg_inv_q when sel_base_mul_FG = '1' else
					reg_h_q;
base_mult_FG_b <= reg_F_q when sel_base_mul_FG = '1' else
					reg_G_q;
					
base_mult_BC_a <= reg_h_q;
base_mult_BC_b <= reg_C_q;

reg_h_d <= base_mult_FG_o;

reg_inv_d <= value_inv;
reg_inv_ce <= ready_inv;

ctr_i_FG_d <= ctr_degree_F_q;

ctr_i_BC_d <= degree_C_plus_j;

reg_j_d <= std_logic_vector(unsigned(ctr_degree_F_q) - unsigned(reg_degree_G_q));
	
reg_F_d <= int_value_F;
	
reg_G_d <= int_value_G;

reg_B_d <= int_value_B;
	
reg_C_d <= int_value_C;

ctr_degree_F_d <= reg_degree_G_q;
						
reg_degree_G_d <= ctr_degree_F_q;

ctr_degree_B_d <= degree_C_plus_j when sel_ctr_degree_B = '1' else
					reg_degree_C_q;
		
degree_C_plus_j <= std_logic_vector(unsigned(reg_degree_C_q) + unsigned(reg_j_q));

i_FG_minus_j <= std_logic_vector(unsigned(ctr_i_FG_q) - unsigned(reg_j_q));
i_BC_minus_j <= std_logic_vector(unsigned(ctr_i_BC_q) - unsigned(reg_j_q));

reg_degree_C_d <= ctr_degree_B_q;

reg_swap_d <= not reg_swap_q;

reg_new_value_F_d <= (base_mult_FG_o xor reg_F_q) when sel_load_new_value_F = '1' else
							reg_F_q;
reg_new_value_G_d <= std_logic_vector(to_unsigned(1, reg_G_d'length)) when sel_reg_new_value_G = '1' else
							reg_G_q;
reg_new_value_B_d <= (base_mult_BC_o xor reg_B_q) when sel_load_new_value_B = '1' else
							std_logic_vector(to_unsigned(1, reg_B_d'length)) when sel_reg_new_value_B = '1' else 
							reg_B_q;
reg_new_value_C_d <= reg_C_q;

int_value_F <= value_G when reg_swap_q = "1" else value_F;
int_value_G <= value_F when reg_swap_q = "1" else value_G;
int_value_B <= value_C when reg_swap_q = "1" else value_B;
int_value_C <= value_B when reg_swap_q = "1" else value_C;

new_value_inv <= reg_new_value_F_q;

new_value_F <= reg_new_value_G_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_new_value_F_q;
new_value_G <= reg_new_value_F_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_new_value_G_q;
new_value_B <= reg_new_value_C_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_new_value_B_q;
new_value_C <= reg_new_value_B_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_new_value_C_q;

write_enable_F <= int_write_enable_G when (reg_swap_q(0) and enable_external_swap) = '1' else int_write_enable_F;
write_enable_G <= int_write_enable_F when (reg_swap_q(0) and enable_external_swap) = '1' else int_write_enable_G;
write_enable_B <= int_write_enable_C when (reg_swap_q(0) and enable_external_swap) = '1' else int_write_enable_B;
write_enable_C <= int_write_enable_B when (reg_swap_q(0) and enable_external_swap) = '1' else int_write_enable_C;

address_degree_F <= ctr_degree_F_q;
address_degree_C_plus_j <= degree_C_plus_j;

address_degree_G <= reg_degree_G_q;
address_degree_C <= reg_degree_C_q;

ctr_load_address_F_d <= address_degree_F;
						
ctr_load_address_G_d <= address_degree_G;
							
ctr_load_address_B_d <= address_degree_C_plus_j;
						
ctr_load_address_C_d <= address_degree_C;

reg_bus_address_F_d <= ctr_load_address_F_q;
reg_bus_address_G_d <= ctr_load_address_G_q;
reg_bus_address_B_d <= ctr_load_address_B_q;
reg_bus_address_C_d <= ctr_load_address_C_q;

reg_calc_address_F_d <= reg_bus_address_F_q;
reg_calc_address_G_d <= reg_bus_address_G_q;
reg_calc_address_B_d <= reg_bus_address_B_q;
reg_calc_address_C_d <= reg_bus_address_C_q;

reg_store_address_F_d <= reg_calc_address_F_q;
reg_store_address_G_d <= reg_calc_address_G_q;
reg_store_address_B_d <= reg_calc_address_B_q;
reg_store_address_C_d <= reg_calc_address_C_q;

address_value_F <= ctr_load_address_G_q when reg_swap_q(0) = '1' else ctr_load_address_F_q;
address_value_G <= ctr_load_address_F_q when reg_swap_q(0) = '1' else ctr_load_address_G_q;
address_value_B <= ctr_load_address_C_q when reg_swap_q(0) = '1' else ctr_load_address_B_q;
address_value_C <= ctr_load_address_B_q when reg_swap_q(0) = '1' else ctr_load_address_C_q;

address_new_value_F <= reg_store_address_G_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_store_address_F_q;
address_new_value_G <= reg_store_address_F_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_store_address_G_q;
address_new_value_B <= reg_store_address_C_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_store_address_B_q;
address_new_value_C <= reg_store_address_B_q when (reg_swap_q(0) and enable_external_swap) = '1' else reg_store_address_C_q;

F_equal_zero <= '1' when (reg_new_value_F_q = std_logic_vector(to_unsigned(0,reg_F_q'length))) else '0';
B_equal_zero <= '1' when (reg_new_value_B_q = std_logic_vector(to_unsigned(0,reg_B_q'length))) else '0';
i_FG_equal_zero <= '1' when (ctr_i_FG_q = std_logic_vector(to_unsigned(0,ctr_i_FG_q'length))) else '0';
i_BC_equal_zero <= '1' when (ctr_i_BC_q = std_logic_vector(to_unsigned(0,ctr_i_BC_q'length))) else '0';
i_FG_minus_j_less_than_zero <= '1' when (signed(i_FG_minus_j) < to_signed(0,i_FG_minus_j'length)) else '0';
i_BC_minus_j_less_than_zero <= '1' when (signed(i_BC_minus_j) < to_signed(0,i_FG_minus_j'length)) else '0';
degree_G_less_equal_final_degree <= '1' when (unsigned(reg_degree_G_q) <= to_unsigned(final_degree-1,reg_degree_G_q'length)) else '0'; 
degree_F_less_than_degree_G <= '1' when (unsigned(ctr_degree_F_q) < unsigned(reg_degree_G_q)) else '0';
degree_B_equal_degree_C_plus_j <= '1' when (ctr_degree_B_q = degree_C_plus_j) else '0';
degree_B_less_than_degree_C_plus_j <= '1' when (unsigned(ctr_degree_B_q) < unsigned(degree_C_plus_j)) else '0';

end Behavioral;