----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Controller_Syndrome_Calculator_2
-- Module Name:    Controller_Syndrome_Calculator_2
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 1st step in Goppa Code Decoding. 
-- 
-- This circuit is the state machine that controls the syndrome_calculator_n
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

entity controller_syndrome_calculator_2 is
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
end controller_syndrome_calculator_2;

architecture Behavioral of controller_syndrome_calculator_2 is
type State is (reset, load_counters, prepare_values, load_values, jump_codeword, clear_remaining_units, prepare_synd, load_synd, store_synd, final); 
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

Output: process (actual_state, limit_ctr_codeword_q, limit_ctr_syndrome_q, reg_first_syndrome_q, reg_codeword_q, almost_units_ready, empty_units)
begin
	case (actual_state) is
		when reset => 
			syndrome_finalized <= '0';
			write_enable_new_syndrome <= '0';
			control_units_ce <= '0';
			control_units_rst <= '1';
			int_reg_L_ce <= '0';
			int_square_h <= '0';
			int_reg_h_ce <= '0';
			int_reg_h_rst <= '0';
			int_sel_reg_h <= '0';
			reg_syndrome_ce <= '0';
			reg_syndrome_rst <= '1';
			reg_codeword_ce <= '0';
			reg_first_syndrome_ce <= '0';
			reg_first_syndrome_rst <= '1';
			ctr_syndrome_ce <= '0';
			ctr_syndrome_rst <= '1';
			ctr_codeword_ce <= '0';
			ctr_codeword_rst <= '1';
		when load_counters => 
			syndrome_finalized <= '0';
			write_enable_new_syndrome <= '0';
			control_units_ce <= '1';
			control_units_rst <= '0';
			int_reg_L_ce <= '0';
			int_square_h <= '0';
			int_reg_h_ce <= '0';
			int_reg_h_rst <= '0';
			int_sel_reg_h <= '0';
			reg_syndrome_ce <= '0';
			reg_syndrome_rst <= '1';
			reg_codeword_ce <= '0';
			reg_first_syndrome_ce <= '0';
			reg_first_syndrome_rst <= '1';
			ctr_syndrome_ce <= '0';
			ctr_syndrome_rst <= '1';
			ctr_codeword_ce <= '0';
			ctr_codeword_rst <= '1';
		when prepare_values => 
			syndrome_finalized <= '0';
			write_enable_new_syndrome <= '0';
			control_units_ce <= '0';
			control_units_rst <= '0';
			int_reg_L_ce <= '0';
			int_square_h <= '0';
			int_square_h <= '0';
			int_reg_h_ce <= '0';
			int_reg_h_rst <= '0';
			int_sel_reg_h <= '0';
			reg_syndrome_ce <= '0';
			reg_syndrome_rst <= '0';
			reg_codeword_ce <= '0';
			reg_first_syndrome_ce <= '0';
			reg_first_syndrome_rst <= '0';
			ctr_syndrome_ce <= '0';
			ctr_syndrome_rst <= '0';
			ctr_codeword_ce <= '0';
			ctr_codeword_rst <= '0';
		when load_values => 
			if(reg_first_syndrome_q(0) = '1') then
				syndrome_finalized <= '0';
				write_enable_new_syndrome <= '0';
				control_units_ce <= '0';
				control_units_rst <= '0';
				int_reg_L_ce <= '1';
				int_square_h <= '0';
				int_reg_h_ce <= '1';
				int_reg_h_rst <= '0';
				int_sel_reg_h <= '0';
				reg_syndrome_ce <= '0';
				reg_syndrome_rst <= '1';
				reg_codeword_ce <= '1';
				reg_first_syndrome_ce <= '0';
				reg_first_syndrome_rst <= '0';
				ctr_syndrome_ce <= '0';
				ctr_syndrome_rst <= '0';
				ctr_codeword_ce <= '0';
				ctr_codeword_rst <= '0';
			else
				syndrome_finalized <= '0';
				write_enable_new_syndrome <= '0';
				control_units_ce <= '0';
				control_units_rst <= '0';
				int_reg_L_ce <= '1';
				int_square_h <= '0';
				int_reg_h_ce <= '1';
				int_reg_h_rst <= '0';
				int_sel_reg_h <= '0';
				reg_syndrome_ce <= '1';
				reg_syndrome_rst <= '0';
				reg_codeword_ce <= '1';
				reg_first_syndrome_ce <= '0';
				reg_first_syndrome_rst <= '0';
				ctr_syndrome_ce <= '0';
				ctr_syndrome_rst <= '0';
				ctr_codeword_ce <= '0';
				ctr_codeword_rst <= '0';
			end if;
		when jump_codeword => 
			if(reg_codeword_q(0) = '1') then
				if(almost_units_ready = '1' or limit_ctr_codeword_q = '1') then
					syndrome_finalized <= '0';
					write_enable_new_syndrome <= '0';
					control_units_ce <= '1';
					control_units_rst <= '0';
					int_reg_L_ce <= '0';
					int_square_h <= '1';
					int_reg_h_ce <= '1';
					int_reg_h_rst <= '0';
					int_sel_reg_h <= '1';
					reg_syndrome_ce <= '0';
					reg_syndrome_rst <= '0';
					reg_codeword_ce <= '0';
					reg_first_syndrome_ce <= '0';
					reg_first_syndrome_rst <= '0';
					ctr_syndrome_ce <= '0';
					ctr_syndrome_rst <= '1';
					ctr_codeword_ce <= '0';
					ctr_codeword_rst <= '0';
				else
					syndrome_finalized <= '0';
					write_enable_new_syndrome <= '0';
					control_units_ce <= '1';
					control_units_rst <= '0';
					int_reg_L_ce <= '0';
					int_square_h <= '1';
					int_reg_h_ce <= '1';
					int_reg_h_rst <= '0';
					int_sel_reg_h <= '1';
					reg_syndrome_ce <= '0';
					reg_syndrome_rst <= '0';
					reg_codeword_ce <= '0';
					reg_first_syndrome_ce <= '0';
					reg_first_syndrome_rst <= '0';
					ctr_syndrome_ce <= '0';
					ctr_syndrome_rst <= '1';
					ctr_codeword_ce <= '1';
					ctr_codeword_rst <= '0';
				end if;
			elsif(limit_ctr_codeword_q = '1') then
				syndrome_finalized <= '0';
				write_enable_new_syndrome <= '0';
				control_units_ce <= '0';
				control_units_rst <= '0';
				int_reg_L_ce <= '0';
				int_square_h <= '1';
				int_reg_h_ce <= '1';
				int_reg_h_rst <= '0';
				int_sel_reg_h <= '1';
				reg_syndrome_ce <= '0';
				reg_syndrome_rst <= '0';
				reg_codeword_ce <= '0';
				reg_first_syndrome_ce <= '0';
				reg_first_syndrome_rst <= '0';
				ctr_syndrome_ce <= '0';
				ctr_syndrome_rst <= '0';
				ctr_codeword_ce <= '0';
				ctr_codeword_rst <= '0';
			else
				syndrome_finalized <= '0';
				write_enable_new_syndrome <= '0';
				control_units_ce <= '0';
				control_units_rst <= '0';
				int_reg_L_ce <= '0';
				int_square_h <= '1';
				int_reg_h_ce <= '1';
				int_reg_h_rst <= '0';
				int_sel_reg_h <= '1';
				reg_syndrome_ce <= '0';
				reg_syndrome_rst <= '0';
				reg_codeword_ce <= '0';
				reg_first_syndrome_ce <= '0';
				reg_first_syndrome_rst <= '0';
				ctr_syndrome_ce <= '0';
				ctr_syndrome_rst <= '0';
				ctr_codeword_ce <= '1';
				ctr_codeword_rst <= '0';
			end if;
		when clear_remaining_units => 
			syndrome_finalized <= '0';
			write_enable_new_syndrome <= '0';
			control_units_ce <= '1';
			control_units_rst <= '0';
			int_reg_L_ce <= '0';
			int_square_h <= '0';
			int_reg_h_ce <= '0';
			int_reg_h_rst <= '1';
			int_sel_reg_h <= '0';
			reg_syndrome_ce <= '0';
			reg_syndrome_rst <= '0';
			reg_codeword_ce <= '0';
			reg_first_syndrome_ce <= '0';
			reg_first_syndrome_rst <= '0';
			ctr_syndrome_ce <= '0';
			ctr_syndrome_rst <= '0';
			ctr_codeword_ce <= '0';
			ctr_codeword_rst <= '0';
		when prepare_synd => 
			syndrome_finalized <= '0';
			write_enable_new_syndrome <= '0';
			control_units_ce <= '0';
			control_units_rst <= '0';
			int_reg_L_ce <= '0';
			int_square_h <= '0';
			int_reg_h_ce <= '0';
			int_reg_h_rst <= '0';
			int_sel_reg_h <= '1';
			reg_syndrome_ce <= '0';
			reg_syndrome_rst <= '0';
			reg_codeword_ce <= '0';
			reg_first_syndrome_ce <= '0';
			reg_first_syndrome_rst <= '0';
			ctr_syndrome_ce <= '0';
			ctr_syndrome_rst <= '0';
			ctr_codeword_ce <= '0';
			ctr_codeword_rst <= '0';
		when load_synd => 
			if(reg_first_syndrome_q(0) = '1') then
				syndrome_finalized <= '0';
				write_enable_new_syndrome <= '0';
				control_units_ce <= '0';
				control_units_rst <= '0';
				int_reg_L_ce <= '0';
				int_square_h <= '0';
				int_reg_h_ce <= '0';
				int_reg_h_rst <= '0';
				int_sel_reg_h <= '1';
				reg_syndrome_ce <= '0';
				reg_syndrome_rst <= '1';
				reg_codeword_ce <= '0';
				reg_first_syndrome_ce <= '0';
				reg_first_syndrome_rst <= '0';
				ctr_syndrome_ce <= '0';
				ctr_syndrome_rst <= '0';
				ctr_codeword_ce <= '0';
				ctr_codeword_rst <= '0';
			else
				syndrome_finalized <= '0';
				write_enable_new_syndrome <= '0';
				control_units_ce <= '0';
				control_units_rst <= '0';
				int_reg_L_ce <= '0';
				int_square_h <= '0';
				int_reg_h_ce <= '0';
				int_reg_h_rst <= '0';
				int_sel_reg_h <= '1';
				reg_syndrome_ce <= '1';
				reg_syndrome_rst <= '0';
				reg_codeword_ce <= '0';
				reg_first_syndrome_ce <= '0';
				reg_first_syndrome_rst <= '0';
				ctr_syndrome_ce <= '0';
				ctr_syndrome_rst <= '0';
				ctr_codeword_ce <= '0';
				ctr_codeword_rst <= '0';
			end if;
		when store_synd => 
			if(limit_ctr_syndrome_q = '1') then
				syndrome_finalized <= '0';
				write_enable_new_syndrome <= '1';
				control_units_ce <= '1';
				control_units_rst <= '0';
				int_reg_L_ce <= '0';
				int_square_h <= '0';
				int_reg_h_ce <= '1';
				int_reg_h_rst <= '0';
				int_sel_reg_h <= '1';
				reg_syndrome_ce <= '0';
				reg_syndrome_rst <= '0';
				reg_codeword_ce <= '0';
				reg_first_syndrome_ce <= '1';
				reg_first_syndrome_rst <= '0';
				ctr_syndrome_ce <= '0';
				ctr_syndrome_rst <= '1';
				ctr_codeword_ce <= '1';
				ctr_codeword_rst <= '0';
			else
				syndrome_finalized <= '0';
				write_enable_new_syndrome <= '1';
				control_units_ce <= '0';
				control_units_rst <= '0';
				int_reg_L_ce <= '0';
				int_square_h <= '0';
				int_reg_h_ce <= '1';
				int_reg_h_rst <= '0';
				int_sel_reg_h <= '1';
				reg_syndrome_ce <= '0';
				reg_syndrome_rst <= '0';
				reg_codeword_ce <= '0';
				reg_first_syndrome_ce <= '0';
				reg_first_syndrome_rst <= '0';
				ctr_syndrome_ce <= '1';
				ctr_syndrome_rst <= '0';
				ctr_codeword_ce <= '0';
				ctr_codeword_rst <= '0';
			end if;
		when final =>
			syndrome_finalized <= '1';
			write_enable_new_syndrome <= '0';
			control_units_ce <= '0';
			control_units_rst <= '1';
			int_reg_L_ce <= '0';
			int_square_h <= '0';
			int_reg_h_ce <= '0';
			int_reg_h_rst <= '0';
			int_sel_reg_h <= '0';
			reg_syndrome_ce <= '0';
			reg_syndrome_rst <= '1';
			reg_codeword_ce <= '0';
			reg_first_syndrome_ce <= '0';
			reg_first_syndrome_rst <= '1';
			ctr_syndrome_ce <= '0';
			ctr_syndrome_rst <= '1';
			ctr_codeword_ce <= '0';
			ctr_codeword_rst <= '1';
		when others =>
			syndrome_finalized <= '0';
			write_enable_new_syndrome <= '0';
			control_units_ce <= '0';
			control_units_rst <= '1';
			int_reg_L_ce <= '0';
			int_square_h <= '0';
			int_reg_h_ce <= '0';
			int_reg_h_rst <= '0';
			int_sel_reg_h <= '0';
			reg_syndrome_ce <= '0';
			reg_syndrome_rst <= '1';
			reg_codeword_ce <= '0';
			reg_first_syndrome_ce <= '0';
			reg_first_syndrome_rst <= '1';
			ctr_syndrome_ce <= '0';
			ctr_syndrome_rst <= '1';
			ctr_codeword_ce <= '0';
			ctr_codeword_rst <= '1';
	end case;
