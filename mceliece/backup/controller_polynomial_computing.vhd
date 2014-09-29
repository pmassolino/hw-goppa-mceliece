----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Controller_Polynomial_Computing
-- Module Name:    Controller_Polynomial_Computing
-- Project Name:   McEliece Goppa decoder
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 3rd step in Goppa Decoding. 
--
-- This circuit is the state machine for polynomial_syndrome_computing_n.
-- This state machine is only active during polynomial sigma evaluation and roots search.
-- During syndrome computation this circuit is ignored and controlled by 
-- controller_syndrome_computing.
--
-- For optimizations in polynomial_syndrome_computing_n_v2 both states machines were joined
-- joined into a single one that can run both algorithms.
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
use IEEE.NUMERIC_STD.ALL;

entity controller_polynomial_computing is
	Port(
		clk : in  STD_LOGIC;
		rst : in STD_LOGIC;
		last_load_x_values : in STD_LOGIC;
		last_store_x_values : in STD_LOGIC;
		limit_polynomial_degree : in STD_LOGIC;
		pipeline_ready : in STD_LOGIC;
		evaluation_data_in : out STD_LOGIC;
		reg_write_enable_rst : out STD_LOGIC;
		ctr_load_x_address_ce : out STD_LOGIC;
		ctr_load_x_address_rst : out STD_LOGIC;
		ctr_store_x_address_ce : out STD_LOGIC;
		ctr_store_x_address_rst : out STD_LOGIC;
		reg_first_values_ce : out STD_LOGIC;
		reg_first_values_rst : out STD_LOGIC;
		ctr_address_polynomial_ce : out STD_LOGIC;
		ctr_address_polynomial_rst : out STD_LOGIC;
		reg_x_rst_rst : out STD_LOGIC;
		shift_polynomial_ce_ce : out STD_LOGIC;
		shift_polynomial_ce_rst : out STD_LOGIC;
		last_coefficients : out STD_LOGIC;
		evaluation_finalized : out STD_LOGIC
	);
end controller_polynomial_computing;

architecture Behavioral of controller_polynomial_computing is

type State is (reset, load_counter, load_first_polynomial_coefficient, reset_first_polynomial_coefficient, prepare_load_polynomial_coefficient, load_polynomial_coefficient, reset_polynomial_coefficient, load_x, load_x_write_x, last_load_x_write_x, write_x, final); 
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

