----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Solving_Key_Equation_5
-- Module Name:    Solving_Key_Equation_5
-- Project Name:   McEliece QD-Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
-- 
-- The 2nd step in Goppa Code Decoding.
--
-- This circuit solves the polynomial key equation sigma with the polynomial syndrome.
-- To solve the key equation, this circuit employs a modified binary extended euclidean algorithm.
-- The modification is made to stop the algorithm in 2*final degree steps.
-- The syndrome is the input and expected to be of degree 2*final_degree-1, and after computations
-- polynomial C, will hold sigma with degree less or equal to final_degree.
--
-- This is pipeline circuit version that is slower than solving_key_equation_4.
-- However this version is constant time, therefore is more side channel resistant. 
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
-- controller_solving_key_equation_5 Rev 1.0
-- register_nbits Rev 1.0
-- register_rst_nbits Rev 1.0
-- counter_rst_nbits Rev 1.0
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

entity solving_key_equation_5 is
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
		value_s : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_r : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_v : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_u : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_inv : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		signal_inv : out STD_LOGIC;
		key_equation_found : out STD_LOGIC;
		write_enable_s : out STD_LOGIC;
		write_enable_r : out STD_LOGIC;
		write_enable_v : out STD_LOGIC;
		write_enable_u : out STD_LOGIC;
		new_value_inv : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_s : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_v : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_r : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_u : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		address_value_s : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_r : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_v : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_u : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_s : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_r : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_v : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_u : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0)
	);
end solving_key_equation_5;

architecture Behavioral of solving_key_equation_5 is

component controller_solving_key_equation_5
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		limit_number_of_iterations : in STD_LOGIC;
		last_polynomial_coefficient : in STD_LOGIC;
		is_inv_zero : in STD_LOGIC;
		is_r0_zero : in STD_LOGIC;
		is_delta_less_than_0 : in STD_LOGIC;
		is_rho_zero : in STD_LOGIC;
		signal_inv : out STD_LOGIC;
		key_equation_found : out STD_LOGIC;
		write_enable_s : out STD_LOGIC;
		write_enable_r : out STD_LOGIC;
		write_enable_v : out STD_LOGIC;
		write_enable_u : out STD_LOGIC;
		sel_mult_r_inv : out STD_LOGIC;
		last_u_value : out STD_LOGIC;
		change_s_v : out STD_LOGIC;
		change_r_u : out STD_LOGIC;
		shift_r_u : out STD_LOGIC;
		reg_value_s_rst : out STD_LOGIC;
		reg_value_s_ce : out STD_LOGIC;
		reg_value_r_rst : out STD_LOGIC;
		reg_value_r_ce : out STD_LOGIC;
		reg_value_v_rst : out STD_LOGIC;
		reg_value_v_ce : out STD_LOGIC;
		reg_value_u_rst : out STD_LOGIC;
		reg_value_u_ce : out STD_LOGIC;
		sel_reg_rho_rst_value : out STD_LOGIC;	
		reg_rho_rst : out STD_LOGIC;
		reg_rho_ce : out STD_LOGIC;
		ctr_delta_ce : out STD_LOGIC;
		ctr_delta_load : out STD_LOGIC;
		ctr_delta_rst : out STD_LOGIC;
		reg_new_value_s_rst : out STD_LOGIC;
		reg_new_value_s_ce : out STD_LOGIC;
		reg_new_value_r_rst : out STD_LOGIC;
		reg_new_value_r_ce : out STD_LOGIC;
		reg_new_value_v_ce : out STD_LOGIC;
		reg_new_value_u_rst : out STD_LOGIC;
		reg_new_value_u_ce : out STD_LOGIC;
		reg_new_value_u0_ce : out STD_LOGIC;
		ctr_load_value_ce : out STD_LOGIC;
		ctr_load_value_rst : out STD_LOGIC;
		ctr_store_value_ce : out STD_LOGIC;
		ctr_store_value_rst : out STD_LOGIC;
		ctr_number_of_iterations_ce : out STD_LOGIC;
		ctr_number_of_iterations_rst : out STD_LOGIC
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

component mult_gf_2_m
	Generic (gf_2_m : integer range 1 to 20 := 11);
	Port (
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		b: in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);

end component;

signal reg_value_s_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_value_s_rst : STD_LOGIC;
constant reg_value_s_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');
signal reg_value_s_ce : STD_LOGIC;
signal reg_value_s_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_value_r_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_value_r_rst : STD_LOGIC;
constant reg_value_r_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');
signal reg_value_r_ce : STD_LOGIC;
signal reg_value_r_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_value_v_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_value_v_rst : STD_LOGIC;
constant reg_value_v_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');
signal reg_value_v_ce : STD_LOGIC;
signal reg_value_v_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_value_u_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_value_u_rst : STD_LOGIC;
constant reg_value_u_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := (others => '0');
signal reg_value_u_ce : STD_LOGIC;
signal reg_value_u_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
	
