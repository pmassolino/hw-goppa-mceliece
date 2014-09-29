----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Controller_Polynomial_Syndrome_Computing
-- Module Name:    Controller_Polynomial_Syndrome_Computing
-- Project Name:   McEliece Goppa decoder
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 1st and 3rd step in Goppa Decoding. 
--
-- This circuit is the state machine for polynomial_syndrome_computing_n_v2.
-- This state machine is for both during syndrome computation and polynomial sigma
-- evaluation and roots search.
--
--
-- Dependencies:
-- VHDL-93
--
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller_polynomial_syndrome_computing is
	Port(
		clk : in  STD_LOGIC;
		rst : in STD_LOGIC;
		mode_polynomial_syndrome : in STD_LOGIC;
		last_load_x_values : in STD_LOGIC;
		last_store_x_values : in STD_LOGIC;
		limit_polynomial_degree : in STD_LOGIC;
		last_syndrome_value : in STD_LOGIC;
		final_syndrome_evaluation : in STD_LOGIC;
		pipeline_ready : in STD_LOGIC;
		evaluation_data_in : out STD_LOGIC;
		reg_write_enable_rst : out STD_LOGIC;
		ctr_load_x_address_ce : out STD_LOGIC;
		ctr_load_x_address_rst : out STD_LOGIC;
		ctr_store_x_address_ce : out STD_LOGIC;
		ctr_store_x_address_rst : out STD_LOGIC;
		reg_first_values_ce : out STD_LOGIC;
		reg_first_values_rst : out STD_LOGIC;
		ctr_address_polynomial_syndrome_ce : out STD_LOGIC;
		ctr_address_polynomial_syndrome_load : out STD_LOGIC;
		ctr_address_polynomial_syndrome_increment_decrement : out STD_LOGIC;
		ctr_address_polynomial_syndrome_rst : out STD_LOGIC;
		reg_x_rst_rst : out STD_LOGIC;
		reg_store_temporary_syndrome_ce : out STD_LOGIC;
		reg_final_syndrome_evaluation_ce : out STD_LOGIC;
		reg_final_syndrome_evaluation_rst : out STD_LOGIC;
		shift_polynomial_ce_ce : out STD_LOGIC;
		shift_polynomial_ce_rst : out STD_LOGIC;
		shift_syndrome_mode_data_in : out STD_LOGIC;
		shift_syndrome_mode_rst : out STD_LOGIC;
		write_enable_new_value_syndrome : out STD_LOGIC;
		finalize_syndrome : out STD_LOGIC;
		last_coefficients : out STD_LOGIC;
		computation_finalized : out STD_LOGIC		
	);
end controller_polynomial_syndrome_computing;

architecture Behavioral of controller_polynomial_syndrome_computing is

type State is (reset, poly_load_counter, poly_load_first_polynomial_coefficient, poly_reset_first_polynomial_coefficient, poly_prepare_load_polynomial_coefficient, poly_load_polynomial_coefficient, poly_reset_polynomial_coefficient, poly_load_x, poly_load_x_write_x, poly_last_load_x_write_x, poly_write_x, poly_final,
synd_load_counter, synd_load_L_syndrome_values, synd_prepare_write_load_L_values, synd_write_load_L_values, synd_prepare_write_L_values, synd_write_L_values, synd_write_syndrome_values, synd_last_write_syndrome_values, synd_final_write_syndrome_values, synd_final_last_write_syndrome_values, synd_final); 
signal actual_state, next_state : State; 

begin