Output: process (actual_state, last_load_x_values, last_store_x_values, limit_polynomial_degree, pipeline_ready)
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
			ctr_address_polynomial_ce <= '0';
			ctr_address_polynomial_rst <= '1';
			reg_x_rst_rst <= '1';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '1';
			last_coefficients <= '0';
			evaluation_finalized <= '0';
		when load_counter =>
			evaluation_data_in <= '0';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_ce <= '1';
			ctr_address_polynomial_rst <= '0';
			reg_x_rst_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			last_coefficients <= '0';
			evaluation_finalized <= '0';
		when load_first_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '0';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '0';
				evaluation_finalized <= '0';
			elsif(limit_polynomial_degree = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '1';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '0';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '0';
				evaluation_finalized <= '0';
			else
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '1';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '1';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '0';
				evaluation_finalized <= '0';
			end if;
		when reset_first_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '0';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '1';
				evaluation_finalized <= '0';
			else
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '1';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '0';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '0';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '1';
				evaluation_finalized <= '0';
			end if;			
		when prepare_load_polynomial_coefficient =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '1';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '1';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_ce <= '1';
			ctr_address_polynomial_rst <= '0';
			reg_x_rst_rst <= '0';
			shift_polynomial_ce_ce <= '1';
			shift_polynomial_ce_rst <= '0';
			last_coefficients <= '0';
			evaluation_finalized <= '0';
		when load_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '0';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '0';
				evaluation_finalized <= '0';
			elsif(limit_polynomial_degree = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '0';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '0';
				evaluation_finalized <= '0';
			else
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '1';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '0';
				evaluation_finalized <= '0';
			end if;
		when reset_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '0';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '1';
				evaluation_finalized <= '0';
			else
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '0';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '1';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '1';
				evaluation_finalized <= '0';
			end if;			
		when load_x =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '1';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '1';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_ce <= '0';
			ctr_address_polynomial_rst <= '0';
			reg_x_rst_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			last_coefficients <= '0';
			evaluation_finalized <= '0';
		when load_x_write_x =>
			if(last_load_x_values = '1' and limit_polynomial_degree = '0') then
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '0';
				ctr_load_x_address_rst <= '1';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '0';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '0';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '0';
				evaluation_finalized <= '0';
			else
				evaluation_data_in <= '1';
				reg_write_enable_rst <= '0';
				ctr_load_x_address_ce <= '1';
				ctr_load_x_address_rst <= '0';
				ctr_store_x_address_ce <= '1';
				ctr_store_x_address_rst <= '0';
				reg_first_values_ce <= '0';
				reg_first_values_rst <= '0';
				ctr_address_polynomial_ce <= '0';
				ctr_address_polynomial_rst <= '0';
				reg_x_rst_rst <= '0';
				shift_polynomial_ce_ce <= '0';
				shift_polynomial_ce_rst <= '0';
				last_coefficients <= '0';
				evaluation_finalized <= '0';
			end if;
		when last_load_x_write_x =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '1';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_ce <= '0';
			ctr_address_polynomial_rst <= '0';
			reg_x_rst_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			last_coefficients <= '0';
			evaluation_finalized <= '0';
		when write_x =>
			evaluation_data_in <= '0';
			reg_write_enable_rst <= '0';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '1';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_ce <= '0';
			ctr_address_polynomial_rst <= '0';
			reg_x_rst_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			last_coefficients <= '0';
			evaluation_finalized <= '0';
		when final =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_ce <= '0';
			ctr_address_polynomial_rst <= '0';
			reg_x_rst_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			last_coefficients <= '0';
			evaluation_finalized <= '1';
		when others =>
			evaluation_data_in <= '1';
			reg_write_enable_rst <= '1';
			ctr_load_x_address_ce <= '0';
			ctr_load_x_address_rst <= '0';
			ctr_store_x_address_ce <= '0';
			ctr_store_x_address_rst <= '0';
			reg_first_values_ce <= '0';
			reg_first_values_rst <= '0';
			ctr_address_polynomial_ce <= '0';
			ctr_address_polynomial_rst <= '0';
			reg_x_rst_rst <= '0';
			shift_polynomial_ce_ce <= '0';
			shift_polynomial_ce_rst <= '0';
			last_coefficients <= '0';
			evaluation_finalized <= '0';
	end case;      
end process;

NewState: process (actual_state, last_load_x_values, last_store_x_values, limit_polynomial_degree, pipeline_ready)
begin
	case (actual_state) is
		when reset =>
			next_state <= load_counter;
		when load_counter =>
			next_state <= load_first_polynomial_coefficient;
		when load_first_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				next_state <= load_x;
			elsif(limit_polynomial_degree = '1') then
				next_state <= reset_first_polynomial_coefficient;
			else
				next_state <= load_first_polynomial_coefficient;
			end if;
		when reset_first_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				next_state <= load_x;
			else
				next_state <= reset_first_polynomial_coefficient;
			end if;
		when prepare_load_polynomial_coefficient =>
			next_state <= load_polynomial_coefficient;
		when load_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				next_state <= load_x;
			elsif(limit_polynomial_degree = '1') then
				next_state <= reset_polynomial_coefficient;
			else
				next_state <= load_polynomial_coefficient;
			end if;
		when reset_polynomial_coefficient =>
			if(pipeline_ready = '1') then
				next_state <= load_x;
			else
				next_state <= reset_polynomial_coefficient;
			end if;
		when load_x =>
			next_state <= load_x_write_x;
		when load_x_write_x =>
			if(last_load_x_values = '1') then
				if(limit_polynomial_degree = '1') then
					next_state <= last_load_x_write_x;
				else
					next_state <= prepare_load_polynomial_coefficient;
				end if;
			else
				next_state <= load_x_write_x;
			end if;
		when last_load_x_write_x =>
			next_state <= write_x;
		when write_x =>
			if(last_store_x_values = '1') then
				next_state <= final;
			else
				next_state <= write_x;
			end if;
		when final =>
			next_state <= final;
		when others =>
			next_state <= reset;
	end case;      
end process;

end Behavioral;