signal sel_reg_rho_rst_value : STD_LOGIC;	
	
signal reg_rho_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_rho_rst : STD_LOGIC;
constant reg_rho_rst_value_0 : STD_LOGIC_VECTOR((gf_2_m - 2) downto 0) := (others => '0');
signal reg_rho_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_rho_ce : STD_LOGIC;
signal reg_rho_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_inv_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_inv_ce : STD_LOGIC;
signal reg_inv_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal ctr_delta_d : STD_LOGIC_VECTOR((size_final_degree) downto 0);
signal ctr_delta_ce : STD_LOGIC;
signal ctr_delta_load : STD_LOGIC;
signal ctr_delta_rst : STD_LOGIC;
constant ctr_delta_rst_value : STD_LOGIC_VECTOR((size_final_degree) downto 0) := std_logic_vector(to_signed(-1, size_final_degree+1));
signal ctr_delta_q : STD_LOGIC_VECTOR((size_final_degree) downto 0);

signal mult_s_rho_r_inv_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mult_s_rho_r_inv_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mult_s_rho_r_inv_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
	
signal mult_v_rho_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mult_v_rho_b : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal mult_v_rho_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal add_s_rho_r : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal add_v_rho_u : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
	
signal reg_new_value_s_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_s_rst : STD_LOGIC;
constant reg_new_value_s_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(1, gf_2_m));
signal reg_new_value_s_ce : STD_LOGIC;
signal reg_new_value_s_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
	
signal reg_new_value_r_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_r_rst : STD_LOGIC;
constant reg_new_value_r_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(0, gf_2_m));
signal reg_new_value_r_ce : STD_LOGIC;
signal reg_new_value_r_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_new_value_v_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_v_ce : STD_LOGIC;
signal reg_new_value_v_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_new_value_u_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_u_rst : STD_LOGIC;
constant reg_new_value_u_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(1, gf_2_m));
signal reg_new_value_u_ce : STD_LOGIC;
signal reg_new_value_u_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal reg_new_value_u0_d : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal reg_new_value_u0_ce : STD_LOGIC;
signal reg_new_value_u0_q : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal ctr_load_value_ce : STD_LOGIC;
signal ctr_load_value_rst : STD_LOGIC;
constant ctr_load_value_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(0, size_final_degree+2));
signal ctr_load_value_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal reg_delay_store_value_d : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal reg_delay_store_value_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal shift_r_u : STD_LOGIC;

signal ctr_store_value_ce : STD_LOGIC;
signal ctr_store_value_rst : STD_LOGIC;
constant ctr_store_value_rst_value : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0) := std_logic_vector(to_unsigned(0, size_final_degree+2));
signal ctr_store_value_q : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal ctr_number_of_iterations_ce : STD_LOGIC;
signal ctr_number_of_iterations_rst : STD_LOGIC;
constant ctr_number_of_iterations_rst_value : STD_LOGIC_VECTOR(size_final_degree downto 0) := std_logic_vector(to_unsigned(0, size_final_degree+1));
signal ctr_number_of_iterations_q : STD_LOGIC_VECTOR(size_final_degree downto 0);

signal sel_mult_r_inv : STD_LOGIC;
signal last_u_value : STD_LOGIC;
signal change_s_v : STD_LOGIC;
signal change_r_u : STD_LOGIC;

signal limit_number_of_iterations : STD_LOGIC;
signal last_polynomial_coefficient : STD_LOGIC;
signal is_rho_zero : STD_LOGIC;
signal is_inv_zero : STD_LOGIC;
signal is_r0_zero : STD_LOGIC;
signal is_delta_less_than_0 : STD_LOGIC;

begin