end process;

NewState: process (actual_state, limit_ctr_codeword_q, limit_ctr_syndrome_q, reg_first_syndrome_q, reg_codeword_q, almost_units_ready, empty_units)
begin
	case (actual_state) is
		when reset => 
			next_state <= load_counters;
		when load_counters => 
			next_state <= prepare_values;
		when prepare_values => 
			next_state <= load_values;
		when load_values => 
			next_state <= jump_codeword;
		when jump_codeword => 
			if(reg_codeword_q(0) = '1') then
				if(almost_units_ready = '1') then
					next_state <= load_synd;
				elsif(limit_ctr_codeword_q = '1') then
					next_state <= clear_remaining_units;
				else
					next_state <= prepare_values;
				end if;
			elsif(limit_ctr_codeword_q = '1') then
				if(empty_units = '1') then
					next_state <= final;
				else
					next_state <= clear_remaining_units;
				end if;
			else
				next_state <= prepare_values;
			end if;
		when clear_remaining_units =>
			if(almost_units_ready = '1') then
				next_state <= prepare_synd;
			else
				next_state <= clear_remaining_units;
			end if;
		when prepare_synd => 
			next_state <= load_synd;
		when load_synd => 
			next_state <= store_synd;
		when store_synd => 
			if(limit_ctr_syndrome_q = '1') then
				if(limit_ctr_codeword_q = '1') then
					next_state <= final;
				else
					next_state <= prepare_values;
				end if;
			else
				next_state <= prepare_synd;
			end if;
		when final =>
			next_state <= final;
		when others =>
			next_state <= reset;
	end case;
end process;

end Behavioral;