----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Controller_Find_Correct_Errors_N
-- Module Name:    Controller_Find_Correct_Errors_N
-- Project Name:   3rd Step - Find and Correct Errors
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description:
--
-- The 3rd step in Goppa Code Decoding. 
-- 
-- This circuit is the state machine controller for find_correct_errors_n.
-- This circuit loads all messages synchronized along side polynomial evaluator circuit.
-- The states of this circuit is to load values and when a signal of last evaluation
-- rises the values of the message are written.
--
-- Dependencies:
-- VHDL-93
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller_find_correct_errors_n is
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		enable_correction : in STD_LOGIC;
		evaluation_finalized : in STD_LOGIC;
		reg_value_evaluated_ce : out STD_LOGIC;
		reg_address_store_new_value_message_ce : out STD_LOGIC;
		reg_address_store_new_value_message_rst : out STD_LOGIC;
		reg_write_enable_new_value_message_ce : out STD_LOGIC;
		reg_write_enable_new_value_message_rst : out STD_LOGIC;
		correction_finalized : out STD_LOGIC
	);
end controller_find_correct_errors_n;

architecture Behavioral of controller_find_correct_errors_n is

type State is (reset, load_counter, load_x_write_x, load_message_x_write_message_x, final); 
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

Output: process (actual_state, enable_correction, evaluation_finalized)
begin
	case (actual_state) is
		when reset =>
			reg_value_evaluated_ce <= '0';
			reg_address_store_new_value_message_ce <= '0';
			reg_address_store_new_value_message_rst <= '1';
			reg_write_enable_new_value_message_ce <= '0';
			reg_write_enable_new_value_message_rst <= '1';
			correction_finalized <= '0';
		when load_counter =>
			reg_value_evaluated_ce <= '0';
			reg_address_store_new_value_message_ce <= '0';
			reg_address_store_new_value_message_rst <= '1';
			reg_write_enable_new_value_message_ce <= '0';
			reg_write_enable_new_value_message_rst <= '1';
			correction_finalized <= '0';
		when load_x_write_x =>
			if(enable_correction = '1') then
				reg_value_evaluated_ce <= '1';
				reg_address_store_new_value_message_ce <= '1';
				reg_address_store_new_value_message_rst <= '0';
				reg_write_enable_new_value_message_ce <= '1';
				reg_write_enable_new_value_message_rst <= '0';
				correction_finalized <= '0';
			else
				reg_value_evaluated_ce <= '0';
				reg_address_store_new_value_message_ce <= '0';
				reg_address_store_new_value_message_rst <= '0';
				reg_write_enable_new_value_message_ce <= '0';
				reg_write_enable_new_value_message_rst <= '0';
				correction_finalized <= '0';
			end if;
		when load_message_x_write_message_x =>
			reg_value_evaluated_ce <= '1';
			reg_address_store_new_value_message_ce <= '1';
			reg_address_store_new_value_message_rst <= '0';
			reg_write_enable_new_value_message_ce <= '1';
			reg_write_enable_new_value_message_rst <= '0';
			correction_finalized <= '0';
		when final =>
			reg_value_evaluated_ce <= '0';
			reg_address_store_new_value_message_ce <= '0';
			reg_address_store_new_value_message_rst <= '0';
			reg_write_enable_new_value_message_ce <= '0';
			reg_write_enable_new_value_message_rst <= '0';
			correction_finalized <= '1';
		when others =>
			reg_value_evaluated_ce <= '0';
			reg_address_store_new_value_message_ce <= '0';
			reg_address_store_new_value_message_rst <= '0';
			reg_write_enable_new_value_message_ce <= '0';
			reg_write_enable_new_value_message_rst <= '0';
			correction_finalized <= '0';
	end case;      
end process;

NewState: process (actual_state, enable_correction, evaluation_finalized)
begin
	case (actual_state) is
		when reset =>
			next_state <= load_counter;
		when load_counter =>
			next_state <= load_x_write_x;
		when load_x_write_x =>
			if(enable_correction = '1') then
				next_state <= load_message_x_write_message_x;
			else
				next_state <= load_x_write_x;
			end if;
		when load_message_x_write_message_x =>
			if(evaluation_finalized = '1') then
				next_state <= final;
			else
				next_state <= load_message_x_write_message_x;
			end if;
		when final =>
			next_state <= final;
		when others =>
			next_state <= reset;
	end case;      
end process;

end Behavioral;