controller : controller_solving_key_equation_5
	Port Map(
		clk => clk,
		rst => rst,
		limit_number_of_iterations => limit_number_of_iterations,
		last_polynomial_coefficient => last_polynomial_coefficient,
		is_inv_zero => is_inv_zero,
		is_r0_zero => is_r0_zero,
		is_delta_less_than_0 => is_delta_less_than_0,
		is_rho_zero => is_rho_zero,
		signal_inv => signal_inv,
		key_equation_found => key_equation_found,
		write_enable_s => write_enable_s,
		write_enable_r => write_enable_r,
		write_enable_v => write_enable_v,
		write_enable_u => write_enable_u,
		sel_mult_r_inv => sel_mult_r_inv,
		last_u_value => last_u_value,
		change_s_v => change_s_v,
		change_r_u => change_r_u,
		shift_r_u => shift_r_u,
		reg_value_s_rst => reg_value_s_rst,
		reg_value_s_ce => reg_value_s_ce,
		reg_value_r_rst => reg_value_r_rst,
		reg_value_r_ce => reg_value_r_ce,
		reg_value_v_rst => reg_value_v_rst,
		reg_value_v_ce => reg_value_v_ce,
		reg_value_u_rst => reg_value_u_rst,
		reg_value_u_ce => reg_value_u_ce,
		sel_reg_rho_rst_value => sel_reg_rho_rst_value,
		reg_rho_rst => reg_rho_rst,
		reg_rho_ce => reg_rho_ce,
		ctr_delta_ce => ctr_delta_ce,
		ctr_delta_load => ctr_delta_load,
		ctr_delta_rst => ctr_delta_rst,
		reg_new_value_s_rst => reg_new_value_s_rst,
		reg_new_value_s_ce => reg_new_value_s_ce,
		reg_new_value_r_rst => reg_new_value_r_rst,
		reg_new_value_r_ce => reg_new_value_r_ce,
		reg_new_value_v_ce => reg_new_value_v_ce,
		reg_new_value_u_rst => reg_new_value_u_rst,
		reg_new_value_u_ce => reg_new_value_u_ce,
		reg_new_value_u0_ce => reg_new_value_u0_ce,
		ctr_load_value_ce => ctr_load_value_ce,
		ctr_load_value_rst => ctr_load_value_rst,
		ctr_store_value_ce => ctr_store_value_ce,
		ctr_store_value_rst => ctr_store_value_rst,
		ctr_number_of_iterations_ce => ctr_number_of_iterations_ce,
		ctr_number_of_iterations_rst => ctr_number_of_iterations_rst
	);

reg_value_s : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_value_s_d,
		clk => clk,
		rst => reg_value_s_rst,
		rst_value => reg_value_s_rst_value,
		ce => reg_value_s_ce,
		q => reg_value_s_q
	);
	
reg_value_r : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_value_r_d,
		clk => clk,
		rst => reg_value_r_rst,
		rst_value => reg_value_r_rst_value,
		ce => reg_value_r_ce,
		q => reg_value_r_q
	);

reg_value_v : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_value_v_d,
		clk => clk,
		rst => reg_value_v_rst,
		rst_value => reg_value_v_rst_value,
		ce => reg_value_v_ce,
		q => reg_value_v_q
	);

reg_value_u : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_value_u_d,
		clk => clk,
		rst => reg_value_u_rst,
		rst_value => reg_value_u_rst_value,
		ce => reg_value_u_ce,
		q => reg_value_u_q
	);
	
reg_rho : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_rho_d,
		clk => clk,
		rst => reg_rho_rst,
		rst_value => reg_rho_rst_value,
		ce => reg_rho_ce,
		q => reg_rho_q
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
	
ctr_delta : counter_decrement_load_rst_nbits
	Generic Map(
		size => size_final_degree+1,
		decrement_value => 1
	)
	Port Map(
		d => ctr_delta_d,
		clk => clk,
		ce => ctr_delta_ce,
		load => ctr_delta_load,
		rst => ctr_delta_rst,
		rst_value => ctr_delta_rst_value,
		q => ctr_delta_q
	);
	
mult_s_rho_r_inv: mult_gf_2_m
	Generic Map (
		gf_2_m => gf_2_m
	)
	Port Map (
		a => mult_s_rho_r_inv_a, 
		b => mult_s_rho_r_inv_b,
		o => mult_s_rho_r_inv_o
	);
	
mult_v_rho: mult_gf_2_m
	Generic Map (
		gf_2_m => gf_2_m
	)
	Port Map (
		a => mult_v_rho_a, 
		b => mult_v_rho_b,
		o => mult_v_rho_o
	);
	
reg_new_value_s : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_s_d,
		clk => clk,
		rst => reg_new_value_s_rst,
		rst_value => reg_new_value_s_rst_value,
		ce => reg_new_value_s_ce,
		q => reg_new_value_s_q
	);
	
reg_new_value_r : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_r_d,
		clk => clk,
		rst => reg_new_value_r_rst,
		rst_value => reg_new_value_r_rst_value,
		ce => reg_new_value_r_ce,
		q => reg_new_value_r_q
	);

reg_new_value_v : register_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_v_d,
		clk => clk,
		ce => reg_new_value_v_ce,
		q => reg_new_value_v_q
	);

reg_new_value_u : register_rst_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_u_d,
		clk => clk,
		rst => reg_new_value_u_rst,
		rst_value => reg_new_value_u_rst_value,
		ce => reg_new_value_u_ce,
		q => reg_new_value_u_q
	);
	
