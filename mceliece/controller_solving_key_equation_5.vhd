----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Controller_FG_Solving_Key_Equation_5
-- Module Name:    Controller_FG_Solving_Key_Equation_5
-- Project Name:   McEliece QD-Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
-- 
-- The 2nd step in Goppa Code Decoding.
--
-- This is a state machine circuit that controls solving_key_equation_5 circuit.
-- This state machine have 3 phases: first phase variable initialization,
-- second computation of polynomial sigma, third step writing the polynomial sigma
-- on a specific memory position.
--
-- Dependencies: 
--
-- VHDL-93
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller_solving_key_equation_5 is
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
end controller_solving_key_equation_5;

architecture Behavioral of controller_solving_key_equation_5 is

type State is (reset, load_counters, prepare_inital_s_r_v_u, prepare_inital_s_r_v_u_2, prepare_inital_s_r_v_u_3, load_inital_s_r_v_u, last_load_inital_s_r_v_u, load_first_values, compute_rho, compute_u0, prepare_compute_new_polynomials, prepare_compute_new_polynomials_2, compute_new_polynomials, last_compute_new_polynomials, update_delta, prepare_last_swap, prepare_last_swap_2, last_swap, finalize_swap, final); 
signal actual_state, next_state : State; 

begin

Clock : process (clk)
begin
	if (clk'event and clk = '1') then
		if (rst = '1') then
			actual_state <= reset;
		else
			actual_state <= next_state;
		end if;        
	end if;
end process;

Output : process (actual_state, limit_number_of_iterations, last_polynomial_coefficient, is_inv_zero, is_r0_zero, is_delta_less_than_0, is_rho_zero)
begin
	case (actual_state) is
		when reset =>
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '1';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '1';
			reg_value_r_ce <= '0';
			reg_value_v_rst <= '1';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '1';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '1';
			reg_new_value_s_rst <= '1';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '1';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '0';
			ctr_load_value_rst <= '1';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '1';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '1';
		when load_counters =>
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '0';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';		
		when prepare_inital_s_r_v_u =>
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '1';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '1';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '1';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';		
		when prepare_inital_s_r_v_u_2 =>
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '1';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '1';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '1';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '1';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '1';
			reg_new_value_v_ce <= '1';
			reg_new_value_u_rst <= '1';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';		
		when prepare_inital_s_r_v_u_3 =>		
			signal_inv <= '1';
			key_equation_found <= '0';
			write_enable_s <= '1';
			write_enable_r <= '1';
			write_enable_v <= '1';
			write_enable_u <= '1';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '1';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '1';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '1';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '1';	
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '1';
			reg_new_value_v_ce <= '1';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '1';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';	
			ctr_store_value_ce <= '1';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';		
		when load_inital_s_r_v_u =>
			if(last_polynomial_coefficient = '1') then
				reg_new_value_s_rst <= '1';
				reg_new_value_s_ce <= '0';
				reg_new_value_r_rst <= '1';
				reg_new_value_r_ce <= '0';
				ctr_load_value_ce <= '0';
				ctr_load_value_rst <= '1';
			else
				reg_new_value_s_rst <= '0';
				reg_new_value_s_ce <= '1';	
				reg_new_value_r_rst <= '0';
				reg_new_value_r_ce <= '1';
				ctr_load_value_ce <= '1';
				ctr_load_value_rst <= '0';			
			end if;
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '1';
			write_enable_r <= '1';
			write_enable_v <= '1';
			write_enable_u <= '1';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '1';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '1';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '1';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_v_ce <= '1';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '1';
			reg_new_value_u0_ce <= '0';
			ctr_store_value_ce <= '1';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';		
		when last_load_inital_s_r_v_u =>
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '1';
			write_enable_r <= '1';
			write_enable_v <= '1';
			write_enable_u <= '1';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '0';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '0';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '1';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';
		when load_first_values =>
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '1';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '1';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '1';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '1';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';
		when compute_rho =>
			if(is_r0_zero = '1') then
				sel_reg_rho_rst_value <= '0';
				reg_rho_rst <= '1';
				reg_rho_ce <= '0';
			elsif(is_inv_zero = '1') then
				sel_reg_rho_rst_value <= '1';
				reg_rho_rst <= '1';
				reg_rho_ce <= '0';			
			else
				sel_reg_rho_rst_value <= '0';
				reg_rho_rst <= '0';
				reg_rho_ce <= '1';			
			end if;
			if(is_delta_less_than_0 = '1' and is_r0_zero = '0') then
				change_s_v <= '1';
			else
				change_s_v <= '0';
			end if;
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '1';
			last_u_value <= '0';
			change_r_u <= '0';
			shift_r_u <= '1';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '1';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '1';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '1';
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';
		when compute_u0 =>
			if(is_delta_less_than_0 = '1' and is_r0_zero = '0') then
				change_s_v <= '1';
			else
				change_s_v <= '0';
			end if;
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_r_u <= '0';
			shift_r_u <= '1';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '1';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '1';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '1';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';	
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '1';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '1';
			reg_new_value_v_ce <= '1';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '1';
			reg_new_value_u0_ce <= '1';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';
		when prepare_compute_new_polynomials =>
			if(is_delta_less_than_0 = '1' and is_rho_zero = '0') then
				change_s_v <= '1';
			else
				change_s_v <= '0';
			end if;
			signal_inv <= '1';
			key_equation_found <= '0';
			write_enable_s <= '1';
			write_enable_r <= '0';
			write_enable_v <= '1';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_r_u <= '0';
			shift_r_u <= '1';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '1';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '1';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '1';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';			
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '1';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '1';
			reg_new_value_v_ce <= '1';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '1';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '1';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';	
		when prepare_compute_new_polynomials_2 =>
			if(is_delta_less_than_0 = '1' and is_rho_zero = '0') then
				change_s_v <= '1';
			else
				change_s_v <= '0';
			end if;
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '1';
			write_enable_r <= '1';
			write_enable_v <= '1';
			write_enable_u <= '1';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_r_u <= '0';
			shift_r_u <= '1';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '1';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '1';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '1';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';			
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '1';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '1';
			reg_new_value_v_ce <= '1';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '1';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '1';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';				
		when compute_new_polynomials =>
			if(last_polynomial_coefficient = '1') then
				reg_value_u_rst <= '1';
				reg_value_u_ce <= '0';
			else
				reg_value_u_rst <= '0';
				reg_value_u_ce <= '1';			
			end if;
			if(is_delta_less_than_0 = '1' and is_rho_zero = '0') then
				change_s_v <= '1';
			else
				change_s_v <= '0';
			end if;
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '1';
			write_enable_r <= '1';
			write_enable_v <= '1';
			write_enable_u <= '1';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_r_u <= '0';
			shift_r_u <= '1';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '1';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '1';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';			
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '1';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '1';
			reg_new_value_v_ce <= '1';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '1';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '1';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';
		when last_compute_new_polynomials =>
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '1';
			write_enable_r <= '1';
			write_enable_v <= '1';
			write_enable_u <= '1';
			sel_mult_r_inv <= '0';
			last_u_value <= '1';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '1';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '0';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';			
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '1';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '1';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '0';
			ctr_load_value_rst <= '1';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';
		when update_delta =>
			if(limit_number_of_iterations = '1') then
				ctr_load_value_ce <= '1';
			else
				ctr_load_value_ce <= '0';
			end if;
			if(is_delta_less_than_0 = '1' and is_rho_zero = '0') then
				ctr_delta_load <= '1';
			else
				ctr_delta_load <= '0';
			end if;
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '1';
			write_enable_v <= '0';
			write_enable_u <= '1';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '1';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '0';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';	
			ctr_delta_ce <= '1';			
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '1';
			ctr_number_of_iterations_ce <= '1';
			ctr_number_of_iterations_rst <= '0';
		when prepare_last_swap =>
			if(is_delta_less_than_0 = '0') then
				change_s_v <= '1';
				change_r_u <= '1';
			else
				change_s_v <= '0';
				change_r_u <= '0';
			end if;
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '1';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '1';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '1';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '1';
			reg_rho_ce <= '0';	
			ctr_delta_ce <= '0';			
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';
		when prepare_last_swap_2 =>
			if(is_delta_less_than_0 = '0') then
				change_s_v <= '1';
				change_r_u <= '1';
			else
				change_s_v <= '0';
				change_r_u <= '0';
			end if;
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '1';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '1';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '1';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';	
			ctr_delta_ce <= '0';			
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '1';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '1';
			reg_new_value_v_ce <= '1';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '1';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';			
		when last_swap =>
			if(is_delta_less_than_0 = '0') then
				change_s_v <= '1';
				change_r_u <= '1';
			else
				change_s_v <= '0';
				change_r_u <= '0';
			end if;
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '1';
			write_enable_r <= '1';
			write_enable_v <= '1';
			write_enable_u <= '1';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '1';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '1';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '1';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '1';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';	
			ctr_delta_ce <= '0';			
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '1';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '1';
			reg_new_value_v_ce <= '1';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '1';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '1';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '1';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';
		when finalize_swap =>
			if(is_delta_less_than_0 = '0') then
				change_s_v <= '1';
				change_r_u <= '1';
			else
				change_s_v <= '0';
				change_r_u <= '0';
			end if;
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '1';
			write_enable_r <= '1';
			write_enable_v <= '1';
			write_enable_u <= '1';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '0';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';	
			ctr_delta_ce <= '0';			
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '1';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '1';
			reg_new_value_v_ce <= '1';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '1';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '0';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '1';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';			
		when final =>
			signal_inv <= '0';
			key_equation_found <= '1';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '0';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';	
			ctr_delta_ce <= '0';			
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '0';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';
		when others =>
			signal_inv <= '0';
			key_equation_found <= '0';
			write_enable_s <= '0';
			write_enable_r <= '0';
			write_enable_v <= '0';
			write_enable_u <= '0';
			sel_mult_r_inv <= '0';
			last_u_value <= '0';
			change_s_v <= '0';
			change_r_u <= '0';
			shift_r_u <= '0';
			reg_value_s_rst <= '0';
			reg_value_s_ce <= '0';
			reg_value_r_rst <= '0';
			reg_value_r_ce <= '0';
			reg_value_v_rst <= '0';
			reg_value_v_ce <= '0';
			reg_value_u_rst <= '0';
			reg_value_u_ce <= '0';
			sel_reg_rho_rst_value <= '0';
			reg_rho_rst <= '0';
			reg_rho_ce <= '0';
			ctr_delta_ce <= '0';
			ctr_delta_load <= '0';
			ctr_delta_rst <= '0';
			reg_new_value_s_rst <= '0';
			reg_new_value_s_ce <= '0';
			reg_new_value_r_rst <= '0';
			reg_new_value_r_ce <= '0';
			reg_new_value_v_ce <= '0';
			reg_new_value_u_rst <= '0';
			reg_new_value_u_ce <= '0';
			reg_new_value_u0_ce <= '0';
			ctr_load_value_ce <= '0';
			ctr_load_value_rst <= '0';
			ctr_store_value_ce <= '0';
			ctr_store_value_rst <= '0';
			ctr_number_of_iterations_ce <= '0';
			ctr_number_of_iterations_rst <= '0';
	end case;
end process;

New_State : process (actual_state, limit_number_of_iterations, last_polynomial_coefficient, is_inv_zero, is_r0_zero, is_delta_less_than_0, is_rho_zero)
begin
	case (actual_state) is
		when reset =>
			next_state <= load_counters;
		when load_counters =>
			next_state <= prepare_inital_s_r_v_u;
		when prepare_inital_s_r_v_u =>
			next_state <= prepare_inital_s_r_v_u_2;
		when prepare_inital_s_r_v_u_2 =>
			next_state <= prepare_inital_s_r_v_u_3;
		when prepare_inital_s_r_v_u_3 =>
			next_state <= load_inital_s_r_v_u;
		when load_inital_s_r_v_u =>
			if(last_polynomial_coefficient = '1') then
				next_state <= last_load_inital_s_r_v_u;
			else
				next_state <= load_inital_s_r_v_u;
			end if;
		when last_load_inital_s_r_v_u =>
			next_state <= load_first_values;
		when load_first_values =>
			next_state <= compute_rho;
		when compute_rho =>
			next_state <= compute_u0;
		when compute_u0 =>
			next_state <= prepare_compute_new_polynomials;
		when prepare_compute_new_polynomials =>
			next_state <= prepare_compute_new_polynomials_2;
		when prepare_compute_new_polynomials_2 =>
			next_state <= compute_new_polynomials;
		when compute_new_polynomials =>
			if(last_polynomial_coefficient = '1') then
				next_state <= last_compute_new_polynomials;
			else
				next_state <= compute_new_polynomials;
			end if;
		when last_compute_new_polynomials =>
			next_state <= update_delta;
		when update_delta =>
			if(limit_number_of_iterations = '1') then
				next_state <= prepare_last_swap;
			else
				next_state <= load_first_values;
			end if;
		when prepare_last_swap =>
			next_state <= prepare_last_swap_2;
		when prepare_last_swap_2 =>
			next_state <= last_swap;
		when last_swap =>
			if(last_polynomial_coefficient = '1') then
				next_state <= finalize_swap;
			else
				next_state <= last_swap;
			end if;
		when finalize_swap =>
			next_state <= final;
		when final =>
			next_state <= final;
		when others =>
			next_state <= reset;
	end case;
end process;

end Behavioral;