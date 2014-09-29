----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Controller_Error_Adder
-- Module Name:    Controller_Error_Adder
-- Project Name:   McEliece QD-Goppa Encryption
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
-- 
-- This is the state machine controller for the error adder circuit.
-- The state machine only initializes the pipeline, starts adding all errors and 
-- then computes the last values of the pipeline.
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

entity controller_error_adder is
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		limit_ctr_address_codeword_q : in STD_LOGIC;
		reg_codeword_ce : out STD_LOGIC;
		reg_error_ce : out STD_LOGIC;
		ctr_address_codeword_ce : out STD_LOGIC;
		ctr_address_codeword_rst : out STD_LOGIC;
		ctr_address_ciphertext_ce : out STD_LOGIC;
		ctr_address_ciphertext_rst : out STD_LOGIC;
		write_enable_ciphertext : out STD_LOGIC;
		error_added : out STD_LOGIC
	);
end controller_error_adder;

architecture Behavioral of controller_error_adder is

type State is (reset, load_counter, load_codeword, add_error, last_error, write_last_error, final); 
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

Output: process (actual_state, limit_ctr_address_codeword_q)
begin
	case (actual_state) is
		when reset =>
			write_enable_ciphertext <= '0';
			reg_codeword_ce <= '0';
			reg_error_ce <= '0';
			ctr_address_codeword_ce <= '0';
			ctr_address_codeword_rst <= '1';
			ctr_address_ciphertext_ce <= '0';
			ctr_address_ciphertext_rst <= '1';
			error_added <= '0';
		when load_counter =>
			write_enable_ciphertext <= '0';
			reg_codeword_ce <= '0';
			reg_error_ce <= '0';
			ctr_address_codeword_ce <= '1';
			ctr_address_codeword_rst <= '0';
			ctr_address_ciphertext_ce <= '0';
			ctr_address_ciphertext_rst <= '0';
			error_added <= '0';
		when load_codeword =>
			write_enable_ciphertext <= '0';
			reg_codeword_ce <= '1';
			reg_error_ce <= '1';
			ctr_address_codeword_ce <= '1';
			ctr_address_codeword_rst <= '0';
			ctr_address_ciphertext_ce <= '0';
			ctr_address_ciphertext_rst <= '0';
			error_added <= '0';		
		when add_error => 
			write_enable_ciphertext <= '1';
			reg_codeword_ce <= '1';
			reg_error_ce <= '1';
			ctr_address_codeword_ce <= '1';
			ctr_address_codeword_rst <= '0';
			ctr_address_ciphertext_ce <= '1';
			ctr_address_ciphertext_rst <= '0';
			error_added <= '0';		
		when last_error =>
			write_enable_ciphertext <= '1';
			reg_codeword_ce <= '1';
			reg_error_ce <= '1';
			ctr_address_codeword_ce <= '0';
			ctr_address_codeword_rst <= '0';
			ctr_address_ciphertext_ce <= '1';
			ctr_address_ciphertext_rst <= '0';
			error_added <= '0';		
		when write_last_error =>
			write_enable_ciphertext <= '1';
			reg_codeword_ce <= '0';
			reg_error_ce <= '0';
			ctr_address_codeword_ce <= '0';
			ctr_address_codeword_rst <= '0';
			ctr_address_ciphertext_ce <= '0';
			ctr_address_ciphertext_rst <= '0';
			error_added <= '0';
		when final =>
			write_enable_ciphertext <= '0';
			reg_codeword_ce <= '0';
			reg_error_ce <= '0';
			ctr_address_codeword_ce <= '0';
			ctr_address_codeword_rst <= '0';
			ctr_address_ciphertext_ce <= '0';
			ctr_address_ciphertext_rst <= '0';
			error_added <= '1';		
		when others =>
			write_enable_ciphertext <= '0';
			reg_codeword_ce <= '0';
			reg_error_ce <= '0';
			ctr_address_codeword_ce <= '0';
			ctr_address_codeword_rst <= '0';
			ctr_address_ciphertext_ce <= '0';
			ctr_address_ciphertext_rst <= '0';
			error_added <= '0';		
	end case;
end process;

NewState : process(actual_state, limit_ctr_address_codeword_q)
begin
	case (actual_state) is
		when reset =>
			next_state <= load_counter;
		when load_counter =>
			next_state <= load_codeword;
		when load_codeword =>
			next_state <= add_error;
		when add_error =>
			if(limit_ctr_address_codeword_q = '1') then
				next_state <= last_error;
			else
				next_state <= add_error;
			end if;
		when last_error =>
			next_state <= write_last_error;
		when write_last_error =>
			next_state <= final;
		when final =>
			next_state <= final;
		when others =>
			next_state <= reset;
	end case;
end process;

end Behavioral;