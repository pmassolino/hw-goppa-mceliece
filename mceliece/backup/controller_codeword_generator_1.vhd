----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Controller_Codeword_Generator_1
-- Module Name:    Controller_Codeword_Generator_1
-- Project Name:   McEliece QD-Goppa Encoder
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The first and only step in QD-Goppa Code encoding. 
--
-- This circuit is the state machine controller for Codeword_Generator_1 and
-- Codeword_Generator_n_m. The state machine is composed of a step to copy the
-- original message and another for multiplying the message by matrix A.
-- This matrix multiplication is designed for matrices composed of dyadic blocks.
-- The algorithm computes one dyadic matrix at time.
-- Each dyadic matrix is computed in a column wise strategy.
--
-- Dependencies: 
-- VHDL-93
--
-- Revision: 
-- Revision 1.00 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller_codeword_generator_1 is
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
end controller_codeword_generator_1;

architecture Behavioral of controller_codeword_generator_1 is

type State is (reset, load_counter, prepare_message, load_message, copy_message, last_message, write_last_message, prepare_counters_a, new_acc, calc_codeword_a, last_column_value_a, write_last_column_value_a, last_row_value_a, write_last_row_value_a, last_value_a, write_last_value_a, prepare_counters_b, load_acc, calc_codeword_b, last_column_value_b, write_last_column_value_b, last_row_value_b, write_last_row_value_b, last_value_b, write_last_value_b, final); 
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