Clock: process (clk)
begin
	if (clk'event and clk = '1') then
		if (rst = '1') then
			actual_state <= reset;
		else
			actual_state <= next_state;
		end if;        
	end if;
end process;

Output: process (actual_state, last_load_x_values, last_store_x_values, last_syndrome_value, final_syndrome_evaluation, limit_polynomial_degree, pipeline_ready)
begin
	case (actual_state) is
		when reset =>
			evaluation_data_in <= '0';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '1';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '1';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '1';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '1';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '1';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '1';
			shift_syndrome_mode_data_in <= '1';
			shift_syndrome_mode_rst <= '1';
			write_enable_new_value_syndrome <= '0';
			finalize_syndrome <= '1';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when poly_load_counter =>
			evaluation_data_in <= '0';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '1';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '1';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '0';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '0';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			finalize_syndrome <= '1';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when poly_load_first_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '0';
				computation_finalized <= '0';
			elsif(limit_polynomial_degree = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '1';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '0';
				computation_finalized <= '0';
			else
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '1';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '1';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '0';
				computation_finalized <= '0';
			end if;
		when poly_reset_first_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '1';
				computation_finalized <= '0';
			else
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '1';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';				
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '1';
				computation_finalized <= '0';
			end if;			
		when poly_prepare_load_polynomial_coefficient =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '1';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '1';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '1';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '1';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';			
			reg_x_rst_rst <= '0';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			shift_polynomial_ce_ce <= '1';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '0';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			finalize_syndrome <= '1';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when poly_load_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';				
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '0';
				computation_finalized <= '0';
			elsif(limit_polynomial_degree = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';				
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '0';
				computation_finalized <= '0';
			else
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '1';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';				
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '0';
				computation_finalized <= '0';
			end if;
		when poly_reset_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';				
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '1';
				computation_finalized <= '0';
			else
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';				
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '1';
				computation_finalized <= '0';
			end if;			
		when poly_load_x =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '1';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '1';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';			
			reg_x_rst_rst <= '0';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '0';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			finalize_syndrome <= '1';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when poly_load_x_write_x =>
			if(last_load_x_values = '1' and limit_polynomial_degree = '0') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '0';
				ctr_load_x_address_rst <= '1';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';				
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '0';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '0';
				computation_finalized <= '0';
			else
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_load <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				ctr_address_polynomial_syndrome_rst <= '0';
				reg_store_temporary_syndrome_ce <= '0';				
				reg_x_rst_rst <= '0';
				reg_final_syndrome_evaluation_ce <= '0';
				reg_final_syndrome_evaluation_rst <= '0';
				shift_polynomial_ce_ce <= '0';
				shift_polynomial_ce_rst <= '0';
				shift_syndrome_mode_data_in <= '0';
				shift_syndrome_mode_rst <= '0';
				write_enable_new_value_syndrome <= '0';
				finalize_syndrome <= '1';
				last_coefficients <= '0';
				computation_finalized <= '0';
			end if;
		when poly_last_load_x_write_x =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '1';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '1';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';			
			reg_x_rst_rst <= '0';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '0';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			finalize_syndrome <= '1';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when poly_write_x =>
			evaluation_data_in <= '0';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '1';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '1';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';			
			reg_x_rst_rst <= '0';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '0';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			finalize_syndrome <= '1';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when poly_final =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '1';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';			
			reg_x_rst_rst <= '0';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '0';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			finalize_syndrome <= '1';
			last_coefficients <= '0';
			computation_finalized <= '1';
		when synd_load_counter =>
			evaluation_data_in <= '0';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '1';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '1';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '1';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			finalize_syndrome <= '1';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '1';
			shift_syndrome_mode_data_in <= '1';
			shift_syndrome_mode_rst <= '1';
			write_enable_new_value_syndrome <= '0';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when synd_load_L_syndrome_values =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			finalize_syndrome <= '1';
			shift_polynomial_ce_ce <= '1';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '1';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when synd_prepare_write_load_L_values =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			finalize_syndrome <= '1';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '1';			
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when synd_write_load_L_values =>
			if(last_load_x_values = '1') then
				ctr_load_x_address_ce <= '0';
			else
				ctr_load_x_address_ce <= '1';
			end if;
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '1';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			finalize_syndrome <= '1';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '1';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when synd_prepare_write_L_values =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '1';
			ctr_store_x_address_ce <= '1';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '1';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			finalize_syndrome <= '1';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '1';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when synd_write_L_values =>
			if(last_syndrome_value = '1') then
				reg_final_syndrome_evaluation_ce <= '1';
			else
				reg_final_syndrome_evaluation_ce <= '0';
			end if;
			if(last_store_x_values = '1') then
				reg_write_enable_rst <= '1';
				ctr_load_x_address_ce <= '1';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '1';
				ctr_address_polynomial_syndrome_ce <= '0';
				ctr_address_polynomial_syndrome_increment_decrement <= '0';
				reg_store_temporary_syndrome_ce <= '1';
				shift_polynomial_ce_rst <= '1';
			else
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				ctr_address_polynomial_syndrome_ce <= '1';
				ctr_address_polynomial_syndrome_increment_decrement <= '1';
				reg_store_temporary_syndrome_ce <= '0';
				shift_polynomial_ce_rst <= '0';
			end if;
			evaluation_data_in <= '1';
			ctr_load_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_rst <= '0';
			finalize_syndrome <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_syndrome_mode_data_in <= '0';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when synd_write_syndrome_values =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '1';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			finalize_syndrome <= '1';
			shift_polynomial_ce_ce <= '1';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '1';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '1';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when synd_last_write_syndrome_values => 
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '1';
			ctr_address_polynomial_syndrome_load <= '1';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			finalize_syndrome <= '1';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '1';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when synd_final_write_syndrome_values =>
			if(final_syndrome_evaluation = '1' and last_syndrome_value = '0') then
				write_enable_new_value_syndrome <= '0';
			else
				write_enable_new_value_syndrome <= '1';
			end if;
			if(last_syndrome_value = '1') then
				reg_final_syndrome_evaluation_rst <= '1';
			else
				reg_final_syndrome_evaluation_rst <= '0';
			end if;
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '1';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			finalize_syndrome <= '1';
			shift_polynomial_ce_ce <= '1';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '1';
			shift_syndrome_mode_rst <= '0';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when synd_final_last_write_syndrome_values => 
			evaluation_data_in <= '0';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			finalize_syndrome <= '1';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '1';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			last_coefficients <= '0';
			computation_finalized <= '0';
		when synd_final =>
			evaluation_data_in <= '0';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '1';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';
			reg_x_rst_rst <= '1';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '1';
			finalize_syndrome <= '1';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '1';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			last_coefficients <= '0';
			computation_finalized <= '1';
		when others =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_syndrome_ce <= '0';
			ctr_address_polynomial_syndrome_load <= '0';
			ctr_address_polynomial_syndrome_increment_decrement <= '0';
			ctr_address_polynomial_syndrome_rst <= '0';
			reg_store_temporary_syndrome_ce <= '0';			
			reg_x_rst_rst <= '0';
			reg_final_syndrome_evaluation_ce <= '0';
			reg_final_syndrome_evaluation_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			shift_syndrome_mode_data_in <= '0';
			shift_syndrome_mode_rst <= '0';
			write_enable_new_value_syndrome <= '0';
			finalize_syndrome <= '1';
			last_coefficients <= '0';
			last_coefficients <= '0';
			computation_finalized <= '0';
	end case;      
end process;

NewState: process (actual_state, mode_polynomial_syndrome, last_load_x_values, last_store_x_values, last_syndrome_value, final_syndrome_evaluation, limit_polynomial_degree, pipeline_ready)
begin
	case (actual_state) is
		when reset =>
			if(mode_polynomial_syndrome  = '1') then
				next_state <= synd_load_counter;
			else
				next_state <= poly_load_counter;
			end if;
		when poly_load_counter =>
			next_state <= poly_load_first_polynomial_coefficient;
		when poly_load_first_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				next_state <= poly_load_x;
			elsif(limit_polynomial_degree = '1') then
				next_state <= poly_reset_first_polynomial_coefficient;
			else
				next_state <= poly_load_first_polynomial_coefficient;
			end if;
		when poly_reset_first_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				next_state <= poly_load_x;
			else
				next_state <= poly_reset_first_polynomial_coefficient;
			end if;
		when poly_prepare_load_polynomial_coefficient =>
			next_state <= poly_load_polynomial_coefficient;
		when poly_load_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				next_state <= poly_load_x;
			elsif(limit_polynomial_degree = '1') then
				next_state <= poly_reset_polynomial_coefficient;
			else
				next_state <= poly_load_polynomial_coefficient;
			end if;
		when poly_reset_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				next_state <= poly_load_x;
			else
				next_state <= poly_reset_polynomial_coefficient;
			end if;
		when poly_load_x =>
			next_state <= poly_load_x_write_x;
		when poly_load_x_write_x =>
			if(last_load_x_values = '1') then
				if(limit_polynomial_degree = '1') then
					next_state <= poly_last_load_x_write_x;
				else
					next_state <= poly_prepare_load_polynomial_coefficient;
				end if;
			else
				next_state <= poly_load_x_write_x;
			end if;
		when poly_last_load_x_write_x =>
			next_state <= poly_write_x;
		when poly_write_x =>
			if(last_store_x_values = '1') then
				next_state <= poly_final;
			else
				next_state <= poly_write_x;
			end if;
		when poly_final =>
			next_state <= poly_final;
		when synd_load_counter =>
			next_state <= synd_load_L_syndrome_values;
		when synd_load_L_syndrome_values =>
			if(pipeline_ready = '1') then
				next_state <= synd_prepare_write_load_L_values;
			else
				next_state <= synd_load_L_syndrome_values;
			end if;
		when synd_prepare_write_load_L_values =>
			next_state <= synd_write_load_L_values;
		when synd_write_load_L_values =>
			if(last_load_x_values = '1') then
				next_state <= synd_prepare_write_L_values;
			else
				next_state <= synd_write_load_L_values;
			end if;
		when synd_prepare_write_L_values =>
			next_state <= synd_write_L_values;
		when synd_write_L_values =>
			if(last_store_x_values = '1') then
				if(final_syndrome_evaluation  = '1' or last_syndrome_value = '1') then
					next_state <= synd_final_write_syndrome_values;
				else
					next_state <= synd_write_syndrome_values;
				end if;
			else
				next_state <= synd_write_L_values;
			end if;
		when synd_write_syndrome_values =>
			if(pipeline_ready = '1') then
				next_state <= synd_last_write_syndrome_values;
			else
				next_state <= synd_write_syndrome_values;
			end if;
		when synd_last_write_syndrome_values =>
			next_state <= synd_write_load_L_values;
		when synd_final_write_syndrome_values =>
			if(pipeline_ready = '1') then
				next_state <= synd_final_last_write_syndrome_values;
			else
				next_state <= synd_final_write_syndrome_values;
			end if;
		when synd_final_last_write_syndrome_values =>
			next_state <= synd_final;
		when synd_final =>	
			next_state <= synd_final;
		when others =>
			next_state <= reset;
	end case;      
end process;

end Behavioral;