reg_new_value_u0 : register_nbits
	Generic Map(
		size => gf_2_m
	)
	Port Map(
		d => reg_new_value_u0_d,
		clk => clk,
		ce => reg_new_value_u0_ce,
		q => reg_new_value_u0_q
	);
	
ctr_number_of_iterations : counter_rst_nbits
	Generic Map(
		size => size_final_degree+1,
		increment_value => 1
	)
	Port Map(
		clk => clk,
		ce => ctr_number_of_iterations_ce,
		rst => ctr_number_of_iterations_rst,
		rst_value => ctr_number_of_iterations_rst_value,
		q => ctr_number_of_iterations_q
	);
	
ctr_load_value : counter_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		increment_value => 1
	)
	Port Map(
		clk => clk,
		ce => ctr_load_value_ce,
		rst => ctr_load_value_rst,
		rst_value => ctr_load_value_rst_value,
		q => ctr_load_value_q
	);

ctr_store_value : counter_rst_nbits
	Generic Map(
		size => size_final_degree+2,
		increment_value => 1
	)
	Port Map(
		clk => clk,
		ce => ctr_store_value_ce,
		rst => ctr_store_value_rst,
		rst_value => ctr_store_value_rst_value,
		q => ctr_store_value_q
	);
	
reg_delay_store_value : register_nbits
	Generic Map(
		size => size_final_degree+2
	)
	Port Map(
		d => reg_delay_store_value_d,
		clk => clk,
		ce => '1',
		q => reg_delay_store_value_q
	);
	
reg_value_s_d <= value_s;
reg_value_r_d <= value_r;
reg_value_v_d <= value_v;
reg_value_u_d <= value_u;
	
reg_rho_d <= mult_s_rho_r_inv_o;
reg_rho_rst_value <= reg_rho_rst_value_0 & sel_reg_rho_rst_value;

reg_inv_d <= value_inv;
reg_inv_ce <= ready_inv;

ctr_delta_d <= std_logic_vector(to_signed(-1, size_final_degree+1) - signed(ctr_delta_q));

mult_s_rho_r_inv_a <= reg_inv_q when sel_mult_r_inv = '1' else
							reg_rho_q;
mult_s_rho_r_inv_b <= reg_value_r_q when sel_mult_r_inv = '1' else
							reg_value_s_q;
	
mult_v_rho_a <= reg_rho_q;
mult_v_rho_b <= reg_value_v_q;

add_s_rho_r <= mult_s_rho_r_inv_o xor reg_value_r_q;
add_v_rho_u <= mult_v_rho_o xor reg_value_u_q;

reg_new_value_s_d <= reg_value_r_q when change_s_v = '1' else
							reg_value_s_q;
reg_new_value_r_d <= reg_value_s_q when change_r_u = '1' else
							add_s_rho_r;
reg_new_value_v_d <= reg_value_u_q when change_s_v = '1' else
							reg_value_v_q;
reg_new_value_u_d <= reg_value_v_q when change_r_u = '1' else
							add_v_rho_u;

reg_new_value_u0_d <= add_v_rho_u;

new_value_inv <= reg_new_value_s_q;
 
new_value_s <= reg_new_value_s_q;
new_value_v <= reg_new_value_v_q; 
new_value_r <= reg_new_value_r_q;
new_value_u <= reg_new_value_u0_q when last_u_value = '1' else
					reg_new_value_u_q;
					
address_value_s <= ctr_load_value_q;
address_value_r <= ctr_load_value_q;
address_value_v <= ctr_load_value_q;
address_value_u <= ctr_load_value_q;

reg_delay_store_value_d <= ctr_store_value_q;

address_new_value_s <= ctr_store_value_q;
address_new_value_r <= reg_delay_store_value_q when shift_r_u = '1' else
								ctr_store_value_q;
address_new_value_v <= ctr_store_value_q;
address_new_value_u <= reg_delay_store_value_q when shift_r_u = '1' else
								ctr_store_value_q;

limit_number_of_iterations <= '1' when (ctr_number_of_iterations_q = std_logic_vector(to_unsigned(2*final_degree - 1, size_final_degree+1))) else '0';
last_polynomial_coefficient <= '1' when (ctr_store_value_q = std_logic_vector(to_unsigned(2*final_degree - 1, size_final_degree+2))) else '0';
is_inv_zero <= '1' when (reg_inv_q = std_logic_vector(to_unsigned(0, gf_2_m))) else '0';
is_rho_zero <= '1' when (reg_rho_q = std_logic_vector(to_unsigned(0, gf_2_m))) else '0';
is_r0_zero <= '1' when (reg_value_r_q = std_logic_vector(to_unsigned(0, gf_2_m))) else '0';
is_delta_less_than_0 <= '1' when (signed(ctr_delta_q) < to_signed(0, size_final_degree+1)) else '0';

end Behavioral;