Output: process (actual_state, limit_ctr_dyadic_column_q, limit_ctr_dyadic_row_q, limit_ctr_address_message_q, limit_ctr_address_codeword_q)
begin
	case (actual_state) is
		when reset =>
			write_enable_new_codeword <= '0';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '0';
			reg_codeword_rst <= '1';
			reg_message_ce <= '0';
			reg_matrix_ce <= '0';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '1';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '1';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '1';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '1';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '1';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '0';
			codeword_finalized <= '0';
		when load_counter =>
			write_enable_new_codeword <= '0';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '0';
			reg_codeword_rst <= '1';
			reg_message_ce <= '0';
			reg_matrix_ce <= '0';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '1';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '1';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '1';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '1';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '1';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '0';
			codeword_finalized <= '0';
		when prepare_message =>
			if(limit_ctr_dyadic_row_q = '1') then
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '1';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '0';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '1';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			else
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '1';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '0';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			end if;
		when load_message =>
			if(limit_ctr_dyadic_row_q = '1') then
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '1';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '1';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			else
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '1';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			end if;
		when copy_message =>
			if(limit_ctr_dyadic_row_q = '1' and limit_ctr_dyadic_column_q = '1') then
				write_enable_new_codeword <= '1';
				message_into_new_codeword <= '1';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '1';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '1';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '1';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';		
				codeword_finalized <= '0';
			elsif(limit_ctr_dyadic_row_q = '1') then
				write_enable_new_codeword <= '1';
				message_into_new_codeword <= '1';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '1';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '1';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			elsif(limit_ctr_dyadic_column_q = '1') then
				write_enable_new_codeword <= '1';
				message_into_new_codeword <= '1';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '1';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '1';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			else
				write_enable_new_codeword <= '1';
				message_into_new_codeword <= '1';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '1';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			end if;
		when last_message => 
			if(limit_ctr_dyadic_column_q = '1') then
				write_enable_new_codeword <= '1';
				message_into_new_codeword <= '1';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '1';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '0';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '1';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			else
				write_enable_new_codeword <= '1';
				message_into_new_codeword <= '1';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '1';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '0';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			end if;
		when write_last_message => 
			write_enable_new_codeword <= '1';
			message_into_new_codeword <= '1';
			reg_codeword_ce <= '0';
			reg_codeword_rst <= '0';
			reg_message_ce <= '0';
			reg_matrix_ce <= '0';
			ctr_dyadic_column_ce <= '1';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '1';
			ctr_address_base_codeword_ce <= '1';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '0';
			codeword_finalized <= '0';
		when prepare_counters_a =>
			if(limit_ctr_dyadic_row_q = '1') then
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '0';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '0';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '1';
				codeword_finalized <= '0';		
			else
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '0';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '1';
				codeword_finalized <= '0';
			end if;
		when new_acc => 
			if(limit_ctr_dyadic_row_q = '1') then
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '1';
				reg_message_ce <= '1';
				reg_matrix_ce <= '1';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '0';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '1';
				codeword_finalized <= '0';
			else
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '1';
				reg_message_ce <= '1';
				reg_matrix_ce <= '1';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '1';
				codeword_finalized <= '0';
			end if;
		when calc_codeword_a =>
			if(limit_ctr_dyadic_row_q = '1') then
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '1';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '1';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '0';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '1';
				codeword_finalized <= '0';
			else
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '1';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '1';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '1';
				codeword_finalized <= '0';
			end if;
		when last_row_value_a => 
			write_enable_new_codeword <= '0';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '1';
			reg_codeword_rst <= '0';
			reg_message_ce <= '1';
			reg_matrix_ce <= '1';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '0';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '1';
			codeword_finalized <= '0';
		when write_last_row_value_a => 
			write_enable_new_codeword <= '1';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '0';
			reg_codeword_rst <= '0';
			reg_message_ce <= '0';
			reg_matrix_ce <= '0';
			ctr_dyadic_column_ce <= '1';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '1';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '0';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '1';
			codeword_finalized <= '0';
		when last_column_value_a => 
			write_enable_new_codeword <= '0';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '1';
			reg_codeword_rst <= '0';
			reg_message_ce <= '1';
			reg_matrix_ce <= '1';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '0';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '1';
			codeword_finalized <= '0';
		when write_last_column_value_a => 
			write_enable_new_codeword <= '1';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '0';
			reg_codeword_rst <= '0';
			reg_message_ce <= '0';
			reg_matrix_ce <= '0';
			ctr_dyadic_column_ce <= '1';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '1';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '1';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '0';
			ctr_address_base_codeword_ce <= '1';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '1';
			codeword_finalized <= '0';
		when last_value_a => 
			write_enable_new_codeword <= '0';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '1';
			reg_codeword_rst <= '0';
			reg_message_ce <= '1';
			reg_matrix_ce <= '1';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '0';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '1';
			codeword_finalized <= '0';
		when write_last_value_a => 
			write_enable_new_codeword <= '1';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '0';
			reg_codeword_rst <= '0';
			reg_message_ce <= '0';
			reg_matrix_ce <= '0';
			ctr_dyadic_column_ce <= '1';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '1';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '1';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '1';
			ctr_address_base_message_rst <= '0';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '1';
			internal_codeword <= '1';
			codeword_finalized <= '0';
		when prepare_counters_b =>
			if(limit_ctr_dyadic_row_q = '1') then
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '0';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '0';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';			
			else
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '0';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';			
			end if;
		when load_acc => 
			if(limit_ctr_dyadic_row_q = '1') then
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '1';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '1';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '0';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';	
			else
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '1';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '1';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';	
			end if;
		when calc_codeword_b =>
			if(limit_ctr_dyadic_row_q = '1') then
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '1';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '1';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '0';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '1';
				codeword_finalized <= '0';
			else
				write_enable_new_codeword <= '0';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '1';
				reg_codeword_rst <= '0';
				reg_message_ce <= '1';
				reg_matrix_ce <= '1';
				ctr_dyadic_column_ce <= '0';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '0';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '1';
				codeword_finalized <= '0';
			end if;
		when last_row_value_b => 
			write_enable_new_codeword <= '0';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '1';
			reg_codeword_rst <= '0';
			reg_message_ce <= '1';
			reg_matrix_ce <= '1';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '0';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '1';
			codeword_finalized <= '0';
		when write_last_row_value_b => 
			write_enable_new_codeword <= '1';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '0';
			reg_codeword_rst <= '0';
			reg_message_ce <= '0';
			reg_matrix_ce <= '0';
			ctr_dyadic_column_ce <= '1';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '1';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '0';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '0';
			codeword_finalized <= '0';
		when last_column_value_b => 
			write_enable_new_codeword <= '0';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '1';
			reg_codeword_rst <= '0';
			reg_message_ce <= '1';
			reg_matrix_ce <= '1';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '0';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '1';
			codeword_finalized <= '0';
		when write_last_column_value_b => 
			if(limit_ctr_address_codeword_q = '1') then
				write_enable_new_codeword <= '1';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '0';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '1';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '1';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '1';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '0';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '1';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			else
				write_enable_new_codeword <= '1';
				message_into_new_codeword <= '0';
				reg_codeword_ce <= '0';
				reg_codeword_rst <= '0';
				reg_message_ce <= '0';
				reg_matrix_ce <= '0';
				ctr_dyadic_column_ce <= '1';
				ctr_dyadic_column_rst <= '0';
				ctr_dyadic_row_ce <= '1';
				ctr_dyadic_row_rst <= '0';
				ctr_dyadic_matrices_ce <= '1';
				ctr_dyadic_matrices_rst <= '0';
				ctr_address_base_message_ce <= '0';
				ctr_address_base_message_rst <= '0';
				ctr_address_base_codeword_ce <= '1';
				ctr_address_base_codeword_rst <= '0';
				ctr_address_base_codeword_set <= '0';
				internal_codeword <= '0';
				codeword_finalized <= '0';
			end if;
		when last_value_b => 
			write_enable_new_codeword <= '0';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '1';
			reg_codeword_rst <= '0';
			reg_message_ce <= '1';
			reg_matrix_ce <= '1';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '0';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '0';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '0';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '0';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '0';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '1';
			codeword_finalized <= '0';
		when write_last_value_b => 
			write_enable_new_codeword <= '1';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '0';
			reg_codeword_rst <= '1';
			reg_message_ce <= '0';
			reg_matrix_ce <= '0';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '1';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '1';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '1';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '1';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '1';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '0';
			codeword_finalized <= '0';
		when final =>
			write_enable_new_codeword <= '0';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '0';
			reg_codeword_rst <= '1';
			reg_message_ce <= '0';
			reg_matrix_ce <= '0';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '1';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '1';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '1';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '1';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '1';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '0';
			codeword_finalized <= '1';
		when others =>
			write_enable_new_codeword <= '0';
			message_into_new_codeword <= '0';
			reg_codeword_ce <= '0';
			reg_codeword_rst <= '1';
			reg_message_ce <= '0';
			reg_matrix_ce <= '0';
			ctr_dyadic_column_ce <= '0';
			ctr_dyadic_column_rst <= '1';
			ctr_dyadic_row_ce <= '0';
			ctr_dyadic_row_rst <= '1';
			ctr_dyadic_matrices_ce <= '0';
			ctr_dyadic_matrices_rst <= '1';
			ctr_address_base_message_ce <= '0';
			ctr_address_base_message_rst <= '1';
			ctr_address_base_codeword_ce <= '0';
			ctr_address_base_codeword_rst <= '1';
			ctr_address_base_codeword_set <= '0';
			internal_codeword <= '0';
			codeword_finalized <= '0';
	end case;
end process;


NewState : process(actual_state, limit_ctr_dyadic_column_q, limit_ctr_dyadic_row_q, limit_ctr_address_message_q, limit_ctr_address_codeword_q)
begin
	case (actual_state) is
		when reset =>
			next_state <= load_counter;
		when load_counter =>
			next_state <= prepare_message;
		when prepare_message =>
			next_state <= load_message;
		when load_message =>
			next_state <= copy_message;
		when copy_message =>
			if(limit_ctr_address_message_q = '1') then
				next_state <= last_message;
			else
				next_state <= copy_message;
			end if;
		when last_message =>
			next_state <= write_last_message;
		when write_last_message =>
			next_state <= prepare_counters_a;			
		when prepare_counters_a => 
			if(limit_ctr_dyadic_row_q = '1') then
				if(limit_ctr_dyadic_column_q = '1') then
					if(limit_ctr_address_codeword_q = '1') then
						next_state <= last_value_a;
					else
						next_state <= last_column_value_a;
					end if;
				else
					next_state <= last_row_value_a;
				end if;
			else
				next_state <= new_acc;
			end if;
		when new_acc => 
			if(limit_ctr_dyadic_row_q = '1') then
				if(limit_ctr_dyadic_column_q = '1') then
					if(limit_ctr_address_codeword_q = '1') then
						next_state <= last_value_a;
					else
						next_state <= last_column_value_a;
					end if;
				else
					next_state <= last_row_value_a;
				end if;
			else
				next_state <= calc_codeword_a;
			end if;
		when calc_codeword_a =>
			if(limit_ctr_dyadic_row_q = '1') then
				if(limit_ctr_dyadic_column_q = '1') then
					if(limit_ctr_address_codeword_q = '1') then
						next_state <= last_value_a;
					else
						next_state <= last_column_value_a;
					end if;
				else
					next_state <= last_row_value_a;
				end if;
			else
				next_state <= calc_codeword_a;
			end if;
		when last_column_value_a =>
			next_state <= write_last_column_value_a;
		when write_last_column_value_a =>
			next_state <= prepare_counters_a;
		when last_row_value_a => 
			next_state <= write_last_row_value_a;
		when write_last_row_value_a => 
			next_state <= prepare_counters_a;
		when last_value_a =>
			next_state <= write_last_value_a;
		when write_last_value_a =>
			next_state <= prepare_counters_b;
		when prepare_counters_b =>
			if(limit_ctr_dyadic_row_q = '1') then
				if(limit_ctr_dyadic_column_q = '1') then
					if(limit_ctr_address_message_q = '1') then
						if(limit_ctr_address_codeword_q = '1') then
							next_state <= last_value_b;
						else
							next_state <= last_column_value_b;
						end if;
					else
						next_state <= last_column_value_b;
					end if;
				else
					next_state <= last_row_value_b;
				end if;
			else
				next_state <= load_acc;
			end if;
		when load_acc =>
			if(limit_ctr_dyadic_row_q = '1') then
				if(limit_ctr_dyadic_column_q = '1') then
					if(limit_ctr_address_message_q = '1') then
						if(limit_ctr_address_codeword_q = '1') then
							next_state <= last_value_b;
						else
							next_state <= last_column_value_b;
						end if;
					else
						next_state <= last_column_value_b;
					end if;
				else
					next_state <= last_row_value_b;
				end if;
			else
				next_state <= calc_codeword_b;
			end if;
		when calc_codeword_b =>
			if(limit_ctr_dyadic_row_q = '1') then
				if(limit_ctr_dyadic_column_q = '1') then
					if(limit_ctr_address_message_q = '1') then
						if(limit_ctr_address_codeword_q = '1') then
							next_state <= last_value_b;
						else
							next_state <= last_column_value_b;
						end if;
					else
						next_state <= last_column_value_b;
					end if;
				else
					next_state <= last_row_value_b;
				end if;
			else
				next_state <= calc_codeword_b;
			end if;
		when last_column_value_b =>
			next_state <= write_last_column_value_b;
		when write_last_column_value_b =>
			next_state <= prepare_counters_b;
		when last_row_value_b => 
			next_state <= write_last_row_value_b;
		when write_last_row_value_b => 
			next_state <= prepare_counters_b;
		when last_value_b =>
			next_state <= write_last_value_b;
		when write_last_value_b =>
			next_state <= final;
		when final =>
			next_state <= final;
		when others =>
			next_state <= reset;
	end case;
end process;

end Behavioral;

